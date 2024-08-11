/proc/log_module_customitems(text)
#if defined(UNIT_TEST)
	LOG_GITHUB_DEBUG("CUSTOMITEMS: [text]")
#else
	if (GLOB.config?.logsettings["log_modules_customitems"])
		WRITE_LOG(GLOB.config.logfiles["world_modules_customitems_log"], "CUSTOMITEMS: [text]")
#endif
