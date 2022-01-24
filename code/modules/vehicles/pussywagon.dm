/obj/vehicle/train/cargo/engine/pussywagon
	name = "janicart deluxe engine"
	desc = "The engine for the janicart deluxe trolley, the bread to your butter."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "janicart_off"
	move_delay = 3

	mob_offset_y = 7
	load_offset_x = -13
	vueui_template = "pussywagon"

	var/cart_icon = "janicart"

/obj/item/key/janicart
	name = "key"
	desc = "A keyring with a small steel key, and a pink fob reading \"Pussy Wagon\"."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "keys"
	w_class = ITEMSIZE_TINY

/obj/vehicle/train/cargo/engine/pussywagon/setup_engine()
	cell = new /obj/item/cell/high(src)
	key = null
	update_icon()
	turn_off()

/obj/vehicle/train/cargo/engine/pussywagon/vueui_data_change(list/data, mob/user, datum/vueui/ui)
	data = ..()

	data["has_proper_trolley"] = FALSE
	if(istype(tow, /obj/vehicle/train/cargo/trolley/pussywagon))
		data["has_proper_trolley"] = TRUE
		var/obj/vehicle/train/cargo/trolley/pussywagon/PT = tow
		data["is_hoovering"] = PT.hoover
		data["vacuum_capacity"] = PT.vacuum_capacity
		data["max_vacuum_capacity"] = PT.max_vacuum_capacity
		data["is_mopping"] = PT.mopping
		data["has_bucket"] = !!PT.bucket
		data["bucket_capacity"] = 0
		if(PT.bucket)
			var/obj/item/reagent_containers/B = PT.bucket
			data["bucket_capacity"] = B.reagents.total_volume
			data["max_bucket_capacity"] = B.volume

	return data

/obj/vehicle/train/cargo/engine/pussywagon/Topic(href, href_list, datum/topic_state/state)
	. = ..()
	if(.)
		return

	if(href_list["toggle_hoover"])
		toggle_hoover(usr)
	if(href_list["empty_hoover"])
		var/obj/vehicle/train/cargo/trolley/pussywagon/PT = tow
		PT.empty_hoover(usr)
	if(href_list["toggle_mops"])
		toggle_mop(usr)
	SSvueui.check_uis_for_change(src)

/obj/vehicle/train/cargo/engine/pussywagon/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/key/janicart))
		if(!key)
			user.drop_from_inventory(W, src)
			key = W
			to_chat(user, SPAN_NOTICE("You slide the key into the ignition."))
		else
			to_chat(user, SPAN_WARNING("\The [src] already has a key inserted."))
		return
	..()

/obj/vehicle/train/cargo/engine/pussywagon/turn_on()
	if(!key)
		audible_message("\The [src] whirrs, but the lack of a key causes the engine to shut down.")
		return
	else
		..()
		update_stats()

/obj/vehicle/train/cargo/engine/pussywagon/turn_off()
	..()

	if(tow)
		if(istype(tow, /obj/vehicle/train/cargo/trolley/pussywagon))
			var/obj/vehicle/train/cargo/trolley/pussywagon/PW = tow
			PW.engine_off()

/obj/vehicle/train/cargo/engine/pussywagon/proc/toggle_mop(var/mob/user)
	if(on && tow)
		if(istype(tow,/obj/vehicle/train/cargo/trolley/pussywagon))
			var/obj/vehicle/train/cargo/trolley/pussywagon/PW = tow
			if(!PW.bucket)
				to_chat(user, SPAN_WARNING("You must insert a reagent container first!"))
				return
			PW.mop_toggle()

/obj/vehicle/train/cargo/engine/pussywagon/proc/toggle_hoover(var/mob/user)
	if(use_check_and_message(user))
		return

	if(on && tow)
		if(istype(tow,/obj/vehicle/train/cargo/trolley/pussywagon))
			var/obj/vehicle/train/cargo/trolley/pussywagon/PW = tow
			PW.hoover_toggle()

/obj/vehicle/train/cargo/engine/pussywagon/update_icon()
	cut_overlays()

	if(on)
		add_overlay(image('icons/obj/vehicles.dmi', "[cart_icon]_on_overlay", MOB_LAYER + 1))
		icon_state = "[cart_icon]_on"
	else
		add_overlay(image('icons/obj/vehicles.dmi', "[cart_icon]_off_overlay", MOB_LAYER + 1))
		icon_state = "[cart_icon]_off"
	..()

