/// Logging for PDA messages sent
/proc/log_pda(text)
	if (GLOB.config.logsettings["log_pda"])
		WRITE_LOG(GLOB.config.logfiles["world_pda_log"], "PDA: [text]")

/// Logging for newscaster comments
/proc/log_comment(text)
	//reusing the PDA option because I really don't think news comments are worth a config option
	if (GLOB.config.logsettings["log_pda"])
		WRITE_LOG(GLOB.config.logfiles["world_pda_log"], "COMMENT: [text]")

/// Logging for chatting on modular computer channels
/proc/log_chat(text)
	//same thing here
	if (GLOB.config.logsettings["log_pda"])
		WRITE_LOG(GLOB.config.logfiles["world_pda_log"], "PDA CHAT: [text]")
