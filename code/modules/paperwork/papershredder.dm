/obj/machinery/papershredder
	name = "paper shredder"
	desc = "For those documents you don't want seen."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "papershredder0"
	density = 1
	anchored = 1
	var/max_paper = 10
	var/paperamount = 0
	var/list/shred_amounts = list(
		/obj/item/photo = -1,
		/obj/item/shreddedp = 1,
		/obj/item/paper = 1,
		/obj/item/newspaper = 3,
		/obj/item/card/id = -1,
		/obj/item/paper_bundle = 3
		)// use -1 if it doesn't generate paper

/obj/machinery/papershredder/attackby(var/obj/item/W, var/mob/user)
	if (istype(W, /obj/item/storage))
		empty_bin(user, W)
		return

	else if (W.iswrench())
		playsound(loc, W.usesound, 50, 1)
		anchored = !anchored
		user.visible_message(
			span("notice", anchored ? "\The [user] fastens \the [src] to \the [loc]." : "\The unfastens \the [src] from \the [loc]."),
			span("notice", anchored ? "You fasten \the [src] to \the [loc]." : "You unfasten \the [src] from \the [loc]."),
			"You hear a ratchet."
		)
		return

	else
		var/paper_result
		for(var/shred_type in shred_amounts)
			if(istype(W, shred_type))
				paper_result = shred_amounts[shred_type]
		if(paper_result)
			if (!anchored)
				to_chat(user, span("warning", "\The [src] must be anchored to the ground to operate!"))
				return
			if(paperamount == max_paper)
				to_chat(user, span("warning", "\The [src] is full; please empty it before you continue."))
				return
			if (paper_result > 0)
				paperamount += paper_result
			if(W.icon_state == "scrap")
				flick("papershredder_s_on", src)
			else if(W.icon_state == "paper_words")
				flick("papershredder_w_on", src)
			else if(W.icon_state == "paper_plane")
				flick("papershredder_p_on", src)
			else
				flick("papershredder_on", src)
			qdel(W)
			playsound(src.loc, 'sound/bureaucracy/papershred.ogg', 75, 1)
			to_chat(user, span("notice", "You shred the paper."))
			if(paperamount > max_paper)
				to_chat(user, span("danger", "\The [src] was too full, and shredded paper goes everywhere!"))
				for(var/i=(paperamount-max_paper);i>0;i--)
					var/obj/item/shreddedp/SP = get_shredded_paper()
					SP.forceMove(get_turf(src))
					SP.throw_at(get_edge_target_turf(src,pick(alldirs)),1,5)
				paperamount = max_paper
			update_icon()
			return
	return ..()

/obj/machinery/papershredder/verb/empty_contents()
	set name = "Empty bin"
	set category = "Object"
	set src in range(1)

	if(usr.stat || usr.restrained() || usr.weakened || usr.paralysis || usr.lying || usr.stunned)
		return

	if(!paperamount)
		to_chat(usr, span("notice", "\The [src] is empty."))
		return

	empty_bin(usr)

/obj/machinery/papershredder/proc/empty_bin(var/mob/living/user, var/obj/item/storage/empty_into)

	// Sanity.
	if(empty_into && !istype(empty_into))
		empty_into = null

	if(empty_into && empty_into.contents.len >= empty_into.storage_slots)
		to_chat(user,  span("notice", "\The [empty_into] is full."))
		return

	while(paperamount)
		var/obj/item/shreddedp/SP = get_shredded_paper()
		if(!SP) break
		if(empty_into)
			empty_into.handle_item_insertion(SP)
			if(empty_into.contents.len >= empty_into.storage_slots)
				break
	if(empty_into)
		if(paperamount)
			to_chat(user,  span("notice", "You fill \the [empty_into] with as much shredded paper as it will carry."))
		else
			to_chat(user,  span("notice", "You empty \the [src] into \the [empty_into]."))

	else
		to_chat(user,  span("notice", "You empty \the [src]."))
	update_icon()

/obj/machinery/papershredder/proc/get_shredded_paper()
	if(!paperamount)
		return
	paperamount--
	return new /obj/item/shreddedp(get_turf(src))

/obj/machinery/papershredder/update_icon() //makes it show how full the papershredder is while covering up the animation. Seemsgood - Wezzy
	cut_overlays()
	switch(paperamount)
		if(2 to 3)
			add_overlay("papershredder1")
		if(4 to 5)
			add_overlay("papershredder2")
		if(6 to 7)
			add_overlay("papershredder3")
		if(8 to 9)
			add_overlay("papershredder4")
		if(10)
			add_overlay("papershredder5")
	update_icon()

/obj/item/shreddedp/attackby(var/obj/item/W as obj, var/mob/user)
	if(istype(W, /obj/item/flame/lighter))
		burnpaper(W, user)
	else
		..()

/obj/item/shreddedp/proc/burnpaper(obj/item/P, mob/user)
	var/class = "warning"

	if (!user.restrained())
		if (istype(P, /obj/item/flame))
			var/obj/item/flame/F = P
			if (!F.lit)
				return
		else if (P.iswelder())
			var/obj/item/weldingtool/F = P // NOW THAT'S WHAT I CALL RECYCLING - wezzy
			if (!F.welding)
				return
			if (!F.remove_fuel(1, user))
				return
		else

			return

		if(istype(P, /obj/item/flame/lighter/zippo))
			class = "rose"

		user.visible_message(span("[class]", "[user] holds \the [P] up to \the [src], trying to burn it!"), \
		span("[class]", "You hold \the [P] up to \the [src], burning it slowly."))
		playsound(src.loc, 'sound/bureaucracy/paperburn.ogg', 50, 1)
		flick("shredp_onfire", src) //no do_after here, so people can walk n' burn at the same time. -wezzy

		spawn(20)
			if(get_dist(src, user) < 2 && user.get_active_hand() == P)
				user.visible_message(span("[class]", "[user] burns right through \the [src], turning it to ash. It flutters through the air before settling on the floor in a heap."), \
				span("[class]", "You burn right through \the [src], turning it to ash. It flutters through the air before settling on the floor in a heap."))
				new /obj/effect/decal/cleanable/ash(src.loc)
				qdel(src)

			else
				to_chat(user, span("warning", "You must hold \the [P] steady to burn \the [src]."))

/obj/item/shreddedp
	name = "shredded paper"
	desc = "The remains of a private, confidential, or otherwise sensitive document."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "shredp"
	throwforce = 0
	w_class = 1
	throw_range = 3
	throw_speed = 1
