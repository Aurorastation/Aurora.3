/obj/effect/rune/hiderunes
	can_talisman = TRUE

/obj/effect/rune/hiderunes/do_rune_action(mob/living/user, obj/O = src)
	var/rune_found
	for(var/obj/effect/rune/R in orange(4, get_turf(O)))
		if(R == O)
			continue
		R.invisibility = INVISIBILITY_OBSERVER
		rune_found = TRUE
	if(rune_found)
		if(istype(O,/obj/effect/rune))
			user.say("Kla[pick("'","`")]atu barada nikt'o!")
			for(var/mob/V in viewers(get_turf(O)))
				to_chat(V, span("warning", "The rune turns into gray dust, veiling the surrounding runes."))
			qdel(O)
		else
			user.whisper("Kla[pick("'","`")]atu barada nikt'o!")
			to_chat(user, span("warning", "Your talisman turns into gray dust, veiling the surrounding runes."))
			for(var/mob/V in orange(1, get_turf(O)))
				if(V == user)
					continue
				to_chat(V, span("warning", "Dust emanates from [user]'s hands for a moment."))
		return TRUE