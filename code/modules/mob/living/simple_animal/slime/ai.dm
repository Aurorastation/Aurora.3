/mob/living/simple_animal/slime/FindTarget()
	if(victim) // Don't worry about finding another target if we're eatting someone.
		return
//	if(!will_hunt())
//		return
	..()

/mob/living/simple_animal/slime/special_target_check(mob/living/L)
	if(istype(L, /mob/living/simple_animal/slime))
		var/mob/living/simple_animal/slime/buddy = L
		if(buddy.slime_color == src.slime_color || discipline || unity || buddy.unity)
			return FALSE // Don't hurt same colored slimes.

	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(H.species && H.species.name == "Promethean")
			return FALSE // Prometheans are always our friends.
		else if(istype(H.species, /datum/species/monkey)) // istype() is so they'll eat the alien monkeys too.
			return TRUE // Monkeys are always food.
		if(discipline && !rabid)
			return FALSE // We're a good slime.  For now at least

	if(issilicon(L) || isbot(L) )
		if(discipline && !rabid)
			return FALSE // We're a good slime.  For now at least.
	return ..() // Other colors and nonslimes are jerks however.

/mob/living/simple_animal/slime/ClosestDistance()
	if(target_mob.stat == DEAD)
		return 1 // Melee (eat) the target if dead, don't shoot it.
	return ..()

/mob/living/simple_animal/slime/HelpRequested(var/mob/living/simple_animal/slime/buddy)
	if(istype(buddy))
		if(buddy.slime_color != src.slime_color && (!unity || !buddy.unity)) // We only help slimes of the same color, if it's another slime calling for help.
			ai_log("HelpRequested() by [buddy] but they are a [buddy.slime_color] while we are a [src.slime_color].",2)
			return
		if(buddy.target_mob)
			if(!special_target_check(buddy.target_mob))
				ai_log("HelpRequested() by [buddy] but special_target_check() failed when passed [buddy.target_mob].",2)
				return
	..()


/mob/living/simple_animal/slime/handle_resist()
	if(buckled && victim && isliving(buckled) && victim == buckled) // If it's buckled to a living thing it's probably eating it.
		return
	else
		..()

/*
/mob/living/simple_animal/slime/proc/will_hunt() // Check for being stopped from feeding and chasing
	if(nutrition <= get_starve_nutrition() || rabid)
		return TRUE
	if(nutrition <= get_hunger_nutrition() || prob(25))
		return TRUE
	return FALSE
*/