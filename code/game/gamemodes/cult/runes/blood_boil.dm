/datum/rune/blood_boil
	name = "blood boiling rune"
	desc = "A rune used to evaporate the blood of the non-believers. Show them the will of the Dark One!"
	rune_flags = NO_TALISMAN

/datum/rune/blood_boil/do_rune_action(mob/living/user, atom/movable/A) //cultists need at least one DANGEROUS rune. Even if they're all stealthy.
	var/list/cultists = list()
	var/list/victims = list()
	for(var/mob/living/carbon/C in orange(1, A))
		if(iscultist(C) && !C.stat)
			cultists += C
	if(length(cultists) >= 3)
		for(var/mob/living/carbon/M in viewers(user))
			if(iscultist(M))
				continue
			var/obj/item/nullrod/N = locate() in M
			if(N)
				continue
			M.take_overall_damage(50, 50)
			to_chat(M, SPAN_DANGER(FONT_HUGE("You're burning from the inside!")))
			victims += M
		for(var/mob/living/carbon/human/C in orange(1, A))
			if(iscultist(C) && !C.stat)
				C.say("Dedo ol'btoh! A'oil'e!")
				C.take_overall_damage(15, 0)
		admin_attacker_log_many_victims(user, victims, "Used a blood boil rune.", "Was the victim of a blood boil rune.", "used a blood boil rune on")
		log_and_message_admins_many(cultists - user, "assisted activating a blood boil rune.")
		qdel(A)
		return TRUE
	else
		return fizzle(user, A)