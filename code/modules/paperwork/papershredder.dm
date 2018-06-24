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
		/obj/item/weapon/photo = -1,
		/obj/item/weapon/shreddedp = 1,
		/obj/item/weapon/paper = 1,
		/obj/item/weapon/newspaper = 3,
		/obj/item/weapon/card/id = -1,
		/obj/item/weapon/paper_bundle = 3
		)// use -1 if it doesn't generate paper

/obj/machinery/papershredder/attackby(var/obj/item/W, var/mob/user)
	if (istype(W, /obj/item/weapon/storage))
		empty_bin(user, W)
		return

	else if (iswrench(W))
		playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
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
				user << span("warning", "\The [src] must be anchored to the ground to operate!")
				return
			if(paperamount == max_paper)
				user << "<span class='warning'>\The [src] is full; please empty it before you continue.</span>"
				return
			if (paper_result > 0)
				paperamount += paper_result
			qdel(W)
			playsound(src.loc, 'sound/items/pshred.ogg', 75, 1)
			if(paperamount > max_paper)
				user <<"<span class='danger'>\The [src] was too full, and shredded paper goes everywhere!</span>"
				for(var/i=(paperamount-max_paper);i>0;i--)
					var/obj/item/weapon/shreddedp/SP = get_shredded_paper()
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
		usr << "<span class='notice'>\The [src] is empty.</span>"
		return

	empty_bin(usr)

/obj/machinery/papershredder/proc/empty_bin(var/mob/living/user, var/obj/item/weapon/storage/empty_into)

	// Sanity.
	if(empty_into && !istype(empty_into))
		empty_into = null

	if(empty_into && empty_into.contents.len >= empty_into.storage_slots)
		user << "<span class='notice'>\The [empty_into] is full.</span>"
		return

	while(paperamount)
		var/obj/item/weapon/shreddedp/SP = get_shredded_paper()
		if(!SP) break
		if(empty_into)
			empty_into.handle_item_insertion(SP)
			if(empty_into.contents.len >= empty_into.storage_slots)
				break
	if(empty_into)
		if(paperamount)
			user << "<span class='notice'>You fill \the [empty_into] with as much shredded paper as it will carry.</span>"
		else
			user << "<span class='notice'>You empty \the [src] into \the [empty_into].</span>"

	else
		user << "<span class='notice'>You empty \the [src].</span>"
	update_icon()

/obj/machinery/papershredder/proc/get_shredded_paper()
	if(!paperamount)
		return
	paperamount--
	return new /obj/item/weapon/shreddedp(get_turf(src))

/obj/machinery/papershredder/update_icon()
	icon_state = "papershredder[max(0,min(5,Floor(paperamount/2)))]"

/obj/item/weapon/shreddedp/attackby(var/obj/item/W as obj, var/mob/user)
	if(istype(W, /obj/item/weapon/flame/lighter))
		burnpaper(W, user)
	else
		..()

/obj/item/weapon/shreddedp/proc/burnpaper(var/obj/item/weapon/flame/lighter/P, var/mob/user)
	if(user.restrained())
		return
	if(!P.lit)
		user << "<span class='warning'>\The [P] is not lit.</span>"
		return
	user.visible_message("<span class='warning'>\The [user] holds \the [P] up to \the [src]. It looks like \he's trying to burn it!</span>", \
		"<span class='warning'>You hold \the [P] up to \the [src], burning it slowly.</span>")
	if(!do_after(user,20))
		user << "<span class='warning'>You must hold \the [P] steady to burn \the [src].</span>"
		return
	user.visible_message("<span class='danger'>\The [user] burns right through \the [src], turning it to ash. It flutters through the air before settling on the floor in a heap.</span>", \
		"<span class='danger'>You burn right through \the [src], turning it to ash. It flutters through the air before settling on the floor in a heap.</span>")
	FireBurn()

/obj/item/weapon/shreddedp/proc/FireBurn()
	new /obj/effect/decal/cleanable/ash(get_turf(src))
	qdel(src)

/obj/item/weapon/shreddedp
	name = "shredded paper"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "shredp"
	throwforce = 0
	w_class = 1
	throw_range = 3
	throw_speed = 1

/obj/item/weapon/shreddedp/New()
	..()
	pixel_x = rand(-5,5)
	pixel_y = rand(-5,5)
	if(prob(65)) color = pick("#BABABA","#7F7F7F")
