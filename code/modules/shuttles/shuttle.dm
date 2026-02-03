//shuttle moving state defines are in setup.dm
#define DOCK_ATTEMPT_TIMEOUT 200	//how long in ticks we wait before assuming the docking controller is broken or blown up.

/datum/shuttle
	var/name = ""
	var/warmup_time = 0
	var/moving_status = SHUTTLE_IDLE

	/// Time (in ds) that the current moving_status should be resolved
	var/timer = 0

	/// List of areas containing the turfs of the shuttle. Can be initialized as a single /area
	var/list/area/shuttle_area
	var/obj/effect/shuttle_landmark/current_location //This variable is type-abused initially: specify the landmark_tag, not the actual landmark.
	var/list/shuttle_computers = list()

	var/obj/effect/overmap/visitable/ship/landable/overmap_shuttle
	var/obj/effect/shuttle_landmark/transit/assigned_transit

	var/arrive_time = 0	//the time at which the shuttle arrives when long jumping
	var/flags = SHUTTLE_FLAGS_PROCESS
	var/category = /datum/shuttle
	var/multiz = 0	//how many multiz levels, starts at 0

	/// If there is a z-level above the shuttle, the following baseturf will be added between the z-level's floor (if exists) and open space.
	var/ceiling_baseturf = /turf/simulated/floor/airless/ceiling

	var/list/underlying_areas_by_turf = list()

	var/sound_takeoff = 'sound/effects/shuttle_takeoff.ogg'
	var/sound_landing = 'sound/effects/shuttle_landing.ogg'

	///Whether or not you want your ship to knock people down, and also whether it will throw them several tiles upon launching.
	var/list/movement_force = list(
		"KNOCKDOWN" = 3,
		"THROW" = 0,
	)

	/**
	 * This shuttle will/won't be initialised automatically.
	 * If set to `TRUE`, you are responsible for initialzing the shuttle manually.
	 * Useful for shuttles that are initialed by map_template loading, or shuttles that are created in-game or not used.
	 */
	var/defer_initialisation = FALSE
	var/logging_home_tag   //Whether in-game logs will be generated whenever the shuttle leaves/returns to the landmark with this landmark_tag.
	var/logging_access     //Controls who has write access to log-related stuff; should correlate with pilot access.

	var/mothershuttle //tag of mothershuttle
	var/motherdock    //tag of mothershuttle landmark, defaults to starting location

	var/landing_type = LAND_CRUSH

	var/in_use = null  //tells the controller whether this shuttle needs processing, also attempts to prevent double-use
	var/last_dock_attempt_time = 0
	var/current_dock_target

	/// `id_tag`/`master_tag` of the docking controller of this shuttle.
	var/dock_target = null

	var/obj/effect/shuttle_landmark/prev_location
	var/obj/effect/shuttle_landmark/next_location
	var/datum/computer/file/embedded_program/docking/active_docking_controller

	var/move_time = 240  //the time spent in the transition area
	var/minimum_move_time = 15  //the time spent in the transition area when both of the locations are located on station z-levels

