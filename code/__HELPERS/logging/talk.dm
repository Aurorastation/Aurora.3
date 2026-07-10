/// Logging for generic spoken messages
/proc/log_say(text, list/data)
	logger?.Log(LOG_CATEGORY_GAME_SAY, "SAY: [text]", data)

/// Logging for whispered messages
/proc/log_whisper(text, list/data)
	logger?.Log(LOG_CATEGORY_GAME_WHISPER, "WHISPER: [text]", data)

/// Helper for logging of messages with only one sender and receiver (i.e. mind links)
/proc/log_directed_talk(atom/source, atom/target, message, message_type, tag)
	if(!tag)
		stack_trace("Unspecified tag for private message")
		tag = "UNKNOWN"
	logger?.Log(LOG_CATEGORY_GAME_SAY, "[target] received [message] of type [message_type] - [tag] from [source]", list(
		"source" = source,
		"target" = target,
		"message_type" = message_type,
		"tag" = tag,
	))

/// Logging for speech taking place over comms, as well as tcomms equipment
/proc/log_telecomms(text, list/data)
	logger?.Log(LOG_CATEGORY_TELECOMMS, "TCOMMS: [text]", data)
