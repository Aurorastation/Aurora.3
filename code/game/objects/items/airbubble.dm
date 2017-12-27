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
	var/zipped = 0
	var/used = 0
	density = 0
	storage_capacity = 30
	var/contains_body = 0

/obj/structure/closet/air_bubble/can_open()
	if(zipped)
		return 0
	return 1

/obj/structure/closet/air_bubble/can_close()
	for(var/obj/structure/closet/closet in get_turf(src))
		if(closet != src)
			return 0
	return 1

/obj/structure/closet/air_bubble/open()
	. = ..()
	if(used)
		var/obj/item/O = new/obj/item(src.loc)
		O.name = "used stasis bag"
		O.icon = src.icon
		O.icon_state = "bodybag_used"
		O.desc = "Pretty useless now.."
		qdel(src)

/obj/structure/closet/air_bubble/close()
	if(!opened)
		return 0
	if(!can_close())
		return 0

	var/stored_units = 0

	if(store_misc)
		stored_units += store_misc(stored_units)
	if(store_items)
		stored_units += store_items(stored_units)
	if(store_mobs)
		stored_units += store_mobs(stored_units)

	icon_state = icon_closed
	opened = 0

	playsound(loc, close_sound, 25, 0, -3)
	density = 1
	used = 1
	return 1

/obj/structure/closet/air_bubble/attackby(W as obj, mob/user as mob)
	if(opened)
		if(istype(W, /obj/item/weapon/grab))
			var/obj/item/weapon/grab/G = W
			MouseDrop_T(G.affecting, user)      //act like they were dragged onto the closet
			return 0
		if(istype(W,/obj/item/tk_grab))
			return 0
		if(!dropsafety(W))
			return
		usr.drop_item()
	else if(istype(W, /obj/item/weapon/handcuffs/cable))
		user.visible_message(
			"<span class='warning'>[user] begins putting cable restrains on zipper of [src].</span>",
			"<span class='notice'>You begin putting cable restrains on zipper of [src].</span>",
		)
		playsound(loc, 'sound/weapons/cablecuff.ogg', 50, 1)
		if (!do_after(user, 2 SECONDS, act_target = src, extra_checks = CALLBACK(src, .proc/is_closed)))
			return
		zipped = !zipped
		update_icon()
		user.visible_message(
			"<span class='warning'>[src]'s zipper has been zipped by [user].</span>",
			"<span class='notice'>You put restrains on [src]'s zipper.</span>"
		)
	else if(istype(W, /obj/item/weapon/wirecutters))
		user.visible_message(
			"<span class='warning'>[user] begins cutting cable restrains on zipper of [src].</span>",
			"<span class='notice'>You begin cutting cable restrains on zipper of [src].</span>",
		)
		playsound(loc, 'sound/weapons/cablecuff.ogg', 50, 1)
		if (!do_after(user, 2 SECONDS, act_target = src, extra_checks = CALLBACK(src, .proc/is_closed)))
			return
		zipped = !zipped
		update_icon()
		user.visible_message(
			"<span class='warning'>[src] zipper's cable restrains have been cut by [user].</span>",
			"<span class='notice'>You cut cable restrains on [src]'s zipper.</span>"
		)
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



