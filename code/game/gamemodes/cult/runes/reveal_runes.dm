/datum/rune/reveal_runes
	name = "revealing rune"
	desc = "This rune is used to reveal hidden runes in a radius around us."
	rune_flags = HAS_SPECIAL_TALISMAN_ACTION

/datum/rune/reveal_runes/do_rune_action(mob/living/user, atom/movable/A)
	reveal(user, A, 6, SPAN_WARNING("\The [A] turns into red dust, reveaing the surrounding runes."))

/datum/rune/reveal_runes/do_talisman_action(mob/living/user, atom/movable/A)
	reveal(user, A, 4, SPAN_WARNING("\The [A] turns into red dust, reveaing the surrounding runes."))

/datum/rune/reveal_runes/proc/reveal(mob/living/user, atom/movable/A, var/radius = 6, var/message = SPAN_WARNING("The rune turns into red dust, reveaing the surrounding runes."))
	var/did_reveal
	for(var/obj/effect/rune/R in orange(radius, get_turf(A)))
		if(R == src)
			continue
		R.invisibility = 0
		did_reveal = TRUE
	if(did_reveal)
		if(iscultist(user))
			user.say("Nikt'o barada kla'atu!")
		A.visible_message(message)
	qdel(A)
