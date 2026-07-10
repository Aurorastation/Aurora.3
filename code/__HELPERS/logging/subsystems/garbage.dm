/// Log for the garbage collector
/proc/log_subsystem_garbage(text, type, high_severity = FALSE)
	logger?.Log(LOG_CATEGORY_SUBSYSTEM_GARBAGE, "SSGarbage [text]", list(
		"type" = type,
		"high_severity" = high_severity,
	))

/proc/log_subsystem_garbage_warning(text, type, high_severity = FALSE)
	logger?.Log(LOG_CATEGORY_SUBSYSTEM_GARBAGE, "WARNING: SSGarbage [text]", list(
		"type" = type,
		"high_severity" = high_severity,
	))

/proc/log_subsystem_garbage_error(text, type, high_severity = FALSE)
	logger?.Log(LOG_CATEGORY_SUBSYSTEM_GARBAGE, "ERROR: SSGarbage [text]", list(
		"type" = type,
		"high_severity" = high_severity,
	))

/proc/log_subsystem_garbage_harddel(text)
	logger?.Log(LOG_CATEGORY_HARDDEL, text)
