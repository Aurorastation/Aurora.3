/proc/log_module_sectors(text)
#if defined(UNIT_TEST)
	LOG_GITHUB_NOTICE("Sectors: [text]")
#else
	if (config?.logsettings["log_modules_sectors"])
		WRITE_LOG(config.logfiles["world_modules_sectors_log"], "Sectors: [text]")
#endif
