/datum/rune/communicate
	name = "communication rune"
	desc = "This rune is used to send a message to all acolytes."

/datum/rune/communicate/do_rune_action(mob/living/user, atom/movable/A)
	var/input = input(user, "Please choose a message to tell to the other acolytes.", "Voice of Blood", "")//sanitize() below, say() and whisper() have their own
	if(!input)
		fizzle(user, A)

		user.say("O bidai nabora se'sma!")
		user.whisper("[input]")

	input = sanitize(input)
	log_and_message_admins("used a communicate rune to say '[input]'")
	for(var/datum/mind/H in cult.current_antagonists)
		if(H.current)
			to_chat(H.current, SPAN_CULT("The familiar voice of [H.current] fills your mind: [input]"))
	qdel(A)
