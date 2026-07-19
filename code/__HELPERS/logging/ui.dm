/// Logging for raw hrefs sent through client Topic.
/proc/log_href(text, list/data)
	if(GLOB.config && GLOB.config.logsettings["log_hrefs"] && GLOB.href_logfile)
		WRITE_LOG(GLOB.config.logfiles["world_href_log"], text)
	logger?.Log(LOG_CATEGORY_HREF, text, data)
