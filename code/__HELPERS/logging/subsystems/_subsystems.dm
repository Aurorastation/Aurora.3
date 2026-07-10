/proc/log_subsystem(subsystem, text, log_world = TRUE, severity = SEVERITY_DEBUG)
	if (!subsystem)
		subsystem = "UNKNOWN"
	var/msg = "[subsystem]: [text]"

	logger?.Log(LOG_CATEGORY_SUBSYSTEM, "SUBSYSTEM: [msg]", list(
		"subsystem" = subsystem,
		"severity" = severity,
	))
	// if (log_world)
	// 	world.log <<  "SS[subsystem]: [text]"

/proc/log_subsystem_init(text)
	logger?.Log(LOG_CATEGORY_SUBSYSTEM, "SUBSYSTEM INIT: [text]")

// Generally only used when something has gone very wrong.
/proc/log_failsafe(text)
	logger?.Log(LOG_CATEGORY_SUBSYSTEM, "SUBSYSTEM FAILSAFE: [text]")
