/mob/abstract/ghost/observer/say(text, datum/language/speaking = null, list/message_mods = null, ghost_hearing = GHOSTS_ALL_HEAR, whisper = FALSE, skip_edit = FALSE, message_range = null)
	if (!text)
		return

	log_say("Ghost/[src.key] : [text]")

	if (src.client)
		if(src.client.prefs.muted & (MUTE_DEADCHAT|MUTE_IC))
			to_chat(src, SPAN_WARNING("You cannot talk in deadchat (muted)."))
			return

	. = src.say_dead(text)
