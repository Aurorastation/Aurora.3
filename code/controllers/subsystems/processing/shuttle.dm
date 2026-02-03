#define MAX_TRANSIT_REQUEST_RETRIES 10
/// How many turfs to allow before we stop blocking transit requests
#define MAX_TRANSIT_TILE_COUNT (150 ** 2)
/// How many turfs to allow before we start freeing up existing "soft reserved" transit docks
/// If we're under load we want to allow for cycling, but if not we want to preserve already generated docks for use
#define SOFT_TRANSIT_RESERVATION_THRESHOLD (100 ** 2)
/// Give a shuttle 10 "fires" (~10 seconds) to spawn before it can be cleaned up.
#define SHUTTLE_SPAWN_BUFFER SSshuttle.wait * 10

SUBSYSTEM_DEF(shuttle)
	name = "Shuttle"
	wait = 2 SECONDS
	priority = SS_PRIORITY_SHUTTLE
	init_order = INIT_ORDER_MISC                    //Should be initialized after all maploading is over and atoms are initialized, to ensure that landmarks have been initialized.

	var/overmap_halted = FALSE                   //Whether ships can move on the overmap; used for adminbus.
	var/list/ships = list()                      //List of all ships.
	var/list/shuttles = list()                   //maps shuttle tags to shuttle datums, so that they can be looked up.
	var/list/process_shuttles = list()           //simple list of shuttles, for processing
	/// A list of all the transit landmarks.
	var/list/transit = list()

	/// A list of all the mobile docking ports currently requesting a spot in hyperspace.
	var/list/transit_requesters = list()
	/// An associative list of the mobile docking ports that have failed a transit request, with the amount of times they've actually failed that transit request, up to MAX_TRANSIT_REQUEST_RETRIES
	var/list/transit_request_failures = list()
	/// How many turfs our shuttles are currently utilizing in reservation space
	var/transit_utilized = 0

	/// Map of shuttle landmark `landmark_tag` to the actual landmark object.
	var/list/registered_shuttle_landmarks = list()
	var/last_landmark_registration_time
	var/list/docking_registry = list()           //Docking controller tag -> docking controller program, mostly for init purposes.
	var/list/shuttle_areas = list()              //All the areas of all shuttles.
	/// Assoc list of [area type] -> /datum/shuttle
	var/list/areas_to_shuttles = list()

	var/list/lonely_shuttle_computers = list()   //shuttle computers that haven't been attached to their shuttles yet
	/// List of init'd overmap objects; [shuttle name] -> [/obj/effect/...]; cleared on shuttle init
	var/list/shuttle_objects

	var/list/landmarks_awaiting_sector = list()  //Stores automatic landmarks that are waiting for a sector to finish loading.
	var/list/landmarks_still_needed = list()     //Stores landmark_tags that need to be assigned to the sector (landmark_tag = sector) when registered.
	var/list/shuttles_to_initialize = list()     //A queue for shuttles to initialize at the appropriate time.
	var/list/sectors_to_initialize               //Used to find all sector objects at the appropriate time.
	var/list/initialized_sectors = list()
	var/list/entry_points_to_initialize = list() //Entrypoints must initialize after the shuttles are done.
	var/list/weapons_to_initialize = list() 		 //Ditto above but for ship guns.
	var/block_queue = TRUE

	var/tmp/list/working_shuttles

	/// The destination helper for the cargo elevator.
	var/obj/effect/landmark/destination_helper/cargo_elevator/cargo_dest_helper

/datum/controller/subsystem/shuttle/Initialize()
	last_landmark_registration_time = world.time
	for(var/shuttle_type in subtypesof(/datum/shuttle)) // This accounts for most shuttles, though away maps can queue up more.
		var/datum/shuttle/shuttle = shuttle_type
		if(!(shuttle in SSmapping.current_map.map_shuttles))
			continue
		if(!initial(shuttle.defer_initialisation))
			LAZYDISTINCTADD(shuttles_to_initialize, shuttle_type)
	block_queue = FALSE
	clear_init_queue()

	return SS_INIT_SUCCESS