/datum/shuttle/New(_name, var/obj/effect/shuttle_landmark/initial_location)
	..()
	if(_name)
		src.name = _name

	var/list/areas = list()
	if(!islist(shuttle_area))
		shuttle_area = list(shuttle_area)
	for(var/T in shuttle_area)
		var/area/A = GLOB.areas_by_type[T]
		if(!istype(A))
			CRASH("Shuttle \"[name]\" couldn't locate area [T].")
		areas += A
		RegisterSignal(A, COMSIG_QDELETING, PROC_REF(remove_shuttle_area))
	shuttle_area = areas

	for(var/area/A as anything in shuttle_area)
		for(var/turf/T as anything in A.get_turfs_from_all_zlevels())
			T.stack_below_baseturf(/turf/simulated/floor/plating, /turf/baseturf_skipover/shuttle)
			if(!T.depth_to_find_baseturf(/turf/baseturf_skipover/shuttle))
				continue
			var/turf/new_ceiling = GET_TURF_ABOVE(T)
			if(new_ceiling)
				var/shuttle_depth = new_ceiling.depth_to_find_baseturf(/turf/baseturf_skipover/shuttle_ceiling)
				if(!shuttle_depth)
					if(new_ceiling.is_open())
						new_ceiling.place_on_top(ceiling_baseturf)
					else
						new_ceiling.stack_ontop_of_baseturf(/turf/simulated/open, ceiling_baseturf)
						new_ceiling.stack_ontop_of_baseturf(/turf/space, ceiling_baseturf)

	if(initial_location)
		current_location = initial_location
	else
		current_location = SSshuttle.get_landmark(current_location)
	if(!istype(current_location))
		CRASH("Shuttle \"[name]\" could not find its starting location.")

	if(src.name in SSshuttle.shuttles)
		CRASH("A shuttle with the name '[name]' is already defined.")
	SSshuttle.shuttles[src.name] = src
	for(var/obj/machinery/computer/shuttle_control/SC as anything in SSshuttle.lonely_shuttle_computers)
		if(SC.shuttle_tag == name)
			SSshuttle.lonely_shuttle_computers -= SC
			shuttle_computers += SC
	if(flags & SHUTTLE_FLAGS_PROCESS)
		SSshuttle.process_shuttles += src
	if(flags & SHUTTLE_FLAGS_SUPPLY)
		if(SScargo.shuttle)
			CRASH("A supply shuttle is already defined.")
		SScargo.shuttle = src

	//Initial dock
	update_docking_target(current_location)
	active_docking_controller = current_location.docking_controller
	current_dock_target = get_docking_target(current_location)
	dock()

/datum/shuttle/Destroy()
	current_location = null
	overmap_shuttle = null

	SSshuttle.shuttles -= src.name
	SSshuttle.process_shuttles -= src
	if(SScargo.shuttle == src)
		SScargo.shuttle = null

	next_location = null
	prev_location = null
	active_docking_controller = null

	. = ..()

/datum/shuttle/process()
	if(!timer || timer > world.time)
		return

	switch(moving_status)
		if (SHUTTLE_WARMUP)
			if(check_undocked())
				takeoff(next_location, get_travel_time())

		if (SHUTTLE_INTRANSIT)
			spooldown(next_location)

		if (SHUTTLE_LANDING)
			land(next_location)

/datum/shuttle/overmap/process()
	if(moving_status == SHUTTLE_WARMUP && !next_location)
		return // delay until our transit is ready
	return ..()

/datum/shuttle/proc/set_timer(time)
	timer = world.time + time

/// Begins the process of moving the shuttle in /process(). Sets moving_status to SHUTTLE_WARMUP if shuttle is able to move.
/datum/shuttle/proc/spoolup(obj/effect/shuttle_landmark/destination)
	if(moving_status != SHUTTLE_IDLE || !fuel_check(TRUE))
		return

	var/obj/effect/shuttle_landmark/start = current_location

	set_moving_status(SHUTTLE_WARMUP)
	set_timer(warmup_time)
	callHook("shuttle_moved", list(start, destination))
	if(sound_takeoff)
		playsound(start, sound_takeoff, 50, 20)
	check_transit_zone()

/datum/shuttle/proc/takeoff(obj/effect/shuttle_landmark/destination, travel_time)
	if(moving_status == SHUTTLE_IDLE && !in_use) // Launch canceled
		return

	if(check_landing_zone() != DOCKING_SUCCESS || !fuel_check(TRUE))
		if(src && !QDELETED(src))
			cancel_launch(null)
		return

	set_timer(travel_time || minimum_move_time)

	if(travel_time > minimum_move_time && moving_status != SHUTTLE_WARMUP)
		enter_transit()
		set_moving_status(SHUTTLE_INTRANSIT)
	else
		set_moving_status(SHUTTLE_LANDING)

/datum/shuttle/overmap/takeoff(obj/effect/shuttle_landmark/destination, travel_time)
	. = ..()
	if(moving_status == SHUTTLE_INTRANSIT)
		set_timer(null) // we don't want to "land" after a certain time, we handle that via overmap

/datum/shuttle/proc/spooldown(obj/effect/shuttle_landmark/destination)
	if(moving_status == SHUTTLE_INTRANSIT)
		playsound(destination, sound_landing, 50, 20)
		set_moving_status(SHUTTLE_LANDING)
		set_timer(10 SECONDS)