/obj/vehicle/train/cargo/engine/pussywagon/Move(var/turf/destination)
	switch(dir)
		if(NORTH)
			mob_offset_y = 7
			load_offset_x = 0
			load.pixel_y = mob_offset_y
			load.pixel_x = load_offset_x
		if(SOUTH)
			mob_offset_y = 7
			load_offset_x = 0
			load.pixel_y = mob_offset_y
			load.pixel_x = load_offset_x
		if(EAST)
			mob_offset_y = 7
			load_offset_x = -13
			load.pixel_y = mob_offset_y
			load.pixel_x = load_offset_x
		if(WEST)
			mob_offset_y = 7
			load_offset_x = 13
			load.pixel_y = mob_offset_y
			load.pixel_x = load_offset_x
	..()

/obj/vehicle/train/cargo/trolley/pussywagon
	name = "janicart deluxe trolley"
	desc = "The trolley of the janicart deluxe, equipped with dual rotary mop and a NT-X1 Vacuum Cleaner."
	desc_info = "You can unlatch this from the control console of the janicart."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "jantrolley"

	var/obj/item/reagent_containers/bucket
	var/list/hoovered = list()
	var/max_vacuum_capacity = 125
	var/vacuum_capacity = 125
	var/mopping = 0
	var/hoover = 0


/obj/vehicle/train/cargo/trolley/pussywagon/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/reagent_containers))
		if(!open)
			to_chat(user, SPAN_WARNING("\The [src]'s panel isn't open."))
			return
		if(!bucket)
			user.drop_from_inventory(W,src)
			bucket = W
			to_chat(user, SPAN_NOTICE("You replace \the [src]'s reagent reservoir."))
			return

	if(W.iswrench())
		if(!open)
			to_chat(user, SPAN_WARNING("\The [src]'s panel isn't open."))
			return
		if(bucket)
			bucket.forceMove(user.loc)
			bucket = null
			to_chat(user, SPAN_NOTICE("You remove \the [src]'s reagent reservoir."))
			return
		else
			to_chat(user, SPAN_WARNING("\The [src] doesn't have a reagent reservoir installed."))
			return

	if(W.iscrowbar())
		if(!open)
			to_chat(user, SPAN_WARNING("\The [src]'s panel isn't open."))
			return
		empty_hoover(user)
		to_chat(user, SPAN_NOTICE("You empty \the [src]'s vacuum cleaner."))
		return
	..()

/obj/vehicle/train/cargo/trolley/pussywagon/proc/empty_hoover(var/mob/user)
	for(var/obj/item/I in hoovered)
		I.forceMove(user.loc)
		hoovered -= I
	vacuum_capacity = max_vacuum_capacity

/obj/vehicle/train/cargo/trolley/pussywagon/Move(var/turf/destination)
	if(lead)
		var/turf/tile = loc
		if(mopping && bucket)
			if(isturf(tile))
				if(bucket.reagents.total_volume > 1)
					tile.clean(bucket)
					lead.cell.use(charge_use, load)
				else
					mop_toggle()
		if(hoover)
			var/current_len = hoovered.len
			for(var/obj/item/I in tile)
				if(I.w_class <= 2.0 && !I.anchored && (vacuum_capacity -= w_class >= 0))
					I.forceMove(src)
					hoovered += I
					vacuum_capacity -= I.w_class
					lead.cell.use(charge_use)
			if(!vacuum_capacity)
				hoover_toggle()
			if(hoovered.len > current_len)
				playsound(src, 'sound/machines/disposalflush.ogg', 100, 1)
	return ..()

/obj/vehicle/train/cargo/trolley/pussywagon/proc/engine_off()
	if(mopping)
		mop_toggle()
	if(hoover)
		hoover_toggle()

/obj/vehicle/train/cargo/trolley/pussywagon/proc/mop_toggle()
	if(!mopping)
		mopping = 1
		audible_message("\The [src]'s mop-o-matic rumbles to life.", "You hear something rumble deeply.")
		playsound(src, 'sound/machines/hydraulic_long.ogg', 100, 1)
	else
		mopping = 0
		audible_message("\The [src]'s mop-o-matic putters before turning off.", "You hear something putter slowly.")
	update_icon()

/obj/vehicle/train/cargo/trolley/pussywagon/proc/hoover_toggle()
	if(!hoover)
		hoover = 1
		audible_message("\The [src]'s space hoover rumbles to life.", "You hear something rumble deeply.")
		playsound(src, 'sound/machines/hydraulic_long.ogg', 100, 1)
	else
		hoover = 0
		audible_message("\The [src]'s space hoover putters before turning off.", "You hear something putter slowly.")
	update_icon()

/obj/vehicle/train/cargo/trolley/pussywagon/update_icon()
	cut_overlays()

	if(mopping)
		add_overlay(image('icons/obj/vehicles.dmi', "[icon_state]_mop_overlay", MOB_LAYER + 1))
