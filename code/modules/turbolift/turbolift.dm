// Lift master datum. One per turbolift.
/datum/turbolift
	var/datum/turbolift_floor/target_floor              // Where are we going?
	var/datum/turbolift_floor/current_floor             // Where is the lift currently?
	var/list/doors = list()                             // Doors inside the lift structure.
	var/list/queued_floors = list()                     // Where are we moving to next?
	var/list/floors = list()                            // All floors in this system.
	var/move_delay = 45                                 // Time between floor changes.
	var/floor_wait_delay = 95                           // Time to wait at floor stops.
	var/obj/structure/lift/panel/control_panel_interior // Lift control panel.
	var/doors_closing = 0								// Whether doors are in the process of closing

	var/tmp/moving_upwards
	var/tmp/busy

	var/move_timer

/datum/turbolift/proc/emergency_stop()
	deltimer(move_timer)
	move_timer = null
	queued_floors.Cut()
	target_floor = null
	open_doors()

/datum/turbolift/proc/doors_are_open(datum/turbolift_floor/use_floor = current_floor)
	for(var/obj/machinery/door/airlock/door in (use_floor ? (doors + use_floor.doors) : doors))
		if(!door.density)
			return 1
	return 0

/datum/turbolift/proc/open_doors(datum/turbolift_floor/use_floor = current_floor)
	for(var/obj/machinery/door/airlock/door in (use_floor ? (doors + use_floor.doors) : doors))
		door.command("open")

/datum/turbolift/proc/close_doors(datum/turbolift_floor/use_floor = current_floor)
	for(var/obj/machinery/door/airlock/door in (use_floor ? (doors + use_floor.doors) : doors))
		door.command("close")

/datum/turbolift/proc/do_work()
	var/current_floor_index = floors.Find(current_floor)

	if(!target_floor)
		if(!queued_floors || !queued_floors.len)
			return 0

		target_floor = queued_floors[1]
		queued_floors -= target_floor
		if(current_floor_index < floors.Find(target_floor))
			moving_upwards = 1
		else
			moving_upwards = 0

	if(doors_are_open())
		if(!doors_closing)
			close_doors()
			doors_closing = 1
			queue_movement()
			return 1

		else // We failed to close the doors - probably, someone is blocking them; stop trying to move
			doors_closing = 0
			open_doors()
			control_panel_interior.audible_message("\The [current_floor.ext_panel] buzzes loudly.")
			playsound(control_panel_interior.loc, "sound/machines/buzz-two.ogg", 50, 1)
			return 0

	doors_closing = 0 // The doors weren't open, so they are done closing

	var/area/turbolift/origin = locate(current_floor.area_ref) in all_areas

	if(target_floor == current_floor)
		playsound(control_panel_interior.loc, origin.arrival_sound, 50, 1)
		target_floor.arrived(src)
		target_floor = null

		sleep(15)
		control_panel_interior.visible_message("<b>The elevator</b> announces, \"[origin.lift_announce_str]\"")

		queue_movement(floor_wait_delay + move_delay)
		return 1

	// Work out where we're headed.
	var/datum/turbolift_floor/next_floor
	if(moving_upwards)
		next_floor = floors[current_floor_index + 1]
	else
		next_floor = floors[current_floor_index - 1]

	var/area/turbolift/destination = locate(next_floor.area_ref) in all_areas

	if(!istype(origin) || !istype(destination) || (origin == destination))
		return 0

	if (!moving_upwards || next_floor == floors[floors.len])	// If moving down or moving to the top floor, squish.
		for(var/turf/T in destination)
			for(var/atom/movable/AM in T)
				AM.crush_act()

	origin.move_contents_to(destination)

	current_floor = next_floor
	control_panel_interior.visible_message("The elevator [moving_upwards ? "rises" : "descends"] smoothly.")

	queue_movement()
	return 1

/datum/turbolift/proc/queue_move_to(datum/turbolift_floor/floor)
	if(!floor || !(floor in floors) || (floor in queued_floors))
		return // STOP PRESSING THE BUTTON.
	floor.pending_move(src)
	queued_floors |= floor
	queue_movement()

// TODO: dummy machine ('lift mechanism') in powered area for functionality/blackout checks.
/datum/turbolift/proc/is_functional()
	return 1

/datum/turbolift/proc/handle_movement()
	if (!do_work())
		if (target_floor)
			target_floor.ext_panel.reset()
			target_floor = null

/datum/turbolift/proc/queue_movement(delay = move_delay)
	if (!delay)
		delay = move_delay

	move_timer = addtimer(CALLBACK(src, .proc/handle_movement), delay, TIMER_STOPPABLE | TIMER_UNIQUE)
