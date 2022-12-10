/mob/living/simple_animal/borer/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="", var/ghost_hearing = GHOSTS_ALL_HEAR, var/whisper = FALSE)
	message = capitalize(message)

	if(!message)
		return

	if(stat == DEAD)
		return say_dead(message)

	if(stat)
		return

	message = formalize_text(message)

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
			to_chat(src, SPAN_NOTICE("There are no viable hosts to speak with."))
		else
			var/mob/living/carbon/human/chosen_sayer = pick(viable_sayers)
			log_say("[key_name(src)] : (forcing [key_name(chosen_sayer)]) [message]", ckey=key_name(src))
			chosen_sayer.say(message)
		return

	to_chat(src, "<b>You drop words into [host]'s mind:</b> \"[message]\"")
	to_chat(host, "<b>Your own thoughts speak:</b> \"[message]\"")
	log_say("[key_name(src)] : (borer whisper -> [key_name(host)]) [message]")

	for(var/mob/M in mob_list)
		if(M.client && M.stat == DEAD && !isnewplayer(M) && (M.client.prefs.toggles & CHAT_GHOSTEARS))
			to_chat(M, "<b>[src.truename]</b> whispers to <b>[host]</b>, \"[message]\"")
