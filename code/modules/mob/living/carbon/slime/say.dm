/mob/living/carbon/slime/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="", var/ghost_hearing = GHOSTS_ALL_HEAR, var/whisper = FALSE)
	verb = say_quote(message)

	if(copytext(message,1,2) == "*")
		return emote(copytext(message,2))

	return ..(message, null, verb)

/mob/living/carbon/slime/say_quote(var/text)
	var/ending = copytext(text, length(text))

	if(ending == "?")
		return "asks";
	else if(ending == "!")
		return "cries";

	return "chirps";

/mob/living/carbon/slime/say_understands(var/other)
	if(istype(other, /mob/living/carbon/slime))
		return TRUE
	return ..()

/mob/living/carbon/slime/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "", var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	if(is_friend(speaker))
		speech_buffer = list()
		speech_buffer.Add(speaker)
		speech_buffer.Add(lowertext(html_decode(message)))
	return ..()

/mob/living/carbon/slime/hear_radio(var/message, var/verb="says", var/datum/language/language=null, var/part_a, var/part_b, var/part_c, var/mob/speaker = null, var/hard_to_hear = 0, var/vname ="")
	if(is_friend(speaker))
		speech_buffer = list()
		speech_buffer.Add(speaker)
		speech_buffer.Add(lowertext(html_decode(message)))
	return ..()
