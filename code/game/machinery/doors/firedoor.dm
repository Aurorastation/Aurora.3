#define FIREDOOR_MAX_PRESSURE_DIFF 25 // kPa
#define FIREDOOR_MAX_TEMP 50 // °C
#define FIREDOOR_MIN_TEMP 0

// Bitflags
#define FIREDOOR_ALERT_HOT      1
#define FIREDOOR_ALERT_COLD     2

/obj/machinery/door/firedoor
	name = "emergency shutter"
	desc = "An airtight emergency shutter designed to seal off areas from hostile environments. It flashes a warning light if it detects an environmental hazard on any side."
	icon = 'icons/obj/doors/basic/single/emergency/firedoor.dmi'
	icon_state = "door_open"
	req_one_access = list(access_atmospherics, access_engine_equip, access_first_responder)
	opacity = 0
	density = 0
	layer = LAYER_UNDER_TABLE
	open_layer = LAYER_UNDER_TABLE // Just below doors when open
	closed_layer = DOOR_CLOSED_LAYER + 0.2 // Just above doors when closed

	//These are frequenly used with windows, so make sure zones can pass.
	//Generally if a firedoor is at a place where there should be a zone boundery then there will be a regular door underneath it.
	block_air_zones = 0
	hashatch = 1

	var/blocked = 0
	var/lockdown = 0 // When the door has detected a problem, it locks.
	var/pdiff_alert = 0
	var/pdiff = 0
	var/nextstate = null
	var/net_id
	var/list/areas_added
	var/list/users_to_open = new
	var/next_process_time = 0

	var/hatch_open = 0

	power_channel = ENVIRON
	idle_power_usage = 5
	dir = SOUTH

	turf_hand_priority = 2 //Lower priority than normal doors to prevent interference

	/// Enables smart generation of firedoor dir.
	/// So it automatically aligns to face same dir as the door above it, etc.
	var/enable_smart_generation = TRUE

	var/list/tile_info[4]
	var/list/dir_alerts[4] // 4 dirs, bitflags

	// MUST be in same order as FIREDOOR_ALERT_*
	var/list/ALERT_STATES=list(
		"hot",
		"cold"
	)

	var/open_sound = 'sound/machines/firelockopen.ogg'
	var/close_sound = 'sound/machines/firelockclose.ogg'

	init_flags = 0

/obj/machinery/door/firedoor/Initialize(var/mapload)
	. = ..()
	for(var/obj/machinery/door/firedoor/F in loc)
		if(F != src)
			crash_with("Duplicate firedoors at [x]-[y]-[z]. Deleting one.")
			QDEL_IN(src, 1)
			return .
	var/area/A = get_area(src)
	ASSERT(istype(A))

	A.all_doors.Add(src)
	areas_added = list(A)

	if(!mapload)
		enable_smart_generation = 0

	for(var/direction in cardinal)
		var/turf/T = get_step(src,direction)
		A = get_area(T)
		if(istype(A) && !(A in areas_added))
			A.all_doors.Add(src)
			areas_added += A

	smart_generation()

/obj/machinery/door/firedoor/proc/smart_generation()
	if(!enable_smart_generation)
		return .

	var/turf/current_turf = get_turf(src)
	if(locate(/obj/structure/grille, current_turf))
		hashatch = 0

	// if there is adjacent wall
	if(istype(get_step(src,NORTH), /turf/simulated/wall))
		dir = EAST
		return .
	if(istype(get_step(src,SOUTH), /turf/simulated/wall))
		dir = WEST
		return .
	if(istype(get_step(src,WEST), /turf/simulated/wall))
		dir = NORTH
		return .
	if(istype(get_step(src,EAST), /turf/simulated/wall))
		dir = SOUTH
		return .

	// if there is adjacent firedoor
	if(locate(/obj/machinery/door/firedoor, get_step(src,NORTH)))
		dir = EAST
		return .
	if(locate(/obj/machinery/door/firedoor, get_step(src,SOUTH)))
		dir = WEST
		return .
	if(locate(/obj/machinery/door/firedoor, get_step(src,WEST)))
		dir = NORTH
		return .
	if(locate(/obj/machinery/door/firedoor, get_step(src,EAST)))
		dir = SOUTH
		return .

	// face same dir as door if on the same tile
	var/obj/machinery/door/airlock/door = locate(/obj/machinery/door/airlock, current_turf)
	if(istype(door))
		dir = door.dir
		return .

