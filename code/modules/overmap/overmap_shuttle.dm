/datum/shuttle/autodock/overmap
	warmup_time = 10

	var/range = 0	//how many overmap tiles can shuttle go, for picking destinations and returning.
	var/fuel_consumption = 0 //Amount of moles of gas consumed per trip; If zero, then shuttle is magic and does not need fuel
	var/list/obj/structure/fuel_port/fuel_ports //the fuel ports of the shuttle (but usually just one)

	category = /datum/shuttle/autodock/overmap

/datum/shuttle/autodock/overmap/New(var/_name, var/obj/effect/shuttle_landmark/start_waypoint)
	..(_name, start_waypoint)
	refresh_fuel_ports_list()
	for(var/area/A in shuttle_area) //If shuttles initialize after the blueprints, they won't set correctly so we do it here.
		var/obj/item/blueprints/shuttle/blueprints = locate() in A
		if(blueprints)
			blueprints.set_valid_z_levels()

/datum/shuttle/autodock/overmap/proc/refresh_fuel_ports_list() //loop through all
	fuel_ports = list()
	for(var/area/A in shuttle_area)
		for(var/obj/structure/fuel_port/fuel_port_in_area in A)
			fuel_port_in_area.parent_shuttle = src
			fuel_ports |= fuel_port_in_area

/datum/shuttle/autodock/overmap/fuel_check(var/check_only = FALSE) // "check_only" lets you check the fuel levels without using any.
	if(!src.try_consume_fuel(check_only)) //insufficient fuel
		for(var/area/A in shuttle_area)
			for(var/mob/living/M in A)
				M.show_message(SPAN_WARNING("You hear the shuttle engines sputter... perhaps it doesn't have enough fuel?"), 2,
								SPAN_WARNING("The shuttle shakes but fails to take off."), 1)
				return 0 //failure!
	return 1 //sucess, continue with launch

/datum/shuttle/autodock/overmap/proc/can_go()
	if(!next_location)
		return FALSE
	if(moving_status == SHUTTLE_INTRANSIT)
		return FALSE //already going somewhere, current_location may be an intransit location instead of in a sector
	return get_dist(waypoint_sector(current_location), waypoint_sector(next_location)) <= range

/datum/shuttle/autodock/overmap/can_launch()
	return ..() && can_go()

/datum/shuttle/autodock/overmap/can_force()
	return ..() && can_go()

/datum/shuttle/autodock/overmap/get_travel_time()
	var/distance_mod = get_dist(waypoint_sector(current_location),waypoint_sector(next_location))
	return move_time * (1 + distance_mod)

/datum/shuttle/autodock/overmap/proc/set_destination(var/obj/effect/shuttle_landmark/A)
	if(A != current_location)
		next_location = A

/datum/shuttle/autodock/overmap/proc/get_possible_destinations()
	var/list/res = list()
	for (var/obj/effect/overmap/visitable/S in range(get_turf(waypoint_sector(current_location)), range))
		var/list/waypoints = S.get_waypoints(name)
		for(var/obj/effect/shuttle_landmark/LZ in waypoints)
			if(LZ.is_valid(src))
				res["[waypoints[LZ]] - [LZ.name]"] = LZ
	return res

/datum/shuttle/autodock/overmap/get_location_name()
	if(moving_status == SHUTTLE_INTRANSIT)
		return "In transit"
	return "[waypoint_sector(current_location)] - [current_location]"

/datum/shuttle/autodock/overmap/get_destination_name()
	if(!next_location)
		return "None"
	return "[waypoint_sector(next_location)] - [next_location]"

/datum/shuttle/autodock/overmap/proc/try_consume_fuel(var/check_only = FALSE) //returns 1 if sucessful, returns 0 if error (like insufficient fuel)
	if(!fuel_consumption)
		return 1 //shuttles with zero fuel consumption are magic and can always launch
	if(!fuel_ports.len)
		return 0 //Nowhere to get fuel from
	var/list/obj/item/tank/fuel_tanks = list()
	for(var/obj/structure/FP in fuel_ports) //loop through fuel ports and assemble list of all fuel tanks
		var/obj/item/tank/FT = locate() in FP
		if(FT)
			fuel_tanks += FT
	if(!fuel_tanks.len)
		return 0 //can't launch if you have no fuel TANKS in the ports
	var/total_flammable_gas_moles = 0
	for(var/obj/item/tank/FT in fuel_tanks)
		total_flammable_gas_moles += FT.air_contents.get_by_flag(XGM_GAS_FUEL)
	if(total_flammable_gas_moles < fuel_consumption) //not enough fuel
		return 0
	// We are going to succeed if we got to here, so start consuming that fuel
	var/fuel_to_consume = fuel_consumption
	for(var/obj/item/tank/FT in fuel_tanks) //loop through tanks, consume their fuel one by one
		var/fuel_available = FT.air_contents.get_by_flag(XGM_GAS_FUEL)
		if(!fuel_available) // Didn't even have fuel.
			continue
		if(check_only)
			return 1
		if(fuel_available >= fuel_to_consume)
			FT.remove_air_by_flag(XGM_GAS_FUEL, fuel_to_consume)
			return 1 //ALL REQUIRED FUEL HAS BEEN CONSUMED, GO FOR LAUNCH!
		else //this tank doesn't have enough to launch shuttle by itself, so remove all its fuel, then continue loop
			fuel_to_consume -= fuel_available
			FT.remove_air_by_flag(XGM_GAS_FUEL, fuel_available)

