/datum/rune/ethereal
	name = "ethereal rune"
	desc = "This rune is used to temporarily send an acolyte into the afterlife."
	rune_flags = NO_TALISMAN | CAN_MEMORIZE

/datum/rune/ethereal/do_rune_action(mob/living/user, atom/movable/A) //some bits copypastaed from admin tools - Urist
	if(get_turf(user) == get_turf(A) && ishuman(user))
		var/mob/living/carbon/human/L = user
		user.say("Fwe'sh maherl! Nyag r'ya!")
		user.visible_message(SPAN_WARNING("[user]'s eyes glow red as [user.get_pronoun("he")] freezes in place, absolutely motionless."), \
		SPAN_WARNING("The shadow that is your spirit separates itself from your body. You are now in the realm beyond. While this is a great sight, being here strains your mind and body. Hurry..."), \
		SPAN_WARNING("You hear only complete silence for a moment."))
		announce_ghost_joinleave(user.ghostize(TRUE), 1, "You feel that they had to use some [pick("dark", "black", "blood", "forgotten", "forbidden")] magic to [pick("invade","disturb","disrupt","infest","taint","spoil","blight")] this place!")
		L.ajourn = TRUE
		while(L)
			if(L.key)
				L.ajourn = FALSE
				return
			else
				L.take_organ_damage(10, 0)
			sleep(100)
	else
		to_chat(user, SPAN_WARNING("You must be standing on the rune!"))
	return fizzle(user, A)

/obj/effect/rune/ethereal/Initialize(mapload)
	. = ..(mapload, SScult.runes_by_name[/datum/rune/ethereal::name])
