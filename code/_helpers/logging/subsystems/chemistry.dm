/proc/log_subsystem_chemistry(text)
	if (config?.logsettings["log_subsystems_chemistry"])
		WRITE_LOG(config.logfiles["world_subsystems_chemistry_log"], "SSChemistry: [text]")
