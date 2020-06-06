/obj/vehicle/train/cargo/engine/pussywagon
	name = "janicart deluxe engine"
	desc = "The engine for the janicart deluxe trolley, the bread to your butter."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "janicart_off"
	move_delay = 3

	mob_offset_y = 7
	load_offset_x = -13

	var/cart_icon = "janicart"

/obj/item/key/janicart
	name = "key"
	desc = "A keyring with a small steel key, and a pink fob reading \"Pussy Wagon\"."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "keys"
	w_class = 1

/obj/vehicle/train/cargo/engine/pussywagon/Initialize()
	. = ..()
	cell = new /obj/item/cell/high(src)
	key = null
	update_icon()
	turn_off()	//so engine verbs are correctly set

/obj/vehicle/train/cargo/engine/pussywagon/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/key/janicart))
		if(!key)
			user.drop_from_inventory(W,src)
			key = W
			verbs += /obj/vehicle/train/cargo/engine/verb/remove_key
		return
	..()

/obj/vehicle/train/cargo/engine/pussywagon/turn_on()
	if(!key)
		return
	else
		..()
		update_stats()

		verbs += /obj/vehicle/train/cargo/engine/pussywagon/verb/toggle_mop
		verbs += /obj/vehicle/train/cargo/engine/pussywagon/verb/toggle_hoover

/obj/vehicle/train/cargo/engine/pussywagon/turn_off()
	..()

	if(tow)
		if(istype(tow,/obj/vehicle/train/cargo/trolley/pussywagon))
			var/obj/vehicle/train/cargo/trolley/pussywagon/PW = tow
			if(PW.mopping)
				PW.mop_toggle()
			if(PW.hoover)
				PW.hoover_toggle()
	verbs -= /obj/vehicle/train/cargo/engine/pussywagon/verb/toggle_mop
	verbs -= /obj/vehicle/train/cargo/engine/pussywagon/verb/toggle_hoover

/obj/vehicle/train/cargo/engine/pussywagon/verb/toggle_mop()
	set name = "Toggle Mop-o-matic"
	set category = "Vehicle"
	set src in view(0)

	if(usr.incapacitated())
		return

	if(on && tow)
		if(istype(tow,/obj/vehicle/train/cargo/trolley/pussywagon))
			var/obj/vehicle/train/cargo/trolley/pussywagon/PW = tow
			if(!PW.bucket)
				to_chat(usr, "<span class='warning'>You must insert a reagent container first!</span>")
				return
			PW.mop_toggle()

/obj/vehicle/train/cargo/engine/pussywagon/verb/toggle_hoover()
	set name = "Toggle Space Hoover"
	set category = "Vehicle"
	set src in view(0)

	if(usr.incapacitated())
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
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "jantrolley"

	var/obj/item/reagent_containers/bucket
	var/list/hoovered = list()
	var/vacuum_capacity = 125
	var/mopping = 0
	var/hoover = 0


/obj/vehicle/train/cargo/trolley/pussywagon/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/reagent_containers) && open)
		if(!bucket)
			user.drop_from_inventory(W,src)
			bucket = W
			to_chat(user, "<span class='notice'>You replace \the [src]'s reagent reservoir.</span>")
			return

	if(W.iswrench() && open)
		if(bucket)
			bucket.forceMove(user.loc)
			bucket = null
			to_chat(user, "<span class='notice'>You remove \the [src]'s reagent reservoir.</span>")
			return

	if(W.iscrowbar() && !open)
		if(bucket)
			for(var/obj/item/I in hoovered)
				I.forceMove(user.loc)
				hoovered -= I
			vacuum_capacity = 125
			to_chat(user, "<span class='notice'>You empty \the [src]'s vacuum cleaner.</span>")
			return
	..()

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

/obj/vehicle/train/cargo/trolley/pussywagon/proc/mop_toggle()
	if(!mopping)
		mopping = 1
		src.visible_message("\The [src]'s mop-o-matic rumbles to life.", "You hear something rumble deeply.")
		playsound(src, 'sound/machines/hydraulic_long.ogg', 100, 1)
	else
		mopping = 0
		src.visible_message("\The [src]'s mop-o-matic putters before turning off.", "You hear something putter slowly.")
	update_icon()


/obj/vehicle/train/cargo/trolley/pussywagon/proc/hoover_toggle()
	if(!hoover)
		hoover = 1
		src.visible_message("\The [src]'s space hoover rumbles to life.", "You hear something rumble deeply.")
		playsound(src, 'sound/machines/hydraulic_long.ogg', 100, 1)
	else
		hoover = 0
		src.visible_message("\The [src]'s space hoover putters before turning off.", "You hear something putter slowly.")
	update_icon()

/obj/vehicle/train/cargo/trolley/pussywagon/update_icon()
	cut_overlays()

	if(mopping)
		add_overlay(image('icons/obj/vehicles.dmi', "[icon_state]_mop_overlay", MOB_LAYER + 1))
