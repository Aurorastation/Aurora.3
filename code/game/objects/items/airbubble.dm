// Regular airbubble - folded
/obj/item/airbubble
	name = "air bubble"
	desc = "Special air bubble designed to protect people inside of it from decompressed enviroments."
	icon = 'icons/obj/airbubble.dmi'
	icon_state = "airbubble_fact_folded"
	w_class = ITEMSIZE_NORMAL
	var/used = 0
	var/obj/item/weapon/tank/internal_tank

/obj/item/airbubble/Destroy()
	qdel(internal_tank)
	return ..()

/obj/item/airbubble/attack_self(mob/user)
	var/obj/structure/closet/airbubble/R = new /obj/structure/closet/airbubble(user.loc)
	if(!used)
		internal_tank = new /obj/item/weapon/tank/emergency_oxygen/double(src)
	R.internal_tank = internal_tank
	internal_tank.forceMove(R)
	internal_tank = null
	R.add_fingerprint(user)
	qdel(src)

/obj/structure/closet/airbubble
	name = "air bubble"
	desc = "Special air bubble designed to protect people inside of it from decompressed enviroments."
	icon = 'icons/obj/airbubble.dmi'
	icon_state = "airbubble"
	icon_closed = "airbubble"
	icon_opened = "airbubble_open"
	open_sound = 'sound/items/zip.ogg'
	close_sound = 'sound/items/zip.ogg'
	var/item_path = /obj/item/airbubble
	var/zipped = 0
	density = 0
	storage_capacity = 20
	var/contains_body = 0
	var/used = 1

	var/use_internal_tank = 1
	var/datum/gas_mixture/inside_air
	var/internal_tank_valve = 45 // arbitrary for now
	var/obj/item/weapon/tank/internal_tank
	var/process_ticks = 0

/obj/structure/closet/airbubble/can_open()
	if(zipped)
		return 0
	return 1

/obj/structure/closet/airbubble/can_close()
	for(var/obj/structure/closet/closet in get_turf(src))
		if(closet != src)
			return 0
	var/mob_num = 0
	for(var/mob/living/M in loc)
		mob_num += 1
		if(mob_num > 1)
			visible_message("<span class='warning'>[src] can only fit one person.</span>")
			return 0
	return 1

/obj/structure/closet/airbubble/dump_contents()

	for(var/obj/I in src)
		if(!istype(I, /obj/item/weapon/tank))
			I.forceMove(loc)

	for(var/mob/M in src)
		M.forceMove(loc)
		if(M.client)
			M.client.eye = M.client.mob
			M.client.perspective = MOB_PERSPECTIVE

/obj/structure/closet/airbubble/Initialize()
	. = ..()
	add_inside()
	START_PROCESSING(SSfast_process, src)

/obj/structure/closet/airbubble/Destroy()
	STOP_PROCESSING(SSfast_process, src)
	qdel(internal_tank)
	if(parts)
		new parts(loc)
	if (smooth)
		queue_smooth_neighbors(src)
	return ..()

/obj/structure/closet/airbubble/close()
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
	add_inside()
	return 1

/obj/structure/closet/airbubble/MouseDrop(over_object, src_location, over_location)
	..()
	if(!zipped)
		if((over_object == usr && (in_range(src, usr) || usr.contents.Find(src))))
			if(!ishuman(usr))	return
			if(opened)	return 0
			if(contents.len > 1)	return 0
			visible_message("[usr] folds up the [src.name]")
			var/obj/item/airbubble/bag = new /obj/item/airbubble(get_turf(src))
			bag.internal_tank = internal_tank
			internal_tank.forceMove(bag)
			internal_tank = null
			bag.w_class = ITEMSIZE_LARGE
			bag.icon_state = "airbubble_man_folded"
			qdel(src)
			return

/obj/structure/closet/airbubble/verb/set_internals(mob/user as mob)
	set src in oview(1)
	set category = "Object"
	set name = "Set Internals"
	if(use_internal_tank)
		visible_message(
			"<span class='warning'>[user] set [src] internals.</span>",
			"<span class='notice'>You set [src] internals.</span>"
		)
		if (!do_after(user, 2 SECONDS, act_target = src))
			return
		if(use_internal_tank)
			STOP_PROCESSING(SSfast_process, src)
		else
			START_PROCESSING(SSfast_process, src)
		use_internal_tank = !use_internal_tank
	else
		visible_message("<span class='notice'>[src] has no internal tank.</span>")

