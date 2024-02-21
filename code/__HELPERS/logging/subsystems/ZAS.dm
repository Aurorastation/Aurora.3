/proc/log_subsystem_zas(text)
// SUppress this in case of unit tests, it's essentially useless
#if defined(UNIT_TEST)
	LOG_GITHUB_DEBUG("ZAS: [text]")
#else
	if (GLOB.config.logsettings["log_subsystems_zas"])
		WRITE_LOG(GLOB.config.logfiles["log_subsystems_zas"], "ZAS: [text]")
#endif

/proc/log_subsystem_zas_debug(text)
// SUppress this in case of unit tests, it's essentially useless
#if defined(UNIT_TEST)
	LOG_GITHUB_DEBUG("ZAS-Debug: [text]")
#else
	if (GLOB.config.logsettings["log_subsystems_zas_debug"])
		WRITE_LOG(GLOB.config.logfiles["log_subsystems_zas_debug"], "ZAS-Debug: [text]")
#endif
