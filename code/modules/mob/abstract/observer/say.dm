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


/mob/abstract/observer/emote(var/act, var/type, var/message)
	if(!message)
		return

	if(act != "me")
		return

	log_emote("Ghost/[src.key] : [message]",ckey=key_name(src))

	if(src.client)
		if(src.client.prefs.muted & (MUTE_DEADCHAT|MUTE_IC))
			to_chat(src, "<span class='warning'>You cannot emote in deadchat (muted).</span>")
			return

	. = src.emote_dead(message)
