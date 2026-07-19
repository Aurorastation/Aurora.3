/proc/log_module_ghostroles(text)
	if (GLOB.config?.logsettings["log_modules_ghostroles"])
		WRITE_LOG(GLOB.config.logfiles["world_modules_ghostroles_log"], "GHOSTROLES: [text]")
	logger?.Log(LOG_CATEGORY_MODULE_GHOSTROLES, "GHOSTROLES: [text]")

/proc/log_module_ghostroles_spawner(text)
#if defined(UNIT_TEST)
	LOG_GITHUB_DEBUG("GHOSTROLES SPAWNER: [text]")
#else
	if (GLOB.config?.logsettings["log_modules_ghostroles"])
		WRITE_LOG(GLOB.config.logfiles["world_modules_ghostroles_log"], "GHOSTROLES SPAWNER: [text]")
#endif
	logger?.Log(LOG_CATEGORY_MODULE_GHOSTROLES, "GHOSTROLES SPAWNER: [text]")
