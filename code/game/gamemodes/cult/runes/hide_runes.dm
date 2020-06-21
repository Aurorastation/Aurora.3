/datum/rune/hide_runes
	name = "concealment rune"
	desc = "This rune is used to conceal other runes in an area around us."

/datum/rune/hide_runes/do_rune_action(mob/living/user, atom/movable/A)
	var/rune_found
	for(var/obj/effect/rune/R in orange(4, get_turf(A)))
		if(R == A)
			continue
		R.invisibility = INVISIBILITY_OBSERVER
		rune_found = TRUE
	if(rune_found)
		user.say("Kla'atu barada nikt'o!")
		for(var/mob/V in viewers(get_turf(A)))
			to_chat(V, span("warning", "\The [A] dissipates into a bloody cloud, veiling the surrounding runes."))
		qdel(A)
		return TRUE