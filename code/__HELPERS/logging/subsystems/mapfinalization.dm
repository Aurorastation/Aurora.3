/proc/log_subsystem_mapfinalization(text)
#if defined(UNIT_TEST)
	LOG_GITHUB_NOTICE("SSMapfinalization: [text]")
#else
	if (GLOB.config?.logsettings["log_subsystems_mapfinalization"])
		WRITE_LOG(GLOB.config.logfiles["world_subsystems_mapfinalization_log"], "SSMapfinalization: [text]")
#endif
	logger?.Log(LOG_CATEGORY_SUBSYSTEM_MAPFINALIZATION, "SSMapfinalization: [text]")
