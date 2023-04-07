/proc/log_module_ghostroles(text)
	if (config?.logsettings["log_modules_ghostroles"])
		WRITE_LOG(config.world_modules_ghostroles_log, "GHOSTROLES: [text]")

/proc/log_module_ghostroles_spawner(text)
// Suppress during unit testing
#if defined(UNIT_TEST)
	TEST_DEBUG("GHOSTROLES SPAWNER: [text]")
#else
	if (config?.logsettings["log_modules_ghostroles"])
		WRITE_LOG(config.world_modules_ghostroles_log, "GHOSTROLES SPAWNER: [text]")
#endif
