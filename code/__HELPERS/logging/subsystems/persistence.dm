/proc/log_subsystem_persistence(text)
#if defined(UNIT_TEST)
	LOG_GITHUB_DEBUG("SSPersistence: [text]")
#else
	if (GLOB.config?.logsettings["log_subsystems_persistence"])
		WRITE_LOG(GLOB.config.logfiles["world_subsystems_persistence_log"], "SSPersistence: [text]")
#endif

/proc/log_subsystem_persistence_info(text)
	log_subsystem_persistence("INFO: [text]")

/proc/log_subsystem_persistence_warning(text)
	log_subsystem_persistence("WARNING: [text]")

/proc/log_subsystem_persistence_error(text)
	log_subsystem_persistence("ERROR: [text]")

/proc/log_subsystem_persistence_panic(text)
	log_subsystem_persistence("PANIC: [text]")