/obj/machinery/door/firedoor/Destroy()
	for(var/area/A in areas_added)
		A.all_doors.Remove(src)
	. = ..()

/obj/machinery/door/firedoor/attack_generic(var/mob/user, var/damage)
	if(stat & (BROKEN|NOPOWER))
		if(damage >= 10)
			if(src.density)
				visible_message("<span class='danger'>\The [user] forces \the [src] open!</span>")
				open(1)
			else
				visible_message("<span class='danger'>\The [user] forces \the [src] closed!</span>")
				close(1)
		else
			visible_message("<span class='notice'>\The [user] strains fruitlessly to force \the [src] [density ? "open" : "closed"].</span>")
		return
	..()

/obj/machinery/door/firedoor/get_material()
	return SSmaterials.get_material_by_name(DEFAULT_WALL_MATERIAL)

/obj/machinery/door/firedoor/examine(mob/user, distance, is_adjacent)
	. = ..()
	if(!is_adjacent || !density)
		return

	if(pdiff >= FIREDOOR_MAX_PRESSURE_DIFF)
		to_chat(user, SPAN_DANGER("Current pressure differential is [pdiff] kPa. Opening door will likely result in injury."))

	to_chat(user, "<b>Sensor readings:</b>")
	for(var/index = 1; index <= tile_info.len; index++)
		var/o = "&nbsp;&nbsp;"
		switch(index)
			if(1)
				o += "NORTH: "
			if(2)
				o += "SOUTH: "
			if(3)
				o += "EAST: "
			if(4)
				o += "WEST: "
		if(tile_info[index] == null)
			o += "<span class='warning'>DATA UNAVAILABLE</span>"
			to_chat(user, o)
			continue
		var/celsius = convert_k2c(tile_info[index][1])
		var/pressure = tile_info[index][2]
		o += "<span class='[(dir_alerts[index] & (FIREDOOR_ALERT_HOT|FIREDOOR_ALERT_COLD)) ? "danger" : "color:blue"]'>"
		o += "[celsius]&deg;C</span> "
		o += "<span style='color:blue'>"
		o += "[pressure]kPa</span></li>"
		to_chat(user, o)

	if(islist(users_to_open) && users_to_open.len)
		var/users_to_open_string = users_to_open[1]
		if(users_to_open.len >= 2)
			for(var/i = 2 to users_to_open.len)
				users_to_open_string += ", [users_to_open[i]]"
		to_chat(user, "These people have opened \the [src] during an alert: [users_to_open_string].")

/obj/machinery/door/firedoor/CollidedWith(atom/AM)
	if(p_open || operating)
		return
	if(!density)
		return ..()
	return 0

