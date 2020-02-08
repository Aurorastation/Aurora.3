// returns FALSE if the rune is not used. returns TRUE if the rune is used.
/obj/effect/rune/communicate/do_rune_action(mob/living/user)
	. = TRUE // Default output is TRUE. If the rune is deleted it will return TRUE
	var/input = input(user, "Please choose a message to tell to the other acolytes.", "Voice of Blood", "")//sanitize() below, say() and whisper() have their own
	if(!input)
		if(istype(src))
			fizzle(user)
		return FALSE

	if(istype(src, /obj/effect/rune))
		user.say("O bidai nabora se[pick("'","`")]sma!")
		user.say("[input]")
	else
		user.whisper("O bidai nabora se[pick("'","`")]sma!")
		user.whisper("[input]")

	input = sanitize(input)
	log_and_message_admins("used a communicate rune to say '[input]'")
	for(var/datum/mind/H in cult.current_antagonists)
		if(H.current)
			to_chat(H.current, span("cult", "Cult Broadcast: \"[input]\""))
	qdel(src)
	return TRUE