/// Logging for generic spoken messages
/proc/log_say(text, list/data)
#if defined(UNIT_TEST)
	LOG_GITHUB_DEBUG("SAY: [text]")
#else
	if (GLOB.config.logsettings["log_say"])
		WRITE_LOG(GLOB.config.logfiles["world_game_log"], "SAY: [text]")
#endif
	logger?.Log(LOG_CATEGORY_GAME_SAY, "SAY: [text]", data)

/// Logging for whispered messages
/proc/log_whisper(text, list/data)
	if (GLOB.config.logsettings["log_whisper"])
		WRITE_LOG(GLOB.config.logfiles["world_game_log"], "WHISPER: [text]")
	logger?.Log(LOG_CATEGORY_GAME_WHISPER, "WHISPER: [text]", data)

/// Helper for logging of messages with only one sender and receiver (i.e. mind links)
/proc/log_directed_talk(atom/source, atom/target, message, message_type, tag)
	if(!tag)
		stack_trace("Unspecified tag for private message")
		tag = "UNKNOWN"
	WRITE_LOG(GLOB.config.logfiles["world_game_log"], "[target] received [message] of type [message_type] - [tag] from [source]")
	logger?.Log(LOG_CATEGORY_GAME_SAY, "[target] received [message] of type [message_type] - [tag] from [source]", list(
		"source" = source,
		"target" = target,
		"message_type" = message_type,
		"tag" = tag,
	))

/// Logging for speech taking place over comms, as well as tcomms equipment
/proc/log_telecomms(text, list/data)
	if (GLOB.config.logsettings["log_telecomms"])
		WRITE_LOG(GLOB.config.logfiles["world_telecomms_log"], "TCOMMS: [text]")
	logger?.Log(LOG_CATEGORY_TELECOMMS, "TCOMMS: [text]", data)
