/proc/log_module_exoplanets(text)
#if defined(UNIT_TEST)
	LOG_GITHUB_NOTICE("Exoplanets: [text]")
#else
	if (GLOB.config?.logsettings["log_modules_exoplanets"])
		WRITE_LOG(GLOB.config.logfiles["world_modules_exoplanets_log"], "Exoplanets: [text]")
#endif