/datum/shuttle/proc/land(obj/effect/shuttle_landmark/destination)
	if(moving_status != SHUTTLE_LANDING) // what
		return

	transit_to_landmark(destination, overmap_shuttle.fore_dir)
	set_moving_status(SHUTTLE_IDLE)
	process_arrived()
	arrived()

/datum/shuttle/proc/fuel_check()
	return 1 //fuel check should always pass in non-overmap shuttles (they have magic engines)

/datum/shuttle/proc/can_land(obj/effect/shuttle_landmark/destination)
	if(!istype(destination))
		return SHUTTLE_NOT_A_LANDMARK

	if(destination.override_landing_checks)
		return SHUTTLE_CAN_DOCK

	var/datum/component/bounding/area/ship_bounds = overmap_shuttle.GetComponent(/datum/component/bounding/area)
	var/datum/component/bounding/bfs/dest_bounds = destination.GetComponent(/datum/component/bounding/bfs)

	if(ship_bounds.w_offset > dest_bounds.w_offset)
		return SHUTTLE_DWIDTH_TOO_LARGE

	if(ship_bounds.width - ship_bounds.w_offset > dest_bounds.width - dest_bounds.w_offset)
		return SHUTTLE_WIDTH_TOO_LARGE

	if(ship_bounds.h_offset > dest_bounds.h_offset)
		return SHUTTLE_DHEIGHT_TOO_LARGE

	if(ship_bounds.height - ship_bounds.h_offset > dest_bounds.height - dest_bounds.h_offset)
		return SHUTTLE_HEIGHT_TOO_LARGE

	if(destination.occupant)
		if(destination.occupant != src)
			return SHUTTLE_SOMEONE_ELSE_DOCKED
		else
			return SHUTTLE_ALREADY_DOCKED

	return SHUTTLE_CAN_DOCK

/datum/shuttle/proc/check_dock(obj/effect/shuttle_landmark/destination, silent = FALSE)
	var/status = can_land(destination)
	if(status == SHUTTLE_CAN_DOCK)
		return TRUE
	if(status != SHUTTLE_ALREADY_DOCKED && !silent)
		log_and_message_admins("Shuttle [src] cannot dock at [destination], error: [status]")
	return FALSE

