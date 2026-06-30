/mob/living/simple_animal/borer/say(var/text, var/datum/language/speaking = null, var/verb="says", var/alt_name="", var/ghost_hearing = GHOSTS_ALL_HEAR, var/whisper = FALSE, var/skip_edit = FALSE)
	text = capitalize(text)

	if(!text)
		return

	if(stat == DEAD)
		return say_dead(text)

	if(stat)
		return

	text = formalize_text(text)

	if(copytext(text, 1, 2) == "*")
		return emote(copytext(text, 2))

	var/datum/language/L = parse_language(text)
	if(L?.flags & HIVEMIND)
		L.broadcast(src, trim(copytext(text,3)), src.truename)
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
			log_say("[key_name(src)] : (forcing [key_name(chosen_sayer)]) [text]")
			chosen_sayer.say(text)
		return

	to_chat(src, "<b>You drop words into [host]'s mind:</b> \"[text]\"")
	to_chat(host, "<b>Your own thoughts speak:</b> \"[text]\"")
	log_say("[key_name(src)] : (borer whisper -> [key_name(host)]) [text]")

	for(var/mob/M in GLOB.mob_list)
		if(M.client && M.stat == DEAD && !isnewplayer(M) && (M.client.prefs.toggles & CHAT_GHOSTEARS))
			to_chat(M, "<b>[src.truename]</b> whispers to <b>[host]</b>, \"[text]\"")
