/mob/living/silicon/pai/say(text, datum/language/speaking = null, list/message_mods = null, ghost_hearing = GHOSTS_ALL_HEAR, whisper = FALSE, skip_edit = FALSE, message_range = null)
	if(silence_time)
		to_chat(src, "<font color=green>Communication circuits remain uninitialized.</font>")
		return
	return ..()
