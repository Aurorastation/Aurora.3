/// Logging for loadout things
/proc/log_loadout(text)
	if (GLOB.config.logsettings["log_loadout"])
		WRITE_LOG(GLOB.config.logfiles["world_loadout_log"], "LOADOUT: [text]")
