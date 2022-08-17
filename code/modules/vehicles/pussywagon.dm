//
// Custodial Truck a.k.a. Pussy Wagon
// 
/obj/vehicle/train/cargo/engine/pussywagon
	name = "\improper C8000 deluxe custodial truck"
	desc = "A C8000 deluxe custodial truck. The bread to the custodians' butter."
	desc_info = "Click-drag yourself onto the truck to climb onto it.<br>\
		- CTRL-click the truck to open the ignition and controls menu.<br>\
		- ALT-click the truck to remove the key from the ignition.<br>\
		- Click the truck to open a UI menu.<br>\
		- Click the resist button or type \"resist\" in the command bar at the bottom of your screen to get off the truck."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "janicart_off"
	light_range = 0 // Turn off the light inherited from the parent.
	move_delay = 3
	mob_offset_y = 7
	load_offset_x = -13
	vueui_template = "pussywagon"

	// Unique Variables
	var/cart_icon = "janicart"
	var/ignition = FALSE

/obj/vehicle/train/cargo/engine/pussywagon/setup_engine()
	cell = new /obj/item/cell/high(src)
	key = null
	update_icon()
	toggle_ignition()

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
		return TRUE

	if(href_list["toggle_hoover"])
		toggle_hoover(usr)
	if(href_list["empty_hoover"])
		var/obj/vehicle/train/cargo/trolley/pussywagon/PT = tow
		PT.empty_hoover(usr)
	if(href_list["toggle_mop"])
		toggle_mop(usr)
	SSvueui.check_uis_for_change(src)

/obj/vehicle/train/cargo/engine/pussywagon/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/key/janicart))
		if(!key)
			user.drop_from_inventory(W, src)
			key = W
			to_chat(user, SPAN_NOTICE("You slide \the [W] into \the [src]'s ignition."))
			playsound(src, 'sound/machines/vehicles/pussywagon/key_in.ogg', 50, FALSE)
		else
			to_chat(user, SPAN_NOTICE("There is already a key in [src]'s ignition."))
		return
	..()

/obj/vehicle/train/cargo/engine/pussywagon/CtrlClick(mob/user)
	if(load && load != user)
		to_chat(user, SPAN_WARNING("You can't interact with \the [src] while its in use."))
		return
	var/list/options = list(
		"Toggle Ignition" = image('icons/mob/screen/radial.dmi', "custodial_key"),
		"Toggle Mopping" = image('icons/mob/screen/radial.dmi', "custodial_mop"),
		"Toggle Vacuuming" = image('icons/mob/screen/radial.dmi', "custodial_vacuum")
	)
	var/chosen_option = show_radial_menu(user, src, options, radius = 42, require_near = TRUE, tooltips = TRUE)
	if (!chosen_option)
		return
	switch(chosen_option)
		if("Toggle Ignition")
			toggle_ignition(user)
		if("Toggle Mopping")
			toggle_mop(user)
		if("Toggle Vacuuming")
			toggle_hoover(user)

/obj/vehicle/train/cargo/engine/pussywagon/AltClick(mob/user)
	if(Adjacent(user))
		remove_key(user)
	else
		return ..()

/obj/vehicle/train/cargo/engine/pussywagon/remove_key(mob/user)
	if(!key)
		to_chat(user, SPAN_NOTICE("There is no key in \the [src]'s ignition."))
		return

	if(load && load != user)
		to_chat(usr, SPAN_WARNING("You can't remove \the [key] from \the [src] while its in use."))
		return

	to_chat(user, SPAN_NOTICE("You take out \the [key] out of \the [src]'s ignition."))
	playsound(src, 'sound/machines/vehicles/pussywagon/key_out.ogg', 50, FALSE)

	user.put_in_hands(key)
	key = null

	if(ignition)
		toggle_ignition()

/obj/vehicle/train/cargo/engine/pussywagon/proc/toggle_ignition(mob/user)
	if(!ignition)
		if(!key)
			to_chat(user, SPAN_NOTICE("There is no key in \the [src]'s ignition."))
			return
		else
			if(stat)
				return FALSE
			if(powered && cell.charge < charge_use)
				return FALSE
			to_chat(user, SPAN_NOTICE("You turn on \the [src]'s ignition."))
			playsound(src, 'sound/machines/vehicles/pussywagon/button.ogg', 50, FALSE)
			playsound_in(src, 'sound/machines/vehicles/pussywagon/start.ogg', 50, FALSE, time = 1 SECOND)
			on = TRUE
			ignition = TRUE
			update_stats()
			update_icon()
			return TRUE
	else
		to_chat(user, SPAN_NOTICE("You turn off \the [src]'s ignition."))
		if(key)
			playsound(src, 'sound/machines/vehicles/pussywagon/button.ogg', 50, FALSE)
		on = FALSE
		ignition = FALSE
		update_icon()

		if(tow)
			if(istype(tow, /obj/vehicle/train/cargo/trolley/pussywagon))
				var/obj/vehicle/train/cargo/trolley/pussywagon/PW = tow
				PW.trolley_off()