/obj/machinery/door/firedoor/attack_hand(mob/user as mob)
	add_fingerprint(user)
	if(operating)
		return//Already doing something.

	if(blocked)
		to_chat(user, "<span class='warning'>\The [src] is welded solid!</span>")
		return

	var/alarmed = lockdown
	for(var/area/A in areas_added)		//Checks if there are fire alarms in any areas associated with that firedoor
		if(A.fire || A.air_doors_activated)
			alarmed = 1
	if(user.incapacitated() || (get_dist(src, user) > 1  && !issilicon(user)))
		return

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(H) || H.default_attack?.crowbar_door)
			if(src.density)
				visible_message("<span class='danger'>\The [H] forces \the [src] open!</span>")
				open(1)
			else
				visible_message("<span class='danger'>\The [H] forces \the [src] closed!</span>")
				close(1)
			return

	if(density && (stat & (BROKEN|NOPOWER))) //can still close without power
		to_chat(user, "\The [src] is not functioning, you'll have to force it open manually.")
		return

	if(alarmed && density && lockdown && !allowed(user))
		to_chat(user, "<span class='warning'>Access denied.  Please wait for authorities to arrive, or for the alert to clear.</span>")
		return
	else if(Adjacent(user))
		user.visible_message("[user] [density ? "open" : "close"]s \an [src].",\
		"You [density ? "open" : "close"] \the [src].",\
		"You hear a beep, and a door opening.")

	var/needs_to_close = 0
	if(density)
		if(alarmed)
			// Accountability!
			users_to_open |= user.name
			needs_to_close = !issilicon(user)

		open()
	else
		close()

	if(needs_to_close)
		addtimer(CALLBACK(src, PROC_REF(do_close)), 50)

/obj/machinery/door/firedoor/proc/do_close()
	var/alarmed = FALSE
	for (var/thing in areas_added)
		var/area/A = thing
		if (A.fire || A.air_doors_activated)
			alarmed = TRUE
			break

	if (alarmed)
		nextstate = FIREDOOR_CLOSED
		close()

/obj/machinery/door/firedoor/attackby(obj/item/C as obj, mob/user as mob)
	if(!istype(C, /obj/item/forensics))
		add_fingerprint(user)
	if(operating)
		return TRUE // Already doing something.
	if(C.iswelder() && !repairing)
		var/obj/item/weldingtool/WT = C
		if(WT.isOn())
			user.visible_message(
				SPAN_WARNING("[user] begins welding [src] [blocked ? "open" : "shut"]."),
				SPAN_NOTICE("You begin welding [src] [blocked ? "open" : "shut"]."),
				SPAN_ITALIC("You hear a welding torch on metal.")
			)
			playsound(src, 'sound/items/Welder.ogg', 50, 1)
			if(!WT.use_tool(src, user, 20, volume = 50, extra_checks = CALLBACK(src, PROC_REF(is_open), src.density)))
				return
			if(!WT.use(0,user))
				to_chat(user, SPAN_NOTICE("You need more welding fuel to complete this task."))
				return TRUE
			playsound(src, 'sound/items/welder_pry.ogg', 50, 1)
			blocked = !blocked
			update_icon()
		return TRUE
	if(density && C.isscrewdriver())
		hatch_open = !hatch_open
		user.visible_message("<span class='danger'>[user] has [hatch_open ? "opened" : "closed"] \the [src] maintenance panel.</span>",
									"You have [hatch_open ? "opened" : "closed"] the [src] maintenance panel.")
		update_icon()
		return TRUE

	if(blocked && C.iscrowbar() && !repairing)
		if(!hatch_open)
			to_chat(user, "<span class='danger'>You must open the maintenance panel first!</span>")
		else
			user.visible_message("<span class='danger'>[user] is removing the electronics from \the [src].</span>",
									"You start to remove the electronics from [src].")
			if(C.use_tool(src, user, 30, volume = 50))
				if(blocked && density && hatch_open)
					user.visible_message("<span class='danger'>[user] has removed the electronics from \the [src].</span>",
										"You have removed the electronics from [src].")

					if (stat & BROKEN)
						new /obj/item/trash/broken_electronics(src.loc)
					else
						new/obj/item/airalarm_electronics(src.loc)

					var/obj/structure/firedoor_assembly/FA = new/obj/structure/firedoor_assembly(src.loc)
					FA.anchored = 1
					FA.density = 1
					FA.wired = 1
					FA.update_icon()
					qdel(src)
		return TRUE

	if(blocked)
		to_chat(user, "<span class='danger'>\The [src] is welded shut!</span>")
		return TRUE

	if(C.iscrowbar() || istype(C,/obj/item/material/twohanded/fireaxe) || C.ishammer())
		if(operating)
			return TRUE

		if(blocked && C.iscrowbar())
			user.visible_message("<span class='danger'>\The [user] pries at \the [src] with \a [C], but \the [src] is welded in place!</span>",\
			"You try to pry \the [src] [density ? "open" : "closed"], but it is welded in place!",\
			"You hear someone struggle and metal straining.")
			return TRUE

		if(istype(C,/obj/item/material/twohanded/fireaxe))
			var/obj/item/material/twohanded/fireaxe/F = C
			if(!F.wielded)
				return TRUE

		user.visible_message("<span class='danger'>\The [user] starts to force \the [src] [density ? "open" : "closed"] with \a [C]!</span>",\
				"You start forcing \the [src] [density ? "open" : "closed"] with \the [C]!",\
				"You hear metal strain.")
		if(C.use_tool(src, user, 30, volume = 50))
			if(C.iscrowbar() || C.ishammer())
				if(stat & (BROKEN|NOPOWER) || !density)
					user.visible_message("<span class='danger'>\The [user] forces \the [src] [density ? "open" : "closed"] with \a [C]!</span>",\
					"You force \the [src] [density ? "open" : "closed"] with \the [C]!",\
					"You hear metal strain, and a door [density ? "open" : "close"].")
			else
				user.visible_message("<span class='danger'>\The [user] forces \the [ blocked ? "welded" : "" ] [src] [density ? "open" : "closed"] with \a [C]!</span>",\
					"You force \the [ blocked ? "welded" : "" ] [src] [density ? "open" : "closed"] with \the [C]!",\
					"You hear metal strain and groan, and a door [density ? "opening" : "closing"].")
			if(density)
				open(1, user)
			else
				close()
			return TRUE

	return ..()