/datum/shuttle/proc/transit_to_landmark(obj/effect/shuttle_landmark/destination, movement_direction, force=FALSE)
	if(current_location == destination)
		destination.clear_landing_indicators()
		return DOCKING_SUCCESS

	if(!force)
		if(!check_dock(destination))
			destination.clear_landing_indicators()
			return DOCKING_BLOCKED
		if(current_location.cannot_depart(src) || !fuel_check(TRUE))
			destination.clear_landing_indicators()
			return DOCKING_IMMOBILIZED

	var/obj/effect/shuttle_landmark/starting_location = current_location
	var/fallback_area_type = SHUTTLE_DEFAULT_UNDERLYING_AREA

	if(sound_takeoff)
		playsound(current_location, sound_takeoff, 50, 20)

	if(starting_location)
		fallback_area_type = starting_location.area_type

	var/datum/component/bounding/area/old_bounds = overmap_shuttle.GetComponent(/datum/component/bounding/area)
	var/datum/component/bounding/bfs/new_bounds = destination.GetComponent(/datum/component/bounding/bfs)

	if(mothershuttle)
		var/datum/shuttle/mothership = SSshuttle.shuttles[mothershuttle]
		if(mothership)
			if(current_location.landmark_tag == motherdock)
				old_bounds.bounding_areas |= shuttle_area
			else
				old_bounds.bounding_areas -= shuttle_area

	old_bounds.rebuild_bounding_box()

	/**************************************************************************************************************
		Both lists are associative with a turf:bitflag structure. (new_turfs bitflag space unused currently)
		The bitflag contains the data for what inhabitants of that coordinate should be moved to the new location
		The bitflags can be found in __DEFINES/shuttles.dm
	*/
	var/list/old_turfs = old_bounds.return_ordered_turfs()
	var/list/new_turfs = new_bounds.return_ordered_turfs()
	CHECK_TICK
	/**************************************************************************************************************/

	var/area/fallback_area = GLOB.areas_by_type[fallback_area_type]
	if(!fallback_area)
		fallback_area = new fallback_area_type(null)

	var/rotation = 0
	if(destination.dir != starting_location.dir)
		rotation = dir2angle(destination.dir) - dir2angle(starting_location.dir)
		if ((rotation % 90) != 0)
			rotation += (rotation % 90) // diagonal rotations? in this economy?
		rotation = SIMPLIFY_DEGREES(rotation)

	if(!movement_direction)
		movement_direction = REVERSE_DIR(overmap_shuttle.fore_dir)

	var/list/moved_atoms = list()
	var/list/areas_to_move = list()
	var/list/underlying_areas = list()

	. = preflight_check(old_turfs, new_turfs, areas_to_move, underlying_areas, rotation)
	if(.)
		destination.clear_landing_indicators()
		return

	destination.shuttle_inbound(src)

	// not included: hidden docking ports

	// we check again
	if(!force)
		if(!check_dock(destination))
			destination.clear_landing_indicators()
			return DOCKING_BLOCKED
		if(current_location.cannot_depart(src) || !fuel_check(TRUE))
			destination.clear_landing_indicators()
			return DOCKING_IMMOBILIZED

	if(!fuel_check())
		var/datum/shuttle/S = src
		if(istype(S))
			S.cancel_launch(null)
		return DOCKING_BINGO_FUEL

	// we're good to go. hit it.
	move_shuttle(old_turfs, new_turfs, moved_atoms, rotation, movement_direction, starting_location, fallback_area)

	SEND_SIGNAL(starting_location, COMSIG_SHUTTLE_OUTBOUND)
	SEND_SIGNAL(destination, COMSIG_SHUTTLE_INBOUND)

	CHECK_TICK

	cleanup_runway(destination, old_turfs, new_turfs, areas_to_move, underlying_areas, moved_atoms, rotation, movement_direction, fallback_area)

	// unhide turfs if necessary

	// open shuttle doors

	destination.clear_landing_indicators()
	return DOCKING_SUCCESS

/datum/shuttle/proc/preflight_check(list/old_turfs, list/new_turfs, list/areas_to_move, list/underlying_areas, rotation)
	for(var/i in 1 to old_turfs.len)
		CHECK_TICK
		var/turf/old_turf = old_turfs[i]
		var/turf/new_turf = new_turfs[i]
		if(!new_turf)
			return DOCKING_NULL_DESTINATION
		if(!old_turf)
			return DOCKING_NULL_SOURCE

		var/area/old_area = old_turf.loc
		var/move_mode = old_area.before_shuttle_move(shuttle_area)

		for(var/atom/movable/moving_atom as anything in old_turf.contents)
			CHECK_TICK
			if(moving_atom.loc != old_turf)
				continue
			move_mode = moving_atom.before_shuttle_move(new_turf, rotation, move_mode, src)

		move_mode = old_turf.shuttle_move_from(new_turf, move_mode)
		move_mode = new_turf.shuttle_move_to(old_turf, move_mode, src)

		if(move_mode & MOVE_AREA)
			var/area/underlying_area = underlying_areas_by_turf[old_turf]
			if(underlying_area)
				underlying_areas[underlying_area] = TRUE
			areas_to_move[old_area] = TRUE

		old_turfs[old_turf] = move_mode

/datum/shuttle/proc/move_shuttle(list/old_turfs, list/new_turfs, list/moved_atoms, rotation, movement_direction, old_dock, area/fallback_area)
	for(var/i in 1 to old_turfs.len)
		var/turf/old_turf = old_turfs[i]
		var/turf/new_turf = new_turfs[i]
		var/move_mode = old_turfs[old_turf]

		if(move_mode & MOVE_TURF)
			old_turf.on_shuttle_move(new_turf, movement_force, movement_direction, move_mode & MOVE_AREA)

		if(move_mode & MOVE_AREA)
			var/area/old_shuttle_area = old_turf.loc
			old_shuttle_area.on_shuttle_move(old_turf, new_turf, src, fallback_area)

		if(move_mode & MOVE_CONTENTS)
			for(var/atom/movable/thing as anything in old_turf)
				if(thing.loc != old_turf)
					continue
				thing.on_shuttle_move(new_turf, old_turf, movement_force, movement_direction, old_dock, src)
				moved_atoms[thing] = old_turf

