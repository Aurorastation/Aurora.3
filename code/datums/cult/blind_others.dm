/datum/rune/blind
	name = "blinding rune"
	desc = "A rune used to blind the unbelievers."
	rune_flags = HAS_SPECIAL_TALISMAN_ACTION

/datum/rune/blind/do_rune_action(mob/living/user, atom/movable/A)
		var/list/affected = list()
		for(var/mob/living/carbon/C in viewers(get_turf(O)))
			if(iscultist(C))
				continue
			var/obj/item/nullrod/N = locate() in C
			if(N)
				continue
			C.eye_blurry += 50
			C.eye_blind += 20
			if(prob(5))
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

/datum/rune/blind/do_talisman_action(mob/living/user, obj/item/A)
	var/list/affected = list()
	for(var/mob/living/carbon/C in view(2, user))
		if(iscultist(C))
			continue
		var/obj/item/nullrod/N = locate() in C
		if(N)
			continue
		C.eye_blurry += 30
		C.eye_blind += 10
		affected += C
		to_chat(C, span("warning", "You feel a sharp pain in your eyes, and the world disappears into darkness.."))
	if(length(affected))
		user.whisper("Sti', kaliesin!")
		to_chat(user, span("warning", "Your talisman turns into gray dust, blinding those who not follow the Nar-Sie."))
		admin_attacker_log_many_victims(user, affected, "Used a blindness talisman.", "Was victim of a blindness talisman.", "used a blindness talisman on")
		qdel(A)
