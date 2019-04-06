/mob/living/silicon/robot/drone/say(var/message)
	if(local_transmit)
		message = sanitize(message)

		if (stat == 2)
			return say_dead(message)

		if(copytext(message,1,2) == "*")
			return emote(copytext(message,2))

		if(copytext(message,1,2) == ";")
			var/datum/language/L = all_languages["Drone Talk"]
			if(istype(L))
				return L.broadcast(src,trim(copytext(message,2)))

		//Must be concious to speak
		if (stat)
			return 0

		// Message must not be empty
		if (length(message) == 0)
			return 0

		var/list/listeners = hearers(5,src)
		listeners |= src

		for(var/mob/living/silicon/D in listeners)
			if(D.client && D.local_transmit)
				to_chat(D, "<b>[src]</b> transmits, \"[message]\"")

		for (var/mob/M in player_list)
			if (isnull(M.client))
				continue
			if (istype(M, /mob/abstract/new_player))
				continue
			else if(M.stat == 2 &&  M.client.prefs.toggles & CHAT_GHOSTEARS)
				to_chat(M, "<b>[src]</b> transmits, \"[message]\"")
		return 1
	return ..(message, 0)
