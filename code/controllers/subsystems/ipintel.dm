SUBSYSTEM_DEF(ipintel)
	name = "XKeyScore"
	init_order = INIT_ORDER_MISC_FIRST
	flags = SS_NO_FIRE
	/// Whether IPIntel lookups are currently enabled. Disabled until Initialize() to avoid checking reconnects at roundstart.
	var/enabled = FALSE
	/// world.timeofday value before which all API requests are suppressed due to prior rate-limit or connection errors
	var/throttle = 0
	/// Number of consecutive API failures; used to scale the throttle window
	var/errors = 0
	/// In-memory cache of recent [/datum/ipintel] results, keyed by IP address string
	var/list/cache = list()

/datum/controller/subsystem/ipintel/Initialize()
	enabled = TRUE
	return SS_INIT_SUCCESS

/**
 * Looks up the IPIntel score for the given IP address.
 *
 * Called from [/client/proc/InitClient] during client connection to check
 * whether the connecting IP is likely a proxy or VPN.
 *
 * Checks sources in priority order:
 * 1. In-memory cache ([/datum/controller/subsystem/ipintel/var/cache])
 * 2. Database cache (`ss13_ipintel` table)
 * 3. Live IPIntel API request via [/datum/controller/subsystem/ipintel/proc/query]
 *
 * The result is always delivered via `on_complete`, which is called with a [/datum/ipintel]
 * as its sole argument. For cache hits the callback is invoked before this proc returns;
 * for live requests it is invoked asynchronously once the HTTP response arrives.
 *
 * The return value is set to the [/datum/ipintel] datum immediately, but its `intel` field
 * is only guaranteed to be populated by the time `on_complete` fires.
 *
 * Arguments:
 * * ip - The IP address string to look up
 * * bypasscache - If TRUE, skips both memory and database cache and always queries the API
 * * updatecache - If TRUE, writes a successful live result back to memory and database cache
 * * on_complete - Callback invoked with the final [/datum/ipintel] datum when the result is ready
 */