/datum/shuttle/proc/cleanup_runway(obj/effect/shuttle_landmark/new_dock, list/old_turfs, list/new_turfs, list/areas_to_move, list/underlying_areas, list/moved_atoms, rotation, movement_direction, area/fallback_area)
	// -- after_shuttle_move --
	fallback_area.after_shuttle_move()

	for(var/i in 1 to underlying_areas.len)
		CHECK_TICK
		var/area/underlying_area = underlying_areas[i]
		underlying_area.after_shuttle_move()

	for(var/i in 1 to areas_to_move.len)
		CHECK_TICK
		var/area/internal_area = areas_to_move[i]
		internal_area.after_shuttle_move()

	for(var/i in 1 to old_turfs.len)
		CHECK_TICK
		var/turf/old_turf = old_turfs[i]
		var/old_move_mode = old_turfs[old_turf]
		var/turf/old_ceiling = GET_TURF_ABOVE(old_turf)

		if(old_ceiling && ceiling_baseturf)
			var/shuttle_depth = old_ceiling.depth_to_find_baseturf(/turf/baseturf_skipover/shuttle_ceiling)
			if(shuttle_depth)
				old_turf.scrape_away(shuttle_depth)
			else
				old_turf.remove_baseturfs_from_typecache(list(ceiling_baseturf = TRUE))

		if(!(old_move_mode & MOVE_TURF))
			continue

		var/turf/new_turf = new_turfs[i]
		new_turf.after_shuttle_move(old_turf, rotation)
		var/turf/new_ceiling = GET_TURF_ABOVE(new_turf)
		if(new_ceiling)
			var/shuttle_depth = new_ceiling.depth_to_find_baseturf(/turf/baseturf_skipover/shuttle_ceiling)
			if(!shuttle_depth) // if two shuttles trade places in the exact same second this'll break I guess. oh no! anyways
				if(new_ceiling.is_open())
					new_ceiling.place_on_top(ceiling_baseturf)
				else
					new_ceiling.stack_ontop_of_baseturf(/turf/simulated/open, ceiling_baseturf)
					new_ceiling.stack_ontop_of_baseturf(/turf/space, ceiling_baseturf)

	for(var/i in 1 to moved_atoms.len)
		CHECK_TICK
		var/atom/movable/moved_atom = moved_atoms[i]
		if(QDELETED(moved_atom))
			continue
		var/turf/old_turf = moved_atoms[moved_atom]
		moved_atom.after_shuttle_move(old_turf, movement_force, overmap_shuttle.dir, overmap_shuttle.fore_dir, movement_direction, rotation)

	// -- late_shuttle_move --
	fallback_area.late_shuttle_move()

	for(var/i in 1 to areas_to_move.len)
		CHECK_TICK
		var/area/internal_area = areas_to_move[i]
		internal_area.late_shuttle_move()

	for(var/i in 1 to underlying_areas.len)
		CHECK_TICK
		var/area/underlying_area = underlying_areas[i]
		underlying_area.late_shuttle_move()

	for(var/i in 1 to old_turfs.len)
		CHECK_TICK
		if(!(old_turfs[old_turfs[i]] & (MOVE_CONTENTS|MOVE_TURF)))
			continue
		var/turf/old_turf = old_turfs[i]
		var/turf/new_turf = new_turfs[i]
		new_turf.late_shuttle_move(old_turf)

	for(var/i in 1 to moved_atoms.len)
		CHECK_TICK
		var/atom/movable/moved_atom = moved_atoms[i]
		if(QDELETED(moved_atom))
			continue
		var/turf/old_turf = moved_atoms[moved_atom]
		moved_atom.late_shuttle_move(old_turf, movement_force, movement_direction)

