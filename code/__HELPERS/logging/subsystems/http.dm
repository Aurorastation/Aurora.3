/// Logging for HTTP Requests
/proc/log_subsystem_http(text)
	logger?.Log(LOG_CATEGORY_SUBSYSTEM_HTTP, "HTTP: [text]")
