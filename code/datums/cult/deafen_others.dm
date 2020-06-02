/datum/rune/deafen
	name = "deafening rune"
	desc = "This rune is used to deafen all unbelievers in a wide range around us."
	rune_flags = HAS_SPECIAL_TALISMAN_ACTION

/obj/effect/rune/deafen/do_rune_action(mob/living/user, atom/movable/A)
	var/list/affected = list()
	for(var/mob/living/carbon/C in range(7, get_turf(A)))
		if(iscultist(C))
			continue
		var/obj/item/nullrod/N = locate() in C
		if(N)
			continue
		C.ear_deaf += 50
		to_chat(C, SPAN_DANGER("Your ears ring as you go deaf!"))
		affected += C
		if(prob(1))
			C.sdisabilities |= DEAF
	if(affected.len)
		user.say("Sti'kaliedir!")
		admin_attacker_log_many_victims(user, affected, "Used a deafen rune.", "Was victim of a deafen rune.", "used a deafen rune on")
		qdel(O)
	else
		return fizzle(user)

/datum/rune/deafen(mob/living/user, obj/A)
	var/list/affected = list()
	for(var/mob/living/carbon/C in range(7, user))
		if(iscultist(C))
			continue
		var/obj/item/nullrod/N = locate() in C
		if(N)
			continue
		C.ear_deaf += 30
		//talismans is weaker.
		to_chat(C, SPAN_DANGER("Your ears ring as you go deaf!"))
		affected += C
	if(affected.len)
		user.whisper("Sti[pick("'","`")] kaliedir!")
		to_chat(user, span("warning", "Your talisman turns into gray dust, deafening everyone around."))
		admin_attacker_log_many_victims(user, affected, "Used a deafen rune.", "Was victim of a deafen rune.", "used a deafen rune on")
	return TRUE