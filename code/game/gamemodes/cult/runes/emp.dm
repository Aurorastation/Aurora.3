/datum/rune/emp
	name = "EMP rune"
	desc = "This rune is used to disable electronics in an area around us."
	rune_flags = HAS_SPECIAL_TALISMAN_ACTION

/datum/rune/emp/do_rune_action(mob/living/user, atom/movable/A)
	do_emp(user, A, 2)

/datum/rune/emp/do_talisman_action(mob/living/user, var/atom/movable/A)
	do_emp(user, A, 1)

/datum/rune/emp/proc/do_emp(mob/living/user, atom/movable/A, radius = 2)
	user.say("Ta'gh fara'qha fel d'amar det!")
	log_and_message_admins("activated an EMP [A].")
	var/turf/T = get_turf(A)
	playsound(T, 'sound/magic/Disable_Tech.ogg', 25, 1)

	var/list/ex = list(user) // exclude caster
	for(var/mob/M in range(2, T))
		if(iscultist(M))
			ex += M
	empulse(T, 1, radius, exclude = ex)
	qdel(A)
