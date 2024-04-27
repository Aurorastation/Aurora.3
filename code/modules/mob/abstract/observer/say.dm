/mob/abstract/observer/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="", var/ghost_hearing = GHOSTS_ALL_HEAR, var/whisper = FALSE)
	if (!message)
		return

	log_say("Ghost/[src.key] : [message]",ckey=key_name(src))

	if (src.client)
		if(src.client.prefs.muted & (MUTE_DEADCHAT|MUTE_IC))
			to_chat(src, "<span class='warning'>You cannot talk in deadchat (muted).</span>")
			return

	. = src.say_dead(message)
