// Regular airbubble - folded
/obj/item/airbubble
	name = "air bubble"
	desc = "Special air bubble designed to protect people inside of it from decompressed enviroments."
	icon = 'icons/obj/airbubble.dmi'
	icon_state = "airbubble_fact_folded"
	w_class = ITEMSIZE_NORMAL
	var/used = FALSE
	var/ripped = FALSE
	var/obj/item/weapon/tank/internal_tank

/obj/item/airbubble/Destroy()
	qdel(internal_tank)
	return ..()

/obj/item/airbubble/attack_self(mob/user)
	var/obj/structure/closet/airbubble/R = new /obj/structure/closet/airbubble(user.loc)
	if(!used && !ripped)
		internal_tank = new /obj/item/weapon/tank/emergency_oxygen/double(src)
	R.internal_tank = internal_tank
	internal_tank.forceMove(R)
	internal_tank = null
	R.add_fingerprint(user)
	R.ripped = ripped
	R.update_icon()
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
	var/zipped = FALSE
	density = 0
	storage_capacity = 20
	var/contains_body = FALSE
	var/used = TRUE
	var/ripped = FALSE

	var/use_internal_tank = TRUE
	var/datum/gas_mixture/inside_air
	var/internal_tank_valve = 45 // arbitrary for now
	var/obj/item/weapon/tank/internal_tank
	var/process_ticks = 0

/obj/structure/closet/airbubble/can_open()
	if(zipped)
		return 0
	return 1

/obj/structure/closet/airbubble/can_close()
	if(zipped)
		return 0
	var/turf/T = get_turf(src)
	for(var/obj/structure/closet/closet in T)
		if(closet != src)
			return 0
	var/mob_num = 0
	for(var/mob/living/M in T)
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
	if((!zipped || ripped )&& (over_object == usr && (in_range(src, usr) || usr.contents.Find(src))))
		if(!ishuman(usr))	return
		if(opened)	return 0
		if(contents.len > 1)	return 0
		visible_message("[usr] folds up the [src.name]")
		var/obj/item/airbubble/bag = new /obj/item/airbubble(get_turf(src))
		bag.ripped = ripped
		bag.internal_tank = internal_tank
		internal_tank.forceMove(bag)
		internal_tank = null
		bag.w_class = ITEMSIZE_LARGE
		bag.icon_state = "[icon_state]_man_folded"
		bag.desc = "Special air bubble designed to protect people inside of it from decompressed enviroments. It appears to be poorly hand folded."
		qdel(src)
		return

/obj/structure/closet/airbubble/req_breakout()

	if(opened)
		return 0 //Door's open... wait, why are you in it's contents then?
	if(zipped)
		return 1 //closed but not welded...
	if(breakout)
		return -1 //Already breaking out.
	return 0

/obj/structure/closet/airbubble/mob_breakout(var/mob/living/escapee)

	//Improved by nanako
	//Now it actually works, also locker breakout time stacks with locking and welding
	//This means secure lockers are more useful for imprisoning people
	var/breakout_time = 1 * req_breakout()//1.5 minutes if locked or welded, 3 minutes if both
	if(breakout_time <= 0)
		return



	//okay, so the closet is either welded or locked... resist!!!
	escapee.next_move = world.time + 100
	escapee.last_special = world.time + 100
	escapee << "<span class='warning'>You lean on the back of \the [src] and start punching internal wall with your legs. (this will take about [breakout_time] minutes)</span>"
	visible_message("<span class='danger'>\The [src] begins to shake violently! Something is terring it from the inside!</span>")

	var/time = 6 * breakout_time * 2

	var/datum/progressbar/bar
	if (escapee.client && escapee.client.prefs.toggles_secondary & PROGRESS_BARS)
		bar = new(escapee, time, src)

	breakout = 1
	for(var/i in 1 to time) //minutes * 6 * 5seconds * 2
		playsound(loc, "sound/items/[pick("rip1","rip2")].ogg", 100, 1)
		animate_shake()

		if (bar)
			bar.update(i)

		if(!do_after(escapee, 50, display_progress = FALSE)) //5 seconds
			breakout = 0
			qdel(bar)
			return

		if(!escapee || escapee.stat || escapee.loc != src)
			breakout = 0
			qdel(bar)
			return //closet/user destroyed OR user dead/unconcious OR user no longer in closet OR closet opened

		//Perform the same set of checks as above for weld and lock status to determine if there is even still a point in 'resisting'...
		if(!req_breakout())
			breakout = 0
			qdel(bar)
			return

	//Well then break it!
	breakout = 0
	escapee << "<span class='warning'>You successfully break out! Tearing the bubble's walls!</span>"
	visible_message("<span class='danger'>\the [escapee] successfully broke out of \the [src]! Tearing the bubble's walls!</span>")
	playsound(loc, "sound/items/[pick("rip1","rip2")].ogg", 100, 1)
	break_open()
	animate_shake()
	qdel(bar)

/obj/structure/closet/airbubble/break_open()
	ripped = TRUE
	update_icon()
	dump_contents()

