//TODO: Convert this over for languages.
/mob/living/carbon/brain/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="", var/ghost_hearing = GHOSTS_ALL_HEAR, var/whisper = FALSE)
	if (silent)
		return

	if(!(container && istype(container, /obj/item/device/mmi)))
		return //No MMI, can't speak, bucko./N
	else
		speaking = parse_language(message)
		if(speaking)
			message = copytext(message, 2+length(speaking.key))
		var/ending = copytext(message, length(message))
		var/pre_ending = copytext(message, length(message) - 1, length(message))
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
				message = Gibberish(message, (emp_damage*6))//scrambles the message, gets worse when emp_damage is higher

		if(speaking && speaking.flags & HIVEMIND)
			speaking.broadcast(src,trim(message))
			return

		if(istype(container, /obj/item/device/mmi/radio_enabled))
			var/obj/item/device/mmi/radio_enabled/R = container
			if(R.radio)
				spawn(0) R.radio.hear_talk(src, sanitize(message), verb, speaking)
		..(trim(message), speaking, verb)
