// These come with shuttle functionality. Need to be assigned a (unique) shuttle datum name.
// Mapping location doesn't matter, so long as on a map loaded at the same time as the shuttle areas.
// Multiz shuttles currently not supported. Non-autodock shuttles currently not supported.

/obj/effect/overmap/visitable/ship/landable
	var/shuttle                                         // Name of associated shuttle. Must be autodock.
	var/obj/effect/shuttle_landmark/ship/landmark       // Record our open space landmark for easy reference.
	var/multiz = 0										// Index of multi-z levels, starts at 0
	var/status = SHIP_STATUS_LANDED
	///If true, it will use the z-level it's mapped on as the "Open Space" level, if false it will create a new level for that.
	var/use_mapped_z_levels = FALSE //If you use this, use /obj/effect/shuttle_landmark/ship as the landmark (set the landmark_tag to match on the shuttle, no other setup needed)
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	layer = OVERMAP_SHUTTLE_LAYER
	/// Angle of the ship's docking port relative to the ship.
	var/port_dir = NORTH

/obj/effect/overmap/visitable/ship/landable/Initialize()
	. = ..()
	if(!SSshuttle.initialized)
		LAZYSET(SSshuttle.shuttle_objects, shuttle, src)
	else
		var/datum/shuttle/shuttle_datum = SSshuttle.shuttles[shuttle]
		shuttle_datum.overmap_shuttle = src
		shuttle_datum.RegisterSignal(src, COMSIG_QDELETING, TYPE_PROC_REF(/datum, qdel_self))

/obj/effect/overmap/visitable/ship/landable/Destroy()
	UnregisterSignal(SSshuttle.shuttles[shuttle], COMSIG_SHUTTLE_OUTBOUND)
	return ..()

/obj/effect/overmap/visitable/ship/landable/proc/get_transit_path_type(bluespace = FALSE)
	. = /turf/space/transit
	if(bluespace)
		switch(fore_dir)
			if(NORTH)
				return /turf/space/transit/bluespace
			if(SOUTH)
				return /turf/space/transit/bluespace/south
			if(EAST)
				return /turf/space/transit/bluespace/east
			if (WEST)
				return /turf/space/transit/bluespace/west

	switch(fore_dir)
		if(NORTH, SOUTH)
			return /turf/space/transit/north
		if(EAST, WEST)
			return /turf/space/transit/east

/obj/effect/overmap/visitable/ship/landable/can_burn()
	if(status != SHIP_STATUS_OVERMAP)
		return 0
	return ..()

/obj/effect/overmap/visitable/ship/landable/burn()
	if(status != SHIP_STATUS_OVERMAP)
		return 0
	return ..()

/obj/effect/overmap/visitable/ship/landable/check_ownership(obj/object)
	var/datum/shuttle/shuttle_datum = SSshuttle.shuttles[shuttle]
	if(!shuttle_datum)
		return
	var/list/areas = shuttle_datum.find_childfree_areas()
	if(get_area(object) in areas)
		return 1

/obj/effect/overmap/visitable/ship/landable/move_to_starting_location()
	if(!use_mapped_z_levels)
		return
	else
		..() // this picks a random turf

/obj/effect/overmap/visitable/ship/landable/get_areas()
	var/datum/shuttle/shuttle_datum = SSshuttle.shuttles[shuttle]
	if(!shuttle_datum)
		return ..() || list()
	return shuttle_datum.find_childfree_areas()

/obj/effect/overmap/visitable/ship/landable/populate_sector_objects()
	..()
	var/datum/shuttle/shuttle_datum = SSshuttle.shuttles[shuttle]
	if(use_mapped_z_levels)
		var/obj/effect/shuttle_landmark/ship/ship_landmark = shuttle_datum.current_location
		if(!istype(ship_landmark))
			stack_trace("Landable ship [src] with shuttle [shuttle] was mapped with a starting landmark type [ship_landmark.type], but should be /obj/effect/shuttle_landmark/ship.")
			ship_landmark = new(ship_landmark.loc, shuttle)
			qdel(shuttle_datum.current_location)
			shuttle_datum.current_location = ship_landmark
		landmark = ship_landmark
		landmark.shuttle_name = shuttle
		LAZYDISTINCTADD(initial_generic_waypoints, landmark.landmark_tag) // this is us being user-friendly: it means we register it properly regardless of whether the mapper put the tag in initial_restricted_waypoints

		var/visitor_dir = fore_dir
		for(var/landmark_name in list("FORE", "PORT", "AFT", "STARBOARD"))
			var/turf/visitor_turf = get_ranged_target_turf(get_turf(landmark), visitor_dir, round(min(world.maxx/4, world.maxy/4)))
			var/obj/effect/shuttle_landmark/visiting_shuttle/visitor_landmark = new (visitor_turf, landmark, landmark_name)
			add_landmark(visitor_landmark)
			visitor_dir = turn(visitor_dir, 90)

	//Configure shuttle datum
	RegisterSignal(shuttle_datum, COMSIG_SHUTTLE_OUTBOUND, PROC_REF(on_shuttle_jump))
	on_landing(landmark, shuttle_datum.current_location) // We "land" at round start to properly place ourselves on the overmap.
	if(landmark == shuttle_datum.current_location)
		status = SHIP_STATUS_OVERMAP

	var/obj/effect/overmap/visitable/mothership = GLOB.map_sectors["[shuttle_datum.current_location.z]"]
	if(mothership)
		for(var/obj/machinery/computer/ship/sensors/sensor_console in consoles)
			sensor_console.datalink_add_ship_datalink(mothership)
			break