/obj/vehicle/train/cargo/engine/pussywagon/proc/toggle_mop(mob/user)
	if(on && tow)
		if(istype(tow, /obj/vehicle/train/cargo/trolley/pussywagon))
			var/obj/vehicle/train/cargo/trolley/pussywagon/PW = tow
			if(!PW.bucket)
				to_chat(user, SPAN_NOTICE("You must insert a reagent container first."))
				return
			if(!PW.mopping)
				to_chat(user, SPAN_NOTICE("You turn on \the [src]'s rotary mop."))
			else
				to_chat(user, SPAN_NOTICE("You turn off \the [src]'s rotary mop."))
			PW.toggle_mop()

/obj/vehicle/train/cargo/engine/pussywagon/proc/toggle_hoover(mob/user)
	if(use_check_and_message(user))
		return

	if(on && tow)
		if(istype(tow, /obj/vehicle/train/cargo/trolley/pussywagon))
			var/obj/vehicle/train/cargo/trolley/pussywagon/PW = tow
			if(!PW.hoover)
				to_chat(user, SPAN_NOTICE("You turn on \the [src]'s vacuum cleaner."))
			else
				to_chat(user, SPAN_NOTICE("You turn off \the [src]'s vacuum cleaner."))
			PW.toggle_hoover()

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
	name = "\improper C8000 deluxe custodial trolley"
	desc = "The trolley of the C8000 deluxe custodial truck, equipped with a dual rotary mop and a industrial vacuum cleaner."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "jantrolley"
	light_range = 0 // Turn off the light inherited from the parent.

	var/obj/item/reagent_containers/bucket
	var/list/hoovered = list()
	var/max_vacuum_capacity = 125
	var/vacuum_capacity = 125
	var/mopping = 0
	var/hoover = 0

/obj/vehicle/train/cargo/trolley/pussywagon/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/reagent_containers))
		if(!open)
			to_chat(user, SPAN_WARNING("\The [src]'s maintenance panel isn't open."))
			return
		if(!bucket)
			user.drop_from_inventory(W,src)
			bucket = W
			to_chat(user, SPAN_NOTICE("You replace \the [src]'s reagent reservoir."))
			return

	if(W.iswrench())
		if(!open)
			to_chat(user, SPAN_WARNING("\The [src]'s maintenance panel isn't open."))
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

/obj/vehicle/train/cargo/trolley/pussywagon/proc/empty_hoover(mob/user)
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
					toggle_mop()
		if(hoover)
			var/current_len = hoovered.len
			for(var/obj/item/I in tile)
				if(I.w_class <= 2.0 && !I.anchored && (vacuum_capacity -= w_class >= 0))
					I.forceMove(src)
					hoovered += I
					vacuum_capacity -= I.w_class
					lead.cell.use(charge_use)
			if(!vacuum_capacity)
				toggle_hoover()
			if(hoovered.len > current_len)
				playsound(src, 'sound/machines/disposalflush.ogg', 50, TRUE)
	return ..()

/obj/vehicle/train/cargo/trolley/pussywagon/proc/trolley_off()
	if(mopping)
		toggle_mop()
	if(hoover)
		toggle_hoover()

/obj/vehicle/train/cargo/trolley/pussywagon/proc/toggle_mop()
	if(!mopping)
		playsound(src, 'sound/machines/hydraulic_long.ogg', 20, TRUE)
		mopping = 1
	else
		mopping = 0
	update_icon()

/obj/vehicle/train/cargo/trolley/pussywagon/proc/toggle_hoover()
	if(!hoover)
		playsound(src, 'sound/machines/hydraulic_long.ogg', 20, TRUE)
		hoover = 1
	else
		hoover = 0
	update_icon()

/obj/vehicle/train/cargo/trolley/pussywagon/update_icon()
	cut_overlays()

	if(mopping)
		add_overlay(image('icons/obj/vehicles.dmi', "[icon_state]_mop_overlay", MOB_LAYER + 1))

/obj/item/key/janicart
	name = "\improper C8000 deluxe custodial truck key fob"
	desc = "A stainless steel key fob with a chromed top attached to a small steel key ring. The key ring has a pink tag hanging on it, with the text \"Pussy Wagon\"."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "keys"
	w_class = ITEMSIZE_TINY