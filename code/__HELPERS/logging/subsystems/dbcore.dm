/proc/log_subsystem_dbcore(text)
	if (GLOB.config?.logsettings["log_subsystems_dbcore"])
		WRITE_LOG(GLOB.config.logfiles["world_subsystems_dbcore_log"], "SSdbcore: [text]")