/datum/controller/subsystem/ipintel/proc/get_ip_intel(ip, bypasscache = FALSE, updatecache = TRUE, datum/callback/on_complete)
	var/datum/ipintel/res = new()
	res.ip = ip
	. = res
	if (!ip || !GLOB.config.ipintel_email || !enabled)
		if (on_complete)
			on_complete.Invoke(res)
		return
	if (!bypasscache)
		var/datum/ipintel/cachedintel = cache[ip]
		if (cachedintel && cachedintel.is_valid())
			cachedintel.cache = TRUE
			if (on_complete)
				on_complete.Invoke(cachedintel)
			return cachedintel

		var/datum/db_query/query_get_ip_intel = SSdbcore.NewQuery(
			{"SELECT date, intel, TIMESTAMPDIFF(MINUTE, date, NOW())
			FROM ss13_ipintel
			WHERE
				ip = INET6_ATON(:ip)
				AND ((
						intel < :rating_bad
						AND
						date + INTERVAL :save_good HOUR > NOW()
					) OR (
						intel >= :rating_bad
						AND
						date + INTERVAL :save_bad HOUR > NOW()
				))"},
			list(
				"ip" = ip,
				"rating_bad" = GLOB.config.ipintel_rating_bad,
				"save_good" = GLOB.config.ipintel_save_good,
				"save_bad" = GLOB.config.ipintel_save_bad,
			)
		)
		if (!query_get_ip_intel.Execute())
			qdel(query_get_ip_intel)
			if (on_complete)
				on_complete.Invoke(res)
			return
		if (query_get_ip_intel.NextRow())
			res.cache = TRUE
			res.cachedate = query_get_ip_intel.item[1]
			res.intel = text2num(query_get_ip_intel.item[2])
			res.cacheminutesago = text2num(query_get_ip_intel.item[3])
			res.cacherealtime = world.realtime - (text2num(query_get_ip_intel.item[3])*10*60)
			cache[ip] = res
			qdel(query_get_ip_intel)
			if (on_complete)
				on_complete.Invoke(res)
			return
		qdel(query_get_ip_intel)
	query(ip, CALLBACK(src, PROC_REF(on_query_complete), ip, res, updatecache, on_complete))

/**
 * Internal callback for [/datum/controller/subsystem/ipintel/proc/get_ip_intel] — invoked by
 * [/datum/controller/subsystem/ipintel/proc/query] once the live API result is available.
 *
 * Writes the intel score into `res`, updates memory and database caches when appropriate,
 * then invokes the outer `on_complete` callback.
 *
 * Arguments:
 * * ip - The IP address that was looked up
 * * res - The [/datum/ipintel] datum being populated
 * * updatecache - Whether to persist the result to memory and database cache
 * * on_complete - The callback originally passed to [/datum/controller/subsystem/ipintel/proc/get_ip_intel]
 * * intel - The raw intel score returned by [/datum/controller/subsystem/ipintel/proc/query], or -1 on error
 */
/datum/controller/subsystem/ipintel/proc/on_query_complete(ip, datum/ipintel/res, updatecache, datum/callback/on_complete, intel)
	PRIVATE_PROC(TRUE)
	res.intel = intel
	if (updatecache && res.intel >= 0)
		cache[ip] = res
		var/datum/db_query/query_add_ip_intel = SSdbcore.NewQuery(
			"INSERT INTO ss13_ipintel (ip, intel) VALUES (INET6_ATON(:ip), :intel) ON DUPLICATE KEY UPDATE intel = VALUES(intel), date = NOW()",
			list("ip" = ip, "intel" = res.intel)
		)
		query_add_ip_intel.SetSuccessCallback(CALLBACK(GLOBAL_PROC, /proc/qdel))
		query_add_ip_intel.SetFailCallback(CALLBACK(GLOBAL_PROC, /proc/qdel))
		query_add_ip_intel.ExecuteNoSleep(TRUE) // Allow to run while we still load the game
	if (on_complete)
		on_complete.Invoke(res)

/**
 * Submits an async IPIntel API request for the given IP address via [/datum/controller/subsystem/http].
 *
 * The result is delivered to `on_complete` as a raw intel score (0.0–1.0), or -1 on any
 * failure. Does nothing and invokes `on_complete(-1)` if IPIntel is disabled or currently
 * throttled due to prior errors.
 *
 * Use [/datum/controller/subsystem/ipintel/proc/get_ip_intel] instead of calling this directly;
 * it handles cache lookup and result storage around this proc.
 *
 * Arguments:
 * * ip - The IP address to query
 * * on_complete - Callback invoked with the intel score (num) when the response arrives
 * * retry - TRUE if this is an automatic retry after a transient failure
 */
/datum/controller/subsystem/ipintel/proc/query(ip, datum/callback/on_complete, retry = FALSE)
	PRIVATE_PROC(TRUE)
	if (!ip || !enabled)
		if (on_complete)
			on_complete.Invoke(-1)
		return
	if (throttle > world.timeofday)
		if (on_complete)
			on_complete.Invoke(-1)
		return

	var/url = "https://[GLOB.config.ipintel_domain]/check.php?ip=[ip]&contact=[GLOB.config.ipintel_email]&format=json&flags=f"
	SShttp.create_async_request(
		RUSTG_HTTP_METHOD_GET,
		url,
		"",
		null,
		CALLBACK(src, PROC_REF(process_response), ip, on_complete, retry)
	)

/**
 * SShttp callback for [/datum/controller/subsystem/ipintel/proc/query] — processes the HTTP
 * response from the IPIntel API.
 *
 * On success, parses the JSON body and invokes `on_complete` with the numeric result.
 * On transient errors (connection failure, unexpected status, bad JSON) the request is
 * retried once after a brief delay. On a second failure, or on a hard 429 rate-limit
 * response, `on_complete` is invoked with -1.
 *
 * Arguments:
 * * ip - The IP address that was queried
 * * on_complete - Callback to invoke with the final intel score or -1
 * * retry - TRUE if this invocation is already a retry
 * * http - The [/datum/http_response] returned by SShttp
 */
/datum/controller/subsystem/ipintel/proc/process_response(ip, datum/callback/on_complete, retry, datum/http_response/http)
	PRIVATE_PROC(TRUE)
	if (http.errored)
		handle_error("Unable to connect to API.", ip, retry)
		if (!retry)
			sleep(25)
			query(ip, on_complete, TRUE)
		else
			if (on_complete)
				on_complete.Invoke(-1)
		return

	if (http.status_code == 200)
		var/response = json_decode(http.body)
		if (response)
			if (response["status"] == "success")
				var/intelnum = text2num(response["result"])
				if (isnum(intelnum))
					if (on_complete)
						on_complete.Invoke(intelnum)
					return
				else
					handle_error("Bad intel from server: [response["result"]].", ip, retry)
			else
				handle_error("Bad response from server: [response["status"]].", ip, retry)
		if (!retry)
			sleep(25)
			query(ip, on_complete, TRUE)
		else
			if (on_complete)
				on_complete.Invoke(-1)
	else if (http.status_code == 429)
		handle_error("Status Code 429: We have exceeded the rate limit.", ip, TRUE)
		if (on_complete)
			on_complete.Invoke(-1)
	else
		handle_error("Unknown status code: [http.status_code].", ip, retry)
		if (!retry)
			sleep(25)
			query(ip, on_complete, TRUE)
		else
			if (on_complete)
				on_complete.Invoke(-1)

/**
 * Logs an IPIntel error and, on a final retry failure, increments [/datum/controller/subsystem/ipintel/var/errors]
 * and sets [/datum/controller/subsystem/ipintel/var/throttle] to temporarily suppress further API calls.
 *
 * The throttle duration grows linearly with the error count:
 * each additional failure adds another 12-second window (10 ticks × 120 × error count).
 * All errors are written via [/proc/log_subsystem_ipintel].
 *
 * Arguments:
 * * error - Base error message to log
 * * ip - The IP address that triggered the error
 * * retry - TRUE if this is a final failure (no further retry will be attempted)
 */
/datum/controller/subsystem/ipintel/proc/handle_error(error, ip, retry)
	PRIVATE_PROC(TRUE)
	if (retry)
		errors++
		error += " Could not check [ip]. Disabling IPINTEL for [errors] minute\s"
		throttle = world.timeofday + (10 * 120 * errors)
	else
		error += " Attempting retry on [ip]."
	log_subsystem_ipintel(error)

