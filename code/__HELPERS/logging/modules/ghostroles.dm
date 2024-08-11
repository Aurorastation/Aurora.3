/proc/log_module_ghostroles(text)
	if (GLOB.config?.logsettings["log_modules_ghostroles"])
		WRITE_LOG(GLOB.config.logfiles["world_modules_ghostroles_log"], "GHOSTROLES: [text]")

/proc/log_module_ghostroles_spawner(text)
// Suppress during unit testing
#if defined(UNIT_TEST)
	LOG_GITHUB_DEBUG("GHOSTROLES SPAWNER: [text]")
#else
	if (GLOB.config?.logsettings["log_modules_ghostroles"])
		WRITE_LOG(GLOB.config.logfiles["world_modules_ghostroles_log"], "GHOSTROLES SPAWNER: [text]")
#endif
