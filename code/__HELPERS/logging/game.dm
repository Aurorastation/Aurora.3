/// Logging for generic/unsorted game messages
/proc/log_game(text, list/data)
	logger?.Log(LOG_CATEGORY_GAME, "GAME: [text]", data)

/proc/log_game_mode(text)
	logger?.Log(LOG_CATEGORY_GAME, "GAMEMODE: [text]")

/// Logging for emotes
/proc/log_emote(text, list/data)
	logger?.Log(LOG_CATEGORY_GAME_EMOTE, "EMOTE: [text]", data)

/// Logging for emotes sent over the radio
/proc/log_radio_emote(text, list/data)
	logger?.Log(LOG_CATEGORY_GAME_RADIO_EMOTE, "RADIOEMOTE: [text]", data)

/// Logging for messages sent in OOC
/proc/log_ooc(text, list/data)
	logger?.Log(LOG_CATEGORY_GAME_OOC, "OOC: [text]", data)

/// Logging for prayed messages
/proc/log_prayer(text, list/data)
	logger?.Log(LOG_CATEGORY_GAME_PRAYER, "PRAY: [text]", data)

/// Logging for logging in & out of the game, with error messages.
/proc/log_access(text, list/data)
	logger?.Log(LOG_CATEGORY_GAME_ACCESS, "ACCESS: [text]", data)

/// Logging for OOC votes
/proc/log_vote(text, list/data)
	logger?.Log(LOG_CATEGORY_GAME_VOTE, "VOTE: [text]", data)
