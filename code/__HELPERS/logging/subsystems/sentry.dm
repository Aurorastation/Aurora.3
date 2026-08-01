/// Logging for the Sentry subsystem itself (not the events it forwards).
/proc/log_subsystem_sentry(text)
	if (GLOB.config?.logsettings["log_subsystems_sentry"])
		WRITE_LOG(GLOB.config.logfiles["world_subsystems_sentry_log"], "SSsentry: [text]")
