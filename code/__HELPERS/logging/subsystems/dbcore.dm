/proc/log_subsystem_dbcore(text)
	logger?.Log(LOG_CATEGORY_SUBSYSTEM_DBCORE, "SSdbcore: [text]")
	if(SSsentry)
		SSsentry.capture_message(text, "error", "sql")
