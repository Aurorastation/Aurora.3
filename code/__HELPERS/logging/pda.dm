/// Logging for PDA messages sent
/proc/log_pda(text, list/data)
	logger?.Log(LOG_CATEGORY_PDA, "PDA: [text]", data)

/// Logging for newscaster comments
/proc/log_comment(text, list/data)
	logger?.Log(LOG_CATEGORY_PDA_COMMENT, "COMMENT: [text]", data)

/// Logging for chatting on modular computer channels
/proc/log_chat(text, list/data)
	logger?.Log(LOG_CATEGORY_PDA_CHAT, "PDA CHAT: [text]", data)