/datum/controller/subsystem/shuttle/fire(resumed = FALSE)
	if (!resumed)
		working_shuttles = process_shuttles.Copy()

	while(working_shuttles.len)
		var/datum/shuttle/shuttle = working_shuttles[working_shuttles.len]
		working_shuttles.len--
		if(shuttle.moving_status != SHUTTLE_IDLE && (shuttle.process() == PROCESS_KILL))
			process_shuttles -= shuttle

		if(TICK_CHECK)
			break

	for(var/thing in transit)
		var/obj/effect/shuttle_landmark/transit/transit = thing
		if(!transit.owner)
			qdel(transit, force=TRUE)
		if(transit_utilized < SOFT_TRANSIT_RESERVATION_THRESHOLD)
			continue
		var/datum/shuttle/owner = transit.owner
		if(owner && (world.time > transit.spawn_time + SHUTTLE_SPAWN_BUFFER))
			var/idle = owner.moving_status == SHUTTLE_IDLE
			var/not_in_use = (!transit.occupant)
			if(idle && not_in_use)
				qdel(transit, force=TRUE)

	if(!SSmapping.clearing_reserved_turfs)
		while(length(transit_requesters))
			var/requester = popleft(transit_requesters)
			var/success = null
			if(transit_utilized < MAX_TRANSIT_TILE_COUNT)
				success = generate_transit_landmark(requester)
				var/datum/shuttle/R = requester
				R.transit_success()
			if(!success)
				transit_request_failures[requester]++
				if(transit_request_failures[requester] < MAX_TRANSIT_REQUEST_RETRIES)
					transit_requesters += requester
				else
					var/datum/shuttle/R = requester
					R.transit_failure()
					log_debug("[R] has failed to get a transit zone")
			if(TICK_CHECK)
				break

/datum/controller/subsystem/shuttle/proc/clear_init_queue()
	if(block_queue)
		return
	initialize_shuttles()
	initialize_sectors()
	initialize_entrypoints()
	initialize_ship_weapons()

/datum/controller/subsystem/shuttle/proc/initialize_entrypoints()
	for(var/obj/effect/landmark/entry_point/EP in entry_points_to_initialize)
		var/obj/effect/overmap/visitable/ship/S = EP.get_candidate()
		if(istype(S))
			LAZYADD(S.entry_points, EP)
	entry_points_to_initialize.Cut()

/datum/controller/subsystem/shuttle/proc/initialize_ship_weapons()
	for(var/obj/machinery/ship_weapon/SW in weapons_to_initialize)
		SW.sync_linked()
		if(SW.linked)
			LAZYADD(SW.linked.ship_weapons, SW)
	weapons_to_initialize.Cut()

/datum/controller/subsystem/shuttle/proc/initialize_shuttles()
	var/list/shuttles_made = list()
	for(var/shuttle_type in shuttles_to_initialize)
		var/datum/shuttle/shuttle = initialize_shuttle(shuttle_type)
		if(shuttle)
			shuttles_made += shuttle
			if(LAZYISIN(shuttle_objects, shuttle.name))
				shuttle.overmap_shuttle = shuttle_objects[shuttle.name]
				shuttle.RegisterSignal(shuttle_objects[shuttle.name], COMSIG_QDELETING, TYPE_PROC_REF(/datum, qdel_self))
				LAZYREMOVE(shuttle_objects, shuttle.name)
	hook_up_motherships(shuttles_made)
	shuttles_to_initialize = null

/datum/controller/subsystem/shuttle/proc/initialize_sectors()
	for(var/sector in sectors_to_initialize)
		initialize_sector(sector)
	sectors_to_initialize = null

/datum/controller/subsystem/shuttle/proc/register_landmark(shuttle_landmark_tag, obj/effect/shuttle_landmark/shuttle_landmark)
	if (registered_shuttle_landmarks[shuttle_landmark_tag])
		CRASH("Attempted to register shuttle landmark with tag [shuttle_landmark_tag], but it is already registered!")
	if (istype(shuttle_landmark))
		registered_shuttle_landmarks[shuttle_landmark_tag] = shuttle_landmark
		last_landmark_registration_time = world.time

		var/obj/effect/overmap/visitable/O = landmarks_still_needed[shuttle_landmark_tag]
		if(O) //These need to be added to sectors, which we handle.
			try_add_landmark_tag(shuttle_landmark_tag, O)
			landmarks_still_needed -= shuttle_landmark_tag
		else if(istype(shuttle_landmark, /obj/effect/shuttle_landmark/automatic)) //These find their sector automatically
			O = GLOB.map_sectors["[shuttle_landmark.z]"]
			if(O)
				O.add_landmark(shuttle_landmark, shuttle_landmark.shuttle_restricted)
			else
				landmarks_awaiting_sector += shuttle_landmark