/datum/shuttle/autodock/overmap/on_move_interim()
	..()
	for(var/obj/machinery/computer/shuttle_control/explore/E in shuttle_computers)
		var/obj/effect/overmap/visitable/ship/S = E.connected
		if(S)
			S.halt()
			S.unhalt()

#define FUEL_PORT_UNSECURED 0
#define FUEL_PORT_BOLTED	1
#define FUEL_PORT_WELDED	2

/obj/structure/fuel_port //empty
	name = "fuel port"
	desc = "The fuel input port of the shuttle. Holds one fuel tank. Use a crowbar to open and close it."
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "fuel_port"
	density = 0
	anchored = 1
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	var/state = FUEL_PORT_WELDED
	var/icon_closed = "fuel_port"
	var/icon_empty = "fuel_port_empty"
	var/icon_full = "fuel_port_full"
	var/opened = 0
	var/parent_shuttle
	var/port_item_path = /obj/item/fuel_port

/obj/structure/fuel_port/assembly_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "The fuel port must be wrenched and welded in place before it can be loaded and used by the shuttle."

/obj/structure/fuel_port/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	switch(state)
		if(FUEL_PORT_UNSECURED)
			. += SPAN_NOTICE("\The [src] is in place, but not attached to anything.")
		if(FUEL_PORT_BOLTED)
			. += SPAN_NOTICE("\The [src]'s external reinforcing bolts are deployed and locked.")
		if(FUEL_PORT_WELDED)
			. += SPAN_NOTICE("\The [src] is bolted and welded in place.")

/obj/structure/fuel_port/Initialize(mapload, var/placement_dir, var/constructed)
	. = ..()
	switch(placement_dir)
		if(NORTH)
			pixel_y = 32
		if(SOUTH)
			pixel_y = -32
		if(EAST)
			pixel_x = 32
		if(WEST)
			pixel_x = -32
	if(constructed)
		state = FUEL_PORT_UNSECURED
	update_shuttle()

/obj/structure/fuel_port/New(loc, var/placement_dir, var/constructed = FALSE)
	. = ..()

/obj/structure/fuel_port/Destroy()
	update_shuttle()
	return ..()

/obj/structure/fuel_port/attack_hand(mob/user)
	if(state == FUEL_PORT_UNSECURED)
		to_chat(user, SPAN_NOTICE("You remove \the [src] from its position."))
		var/obj/item/fuel_port/P = new port_item_path(user.loc)
		user.put_in_active_hand(P)
		qdel(src)
	else if(!opened)
		to_chat(user, SPAN_WARNING("\The [src] is secured tightly. You'll need to pry it open with a crowbar."))
		return
	else if(contents.len > 0)
		user.put_in_hands(contents[1])
	update_icon()

/obj/structure/fuel_port/update_icon()
	. = ..()
	if(opened)
		if(contents.len > 0)
			icon_state = icon_full
		else
			icon_state = icon_empty
	else
		icon_state = icon_closed

