/proc/log_module_ruins(text)
#if defined(UNIT_TEST)
	LOG_GITHUB_NOTICE("Ruins: [text]")
#else
	if (GLOB.config?.logsettings["log_modules_ruins"])
		WRITE_LOG(GLOB.config.logfiles["world_modules_ruins_log"], "Ruins: [text]")
#endif

/**
 * Used to highlight warnings on Github during Unit Tests
 */
/proc/log_module_ruins_warning(text)
#if defined(UNIT_TEST)
	LOG_GITHUB_WARNING("Ruins: [text]")
#else
	if (GLOB.config?.logsettings["log_modules_ruins"])
		WRITE_LOG(GLOB.config.logfiles["world_modules_ruins_log"], "Ruins: [text]")
#endif
