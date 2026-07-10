/proc/log_subsystem_persistence(text)
	logger?.Log(LOG_CATEGORY_SUBSYSTEM_PERSISTENCE, "SSPersistence: [text]")

/proc/log_subsystem_persistence_info(text)
	log_subsystem_persistence("INFO: [text]")

/proc/log_subsystem_persistence_warning(text)
	log_subsystem_persistence("WARNING: [text]")

/proc/log_subsystem_persistence_error(text)
	log_subsystem_persistence("ERROR: [text]")

/proc/log_subsystem_persistence_panic(text)
	log_subsystem_persistence("PANIC: [text]")
