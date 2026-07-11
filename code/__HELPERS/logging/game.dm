/// Logging for generic/unsorted game messages
/proc/log_game(text, list/data)
	if (GLOB.config.logsettings["log_game"])
		WRITE_LOG(GLOB.config.logfiles["world_game_log"], "GAME: [text]")
	logger?.Log(LOG_CATEGORY_GAME, "GAME: [text]", data)

/proc/log_game_mode(text)
#if defined(UNIT_TEST)
	LOG_GITHUB_DEBUG("GAMEMODE: [text]")
#else
	if (GLOB.config.logsettings["log_game"])
		WRITE_LOG(GLOB.config.logfiles["world_game_log"], "GAMEMODE: [text]")
#endif
	logger?.Log(LOG_CATEGORY_GAME, "GAMEMODE: [text]")

/// Logging for emotes
/proc/log_emote(text, list/data)
#if defined(UNIT_TEST)
	LOG_GITHUB_DEBUG("EMOTE: [text]")
#else
	if (GLOB.config.logsettings["log_emote"])
		WRITE_LOG(GLOB.config.logfiles["world_game_log"], "EMOTE: [text]")
#endif
	logger?.Log(LOG_CATEGORY_GAME_EMOTE, "EMOTE: [text]", data)

/// Logging for emotes sent over the radio
/proc/log_radio_emote(text, list/data)
	if (GLOB.config.logsettings["log_emote"])
		WRITE_LOG(GLOB.config.logfiles["world_game_log"], "RADIOEMOTE: [text]")
	logger?.Log(LOG_CATEGORY_GAME_RADIO_EMOTE, "RADIOEMOTE: [text]", data)

/// Logging for messages sent in OOC
/proc/log_ooc(text, list/data)
	if (GLOB.config.logsettings["log_ooc"])
		WRITE_LOG(GLOB.config.logfiles["world_game_log"], "OOC: [text]")
	logger?.Log(LOG_CATEGORY_GAME_OOC, "OOC: [text]", data)

/// Logging for prayed messages
/proc/log_prayer(text, list/data)
	if (GLOB.config.logsettings["log_prayer"])
		WRITE_LOG(GLOB.config.logfiles["world_game_log"], "PRAY: [text]")
	logger?.Log(LOG_CATEGORY_GAME_PRAYER, "PRAY: [text]", data)

/// Logging for logging in & out of the game, with error messages.
/proc/log_access(text, list/data)
	if (GLOB.config.logsettings["log_access"])
		WRITE_LOG(GLOB.config.logfiles["world_game_log"], "ACCESS: [text]")
	logger?.Log(LOG_CATEGORY_GAME_ACCESS, "ACCESS: [text]", data)

/// Logging for OOC votes
/proc/log_vote(text, list/data)
	if (GLOB.config.logsettings["log_vote"])
		WRITE_LOG(GLOB.config.logfiles["world_game_log"], "VOTE: [text]")
	logger?.Log(LOG_CATEGORY_GAME_VOTE, "VOTE: [text]", data)