/datum/shuttle/proc/check_landing_zone(obj/effect/shuttle_landmark/dest)
	if(!dest)
		dest = next_location
	if(!istype(dest))
		return DOCKING_NULL_DESTINATION

	. = DOCKING_SUCCESS
	var/list/bounds = overmap_shuttle.get_bounds()
	var/list/overlappers = SSshuttle.get_dock_overlap(bounds[1], bounds[2], bounds[3], bounds[4], dest.z)
	var/list/shuttle_turfs = block(bounds[1], bounds[2], overmap_shuttle.z, bounds[3], bounds[4], overmap_shuttle.z)
	for(var/turf/T as anything in shuttle_turfs)
		if(check_landing_turf(T, overlappers))
			return DOCKING_BLOCKED

/datum/shuttle/proc/check_landing_turf(turf/T, list/overlappers)
	if(!T || T.x <= TRANSITIONEDGE || T.y <= TRANSITIONEDGE || T.x >= world.maxx - TRANSITIONEDGE || T.y >= world.maxy - TRANSITIONEDGE)
		return DOCKING_BLOCKED

	. = DOCKING_SUCCESS

	if(T.density)
		return DOCKING_BLOCKED

	for(var/i in 1 to overlappers.len)
		var/obj/effect/shuttle_landmark/slm = overlappers[i]
		if(slm == current_location || slm == next_location)
			continue
		var/list/overlap = overlappers[slm]
		var/list/xs = overlap[1]
		var/list/ys = overlap[2]
		if(xs["[T.x]"] && ys["[T.y]"])
			return DOCKING_BLOCKED // wildtodo: maybe shuttles should block docks that arent special

//returns 1 if the shuttle has a valid arrive time
/datum/shuttle/proc/has_arrive_time()
	return (moving_status == SHUTTLE_INTRANSIT)

/datum/shuttle/proc/find_children()
	. = list()
	for(var/shuttle_name in SSshuttle.shuttles)
		var/datum/shuttle/shuttle = SSshuttle.shuttles[shuttle_name]
		if(shuttle.mothershuttle == name)
			. += shuttle

//Returns those areas that are not actually child shuttles.
/datum/shuttle/proc/find_childfree_areas()
	. = shuttle_area.Copy()
	for(var/datum/shuttle/child in find_children())
		. -= child.shuttle_area

/datum/shuttle/proc/get_location_name()
	if(moving_status == SHUTTLE_INTRANSIT)
		return "In transit"
	return current_location.name

/datum/shuttle/proc/get_destination_name()
	if(!next_location)
		return "None"
	return next_location.name

/datum/shuttle/proc/set_moving_status(var/new_state)
	moving_status = new_state
	for(var/obj/machinery/computer/shuttle_control/SC as anything in shuttle_computers)
		SC.update_helmets(src)

/datum/shuttle/proc/on_move_interim()
	return

/datum/shuttle/proc/remove_shuttle_area(area/area_to_remove)
	UnregisterSignal(area_to_remove, COMSIG_QDELETING)
	SSshuttle.shuttle_areas -= area_to_remove
	SSshuttle.areas_to_shuttles -= area_to_remove
	shuttle_area -= area_to_remove
	if(!length(shuttle_area))
		qdel(src)

/datum/shuttle/proc/enter_transit()
	if(!fuel_check())
		set_moving_status(SHUTTLE_IDLE)
		return

	var/obj/effect/shuttle_landmark/S0 = current_location
	var/obj/effect/shuttle_landmark/S1 = assigned_transit

	if(S1)
		if(transit_to_landmark(S1) != DOCKING_SUCCESS)
			WARNING("Shuttle \"[name]\" could not enter transit space. Docked at [S0 ? S0.name : "null"]. Transit dock [S1 ? S1.name : "null"]")
		else if(S0)
			if(S0.delete_after)
				qdel(S0, TRUE)
			else
				prev_location = S0
	else
		WARNING("Shuttle \"[name]\" could not enter transit space. Docked at [S0 ? S0.name : "null"]. Transit dock [S1 ? S1.name : "null"]")

/datum/shuttle/proc/transit_failure()
	message_admins("Shuttle [src] repeatedly failed to create transit zone.")
	cancel_launch()

/datum/shuttle/proc/transit_success()
	return

/datum/shuttle/proc/update_docking_target(var/obj/effect/shuttle_landmark/location)
	if(location && location.special_dock_targets && location.special_dock_targets[name])
		current_dock_target = location.special_dock_targets[name]
	else
		current_dock_target = dock_target
	active_docking_controller = SSshuttle.docking_registry[current_dock_target]

