/proc/log_subsystem_odyssey(text)
	if (GLOB.config?.logsettings["log_subsystems_odyssey"])
		WRITE_LOG(GLOB.config.logfiles["world_subsystems_odyssey_log"], "SSodyssey: [text]")