/obj/effect/shuttle_landmark/ship
	name = "Open Space"
	landmark_tag = "ship"
	var/shuttle_name
	var/list/visitors // landmark -> visiting shuttle stationed there

/obj/effect/shuttle_landmark/ship/Initialize(mapload, shuttle_name)
	if(!src.shuttle_name)
		landmark_tag += "_[shuttle_name]"
		src.shuttle_name = shuttle_name
	. = ..()

/obj/effect/shuttle_landmark/ship/Destroy()
	var/obj/effect/overmap/visitable/ship/landable/ship = GLOB.map_sectors["[z]"]
	if(istype(ship) && ship.landmark == src)
		ship.landmark = null
	. = ..()

/obj/effect/shuttle_landmark/ship/cannot_depart(datum/shuttle/shuttle)
	if(LAZYLEN(visitors))
		return "Grappled by other shuttle; cannot manouver."

// wildtodo: spawn and clear these as necessary
/obj/effect/shuttle_landmark/visiting_shuttle
	var/obj/effect/shuttle_landmark/ship/core_landmark
	delete_after = TRUE

/obj/effect/shuttle_landmark/visiting_shuttle/Initialize(mapload, obj/effect/shuttle_landmark/ship/master, _name)
	core_landmark = master
	name = _name
	landmark_tag = master.shuttle_name + _name
	RegisterSignal(master, COMSIG_QDELETING, TYPE_PROC_REF(/datum, qdel_self))
	. = ..()

/obj/effect/shuttle_landmark/visiting_shuttle/Destroy()
	UnregisterSignal(core_landmark, COMSIG_QDELETING)
	LAZYREMOVE(core_landmark.visitors, src)
	core_landmark = null
	. = ..()

/obj/effect/shuttle_landmark/visiting_shuttle/shuttle_arrived(datum/shuttle/shuttle)
	..()
	LAZYSET(core_landmark.visitors, src, shuttle)
	RegisterSignal(shuttle, COMSIG_SHUTTLE_OUTBOUND, PROC_REF(shuttle_left))

/obj/effect/shuttle_landmark/visiting_shuttle/proc/shuttle_left(datum/shuttle/shuttle, obj/effect/shuttle_landmark/old_landmark, obj/effect/shuttle_landmark/new_landmark)
	if(old_landmark == src)
		UnregisterSignal(shuttle, COMSIG_SHUTTLE_OUTBOUND)
		LAZYREMOVE(core_landmark.visitors, src)

/obj/effect/overmap/visitable/ship/landable/proc/on_shuttle_jump(datum/shuttle/given_shuttle, obj/effect/shuttle_landmark/from, obj/effect/shuttle_landmark/into)
	if(given_shuttle != SSshuttle.shuttles[shuttle])
		return
	var/datum/shuttle/S = given_shuttle
	if (S.moving_status == SHUTTLE_INTRANSIT)
		status = SHIP_STATUS_TRANSIT
	else if (into == landmark)
		status = SHIP_STATUS_OVERMAP
	else
		status = SHIP_STATUS_LANDED
	on_landing(from, into)

/obj/effect/overmap/visitable/ship/landable/proc/on_landing(obj/effect/shuttle_landmark/from, obj/effect/shuttle_landmark/into)
	var/obj/effect/overmap/visitable/target = GLOB.map_sectors["[into.z]"]
	var/datum/shuttle/shuttle_datum = SSshuttle.shuttles[shuttle]
	if(into.landmark_tag == shuttle_datum.motherdock) // If our motherdock is a landable ship, it won't be found properly here so we need to find it manually.
		for(var/obj/effect/overmap/visitable/ship/landable/landable in SSshuttle.ships)
			if(landable.shuttle == shuttle_datum.mothershuttle)
				target = landable
				break
	if(!target || target == src)
		return
	forceMove(target)
	halt()

/obj/effect/overmap/visitable/ship/landable/proc/on_takeoff(obj/effect/shuttle_landmark/from, obj/effect/shuttle_landmark/into)
	if(!isturf(loc))
		forceMove(get_turf(loc))
		unhalt()

/obj/effect/overmap/visitable/ship/landable/get_landed_info()
	switch(status)
		if(SHIP_STATUS_LANDED)
			var/obj/effect/overmap/visitable/location = loc
			if(istype(loc, /obj/effect/overmap/visitable/sector))
				return "Landed on \the [location.name]"
			if(istype(loc, /obj/effect/overmap/visitable/ship))
				return "Docked with \the [location.name]"
			return "Docked with an unknown object."
		if(SHIP_STATUS_TRANSIT)
			return "Maneuvering."
		if(SHIP_STATUS_OVERMAP)
			return "Deep Space."
