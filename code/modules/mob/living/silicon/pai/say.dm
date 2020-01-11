/mob/living/silicon/pai/say(var/msg)
	if(silence_time)
		to_chat(src, span("warning", "Communication circuits remain uninitialized."))
	else
		..(msg)