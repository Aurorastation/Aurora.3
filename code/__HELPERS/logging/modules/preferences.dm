/proc/log_module_preferences(text)
#if defined(UNIT_TEST)
	LOG_GITHUB_NOTICE("Preferences: [text]")
#else
	if (GLOB.config?.logsettings["log_modules_preferences"])
		WRITE_LOG(GLOB.config.logfiles["world_modules_preferenes_log"], "Preferences: [text]")
#endif
