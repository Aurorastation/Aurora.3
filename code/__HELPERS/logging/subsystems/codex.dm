/proc/log_subsystem_codex(text)
	if (GLOB.config?.logsettings["log_subsystems_codex"])
		WRITE_LOG(GLOB.config.logfiles["world_subsystems_codex_log"], "SScodex: [text]")
