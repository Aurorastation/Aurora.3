/proc/log_subsystem(subsystem, text, log_world = TRUE, severity = SEVERITY_DEBUG)
	if (!subsystem)
		subsystem = "UNKNOWN"
	var/msg = "[subsystem]: [text]"

	if (GLOB.config?.logsettings["log_subsystems"])
		WRITE_LOG(GLOB.config.logfiles["world_subsystems_log"], "SUBSYSTEM: [msg]")
	// if (log_world)
	// 	world.log <<  "SS[subsystem]: [text]"

/proc/log_subsystem_init(text)
#if defined(UNIT_TEST)
	LOG_GITHUB_DEBUG("SUBSYSTEM INIT: [text]")
#else
	if (GLOB.config?.logsettings["log_subsystems"])
		WRITE_LOG(GLOB.config.logfiles["world_subsystems_log"], "SUBSYSTEM INIT: [text]")
#endif

// Generally only used when something has gone very wrong.
/proc/log_failsafe(text)
	if (GLOB.config?.logsettings["log_subsystems"])
		WRITE_LOG(GLOB.config.logfiles["world_subsystems_log"], "SUBSYSTEM FAILSAFE: [text]")