/datum/controller/subsystem/shuttle/proc/get_landmark(var/shuttle_landmark_tag)
	return registered_shuttle_landmarks[shuttle_landmark_tag]

//Checks if the given sector's landmarks have initialized; if so, registers them with the sector, if not, marks them for assignment after they come in.
//Also adds automatic landmarks that were waiting on their sector to spawn.
/datum/controller/subsystem/shuttle/proc/initialize_sector(obj/effect/overmap/visitable/given_sector)
	given_sector.populate_sector_objects() // This is a late init operation that sets up the sector's map_z and does non-overmap-related init tasks.

	for(var/landmark_tag in given_sector.initial_generic_waypoints)
		if(!try_add_landmark_tag(landmark_tag, given_sector))
			landmarks_still_needed[landmark_tag] = given_sector

	for(var/shuttle_name in given_sector.initial_restricted_waypoints)
		for(var/landmark_tag in given_sector.initial_restricted_waypoints[shuttle_name])
			if(!try_add_landmark_tag(landmark_tag, given_sector))
				landmarks_still_needed[landmark_tag] = given_sector

	var/landmarks_to_check = landmarks_awaiting_sector.Copy()
	for(var/thing in landmarks_to_check)
		var/obj/effect/shuttle_landmark/automatic/landmark = thing
		if(landmark.z in given_sector.map_z)
			given_sector.add_landmark(landmark, landmark.shuttle_restricted)
			landmarks_awaiting_sector -= landmark

	initialized_sectors |= given_sector

/datum/controller/subsystem/shuttle/proc/try_add_landmark_tag(landmark_tag, obj/effect/overmap/visitable/given_sector)
	var/obj/effect/shuttle_landmark/landmark = get_landmark(landmark_tag)
	if(!landmark)
		return FALSE

	if(landmark.landmark_tag in given_sector.initial_generic_waypoints)
		given_sector.add_landmark(landmark)
		. = TRUE
	for(var/shuttle_name in given_sector.initial_restricted_waypoints)
		if(landmark.landmark_tag in given_sector.initial_restricted_waypoints[shuttle_name])
			given_sector.add_landmark(landmark, shuttle_name)
			. = TRUE

/datum/controller/subsystem/shuttle/proc/initialize_shuttle(var/shuttle_type)
	var/datum/shuttle/shuttle = shuttle_type
	if(initial(shuttle.category) != shuttle_type)
		shuttle = new shuttle()
		shuttle_areas |= shuttle.shuttle_area
		for(var/area/A as anything in shuttle.shuttle_area)
			areas_to_shuttles[A.type] = shuttle
		return shuttle

/datum/controller/subsystem/shuttle/proc/hook_up_motherships(shuttles_list)
	for(var/datum/shuttle/S in shuttles_list)
		if(S.mothershuttle && !S.motherdock)
			var/datum/shuttle/mothership = shuttles[S.mothershuttle]
			if(mothership)
				S.motherdock = S.current_location.landmark_tag
				mothership.shuttle_area |= S.shuttle_area
			else
				log_world("ERROR: Shuttle [S] was unable to find mothership [mothership]!")

/datum/controller/subsystem/shuttle/proc/toggle_overmap(new_setting)
	if(overmap_halted == new_setting)
		return
	overmap_halted = !overmap_halted
	for(var/ship in ships)
		var/obj/effect/overmap/visitable/ship/ship_effect = ship
		overmap_halted ? ship_effect.halt() : ship_effect.unhalt()

/datum/controller/subsystem/shuttle/stat_entry(msg)
	msg = "Shuttles:[shuttles.len], Ships:[ships.len], L:[registered_shuttle_landmarks.len][overmap_halted ? ", HALT" : ""]"
	return ..()

/datum/controller/subsystem/shuttle/proc/ship_by_type(type)
	for (var/obj/effect/overmap/visitable/ship/ship in ships)
		if (ship.type == type)
			return ship
	return null

/datum/controller/subsystem/shuttle/proc/request_transit_dock(datum/shuttle/shuttle)
	if(!istype(shuttle))
		CRASH("[shuttle] is not a shuttle")

	if(!shuttle.assigned_transit && !(shuttle in transit_requesters))
		transit_requesters += shuttle

