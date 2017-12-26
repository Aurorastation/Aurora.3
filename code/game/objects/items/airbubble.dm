//Also contains /obj/structure/closet/body_bag because I doubt anyone would think to look for bodybags in /object/structures

/obj/item/air_bubble
	name = "air bubble"
	desc = "Special air bubble designed to protect people inside of it from decompressed enviroments."
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "bodybag_folded"
	w_class = 2.0

	attack_self(mob/user)
		var/obj/structure/closet/body_bag/R = new /obj/structure/closet/body_bag(user.loc)
		R.add_fingerprint(user)
		qdel(src)

/obj/structure/closet/air_bubble
	name = "air bubble"
	desc = "Special air bubble designed to protect people inside of it from decompressed enviroments."
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "bodybag_closed"
	icon_closed = "bodybag_closed"
	icon_opened = "bodybag_open"
	open_sound = 'sound/items/zip.ogg'
	close_sound = 'sound/items/zip.ogg'
	var/item_path = /obj/item/air_bubble
	density = 0
	storage_capacity = 30
	var/contains_body = 0

/obj/structure/closet/air_bubble/attackby(W as obj, mob/user as mob)
	if(opened)
		if(istype(W, /obj/item/weapon/grab))
			var/obj/item/weapon/grab/G = W
			MouseDrop_T(G.affecting, user)      //act like they were dragged onto the closet
			return 0
		if(istype(W,/obj/item/tk_grab))
			return 0
		if(istype(W, /obj/item/weapon/storage/laundry_basket) && W.contents.len)
			var/obj/item/weapon/storage/laundry_basket/LB = W
			var/turf/T = get_turf(src)
			for(var/obj/item/I in LB.contents)
				LB.remove_from_storage(I, T)
			user.visible_message(
				"<span class='notice'>[user] empties \the [LB] into \the [src].</span>",
				"<span class='notice'>You empty \the [LB] into \the [src].</span>",
				"<span class='notice'>You hear rustling of clothes.</span>"
			)
			return
		if(!dropsafety(W))
			return
		usr.drop_item()
		if(W)
			W.forceMove(loc)
	else if(iswelder(W))
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.isOn())
			user.visible_message(
				"<span class='warning'>[user] begins welding zipper of [src] [welded ? "open" : "shut"].</span>",
				"<span class='notice'>You begin welding zipper of [src] [welded ? "open" : "shut"].</span>",
				"You hear a welding torch on metal."
			)
			playsound(loc, 'sound/items/Welder2.ogg', 50, 1)
			if (!do_after(user, 2 SECONDS, act_target = src, extra_checks = CALLBACK(src, .proc/is_closed)))
				return
			if(!WT.remove_fuel(0,user))
				user << "<span class='notice'>You need more welding fuel to complete this task.</span>"
				return
			welded = !welded
			update_icon()
			user.visible_message(
				"<span class='warning'>[src]'s zipper has been [welded ? "welded shut" : "unwelded"] by [user].</span>",
				"<span class='notice'>You weld [src]'s zipper [!welded ? "open" : "shut"].</span>"
			)
		else
			attack_hand(user)
	else
		attack_hand(user)
	return

/obj/structure/closet/air_bubble/store_mobs(var/stored_units)
	contains_body = ..()
	return contains_body

/obj/structure/closet/air_bubble/close()
	if(..())
		density = 0
		return 1
	return 0

/obj/structure/closet/air_bubble/MouseDrop(over_object, src_location, over_location)
	..()
	if((over_object == usr && (in_range(src, usr) || usr.contents.Find(src))))
		if(!ishuman(usr))	return
		if(opened)	return 0
		if(contents.len)	return 0
		visible_message("[usr] folds up the [src.name]")
		new item_path(get_turf(src))
		spawn(0)
			qdel(src)
		return

/obj/structure/closet/air_bubble/update_icon()
	if(opened)
		icon_state = icon_opened
	else
		if(contains_body > 0)
			icon_state = "bodybag_closed1"
		else
			icon_state = icon_closed