/obj/structure/closet/airbubble/verb/set_internals(mob/user as mob)
	set src in oview(1)
	set category = "Object"
	set name = "Set Internals"
	if(!isnull(internal_tank))
		visible_message("<span class='warning'>[user] is setting [src] internals.</span>")
		user << "<span class='notice'>You are settting [src] internals.</span>"
		if (!do_after(user, 2 SECONDS, act_target = src))
			return
		visible_message("<span class='warning'>[user] have set [src] internals.</span>")
		user << "<span class='notice'>You set [src] internals.</span>"
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
		visible_message("<span class='warning'>[user] is removing [internal_tank] from [src].</span>")
		user << "<span class='notice'>You are removing [internal_tank] from [src].</span>"
		if (!do_after(user, 2 SECONDS, act_target = src))
			return
		visible_message("<span class='warning'>[user] have removed [internal_tank] from [src].</span>")
		user << "<span class='notice'>You removed [internal_tank] from [src].</span>"
		for(var/obj/I in src)
			I.forceMove(user.loc)
		use_internal_tank = 0
		internal_tank = null
		update_icon()
		STOP_PROCESSING(SSfast_process, src)
	else
		visible_message("<span class='warning'>[src] already has no tank.</span>")

/obj/structure/closet/airbubble/attackby(W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/tank))
		if(!use_internal_tank)
			visible_message("<span class='warning'>[user] is attaching [W] to [src].</span>")
			user << "<span class='notice'>You are attaching [W] to [src].</span>"
			if (!do_after(user, 2 SECONDS, act_target = src))
				return
			visible_message("<span class='warning'>[user] have attached [W] to [src].</span>")
			user << "<span class='notice'>You attached [W] to [src].</span>"
			var/obj/item/weapon/tank/T = W
			internal_tank = T
			user.drop_from_inventory(T)
			T.forceMove(src)
			use_internal_tank = 1
			START_PROCESSING(SSfast_process, src)
		else
			user.visible_message("<span class='warning'>[src] already has a tank attached.</span>")
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
		visible_message("<span class='warning'>[user] begins putting cable restrains on zipper of [src].</span>")
		user << "<span class='notice'>You begin putting cable restrains on zipper of [src].</span>"
		playsound(loc, 'sound/weapons/cablecuff.ogg', 50, 1)
		if (!do_after(user, 3 SECONDS, act_target = src, extra_checks = CALLBACK(src, .proc/is_closed)))
			return
		zipped = !zipped
		update_icon()
		user.visible_message("<span class='warning'>[src]'s zipper has been zipped by [user].</span>")
		user << "<span class='notice'>You put restrains on [src]'s zipper.</span>"

		qdel(W)
		update_icon()
	else if(istype(W, /obj/item/weapon/wirecutters))
		visible_message("<span class='warning'>[user] begins cutting cable restrains on zipper of [src].</span>")
		user << "<span class='notice'>You begin cutting cable restrains on zipper of [src].</span>"
		playsound(loc, 'sound/items/Wirecutter.ogg', 50, 1)
		if (!do_after(user, 3 SECONDS, act_target = src, extra_checks = CALLBACK(src, .proc/is_closed)))
			return
		zipped = !zipped
		update_icon()
		visible_message("<span class='warning'>[src] zipper's cable restrains have been cut by [user].</span>")
		user << "<span class='notice'>You cut cable restrains on [src]'s zipper.</span>"
		new/obj/item/weapon/handcuffs/cable(src.loc)
		update_icon()
	else
		attack_hand(user)
	return

/obj/structure/closet/airbubble/store_mobs(var/stored_units)
	contains_body = ..()
	return contains_body

/obj/structure/closet/airbubble/update_icon()
	cut_overlays()
	if(opened)
		icon_state = icon_opened
	else if(ripped)
		name = "ripped air bubble"
		icon_state = "[icon_state]_ripped"
		add_overlay("[icon_closed]_restrained")
	else
		icon_state = icon_closed
		if(zipped)
			add_overlay("[icon_state]_restrained")


/obj/structure/closet/airbubble/proc/process_tank_give_air()
	if(internal_tank && !ripped)
		var/datum/gas_mixture/tank_air = internal_tank.return_air()

		var/release_pressure = internal_tank_valve
		if(ripped)
			inside_air = get_turf_air()
			visible_message("<span class='warning'>You hear air howling from [src]'s hole. Maybe it is good to shut off valve on the internals tank?</span>")
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
			bag.icon_state = "[icon_state]_man_folded"
			bag.desc = "Special air bubble designed to protect people inside of it from decompressed enviroments.This does not seem like a regular color scheme. It appears to be poorly hand folded."
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

/obj/structure/closet/airbubble/syndie/update_icon()
	cut_overlays()
	if(opened)
		icon_state = icon_opened
	else if(ripped)
		name = "ripped air bubble"
		icon_state = "[icon_state]_ripped"
		add_overlay("[icon_closed]_restrained")
	else
		icon_state = icon_closed
		if(zipped)
			add_overlay("[icon_state]_restrained")