// CHECK PRESSURE
/obj/machinery/door/firedoor/process()
	if(density && next_process_time <= world.time)
		next_process_time = world.time + 100		// 10 second delays between process updates
		var/changed = 0
		lockdown=0
		// Pressure alerts
		pdiff = getOPressureDifferential(src.loc)
		pdiff = QUANTIZE(pdiff)	// Hello, sanity.
		if(pdiff >= FIREDOOR_MAX_PRESSURE_DIFF)
			lockdown = 1
			if(!pdiff_alert)
				pdiff_alert = 1
				changed = 1 // update_icon()
		else
			if(pdiff_alert)
				pdiff_alert = 0
				changed = 1 // update_icon()

		tile_info = getCardinalAirInfo(src.loc,list("temperature","pressure"))
		var/old_alerts = dir_alerts
		for(var/index = 1; index <= 4; index++)
			var/list/tileinfo=tile_info[index]
			if(tileinfo==null)
				continue // Bad data.
			var/celsius = convert_k2c(tileinfo[1])

			var/alerts = 0

			// Temperatures
			if(celsius >= FIREDOOR_MAX_TEMP)
				alerts |= FIREDOOR_ALERT_HOT
				lockdown = 1
			else if(celsius <= FIREDOOR_MIN_TEMP)
				alerts |= FIREDOOR_ALERT_COLD
				lockdown = 1

			dir_alerts[index]=alerts

		if(dir_alerts != old_alerts)
			changed = 1
		if(changed)
			update_icon()

	else if(!density)
		return PROCESS_KILL

/obj/machinery/door/firedoor/proc/latetoggle()
	if(operating || !nextstate)
		return
	switch(nextstate)
		if(FIREDOOR_OPEN)
			nextstate = null

			open()
		if(FIREDOOR_CLOSED)
			nextstate = null
			close()
	return

/obj/machinery/door/firedoor/can_close()
	if(locate(/obj/effect/blob) in get_turf(src))
		return FALSE
	if(locate(/mob/living) in get_turf(src))
		return FALSE
	return ..()

