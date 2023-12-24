/proc/log_subsystem_discord(text)
	if (GLOB.config?.logsettings["log_subsystems_discord"])
		WRITE_LOG(config.logfiles["world_subsystems_discord_log"], "SSdiscord: [text]")
