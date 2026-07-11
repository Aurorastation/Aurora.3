/proc/log_subsystem_zas(text)
#if defined(UNIT_TEST)
	LOG_GITHUB_DEBUG("ZAS: [text]")
#else
	if (GLOB.config.logsettings["log_subsystems_zas"])
		WRITE_LOG(GLOB.config.logfiles["world_subsystems_zas"], "ZAS: [text]")
#endif
	logger?.Log(LOG_CATEGORY_SUBSYSTEM_ZAS, "ZAS: [text]")

/proc/log_subsystem_zas_debug(text)
#if defined(UNIT_TEST)
	LOG_GITHUB_DEBUG("ZAS-Debug: [text]")
#else
	if (GLOB.config.logsettings["log_subsystems_zas_debug"])
		WRITE_LOG(GLOB.config.logfiles["world_subsystems_zas_debug"], "ZAS-Debug: [text]")
#endif
	logger?.Log(LOG_CATEGORY_SUBSYSTEM_ZAS_DEBUG, "ZAS-Debug: [text]")