/obj/structure/closet/airbubble/verb/take_tank(mob/user as mob)
	if(use_internal_tank)
		set src in oview(1)
		set category = "Object"
		set name = "Remove Air Tank"
		visible_message(
		"<span class='warning'>[user] removed [internal_tank] from [src].</span>",
		"<span class='notice'>You remove [internal_tank] from [src].</span>"
		)
		if (!do_after(user, 2 SECONDS, act_target = src))
			return
		for(var/obj/I in src)
			I.forceMove(user.loc)
		use_internal_tank = 0
		internal_tank = null
		update_icon()
		STOP_PROCESSING(SSfast_process, src)
	else
		visible_message(
		"<span class='warning'>[src] already has no tank.</span>")

/obj/structure/closet/airbubble/attackby(W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/tank))
		if(!use_internal_tank)
			user.visible_message(
				"<span class='warning'>[user] attached [W] to [src].</span>",
				"<span class='notice'>You attach [W] to [src].</span>"
			)
			if (!do_after(user, 2 SECONDS, act_target = src))
				return
			var/obj/item/weapon/tank/T = W
			internal_tank = T
			user.drop_from_inventory(T)
			T.forceMove(src)
			use_internal_tank = 1
			START_PROCESSING(SSfast_process, src)
		else
			user.visible_message("<span class='warning'>[src] already has a tank attached.</span>")
			update_icon()
	if(opened)
		if(istype(W, /obj/item/weapon/grab))
			var/obj/item/weapon/grab/G = W
			MouseDrop_T(G.affecting, user)
			return 0
		if(istype(W,/obj/item/tk_grab))
			return 0
		if(!dropsafety(W))
			return
		usr.drop_item()
	else if(istype(W, /obj/item/weapon/handcuffs/cable))
		user.visible_message(
			"<span class='warning'>[user] begins putting cable restrains on zipper of [src].</span>",
			"<span class='notice'>You begin putting cable restrains on zipper of [src].</span>"
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
		qdel(W)
	else if(istype(W, /obj/item/weapon/wirecutters))
		user.visible_message(
			"<span class='warning'>[user] begins cutting cable restrains on zipper of [src].</span>",
			"<span class='notice'>You begin cutting cable restrains on zipper of [src].</span>"
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
		new/obj/item/weapon/handcuffs/cable(src.loc)
	else
		attack_hand(user)
	return

/obj/structure/closet/airbubble/store_mobs(var/stored_units)
	contains_body = ..()
	return contains_body

/obj/structure/closet/airbubble/update_icon()
	if(opened)
		icon_state = icon_opened
	else
		icon_state = icon_closed

/obj/structure/closet/airbubble/proc/process_tank_give_air()
	if(internal_tank)
		var/datum/gas_mixture/tank_air = internal_tank.return_air()

		var/release_pressure = internal_tank_valve
		var/inside_pressure = inside_air.return_pressure()
		var/pressure_delta = min(release_pressure - inside_pressure, (tank_air.return_pressure() - inside_pressure)/2)
		var/transfer_moles = 0

		if(pressure_delta > 0) //inside pressure lower than release pressure
			if(tank_air.temperature > 0)
				transfer_moles = pressure_delta*inside_air.volume/(inside_air.temperature * R_IDEAL_GAS_EQUATION)
				var/datum/gas_mixture/removed = tank_air.remove(transfer_moles)
				inside_air.merge(removed)

		else if(pressure_delta < 0) //inside pressure higher than release pressure
			var/datum/gas_mixture/t_air = get_turf_air()
			pressure_delta = inside_pressure - release_pressure

			if(t_air)
				pressure_delta = min(inside_pressure - t_air.return_pressure(), pressure_delta)
			if(pressure_delta > 0) //if location pressure is lower than inside pressure
				transfer_moles = pressure_delta*inside_air.volume/(inside_air.temperature * R_IDEAL_GAS_EQUATION)

				var/datum/gas_mixture/removed = inside_air.remove(transfer_moles)
				if(t_air)
					t_air.merge(removed)
				else //just delete the inside gas, we're in space or some shit
					qdel(removed)

/obj/structure/closet/airbubble/proc/process_preserve_temp()
	if (inside_air && inside_air.volume > 0)
		var/delta = inside_air.temperature - T20C
		inside_air.temperature -= max(-10, min(10, round(delta/4,0.1)))

/obj/structure/closet/airbubble/remove_air(amount)
	if(use_internal_tank)
		return inside_air.remove(amount)
	else
		var/turf/T = get_turf(src)
		if(T)
			return T.remove_air(amount)
	return

/obj/structure/closet/airbubble/return_air()
	if(use_internal_tank)
		return inside_air
	return ..()

/obj/structure/closet/airbubble/proc/get_turf_air()
	var/turf/T = get_turf(src)
	if(T)
		. = T.return_air()
	return

/obj/structure/closet/airbubble/proc/return_pressure()
	. = 0
	if(use_internal_tank)
		. =  inside_air.return_pressure()
	else
		var/datum/gas_mixture/t_air = get_turf_air()
		if(t_air)
			. = t_air.return_pressure()
	return


/obj/structure/closet/airbubble/proc/return_temperature()
	. = 0
	if(use_internal_tank)
		. = inside_air.temperature
	else
		var/datum/gas_mixture/t_air = get_turf_air()
		if(t_air)
			. = t_air.temperature
	return

/obj/structure/closet/airbubble/process()
	if (!(process_ticks % 4))
		process_preserve_temp()

	if (!(process_ticks % 3))
		process_tank_give_air()

	process_ticks = (process_ticks + 1) % 17

/obj/structure/closet/airbubble/proc/add_inside()
	inside_air = new
	inside_air.temperature = T20C
	inside_air.volume = 2
	inside_air.adjust_multi("oxygen", O2STANDARD*inside_air.volume/(R_IDEAL_GAS_EQUATION*inside_air.temperature), "nitrogen", N2STANDARD*inside_air.volume/(R_IDEAL_GAS_EQUATION*inside_air.temperature))
	return inside_air

// Syndicate airbubble
/obj/item/airbubble/syndie
	name = "air bubble"
	desc = "Special air bubble designed to protect people inside of it from decompressed enviroments. This does not seem like a regular color scheme"
	icon_state = "airbubble_syndie_fact_folded"

/obj/structure/closet/airbubble/syndie
	name = "air bubble"
	desc = "Special air bubble designed to protect people inside of it from decompressed enviroments. This does not seem like a regular color scheme"
	icon_state = "airbubble_syndie"
	icon_closed = "airbubble_syndie"
	icon_closed = "airbubble_syndie"
	icon_opened = "airbubble_syndie_open"
	item_path = /obj/item/airbubble/syndie

/obj/structure/closet/airbubble/syndie/MouseDrop(over_object, src_location, over_location)
	..()
	if(!zipped)
		if((over_object == usr && (in_range(src, usr) || usr.contents.Find(src))))
			if(!ishuman(usr))	return
			if(opened)	return 0
			if(contents.len > 1)	return 0
			visible_message("[usr] folds up the [src.name]")
			var/obj/item/airbubble/bag = new /obj/item/airbubble/syndie(get_turf(src))
			bag.internal_tank = internal_tank
			internal_tank.forceMove(bag)
			internal_tank = null
			bag.w_class = ITEMSIZE_LARGE
			bag.icon_state = "airbubble_syndie_man_folded"
			qdel(src)
			return

/obj/item/airbubble/syndie/attack_self(mob/user)
	var/obj/structure/closet/airbubble/R = new /obj/structure/closet/airbubble/syndie(user.loc)
	if(!used)
		internal_tank = new /obj/item/weapon/tank/emergency_oxygen/double(src)
	R.internal_tank = internal_tank
	internal_tank.forceMove(R)
	internal_tank = null
	R.add_fingerprint(user)
	qdel(src)
