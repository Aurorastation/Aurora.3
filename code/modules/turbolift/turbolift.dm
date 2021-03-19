// Lift master datum. One per turbolift.
// The turbolift datum handles receives the "calls" and uses the controller to determine if a specific call is valid
// If a specific "call" is valid, then the actions associated with that call are performed
/datum/turbolift
	var/area/turbolift/target_floor                     // Where are we going?
	var/area/turbolift/current_floor                    // Where is the lift currently?
	var/list/doors = list()                             // Doors inside the lift structure.
	var/list/lights = list()                            // Lights inside the lift structure.
	var/list/queued_floors = list()                     // Where are we moving to next?
	var/list/floors = list()                            // All floors in this system.
	var/move_delay = 15                                 // Time between floor changes.
	var/floor_wait_delay = 95                           // Time to wait at floor stops.
	var/obj/structure/lift/panel/control_panel_interior // Lift control panel.
	var/obj/machinery/turbolift_controller/controller   // Controller of the Turbolift
	var/doors_closing = 0								// Whether doors are in the process of closing
	var/controller_link_id

	var/tmp/moving_upwards
	var/tmp/busy

	var/move_timer


//These are the calls the requests the lift receives from various io devices.
/datum/turbolift/proc/register_hallcall(var/mob/user, var/obj/structure/lift/button/B)
	if(!controller.can_hallcall(user,B))
		return
	B.light_up()
	if(B.floor == current_floor)
		open_doors()
		addtimer(CALLBACK(B, /obj/structure/lift/button/.proc/reset), 3)
		return
	queue_move_to(B.floor)

/datum/turbolift/proc/register_cabincall_floor(var/mob/user, var/obj/structure/lift/panel/P, var/area/turbolift/destination)
	if(controller && !controller.can_cabincall(user,P,destination))
		return
	queue_move_to(destination)

/datum/turbolift/proc/register_cabincall_open_doors(var/mob/user, var/obj/structure/lift/panel/P)
	if(controller && !controller.can_cabin_dooropen(user,P))
		return
	open_doors()

/datum/turbolift/proc/register_cabincall_close_doors(var/mob/user, var/obj/structure/lift/panel/P)
	if(controller && !controller.can_cabin_doorclose(user,P))
		return
	close_doors()

/datum/turbolift/proc/register_cabincall_estop(var/mob/user, var/obj/structure/lift/panel/P)
	if(controller && !controller.can_estop(user,P))
		return
	emergency_stop()


//These are the actual actions the lift performs
/datum/turbolift/proc/emergency_stop()
	deltimer(move_timer)
	move_timer = null
	queued_floors.Cut()
	target_floor = null
	open_doors()

/datum/turbolift/proc/doors_are_open(var/area/turbolift/use_floor = current_floor)
	for(var/obj/machinery/door/airlock/door in (use_floor ? (doors + use_floor.doors) : doors))
		if(!door.density)
			return 1
	return 0

/datum/turbolift/proc/open_doors(var/area/turbolift/use_floor = current_floor)
	if(controller && !controller.shoud_opendoors())
		return
	for(var/obj/machinery/door/airlock/door in (use_floor ? (doors + use_floor.doors) : doors))
		door.command("open")

/datum/turbolift/proc/close_doors(var/area/turbolift/use_floor = current_floor)
	if(controller && !controller.should_closedoors())
		return
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

	var/doors_open = doors_are_open()
	if(doors_open && !doors_closing)
		close_doors()
		doors_closing = 1
		queue_movement(move_delay / 2)
		return 1
	else if(doors_open && doors_closing && (controller && controller.should_closedoors())) // We failed to close the doors - probably, someone is blocking them; stop trying to move
		doors_closing = 0
		open_doors()
		control_panel_interior.audible_message("\The [current_floor.ext_panel] buzzes loudly.")
		playsound(control_panel_interior.loc, "sound/machines/buzz-two.ogg", 50, 1)
		return 0

	doors_closing = 0 // The doors weren't open, so they are done closing

	if(target_floor == current_floor)
		playsound(control_panel_interior.loc, current_floor.arrival_sound, 50, 1)
		target_floor.arrived(src)
		target_floor = null

		sleep(15)
		control_panel_interior.visible_message("<b>The elevator</b> announces, \"[current_floor.lift_announce_str]\"")

		queue_movement(floor_wait_delay + move_delay)
		return 1

	// Work out where we're headed.
	var/area/turbolift/next_floor
	if(moving_upwards)
		next_floor = floors[current_floor_index + 1]
	else
		next_floor = floors[current_floor_index - 1]

	if(!istype(current_floor) || !istype(next_floor) || (current_floor == next_floor))
		return 0

	var/list/move_candidates = list()
	if(!moving_upwards)
		for(var/turf/T in next_floor)
			for(var/atom/movable/AM in T)
				AM.crush_act()
	else
		for(var/turf/simulated/wall/W in current_floor)
			var/turf/T = GET_ABOVE(W)
			for(var/atom/movable/AM in T)
				if(next_floor == floors[floors.len])
					AM.crush_act()
				else
					move_candidates += AM

	current_floor.move_contents_to(next_floor)
	for(var/thing in move_candidates)
		var/atom/movable/AM = thing
		AM.forceMove(GET_ABOVE(AM))

	current_floor = next_floor
	control_panel_interior.visible_message("The elevator [moving_upwards ? "rises" : "descends"] smoothly.")

	queue_movement()
	return 1

/datum/turbolift/proc/queue_move_to(var/area/turbolift/floor)
	if(!floor || !(floor in floors) || (floor in queued_floors))
		return // STOP PRESSING THE BUTTON.
	floor.pending_move(src)
	queued_floors |= floor
	queue_movement()
	return TRUE

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
