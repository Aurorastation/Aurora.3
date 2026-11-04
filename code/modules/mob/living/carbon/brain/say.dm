//TODO: Convert this over for languages.
/mob/living/carbon/brain/say(text, datum/language/speaking = null, list/message_mods = null, ghost_hearing = GHOSTS_ALL_HEAR, whisper = FALSE, skip_edit = FALSE, message_range = null)
	message_mods = message_mods ? message_mods.Copy() : list()
	if (silent)
		return

	if(!(container && istype(container, /obj/item/mmi)))
		return //No MMI, can't speak, bucko./N
	else
		speaking = parse_language(text)
		if(speaking)
			text = copytext(text, 2+length(speaking.key))
		var/ending = copytext(text, length(text))
		var/pre_ending = copytext(text, length(text) - 1, length(text))
		if (speaking)
			message_mods[SAY_MOD_VERB] = speaking.get_spoken_verb(ending, pre_ending)
		else
			if(ending=="!")
				message_mods[SAY_MOD_VERB]=pick("exclaims","shouts","yells")
			if(ending=="?")
				message_mods[SAY_MOD_VERB]="asks"

		if(prob(emp_damage*4))
			if(prob(10))//10% chane to drop the message entirely
				return
			else
				text = Gibberish(text, (emp_damage*6))//scrambles the message, gets worse when emp_damage is higher

		if(speaking && speaking.flags & HIVEMIND)
			speaking.broadcast(src,trim(text))
			return

		if(istype(container, /obj/item/mmi/radio_enabled))
			var/obj/item/mmi/radio_enabled/R = container
			if(R.radio)
				R.radio.hear_talk(src, sanitize(text), message_mods[SAY_MOD_VERB], speaking)
		return ..(trim(text), speaking, message_mods, ghost_hearing, whisper, skip_edit, message_range)
