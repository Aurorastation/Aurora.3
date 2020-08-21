/mob/abstract/observer/say(var/message)
	message = sanitize(message)

	if (!message)
		return

	log_say("Ghost/[src.key] : [message]",ckey=key_name(src))

	if (src.client)
		if(src.client.prefs.muted & (MUTE_DEADCHAT|MUTE_IC))
			to_chat(src, SPAN_WARNING("You cannot talk in deadchat (muted)."))
			return

	. = src.say_dead(message)