/datum/controller/subsystem/shuttle/proc/generate_transit_landmark(datum/shuttle/shuttle)
	var/obj/effect/overmap/visitable/ship/landable/ship = shuttle.overmap_shuttle
	var/dock_angle = dir2angle(ship.fore_dir) + dir2angle(ship.port_dir) + 180
	var/dock_dir = angle2dir(dock_angle)

	var/transit_width = SHUTTLE_TRANSIT_BORDER * 2
	var/transit_height = SHUTTLE_TRANSIT_BORDER * 2

	var/datum/component/bounding/area/bounds = ship.GetComponent(/datum/component/bounding/area)

	switch(dock_dir)
		if(NORTH, SOUTH)
			transit_width += bounds.width
			transit_height += bounds.height
		if(EAST, WEST)
			transit_width += bounds.height
			transit_height += bounds.width

	var/transit_path = ship.get_transit_path_type()

	var/datum/turf_reservation/proposal = SSmapping.request_turf_block_reservation(
		transit_width,
		transit_height,
		z_size = 1,
		reservation_type = /datum/turf_reservation/transit,
		turf_type_override = transit_path
	)

	if(!istype(proposal))
		log_debug("generate_transit_landmark() failed to get a block reservation from mapping system")
		return FALSE

	var/turf/bottomleft = proposal.bottom_left_turfs[1]
	var/coords = bounds.return_coords(0, 0, dock_dir)

	/*  0------2
	*   |      |
	*   |      |
	*   |  x   |
	*   3------1
	*/
	var/x0 = coords[1]
	var/y0 = coords[2]
	var/x1 = coords[3]
	var/y1 = coords[4]

	// Then we want the point closest to -infinity,-infinity
	var/xmin = min(x0, x1)
	var/ymin = min(y0, y1)

	// Then invert the numbers
	var/transit_x = bottomleft.x + SHUTTLE_TRANSIT_BORDER + abs(xmin)
	var/transit_y = bottomleft.y + SHUTTLE_TRANSIT_BORDER + abs(ymin)

	var/turf/midpoint = locate(transit_x, transit_y, bottomleft.z)

	if(!midpoint)
		log_mapping("generate_transit_landmark() failed to get a midpoint")
		return FALSE

	var/area/shuttle/transit/new_area = new()
	new_area.contents = proposal.reserved_turfs
	var/obj/effect/shuttle_landmark/transit/new_transit_landmark = new(midpoint)
	new_transit_landmark.reserved_area = proposal
	new_transit_landmark.name = "Transit for [ship.name]"
	new_transit_landmark.owner = shuttle
	new_transit_landmark.assigned_area = new_area

	new_transit_landmark.set_dir(angle2dir(dock_angle))

	transit_utilized += (proposal.width + 2) * (proposal.height + 2)
	shuttle.assigned_transit = new_transit_landmark
	RegisterSignal(proposal, COMSIG_QDELETING, PROC_REF(transit_space_clearing))

	return new_transit_landmark

/datum/controller/subsystem/shuttle/proc/transit_space_clearing(datum/turf_reservation/source)
	SIGNAL_HANDLER
	transit_utilized -= (source.width + 2) * (source.height + 2)

/// Returns an assoc list of [obj/effect/shuttle_landmark] -> [list of turfs] that overlap the given bounding box
/datum/controller/subsystem/shuttle/proc/get_dock_overlap(x0, y0, x1, y1, z)
	. = list()
	var/list/shuttle_landmark_cache = registered_shuttle_landmarks
	for(var/cache_tag in shuttle_landmark_cache)
		var/obj/effect/shuttle_landmark/lm = shuttle_landmark_cache[cache_tag]
		if(!lm || lm.z != z)
			continue
		var/datum/component/bounding/bfs/lm_bound_comp = lm.GetComponent(/datum/component/bounding/bfs)
		var/list/bounds = lm_bound_comp.return_coords()
		var/list/overlap = get_overlap(x0, y0, x1, y1, bounds[1], bounds[2], bounds[3], bounds[4])
		var/list/xs = overlap[1]
		var/list/ys = overlap[2]
		if(xs.len && ys.len)
			.[lm] = overlap

#undef MAX_TRANSIT_REQUEST_RETRIES
#undef MAX_TRANSIT_TILE_COUNT
#undef SOFT_TRANSIT_RESERVATION_THRESHOLD
