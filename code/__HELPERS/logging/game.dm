/// Logging for generic/unsorted game messages
/proc/_log_game(text)
	if (GLOB.config.logsettings["log_game"])
		WRITE_LOG(GLOB.config.logfiles["world_game_log"], "GAME: [text]")

/proc/log_game_mode(text)
// SUppress this in case of unit tests, it's essentially useless
#if defined(UNIT_TEST)
	LOG_GITHUB_DEBUG("GAMEMODE: [text]")
#else
	if (GLOB.config.logsettings["log_game"])
		WRITE_LOG(GLOB.config.logfiles["world_game_log"], "GAMEMODE: [text]")
#endif

/// Logging for emotes
/proc/_log_emote(text)
#if defined(UNIT_TEST)
	LOG_GITHUB_DEBUG("EMOTE: [text]")
#else
	if (GLOB.config.logsettings["log_emote"])
		WRITE_LOG(GLOB.config.logfiles["world_game_log"], "EMOTE: [text]")
#endif

/// Logging for emotes sent over the radio
/proc/log_radio_emote(text)
	if (GLOB.config.logsettings["log_emote"])
		WRITE_LOG(GLOB.config.logfiles["world_game_log"], "RADIOEMOTE: [text]")

/// Logging for messages sent in OOC
/proc/_log_ooc(text)
	if (GLOB.config.logsettings["log_ooc"])
		WRITE_LOG(GLOB.config.logfiles["world_game_log"], "OOC: [text]")

/// Logging for prayed messages
/proc/log_prayer(text)
	if (GLOB.config.logsettings["log_prayer"])
		WRITE_LOG(GLOB.config.logfiles["world_game_log"], "PRAY: [text]")

/// Logging for logging in & out of the game, with error messages.
/proc/_log_access(text)
	if (GLOB.config.logsettings["log_access"])
		WRITE_LOG(GLOB.config.logfiles["world_game_log"], "ACCESS: [text]")

/// Logging for OOC votes
/proc/_log_vote(text)
	if (GLOB.config.logsettings["log_vote"])
		WRITE_LOG(GLOB.config.logfiles["world_game_log"], "VOTE: [text]")

