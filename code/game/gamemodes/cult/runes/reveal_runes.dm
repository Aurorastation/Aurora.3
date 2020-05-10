/obj/effect/rune/revealrunes
	can_talisman = TRUE

/obj/effect/rune/revealrunes/do_rune_action(mob/living/user, obj/O = src)
	var/reveal = FALSE
	var/rad
	var/did_reveal
	if(istype(O, /obj/effect/rune))
		rad = 6
		reveal = TRUE
	if(istype(O, /obj/item/paper/talisman))
		rad = 4
		reveal = TRUE
	if(istype(O, /obj/item/nullrod))
		rad = 2
		reveal = TRUE
	if(reveal)
		for(var/obj/effect/rune/R in orange(rad, get_turf(src)))
			if(R == src)
				continue
			R.invisibility = 0
			did_reveal = TRUE
	if(did_reveal)
		if(istype(O, /obj/item/nullrod))
			visible_message(span("warning", "Arcane markings suddenly glow from underneath a thin layer of dust!"))
			return
		if(istype(O, /obj/effect/rune))
			user.say("Nikt[pick("'","`")]o barada kla'atu!")
			for(var/mob/V in viewers(src))
				to_chat(V, span("warning", "The rune turns into red dust, reveaing the surrounding runes."))
			qdel(src)
			return TRUE
		if(istype(O, /obj/item/paper/talisman))
			user.whisper("Nikt[pick("'","`")]o barada kla'atu!")
			to_chat(user, span("warning", "Your talisman turns into red dust, revealing the surrounding runes."))
			for(var/mob/V in orange(1, user.loc))
				if(V == user)
					continue
				to_chat(V, span("warning", "Red dust emanates from [user]'s hands for a moment."))
			qdel(src)
			return
		return TRUE
	if(istype(O, /obj/effect/rune))
		return fizzle(user)
	if(istype(O, /obj/item/paper/talisman))
		var/datum/callback/cb = CALLBACK(src, /obj/effect/rune/.proc/fizzle)
		cb.Invoke(user)
		return