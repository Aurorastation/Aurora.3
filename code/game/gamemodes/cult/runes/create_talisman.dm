/datum/rune/talisman
	name = "talisman creation rune"
	desc = "This rune creates a talisman out of a rune around it."
	rune_flags = NO_TALISMAN

/datum/rune/talisman/do_rune_action(mob/living/user, atom/movable/A)
	var/obj/item/paper/new_talisman
	var/cant_talisman

	for(var/obj/item/paper/P in get_turf(A))
		if(!P.info)
			new_talisman = P
			break
		else
			cant_talisman = TRUE
	if(!new_talisman)
		if(cant_talisman)
			to_chat(user, SPAN_CULT("A tainted paper is unsuitable to bear the markings of the Dark One!"))
		return fizzle(user, A)

	var/obj/effect/rune/imbued_from
	for(var/obj/effect/rune/R in orange(1, A))
		if(R.rune?.type == src.type)
			continue
		if(!R.rune?.can_be_talisman())
			continue
		var/obj/item/paper/talisman/T = new /obj/item/paper/talisman(get_turf(A))
		imbued_from = R
		T.rune = R.rune
		break
	if(imbued_from)
		A.visible_message(SPAN_CULT("The blood from \the [imbued_from] floods into a talisman!"))
		user.say("H'drak v'loso! Mir'kanas verbot!")
		qdel(imbued_from)
		qdel(new_talisman)
		playsound(A, 'sound/magic/enter_blood.ogg', 50)
	else
		return fizzle(user, A)