//only hide, emp, teleport, deafen, blind and tome runes can be imbued atm
/obj/effect/rune/create_talisman/do_rune_action(mob/living/user)
	var/obj/item/paper/new_talisman
	var/cant_talisman

	for(var/obj/item/paper/P in get_turf(src))
		if(!P.info)
			new_talisman = P
			break
		else
			cant_talisman = TRUE
	if(!new_talisman)
		if(cant_talisman)
			to_chat(user, span("cult", "The paper is tainted. It is unsuitable."))
		return fizzle(user)

	var/obj/effect/rune/imbued_from
	for(var/obj/effect/rune/R in orange(1, src))
		if(R == src)
			continue
		if(!R.can_talisman)
			continue
		var/obj/item/paper/talisman/T = new /obj/item/paper/talisman(get_turf(src))
		T.imbued_rune = CALLBACK(R, /obj/effect/rune/.proc/do_rune_action)
		T.rune = R.cult_description
		imbued_from = R
		if(R.network)
			T.network = R.network
		break
	if(imbued_from)
		visible_message(span("warning", "The runes turn into dust, which then forms into an arcane image on the paper."))
		user.say("H'drak v[pick("'","`")]loso, mir'kanas verbot!")
		qdel(imbued_from)
		qdel(new_talisman)
	else
		return fizzle(user)