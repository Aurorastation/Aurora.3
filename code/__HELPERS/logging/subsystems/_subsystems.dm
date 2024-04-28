/proc/log_subsystem_mastercontroller(text)
	if (GLOB.config?.logsettings["log_subsystems"])
		WRITE_LOG(GLOB.config.logfiles["world_subsystems_log"], "SUBSYSTEM MASTERCONTROLLER: [text]")

	send_gelf_log(text, "[time_stamp()]: [text]", SEVERITY_INFO, "MASTER")

/proc/log_subsystem(subsystem, text, log_world = TRUE, severity = SEVERITY_DEBUG)
	if (!subsystem)
		subsystem = "UNKNOWN"
	var/msg = "[subsystem]: [text]"

	if (GLOB.config?.logsettings["log_subsystems"])
		WRITE_LOG(GLOB.config.logfiles["world_subsystems_log"], "SUBSYSTEM: [msg]")

	send_gelf_log(msg, "[time_stamp()]: [msg]", severity, "SUBSYSTEM", additional_data = list("_subsystem" = subsystem))
	// if (log_world)
	// 	world.log <<  "SS[subsystem]: [text]"

/proc/log_subsystem_init(text)
#if defined(UNIT_TEST)
	LOG_GITHUB_DEBUG("SUBSYSTEM INIT: [text]")
#else
	if (GLOB.config?.logsettings["log_subsystems"])
		WRITE_LOG(GLOB.config.logfiles["world_subsystems_log"], "SUBSYSTEM INIT: [text]")

	send_gelf_log(text, "[time_stamp()]: [text]", SEVERITY_INFO, "SS Init")
#endif

// Generally only used when something has gone very wrong.
/proc/log_failsafe(text)
	if (GLOB.config?.logsettings["log_subsystems"])
		WRITE_LOG(GLOB.config.logfiles["world_subsystems_log"], "SUBSYSTEM FAILSAFE: [text]")

	send_gelf_log(text, "[time_stamp()]: [text]", SEVERITY_ALERT, "FAILSAFE")
