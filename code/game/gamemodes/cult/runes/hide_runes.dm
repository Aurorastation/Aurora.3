/obj/effect/rune/hiderunes
	can_talisman = TRUE

/obj/effect/rune/hiderunes/do_rune_action(mob/living/user)
	var/rune_found
	for(var/obj/effect/rune/R in orange(4, src))
		if(R!=src)
			R.invisibility=INVISIBILITY_OBSERVER
		rune_found = TRUE
	if(rune_found)
		if(istype(src,/obj/effect/rune))
			user.say("Kla[pick("'","`")]atu barada nikt'o!")
			for(var/mob/V in viewers(src))
				to_chat(V, span("warning", "The rune turns into gray dust, veiling the surrounding runes."))
			qdel(src)
		else
			user.whisper("Kla[pick("'","`")]atu barada nikt'o!")
			to_chat(user, span("warning", "Your talisman turns into gray dust, veiling the surrounding runes."))
			for(var/mob/V in orange(1,src))
				if(V == user)
					continue
				to_chat(V, span("warning", "Dust emanates from [user]'s hands for a moment."))

		return
	if(istype(src,/obj/effect/rune))
		return fizzle(user)
	else
		call(/obj/effect/rune/proc/fizzle)(user)
		return