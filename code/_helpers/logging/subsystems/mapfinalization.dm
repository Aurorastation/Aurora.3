/proc/log_subsystem_mapfinalization(text)
#if defined(UNIT_TEST)
	LOG_GITHUB_NOTICE("SSMapfinalization: [text]")
#else
	if (GLOB.config?.logsettings["log_subsystems_mapfinalization"])
		WRITE_LOG(GLOB.config.logfiles["world_subsystems_mapfinalization_log"], "SSMapfinalization: [text]")
#endif

/**
 * This is used to highlight errors in github
 */
/proc/log_subsystem_mapfinalization_error(text)
#if defined(UNIT_TEST)
	LOG_GITHUB_ERROR("SSMapfinalization: [text]")
#else
	if (GLOB.config?.logsettings["log_subsystems_mapfinalization"])
		WRITE_LOG(GLOB.config.logfiles["world_subsystems_mapfinalization_log"], "SSMapfinalization: [text]")
#endif
