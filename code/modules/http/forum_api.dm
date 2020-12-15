var/global/forum_api_key = null

/datum/http_request/forum_api
	var/end_point

/datum/http_request/forum_api/New(ep)
	end_point = ep

/datum/http_request/forum_api/proc/_get_url(suffix)
	PRIVATE_PROC(TRUE)

	. = "[config.forum_api_path]/[end_point]"

	if (suffix)
		. += "/[suffix]"

	. += "?key=[global.forum_api_key]"

/datum/http_request/forum_api/proc/prepare_get(subtopic, list/params)
	var/url = _get_url(subtopic)

	if (length(params))
		url += "&[list2params(params)]"

	prepare(RUSTG_HTTP_METHOD_GET, url, null, null)

/datum/http_request/forum_api/proc/prepare_post(subtopic, list/params)
	prepare(RUSTG_HTTP_METHOD_POST, _get_url(subtopic), params2list(params), list("Content-Type" = "application/x-www-form-urlencoded"))

/datum/http_request/forum_api/proc/prepare_delete(subtopic, list/params)
	prepare(RUSTG_HTTP_METHOD_DELETE, _get_url(subtopic), params2list(params), list("Content-Type" = "application/x-www-form-urlencoded"))

/datum/http_request/forum_api/into_response()
	var/datum/http_response/R = ..()

	if (R.errored)
		return R

	try
		R.body = json_decode(R.body)
	catch
		R.errored = TRUE
		R.error = "Malformed JSON returned."
		return R

	var/list/resp_data = R.body
	if (resp_data["errorCode"])
		R.errored = TRUE
		R.error = resp_data["errorMessage"]

	return R
