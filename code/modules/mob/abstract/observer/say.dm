/mob/abstract/observer/say(var/message)
	message = sanitize(message)

	if (!message)
		return

	log_say("Ghost/[src.key] : [message]",ckey=key_name(src))

	if (src.client)
		if(src.client.prefs.muted & (MUTE_DEADCHAT|MUTE_IC))
			to_chat(src, "<span class='warning'>You cannot talk in deadchat (muted).</span>")
			return

	. = src.say_dead(message)
