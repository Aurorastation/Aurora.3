/proc/log_subsystem_fail2topic(text)
#if defined(UNIT_TEST)
	LOG_GITHUB_DEBUG("SSfail2topic: [text]")
#else
	if (GLOB.config?.logsettings["log_subsystems_fail2topic"])
		WRITE_LOG(GLOB.config.logfiles["world_subsystems_fail2topic_log"], "SSFail2topic: [text]")
#endif
