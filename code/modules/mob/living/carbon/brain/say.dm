//TODO: Convert this over for languages.
/mob/living/carbon/brain/say(var/text, var/datum/language/speaking = null, var/verb="says", var/alt_name="", var/ghost_hearing = GHOSTS_ALL_HEAR, var/whisper = FALSE, var/skip_edit = FALSE)
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
			verb = speaking.get_spoken_verb(ending, pre_ending)
		else
			if(ending=="!")
				verb=pick("exclaims","shouts","yells")
			if(ending=="?")
				verb="asks"

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
				R.radio.hear_talk(src, sanitize(text), verb, speaking)
		..(trim(text), speaking, verb)
