/// Logging for PDA messages sent
/proc/log_pda(text, list/data)
	if (GLOB.config.logsettings["log_pda"])
		WRITE_LOG(GLOB.config.logfiles["world_pda_log"], "PDA: [text]")
	logger?.Log(LOG_CATEGORY_PDA, "PDA: [text]", data)

/// Logging for newscaster comments
/proc/log_comment(text, list/data)
	if (GLOB.config.logsettings["log_pda"])
		WRITE_LOG(GLOB.config.logfiles["world_pda_log"], "COMMENT: [text]")
	logger?.Log(LOG_CATEGORY_PDA_COMMENT, "COMMENT: [text]", data)

/// Logging for chatting on modular computer channels
/proc/log_chat(text, list/data)
	if (GLOB.config.logsettings["log_pda"])
		WRITE_LOG(GLOB.config.logfiles["world_pda_log"], "PDA CHAT: [text]")
	logger?.Log(LOG_CATEGORY_PDA_CHAT, "PDA CHAT: [text]", data)
