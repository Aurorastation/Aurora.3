/proc/log_subsystem_atlas(text)
	if (GLOB.config?.logsettings["log_subsystems_atlas"])
		WRITE_LOG(GLOB.config.logfiles["world_subsystems_atlas_log"], "SSAtlas: [text]")
