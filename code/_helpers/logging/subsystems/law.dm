/proc/log_subsystem_law(text)
#if defined(UNIT_TEST)
	LOG_GITHUB_DEBUG("SSLaw: [text]")
#else
	if (config?.logsettings["log_subsystems_law"])
		WRITE_LOG(config.logfiles["world_subsystems_law_log"], "SSLaw: [text]")
#endif
