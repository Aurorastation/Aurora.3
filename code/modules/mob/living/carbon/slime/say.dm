/mob/living/carbon/slime/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="", var/ghost_hearing = GHOSTS_ALL_HEAR, var/whisper = FALSE, var/skip_edit = FALSE)
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

/mob/living/carbon/slime/react_to_message(datum/say_message/msg)
	if(is_friend(msg.speaker))
		speech_buffer = list()
		speech_buffer.Add(msg.speaker)
		speech_buffer.Add(lowertext(html_decode(msg.to_string())))
