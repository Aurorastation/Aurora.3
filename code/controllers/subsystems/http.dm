var/datum/controller/subsystem/http/SShttp

/datum/controller/subsystem/http
	name = "HTTP"
	flags = SS_NO_FIRE | SS_NO_INIT

/datum/controller/subsystem/http/New()
	NEW_SS_GLOBAL(SShttp)

/datum/controller/subsystem/http/proc/request(method, url, body = "", list/headers)
	var/datum/http_request/R = new()
	R.prepare(method, url, body, headers)

	return R

/datum/controller/subsystem/http/proc/get(url, body = "", list/headers)
	return request(RUSTG_HTTP_METHOD_GET, url, body, headers)

/datum/controller/subsystem/http/proc/post(url, body = "", list/headers)
	return request(RUSTG_HTTP_METHOD_POST, url, body, headers)

/datum/controller/subsystem/http/proc/put(url, body = "", list/headers)
	return request(RUSTG_HTTP_METHOD_PUT, url, body, headers)

/datum/controller/subsystem/http/proc/delete(url, body = "", list/headers)
	return request(RUSTG_HTTP_METHOD_DELETE, url, body, headers)

/datum/controller/subsystem/http/proc/patch(url, body = "", list/headers)
	return request(RUSTG_HTTP_METHOD_PATCH, url, body, headers)

/datum/controller/subsystem/http/proc/head(url, body = "", list/headers)
	return request(RUSTG_HTTP_METHOD_HEAD, url, body, headers)

/datum/http_request
	var/id
	var/in_progress = FALSE

	var/method
	var/body
	var/headers
	var/url

	var/_raw_response

/datum/http_request/proc/prepare(method, url, body = "", list/headers)
	if (!length(headers))
		headers = ""
	else
		headers = json_encode(headers)

	src.method = method
	src.url = url
	src.body = body
	src.headers = headers

/datum/http_request/proc/execute_blocking()
	_raw_response = rustg_http_request_blocking(method, url, body, headers)

/datum/http_request/proc/begin_async()
	if (in_progress)
		crash_with("Attempted to re-use a request object.")

	id = rustg_http_request_async(method, url, body, headers)

	if (isnull(text2num(id)))
		crash_with("Proc error: [id]")
		_raw_response = "Proc error: [id]"
	else
		in_progress = TRUE

/datum/http_request/proc/is_complete()
	if (isnull(id))
		return TRUE

	if (!in_progress)
		return TRUE

	var/r = rustg_http_check_request(id)

	if (r == RUSTG_JOB_NO_RESULTS_YET)
		return FALSE
	else
		_raw_response = r
		in_progress = FALSE
		return TRUE

/datum/http_request/proc/into_response()
	var/datum/http_response/R = new()

	try
		var/list/L = json_decode(_raw_response)
		R.status_code = L["status_code"]
		R.headers = L["headers"]
		R.body = L["body"]
	catch
		R.errored = TRUE
		R.error = _raw_response

	return R

/datum/http_response
	var/status_code
	var/body
	var/list/headers

	var/errored = FALSE
	var/error
