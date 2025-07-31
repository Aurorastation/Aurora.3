/proc/log_subsystem_persistence(text)
#if defined(UNIT_TEST)
	LOG_GITHUB_DEBUG("SSPersistence: [text]")
#else
	if (GLOB.config?.logsettings["log_subsystems_persistence"])
		WRITE_LOG(GLOB.config.logfiles["world_subsystems_persistence_log"], "SSPersistence: [text]")
#endif
