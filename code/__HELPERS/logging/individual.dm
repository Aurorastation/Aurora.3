/**
 * Generic logging helper
 *
 * Reads the type of the log and writes it to the respective log file
 * unless log_globally is FALSE
 *
 * Arguments:
 * * message - The message being logged
 * * message_type - the type of log the message is(ATTACK, SAY, etc)
 * * color - color of the log text
 * * log_globally - boolean checking whether or not we write this log to the log file
 */
/atom/proc/log_message(message, message_type, color = null, log_globally = TRUE, list/data)
	message = "[message]"
	if(!length(message))
		stack_trace("Empty message")
		return

	if(!log_globally)
		return

	var/log_source = ismob(src) ? key_name(src) : log_info_line(src)
	var/log_text = "[log_source] [message] [loc_name(src)]"

	switch(message_type)
		if(LOG_ATTACK, LOG_VICTIM)
			log_attack(log_text, data)
		if(LOG_SAY)
			log_say(log_text, data)
		if(LOG_WHISPER)
			log_whisper(log_text, data)
		if(LOG_EMOTE)
			log_emote(log_text, data)
		if(LOG_RADIO_EMOTE)
			log_radio_emote(log_text, data)
		if(LOG_DSAY)
			log_dsay(log_text, data)
		if(LOG_PDA)
			log_pda(log_text, data)
		if(LOG_CHAT)
			log_chat(log_text, data)
		if(LOG_COMMENT)
			log_comment(log_text, data)
		if(LOG_TELECOMMS)
			log_telecomms(log_text, data)
		if(LOG_OOC)
			log_ooc(log_text, data)
		if(LOG_ADMIN)
			log_admin(log_text, data)
		if(LOG_ADMIN_PRIVATE)
			log_admin_private(log_text, data)
		if(LOG_ASAY)
			log_adminsay(log_text, data)
		if(LOG_OWNERSHIP, LOG_GAME, LOG_MECHA, LOG_SHUTTLE, LOG_ECON, LOG_SPEECH_INDICATORS, LOG_TRANSPORT)
			log_game(log_text, data)
		else
			stack_trace("Invalid individual logging type: [message_type]. Defaulting to [LOG_GAME] (LOG_GAME).")
			log_game(log_text, data)

/// Logs a message in a mob's individual log, and in the global logs as well if log_globally is true
/mob/log_message(message, message_type, color = null, log_globally = TRUE, list/data)
	message = "[message]"
	if(!length(message))
		stack_trace("Empty message")
		return

	if(!persistent_client && client)
		var/datum/persistent_client/persistent = client.bind_persistent_client()
		persistent?.set_mob(src)

	if(!islist(logging))
		logging = list()

	// Cannot use the list as a map if the key is a number, so we stringify it (thank you BYOND)
	var/smessage_type = num2text(message_type, MAX_BITFLAG_DIGITS)

	if(!islist(logging[smessage_type]))
		logging[smessage_type] = list()

	// tg doesn't have this block, but I somehow kept breaking things while working on persistent clients otherwise, so
	// this is a safety check to make sure we don't try to log to a null persistent client
	var/log_to_persistent = HAS_CONNECTED_PLAYER(src) && persistent_client
	if(log_to_persistent)
		if(!islist(persistent_client.logging))
			persistent_client.logging = list()
		if(!islist(persistent_client.logging[smessage_type]))
			persistent_client.logging[smessage_type] = list()

	var/colored_message = message
	if(color && istext(color))
		if(copytext(color, 1, 2) == "#")
			colored_message = "<font color=[color]>[message]</font>"
		else
			colored_message = "<font color='[color]'>[message]</font>"

	// This makes readability a bit better for admins.
	switch(message_type)
		if(LOG_WHISPER)
			colored_message = "(WHISPER) [colored_message]"
		if(LOG_OOC)
			colored_message = "(OOC) [colored_message]"
		if(LOG_ASAY)
			colored_message = "(ASAY) [colored_message]"
		if(LOG_EMOTE)
			colored_message = "(EMOTE) [colored_message]"
		if(LOG_RADIO_EMOTE)
			colored_message = "(RADIOEMOTE) [colored_message]"

	var/list/timestamped_message = list("\[[server_timestamp(format = "YYYY-MM-DD hh:mm:ss")]\] [key_name(src)] [loc_name(src)] (Event #[length(logging[smessage_type])])" = colored_message)

	logging[smessage_type] += timestamped_message
	if(log_to_persistent)
		persistent_client.logging[smessage_type] += timestamped_message

	..()