/datum/shuttle/proc/get_docking_target(var/obj/effect/shuttle_landmark/location)
	if(location && location.special_dock_targets)
		if(location.special_dock_targets[name])
			return location.special_dock_targets[name]
	return dock_target
/*
	Docking stuff
*/

/datum/shuttle/proc/check_transit_zone()
	if(assigned_transit)
		return TRANSIT_READY
	else
		SSshuttle.request_transit_dock(src)
		return TRANSIT_REQUEST

/datum/shuttle/proc/dock()
	if(active_docking_controller)
		active_docking_controller.initiate_docking(current_dock_target)
		last_dock_attempt_time = world.time

/datum/shuttle/proc/undock()
	if(active_docking_controller)
		active_docking_controller.initiate_undocking()

/datum/shuttle/proc/force_undock()
	if(active_docking_controller)
		active_docking_controller.force_undock()

/datum/shuttle/proc/check_docked()
	if(active_docking_controller)
		return active_docking_controller.docked()
	return TRUE

/datum/shuttle/proc/check_undocked()
	if(active_docking_controller)
		return active_docking_controller.can_launch()
	return TRUE

/datum/shuttle/proc/process_arrived()
	update_docking_target(next_location)
	active_docking_controller = next_location.docking_controller
	current_dock_target = get_docking_target(next_location)
	dock()

	next_location = null
	in_use = null	//release lock

/datum/shuttle/proc/get_travel_time()
	if(is_station_level(current_location.loc.z) && is_station_level(next_location.loc.z) && move_time > minimum_move_time)
		return minimum_move_time
	else
		return move_time

/*
	Guards
*/
/datum/shuttle/proc/can_launch()
	return (next_location && moving_status == SHUTTLE_IDLE && !in_use)

/datum/shuttle/overmap/can_launch()
	return (moving_status == SHUTTLE_IDLE && !in_use)

/datum/shuttle/proc/can_force()
	return (next_location && moving_status == SHUTTLE_IDLE)

/datum/shuttle/proc/can_cancel()
	return (moving_status == SHUTTLE_WARMUP)

/datum/shuttle/proc/check_departure()
	. = current_location.cannot_depart(src)
	if(!. && check_landing_zone() != DOCKING_SUCCESS)
		. = "Destination zone is invalid or obstructed."
	if(!. && SSodyssey.site_landing_restricted && (GET_Z(next_location) in SSodyssey.scenario_zlevels))
		. = "You are not cleared to land at this site yet! You must wait for your ship's sensor scans to complete first."

/datum/shuttle/proc/check_and_message(mob/user)
	var/msg = check_departure()

	if(msg)
		to_chat(user, SPAN_WARNING(msg))
		return FALSE
	return TRUE

/datum/shuttle/overmap/check_departure()
	. = current_location.cannot_depart(src)

/*
	"Public" procs
*/
/datum/shuttle/proc/launch(var/user)
	SHOULD_CALL_PARENT(TRUE)
	if(!can_launch())
		return

	in_use = user	//obtain an exclusive lock on the shuttle

	undock()
	spoolup()

/datum/shuttle/proc/force_launch(var/user)
	SHOULD_CALL_PARENT(TRUE)
	if(!can_force())
		return

	in_use = user	//obtain an exclusive lock on the shuttle

	force_undock()
	takeoff(next_location, get_travel_time())

/datum/shuttle/proc/cancel_launch()
	SHOULD_CALL_PARENT(TRUE)
	if (!can_cancel()) return

	set_moving_status(SHUTTLE_IDLE)
	in_use = null

	//whatever we were doing with docking: stop it, then redock
	force_undock()
	addtimer(CALLBACK(src, PROC_REF(dock)), 1 SECOND)

//This gets called when the shuttle finishes arriving at it's destination
//This can be used by subtypes to do things when the shuttle arrives.
//Note that this is called when the shuttle leaves the WAIT_FINISHED state, the proc name is a little misleading
/datum/shuttle/proc/arrived()
	return	//do nothing for now

#undef DOCK_ATTEMPT_TIMEOUT
