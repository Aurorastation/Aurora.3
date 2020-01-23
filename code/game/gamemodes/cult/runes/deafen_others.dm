/obj/effect/rune/deafen
	can_talisman = TRUE

/obj/effect/rune/deafen/do_rune_action(mob/living/user, obj/O = src)
	if(istype(O, /obj/effect/rune))
		var/list/affected = list()
		for(var/mob/living/carbon/C in range(7, get_turf(O)))
			if(iscultist(C))
				continue
			var/obj/item/nullrod/N = locate() in C
			if(N)
				continue
			C.ear_deaf += 50
			to_chat(C, span("warning", "The world around you suddenly becomes quiet."))
			affected += C
			if(prob(1))
				C.sdisabilities |= DEAF
		if(affected.len)
			user.say("Sti[pick("'","`")] kaliedir!")
			to_chat(user, span("cult", "The world becomes quiet as the deafening rune dissipates into fine dust."))
			admin_attacker_log_many_victims(user, affected, "Used a deafen rune.", "Was victim of a deafen rune.", "used a deafen rune on")
			qdel(O)
		else
			return fizzle(user)
	else
		var/list/affected = list()
		for(var/mob/living/carbon/C in range(7, user))
			if(iscultist(C))
				continue
			var/obj/item/nullrod/N = locate() in C
			if(N)
				continue
			C.ear_deaf += 30
			//talismans is weaker.
			to_chat(C, span("warning", "The world around you suddenly becomes quiet."))
			affected += C
		if(affected.len)
			user.whisper("Sti[pick("'","`")] kaliedir!")
			to_chat(user, span("warning", "Your talisman turns into gray dust, deafening everyone around."))
			admin_attacker_log_many_victims(user, affected, "Used a deafen rune.", "Was victim of a deafen rune.", "used a deafen rune on")
			for(var/mob/V in orange(1, get_turf(O)))
				if(!iscultist(V))
					to_chat(V, span("warning", "Dust flows from [user]'s hands for a moment, and the world suddenly becomes quiet.."))
	return TRUE