/proc/log_subsystem_atlas(text)
	if (config?.logsettings["log_subsystems_atlas"])
		WRITE_LOG(config.logfiles["world_subsystems_atlas_log"], "SSAtlas: [text]")
