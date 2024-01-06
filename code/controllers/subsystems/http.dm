SUBSYSTEM_DEF(http)
	name = "HTTP"
	flags = SS_TICKER | SS_BACKGROUND | SS_NO_INIT // Measure in ticks, but also only run if we have the spare CPU.
	wait = 1
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY // All the time

	/// List of all async HTTP requests in the processing chain
	var/list/datum/http_request/active_async_requests = list()
	/// List of async HTTP Requests to retry
	var/list/datum/http_request/retry_async_requests = list()
	/// Variable to define if logging is enabled or not. Disabled by default since we know the requests the server is making. Enable with VV if you need to debug requests
	var/logging_enabled = FALSE
	/// Total requests the SS has processed in a round
	var/total_requests
	/// Maximum times a http request is retried
	var/max_retry_count = 3

/datum/controller/subsystem/http/stat_entry(msg)
	return "P: [length(active_async_requests)] | R: [length(retry_async_requests)] | T: [total_requests]"

/datum/controller/subsystem/http/fire(resumed)
	for(var/r in retry_async_requests)
		var/datum/http_request/req = r
		//If the time to retry it has come move it to the active queue again
		if(world.time >= req.retry_at)
			active_async_requests += req
			retry_async_requests -= req

	for(var/r in active_async_requests)
		var/datum/http_request/req = r
		// Check if we are complete
		if(req.is_complete())
			// If so, take it out the processing list
			active_async_requests -= req
			var/datum/http_response/res = req.into_response()
			var/list/log_data = list()

			//Log the reponse we have got
			log_data += "BEGIN ASYNC RESPONSE (ID: [req.id] RETRY: [req.retry_count])"
			if(res.errored)
				log_data += "\t ----- RESPONSE ERRROR -----"
				log_data += "\t [res.error]"
			else
				log_data += "\tResponse status code: [res.status_code]"
				log_data += "\tResponse body: [res.body]"
				log_data += "\tResponse headers: [json_encode(res.headers)]"
			log_data += "END ASYNC RESPONSE (ID: [req.id])"
			log_subsystem_http(log_data.Join("\n"))

			// Automatically Retry if we have a 429 or 503 Status with a retry-after header
			if((res.status_code == 429 || res.status_code == 503) && ("retry-after" in res.headers) )
				var/retry_after = text2num(res.headers["retry-after"])
				if(retry_after == 0 && req.cb)
					if(req.cb)
						req.cb.InvokeAsync(res)
					continue // If we get a Retry-After 0 back, we dont retry it
				if(req.retry_count >= max_retry_count)
					if(req.cb)
						req.cb.InvokeAsync(res)
					continue // If we exceed our maximum retry count, we dont retry it

				req.retry_at = world.time + (retry_after*10)
				req.retry_count++
				retry_async_requests += req
				continue //Dont invoke the callback yet as we dont have a final error

			// If the request has a callback, invoke it. Async of course to avoid choking the SS
			if(req.cb)
				req.cb.InvokeAsync(res)

/**
 * Async request creator
 *
 * Generates an async request, and adds it to the subsystem's processing list.
 * These should be used as they do not lock the entire DD process up as they execute inside their own thread pool inside RUSTG.
 * If a 429 or 503 is encountered and a retry-after header is returned the requested is retrued up to [/datum/controller/subsystem/http/var/max_retry_count] times.
 * During the retries the retry-after header is respected.
 * A callback can be supplied to this proc. If a callback is supplied it is only invoked when after the final request.
 *
 * Arguments:
 * * method - HTTP method to use -> use the RUSTG_HTTP_METHOD_ MACROS
 * * url - URL where the request should go to
 * * body - The body of the request
 * * headers - list of headers to pass along
 * * proc_callback - A Callback to be invoced when a final status is reached
 */
/datum/controller/subsystem/http/proc/create_async_request(method, url, body = "", list/headers, datum/callback/proc_callback)
	var/datum/http_request/req = new()
	req.prepare(method, url, body, headers)
	if(proc_callback)
		req.cb = proc_callback

	// Begin it and add it to the SS active list
	req.begin_async()
	active_async_requests += req
	total_requests++

	// Log it
	var/list/log_data = list()
	log_data += "BEGIN ASYNC REQUEST (ID: [req.id])"
	log_data += "\t[uppertext(req.method)] [req.url]"
	log_data += "\tRequest body: [req.body]"
	log_data += "\tRequest headers: [req.headers]"
	log_data += "END ASYNC REQUEST (ID: [req.id])"
	log_subsystem_http(log_data.Join("\n"))
