/mob/living/simple_animal/borer/say(var/message)
	message = sanitize(message)
	message = capitalize(message)

	if(!message)
		return

	if(stat == DEAD)
		return say_dead(message)

	if(stat)
		return

	var/static/list/correct_punctuation = list("!" = TRUE, "." = TRUE, "?" = TRUE, "-" = TRUE, "~" = TRUE, "*" = TRUE, "/" = TRUE, ">" = TRUE, "\"" = TRUE, "'" = TRUE, "," = TRUE, ":" = TRUE, ";" = TRUE)
	var/ending = copytext(message, length(message), (length(message) + 1))
	if(ending && !correct_punctuation[ending])
		message += "."

	if(copytext(message, 1, 2) == "*")
		return emote(copytext(message, 2))

	var/datum/language/L = parse_language(message)
	if(L?.flags & HIVEMIND)
		L.broadcast(src, trim(copytext(message,3)), src.truename)
		return

	if(!host)
		var/list/viable_sayers = list()
		for(var/mob/living/carbon/human/H in range(3, src))
			if(H.stat)
				continue
			viable_sayers += H
		if(!length(viable_sayers))
			to_chat(src, span("notice", "There are no viable hosts to speak with."))
		else
			var/mob/living/carbon/human/chosen_sayer = pick(viable_sayers)
			log_say("[key_name(src)] : ([name]) [message]", ckey=key_name(src))
			chosen_sayer.say(message)
		return

	to_chat(src, "<b>You drop words into [host]'s mind:</b> \"[message]\"")
	to_chat(host, "<b>Your own thoughts speak:</b> \"[message]\"")

	for(var/mob/M in player_list)
		if(istype(M, /mob/abstract/new_player))
			continue
		else if(M.stat == DEAD && M.client.prefs.toggles & CHAT_GHOSTEARS)
			to_chat(M, "<b>[src.truename]</b> whispers to <b>[host]</b>, \"[message]\"")
