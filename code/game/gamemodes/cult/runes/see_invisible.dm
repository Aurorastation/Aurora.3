/datum/rune/see_invisible
	name = "visibility rune"
	desc = "This rune is used to see the invisible."
	rune_flags = NO_TALISMAN

/datum/rune/see_invisible/do_rune_action(mob/living/user, atom/movable/A)
	if(user.seer == TRUE)
		user.say("Rash'tla sektath mal'zua! Zasan therium viortia!")
		to_chat(user, span("warning", "The world beyond fades from your vision."))
		user.see_invisible = SEE_INVISIBLE_LIVING
		user.seer = FALSE
	else if(user.see_invisible!=SEE_INVISIBLE_LIVING)
		to_chat(user, span("warning", "The world beyond flashes your eyes but disappears quickly, as if something is disrupting your vision."))
		user.see_invisible = SEE_INVISIBLE_CULT
		user.seer = FALSE
	else
		user.say("Rash'tla sektath mal'zua! Zasan therium vivira! Itonis al'ra matum!")
		to_chat(user, span("warning", "The world beyond opens to your eyes."))
		user.see_invisible = SEE_INVISIBLE_CULT
		user.seer = TRUE
	return fizzle(user, A)
