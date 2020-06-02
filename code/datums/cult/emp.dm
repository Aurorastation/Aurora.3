/datum/rune/emp
	name = "emp rune"
	desc = "This rune is used to disable electronics in an area around us."
	rune_flags = HAS_SPECIAL_TALISMAN_ACTION

/datum/rune/emp/do_rune_action(mob/living/user, atom/movable/A)
	user.say("Ta'gh fara[pick("'","`")]qha fel d'amar det!")
	log_and_message_admins("activated an EMP rune.")
	var/turf/T = get_turf(A)
	playsound(T, 'sound/magic/Disable_Tech.ogg', 25, 1)

	var/list/ex = list(user) // exclude caster
	for(var/mob/M in range(2, T))
		if(iscultist(M))
			ex += M
		else
			continue
	empulse(T, 1, 2, exclude = ex)
	qdel(A)
	return TRUE

/datum/rune/emp/do_talisman_action(mob/living/user, obj/A)
	user.say("Ta'gh fara'qha fel d'amar det!")
	log_and_message_admins("activated an EMP talisman.")
	var/turf/T = get_turf(A)
	playsound(T, 'sound/magic/Disable_Tech.ogg', 25, 1)

	var/list/ex = list(user) // exclude caster
	for(var/mob/M in range(2, T))
		if(iscultist(M))
			ex += M
		else
			continue
	empulse(T, 1, radius, exclude = ex)
	qdel(A)
	return TRUE