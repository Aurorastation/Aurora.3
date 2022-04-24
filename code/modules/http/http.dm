/proc/http_create_request(method, url, body = "", list/headers)
	var/datum/http_request/R = new()
	R.prepare(method, url, body, headers)

	return R

/proc/http_create_get(url, body = "", list/headers)
	return http_create_request(RUSTG_HTTP_METHOD_GET, url, body, headers)

/proc/http_create_post(url, body = "", list/headers)
	return http_create_request(RUSTG_HTTP_METHOD_POST, url, body, headers)

/proc/http_create_put(url, body = "", list/headers)
	return http_create_request(RUSTG_HTTP_METHOD_PUT, url, body, headers)

/proc/http_create_delete(url, body = "", list/headers)
	return http_create_request(RUSTG_HTTP_METHOD_DELETE, url, body, headers)

/proc/http_create_patch(url, body = "", list/headers)
	return http_create_request(RUSTG_HTTP_METHOD_PATCH, url, body, headers)

/proc/http_create_head(url, body = "", list/headers)
	return http_create_request(RUSTG_HTTP_METHOD_HEAD, url, body, headers)

/datum/http_request
	var/id
	var/in_progress = FALSE

	var/method
	var/body
	var/headers
	var/url
	/// If present response body will be saved to this file.
	var/output_file

	var/_raw_response

/datum/http_request/proc/prepare(method, url, body = "", list/headers, output_file)
	if (!length(headers))
		headers = ""
	else
		headers = json_encode(headers)

	src.method = method
	src.url = url
	src.body = body
	src.headers = headers
	src.output_file = output_file

/datum/http_request/proc/execute_blocking()
	_raw_response = rustg_http_request_blocking(method, url, body, headers, build_options())

/datum/http_request/proc/begin_async()
	if (in_progress)
		crash_with("Attempted to re-use a request object.")

	id = rustg_http_request_async(method, url, body, headers, build_options())

	if (isnull(text2num(id)))
		crash_with("Proc error: [id]")
		_raw_response = "Proc error: [id]"
	else
		in_progress = TRUE

/datum/http_request/proc/build_options()
	if(output_file)
		return json_encode(list("output_filename"=output_file,"body_filename"=null))
	return "{}"

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