/obj/structure/fuel_port/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.iscrowbar())
		if(state != FUEL_PORT_WELDED)
			to_chat(user, SPAN_WARNING("\The [src] must be bolted and welded in place before it can be opened!"))
			return
		else if(opened)
			to_chat(user, SPAN_NOTICE("You close \the [src]."))
			playsound(src.loc, 'sound/effects/closet_close.ogg', 25, 0, -3)
			opened = 0
		else
			to_chat(user, SPAN_NOTICE("You pry \the [src] open."))
			playsound(src.loc, 'sound/effects/closet_open.ogg', 15, 1, -3)
			opened = 1
	else if(istype(attacking_item, /obj/item/tank))
		if(state != FUEL_PORT_WELDED)
			to_chat(user, SPAN_WARNING("\The [src] must be welded in place before a new tank can be added!"))
			return
		if(!opened)
			to_chat(user, SPAN_NOTICE("\The [src] isn't open!"))
			return
		if(contents.len == 0)
			user.unEquip(attacking_item, TRUE, src)
	else if(attacking_item.iswrench())
		switch(state)
			if(FUEL_PORT_WELDED)
				to_chat(user, SPAN_WARNING("\The [src] is welded in place!"))
				return
			if(FUEL_PORT_BOLTED)
				attacking_item.play_tool_sound(get_turf(src), 75)
				user.visible_message(SPAN_NOTICE("\The [user] unsecures \the [src]'s reinforcing bolts from the wall."), \
					SPAN_NOTICE("You undo \the [src]'s external reinforcing bolts."), \
					SPAN_WARNING("You hear a ratcheting noise."))
				state = FUEL_PORT_UNSECURED
			if(FUEL_PORT_UNSECURED)
				attacking_item.play_tool_sound(get_turf(src), 75)
				user.visible_message(SPAN_NOTICE("\The [user] secures \the [src] to the wall."), \
					SPAN_NOTICE("You secure \the [src]'s external reinforcing bolts."), \
					SPAN_WARNING("You hear a ratcheting noise."))
				state = FUEL_PORT_BOLTED
	else if(attacking_item.iswelder())
		var/obj/item/weldingtool/WT = attacking_item
		switch(state)
			if(FUEL_PORT_UNSECURED)
				to_chat(user, SPAN_WARNING("\The [src]'s external reinforcing bolts must be secured!"))
				return
			if(FUEL_PORT_BOLTED)
				if(WT.use(5, user))
					playsound(get_turf(src), 'sound/items/welder_pry.ogg', 50, TRUE)
					user.visible_message(SPAN_NOTICE("\The [user] starts to weld \the [src] to the wall."), \
						SPAN_NOTICE("You start to weld \the [src] to the wall."), \
						SPAN_WARNING("You hear the sound of metal being welded."))
					if(attacking_item.use_tool(src, user, 20, volume = 50))
						if(!src || !WT.isOn())
							return
						state = FUEL_PORT_WELDED
						to_chat(user, SPAN_NOTICE("You weld \the [src] to the wall."))
				else
					to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
			if(FUEL_PORT_WELDED)
				if(contents.len > 0)
					to_chat(user, SPAN_WARNING("\The [src] cannot be detached with a tank inside!"))
					return
				if(WT.use(0, user))
					playsound(get_turf(src), 'sound/items/welder_pry.ogg', 50, TRUE)
					user.visible_message(SPAN_NOTICE("\The [user] starts to cut \the [src] free from the wall."), \
						SPAN_NOTICE("You start to cut \the [src] free from the wall."), \
						SPAN_WARNING("You hear the sound of metal being welded."))
					if(attacking_item.use_tool(src, user, 20, volume = 50))
						if(!src || !WT.isOn())
							return
						state = FUEL_PORT_BOLTED
						to_chat(user, SPAN_NOTICE("You cut \the [src] free from the wall."))
				else
					to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
	update_icon()

/obj/structure/fuel_port/proc/update_shuttle()
	var/area/A = get_area(src)
	if(A in SSshuttle.shuttle_areas) //Check if we're in a shuttle and refresh its fuel ports
		for(var/shuttle_tag in SSshuttle.shuttles)
			var/datum/shuttle/autodock/overmap/S = SSshuttle.shuttles[shuttle_tag]
			if(istype(S) && (A in S.shuttle_area))
				S.refresh_fuel_ports_list()

// Walls hide stuff inside them, but we want to be visible.
/obj/structure/fuel_port/hide()
	return

/obj/structure/fuel_port/phoron // The best and most expensive fuel. Likely to be in the hands of corporate forces, though the well-off along with military forces throughout the Spur also have a good chance of using it.

/obj/structure/fuel_port/phoron/scc
	icon = 'icons/obj/spaceship/scc/ship_engine.dmi'

/obj/structure/fuel_port/phoron/Initialize()
	. = ..()
	new /obj/item/tank/phoron/shuttle(src)

/obj/structure/fuel_port/hydrogen // The most common and serviceable fuel for a shuttle. It's not as good as phoron, but it will still get you places. It's also not scarce! Used by practically everyone.

/obj/structure/fuel_port/hydrogen/Initialize()
	. = ..()
	new /obj/item/tank/hydrogen/shuttle(src)

/obj/item/fuel_port
	name = "fuel port"
	desc = "The fuel input port of the shuttle. Must be attached to a wall."
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "fuel_port"
	item_state = "fuel_port"
	var/port_path = /obj/structure/fuel_port

/obj/item/fuel_port/afterattack(atom/A, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return
	if(use_check_and_message(user))
		return
	if(!iswall(A) || !isturf(user.loc))
		to_chat(user, SPAN_WARNING("You can't place this here!"))
		return
	if(get_area(A) != get_area(user)) //To make sure that we don't get fuel ports attached outside the shuttle area, etc
		to_chat(user, SPAN_WARNING("You must be in the same area as the target location to attach \the [src]!"))
		return
	var/placement_dir = get_dir(user, A)
	if (!(placement_dir in GLOB.cardinals))
		to_chat(user, SPAN_WARNING("You must stand directly in front of the location you wish to place that on."))
		return

	user.visible_message(SPAN_NOTICE("\The [user] fastens \the [src] to \the [A]."), SPAN_NOTICE("You fasten \the [src] to \the [A]."))
	user.drop_from_inventory(src)
	new port_path(user.loc, placement_dir, TRUE)
	qdel(src)

#undef FUEL_PORT_UNSECURED
#undef FUEL_PORT_BOLTED
#undef FUEL_PORT_WELDED
#undef waypoint_sector
