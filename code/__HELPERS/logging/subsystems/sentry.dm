/// Logging for the Sentry subsystem itself (not the events it forwards).
/proc/log_subsystem_sentry(text)
	logger?.Log(LOG_CATEGORY_SUBSYSTEM_SENTRY, "SSsentry: [text]")
