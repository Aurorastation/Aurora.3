/datum/rune/deafen
	name = "deafening rune"
	desc = "This rune is used to deafen all unbelievers in a wide range around us."
	rune_flags = HAS_SPECIAL_TALISMAN_ACTION

/datum/rune/deafen/do_rune_action(mob/living/user, atom/movable/A)
	do_deafen(user, A, 1, TRUE)

/datum/rune/deafen/do_talisman_action(mob/living/user, var/atom/movable/A)
	do_deafen(user, A, 5, 0.5, FALSE)

/datum/rune/deafen/proc/do_deafen(mob/living/user, atom/movable/A, var/radius = 7, var/effect_mod = 1, var/special_effects = TRUE)
	var/list/affected = list()
	for(var/mob/living/carbon/C in range(radius, get_turf(A)))
		if(iscultist(C))
			continue
		var/obj/item/nullrod/N = locate() in C
		if(N)
			continue
		C.ear_deaf += 50 / effect_mod
		to_chat(C, SPAN_DANGER("Your ears ring as you go deaf!"))
		affected += C
		if(prob(1) && special_effects)
			C.sdisabilities |= DEAF
	if(affected.len)
		user.say("Sti'kaliedir!")
		admin_attacker_log_many_victims(user, affected, "Used a deafen rune.", "Was victim of a deafen rune.", "used a deafen rune on")
		qdel(A)
	else
		return fizzle(user, A)