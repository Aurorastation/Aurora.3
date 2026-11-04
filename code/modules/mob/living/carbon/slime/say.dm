/mob/living/carbon/slime/say(text, datum/language/speaking = null, list/message_mods = null, ghost_hearing = GHOSTS_ALL_HEAR, whisper = FALSE, skip_edit = FALSE, message_range = null)
	message_mods = message_mods ? message_mods.Copy() : list()
	message_mods[SAY_MOD_VERB] = say_quote(text)

	if(copytext(text,1,2) == "*")
		return emote(copytext(text,2))

	return ..(text, null, message_mods, ghost_hearing, whisper, skip_edit, message_range)

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
