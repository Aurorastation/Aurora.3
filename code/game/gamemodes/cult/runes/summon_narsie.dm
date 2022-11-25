/datum/rune/summon_narsie
	name = "geometer rune"
	desc = "This rune is used to summon the Geometer of Blood. It requires nine cultists around it to bring Him into our dimension."
	rune_flags = NO_TALISMAN

/datum/rune/summon_narsie/do_rune_action(mob/living/user, atom/movable/A)
	if(!cult.allow_narsie)
		return fizzle(user, A)

	var/turf/T = get_turf(A)
	if(isNotStationLevel(T.z))
		to_chat(user, SPAN_WARNING("You are too far from the ship, Nar'sie can not be summoned here."))
		return fizzle(user, A)

	var/list/cultists = list()
	for(var/mob/M in range(1, A))
		if(istype(M, /mob/living/carbon/human/apparition))
			to_chat(M, SPAN_WARNING("Apparitions cannot partake in the summoning of the Great Dark One! Clear the area and defend the cultists!"))
			continue
		if(iscultist(M) && !M.stat)
			M.say("Tok-lyr rqa'nap! Qur'man-ze! Gi'lt-lu-nulotf!")
			cultists += M
	if(cultists.len >= 9)
		log_and_message_admins_many(cultists, "summoned Nar-sie.")
		new /obj/singularity/narsie/large(get_turf(A))

		// Can't summon a singular entity twice.
		cult.allow_narsie = FALSE
		return
	else
		for(var/mob/M in cultists)
			if(!iscultist(M))
				continue
			to_chat(M, SPAN_WARNING("Not enough cultists are around to summon the Great Dark One!"))
		return fizzle(user, A)
