/// Logging for HTTP Requests
/proc/log_subsystem_http(text)
	if(GLOB.config.logsettings["log_subsystems_http"])
		WRITE_LOG(GLOB.config.logfiles["world_subsystems_http"], "HTTP: [text]")
