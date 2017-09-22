/mob/living/parasite/captive_brain
	name = "host brain"
	real_name = "host brain"
	universal_understand = 1

/mob/living/parasite/captive_brain/say(var/message)

	if (src.client)
		if(client.prefs.muted & MUTE_IC)
			src << "<span class='warning'>You cannot speak in IC (muted).</span>"
			return

	if(istype(src.loc,/mob/living/parasite/meme))

		message = sanitize(message)
		if (!message)
			return
		log_say("[key_name(src)] : [message]",ckey=key_name(src))
		if (stat == 2)
			return say_dead(message)

		var/mob/living/parasite/meme/ME = src.loc
		src << "You whisper silently, \"[message]\""
		ME.host << "The captive mind of [src] whispers, \"[message]\""

		for (var/mob/M in player_list)
			if (istype(M, /mob/new_player))
				continue
			else if(M.stat == 2 &&  M.client.prefs.toggles & CHAT_GHOSTEARS)
				M << "The captive mind of [src] whispers, \"[message]\""

/mob/living/parasite/captive_brain/emote(var/message)
	return

/mob/living/parasite/captive_brain/send_emote()
	return