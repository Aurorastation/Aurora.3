/obj/effect/rune/emp
	can_talisman = TRUE

/obj/effect/rune/emp/do_rune_action(mob/living/user, obj/O = src)
	var/radius = 4
	if(istype(O, /obj/effect/rune))
		user.say("Ta'gh fara[pick("'","`")]qha fel d'amar det!")
		log_and_message_admins("activated an EMP rune.")
	else
		user.whisper("Ta'gh fara[pick("'","`")]qha fel d'amar det!")
		radius = 2
		log_and_message_admins("activated an EMP talisman.")
	var/turf/T = get_turf(O)
	playsound(T, 'sound/magic/Disable_Tech.ogg', 25, 1)

	var/list/ex = list(user) // exclude caster
	for(var/mob/M in range(radius, T))
		if(iscultist(M))
			ex += M
		else
			continue
	empulse(T, 1, radius, exclude = ex)
	qdel(O)
	return TRUE