/datum/rune/blind
	name = "blinding rune"
	desc = "A rune used to blind the unbelievers."
	rune_flags = HAS_SPECIAL_TALISMAN_ACTION

/datum/rune/blind/do_rune_action(mob/living/user, atom/movable/A)
	do_blind(user, A, 3, 1, TRUE)

/datum/rune/blind/do_talisman_action(mob/living/user, var/atom/movable/A)
	do_blind(user, A, 3, 0.5, FALSE)

/datum/rune/blind/proc/do_blind(mob/living/user, atom/movable/A, var/range = 7, var/effect_mod = 1, var/special_effects = TRUE)
	var/list/affected = list()
	for(var/mob/living/carbon/C in view(A, range))
		if(iscultist(C))
			continue
		var/obj/item/nullrod/N = locate() in C
		if(N)
			continue
		C.eye_blurry += 50 / effect_mod
		C.eye_blind += 20 / effect_mod
		if(prob(5) && special_effects)
			C.disabilities |= NEARSIGHTED
			if(prob(10))
				C.sdisabilities |= BLIND
		to_chat(C, span("danger", "Suddenly you see a red flash that blinds you!"))
		affected += C
	if(length(affected))
		user.say("Sti'kaliesin!")
		to_chat(user, span("warning", "The rune flashes, blinding those who not follow the Nar-Sie, and dissipates into fine dust."))
		admin_attacker_log_many_victims(user, affected, "Used a blindness rune.", "Was victim of a blindness rune.", "used a blindness rune on")
		qdel(A)
	else
		return fizzle(user, A)