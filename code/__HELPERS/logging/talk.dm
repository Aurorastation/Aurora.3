/**
 * Helper for logging chat messages or other logs with arbitrary inputs (e.g. announcements)
 *
 * This proc compiles a log string by prefixing the tag to the message
 * and suffixing what it was forced_by if anything
 * if the message lacks a tag and suffix then it is logged on its own
 * Arguments:
 * * message - The message being logged
 * * message_type - the type of log the message is(ATTACK, SAY, etc)
 * * tag - tag that indicates the type of text(announcement, telepathy, etc)
 * * log_globally - boolean checking whether or not we write this log to the log file
 * * forced_by - source that forced the dialogue if any
 */
/atom/proc/log_talk(message, message_type, tag = null, log_globally = TRUE, forced_by = null, custom_say_emote = null)
	var/prefix = tag ? "([tag]) " : ""
	var/suffix = forced_by ? " FORCED by [forced_by]" : ""
	WRITE_LOG(GLOB.config.logfiles["world_game_log"], "[prefix][custom_say_emote ? "*[custom_say_emote]*, " : ""]\"[message]\"[suffix] - [message_type]")

/// Logging for generic spoken messages
/proc/_log_say(text)
#if defined(UNIT_TEST)
	LOG_GITHUB_DEBUG("SAY: [text]")
#else
	if (GLOB.config.logsettings["log_say"])
		WRITE_LOG(GLOB.config.logfiles["world_game_log"], "SAY: [text]")
#endif

/// Logging for whispered messages
/proc/_log_whisper(text)
	if (GLOB.config.logsettings["log_whisper"])
		WRITE_LOG(GLOB.config.logfiles["world_game_log"], "WHISPER: [text]")

/// Helper for logging of messages with only one sender and receiver (i.e. mind links)
/proc/log_directed_talk(atom/source, atom/target, message, message_type, tag)
	if(!tag)
		stack_trace("Unspecified tag for private message")
		tag = "UNKNOWN"
	WRITE_LOG(GLOB.config.logfiles["world_game_log"], "[target] received [message] of type [message_type] - [tag] from [source]")

/// Logging for speech taking place over comms, as well as tcomms equipment
/proc/log_telecomms(text)
	if (GLOB.config.logsettings["log_telecomms"])
		WRITE_LOG(GLOB.config.logfiles["world_telecomms_log"], "TCOMMS: [text]")
