/// Logging for raw hrefs sent through client Topic.
/proc/log_href(text, list/data)
	logger?.Log(LOG_CATEGORY_HREF, text, data)
