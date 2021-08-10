/mob/living/silicon/robot/drone/say(message, datum/language/speaking)
	if(hacked)
		return ..(message)

	if(local_transmit)
		if(stat == DEAD)
			return say_dead(message)

		if(copytext(message, 1, 2) == "*")
			return emote(copytext(message,2))

		message = formalize_text(message)

		if(copytext(message, 1, 2) == ";")
			var/datum/language/L = all_languages["Drone Talk"]
			if(istype(L))
				return L.broadcast(src,trim(copytext(message, 2)))

		//Must be concious to speak
		if(stat)
			return FALSE

		// Message must not be empty
		if(!length(message))
			return FALSE

		var/list/listeners = hearers(5, src)
		listeners |= src

		var/list/hear_clients = list()
		for(var/mob/living/silicon/D in listeners)
			if(D.client && D.local_transmit)
				to_chat(D, "<b>[real_name]</b> transmits, \"[message]\"")
				hear_clients += D.client

		for(var/mob/M in player_list)
			if(isnull(M.client))
				continue
			if(istype(M, /mob/abstract/new_player))
				continue
			else if(M.stat == DEAD && M.client.prefs.toggles & CHAT_GHOSTEARS)
				to_chat(M, "<b>[real_name]</b> transmits, \"[message]\"")
				hear_clients += M.client

		do_animate_chat(message, speaking, FALSE, hear_clients, 30)

		return TRUE
	return ..(message, 0)