/obj/machinery/door/firedoor/close()
	if(!can_close())
		return
	cut_overlays()
	latetoggle()
	START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
	return ..()

/obj/machinery/door/firedoor/open(forced = 0, user = usr)
	cut_overlays()
	if(hatch_open)
		hatch_open = 0
		visible_message("The maintenance panel of \the [src] closes.")
		update_icon()

	if(!forced)
		if(stat & (BROKEN|NOPOWER))
			return //needs power to open unless it was forced
		else
			use_power_oneoff(360)
	else
		log_and_message_admins("has forced open an emergency shutter.", user, loc)
	latetoggle()
	return ..()

/obj/machinery/door/firedoor/do_animate(animation)
	compile_overlays()
	switch(animation)
		if("opening")
			flick("door_opening", src)
			playsound(src, open_sound, 37, 1)
		if("closing")
			flick("door_closing", src)
			playsound(src, close_sound, 37, 1)

/obj/machinery/door/firedoor/update_icon()
	cut_overlays()
	set_light(0)
	var/do_set_light = 0

	if(density)
		icon_state = "door_closed"
		if(hatch_open)
			add_overlay("hatch")
		if(blocked)
			add_overlay("welded")
		if(pdiff_alert)
			add_overlay(overlay_image(icon, icon_state = "palert", layer = EFFECTS_ABOVE_LIGHTING_LAYER))
			do_set_light = 1
		if(dir_alerts)
			for (var/d = 1; d <= 4; d++)
				//1 = NORTH
				//2 = SOUTH
				//3 = EAST
				//4 = WEST
				if (!dir_alerts[d])
					continue
				if (dir_alerts[d] & FIREDOOR_ALERT_COLD)
					add_overlay(overlay_image(icon, icon_state = "alert_cold", layer = EFFECTS_ABOVE_LIGHTING_LAYER))
				if (dir_alerts[d] & FIREDOOR_ALERT_HOT)
					add_overlay(overlay_image(icon, icon_state = "alert_hot", layer = EFFECTS_ABOVE_LIGHTING_LAYER))

				do_set_light = TRUE
	else
		icon_state = "door_open"
		if(blocked)
			add_overlay("welded_open")

	if(do_set_light)
		set_light(2, 0.5, COLOR_SUN)

/obj/machinery/door/firedoor/noid
	req_one_access = null

/obj/machinery/door/firedoor/noid/closed
	req_one_access = null
	icon_state = "door_closed"
	density = 1

//These are playing merry hell on ZAS.  Sorry fellas :(

/*/obj/machinery/door/firedoor/border_only


	icon = 'icons/obj/doors/edge_Doorfire.dmi'
	glass = 1 //There is a glass window so you can see through the door
				//This is needed due to BYOND limitations in controlling visibility
	heat_proof = 1
	air_properties_vary_with_direction = 1

	CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
		if(istype(mover) && mover.checkpass(PASSGLASS))
			return 1
		if(get_dir(loc, target) == dir) //Make sure looking at appropriate border
			if(air_group) return 0
			return !density
		else
			return 1

	CheckExit(atom/movable/mover as mob|obj, turf/target as turf)
		if(istype(mover) && mover.checkpass(PASSGLASS))
			return 1
		if(get_dir(loc, target) == dir)
			return !density
		else
			return 1


	update_nearby_tiles(need_rebuild)
		if(!SSair) return 0

		var/turf/simulated/source = loc
		var/turf/simulated/destination = get_step(source,dir)

		update_heat_protection(loc)

		if(istype(source)) SSair.tiles_to_update += source
		if(istype(destination)) SSair.tiles_to_update += destination
		return 1
*/


#undef FIREDOOR_MAX_PRESSURE_DIFF
#undef FIREDOOR_MAX_TEMP
#undef FIREDOOR_MIN_TEMP
#undef FIREDOOR_ALERT_HOT
#undef FIREDOOR_ALERT_COLD
