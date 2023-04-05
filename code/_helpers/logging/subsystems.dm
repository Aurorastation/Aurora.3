/proc/log_mc(text)
	log_world("MASTER [text]")
	send_gelf_log(text, "[time_stamp()]: [text]", SEVERITY_INFO, "MASTER")

/proc/log_ss(subsystem, text, log_world = TRUE, severity = SEVERITY_DEBUG)
	if (!subsystem)
		subsystem = "UNKNOWN"
	var/msg = "[subsystem]: [text]"
	log_world("SS [msg]")
	send_gelf_log(msg, "[time_stamp()]: [msg]", severity, "SUBSYSTEM", additional_data = list("_subsystem" = subsystem))
	if (log_world)
		world.log <<  "SS[subsystem]: [text]"

/proc/log_ss_init(text)
	log_world("SSInit [text]")
	send_gelf_log(text, "[time_stamp()]: [text]", SEVERITY_INFO, "SS Init")

// Generally only used when something has gone very wrong.
/proc/log_failsafe(text)
	log_world("FAILSAFE [text]")
	send_gelf_log(text, "[time_stamp()]: [text]", SEVERITY_ALERT, "FAILSAFE")
