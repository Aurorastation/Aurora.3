/datum/map_template
	var/name = "Default Template Name"
	var/id = null // All maps that should be loadable during runtime need an id
	var/width = 0
	var/height = 0
	var/list/mappaths = null
	var/loaded = 0 // Times loaded this round
	var/datum/parsed_map/cached_map
	var/keep_cached_map = FALSE

	///if true, turfs loaded from this template are placed on top of the turfs already there, defaults to TRUE
	var/should_place_on_top = TRUE

	///if true, creates a list of all atoms created by this template loading, defaults to FALSE
	var/returns_created_atoms = FALSE

	///the list of atoms created by this template being loaded, only populated if returns_created_atoms is TRUE
	var/list/created_atoms = list()
	//make sure this list is accounted for/cleared if you request it from ssatoms!

	var/list/shuttles_to_initialise = list()
	var/list/subtemplates_to_spawn
	var/base_turf_for_zs = null
	var/accessibility_weight = 0
	var/template_flags = TEMPLATE_FLAG_ALLOW_DUPLICATES

	///A list of groups, as strings, that this template belongs to. When adding new map templates, try to keep this balanced on the CI execution time, or consider adding a new one
	///ONLY IF IT'S THE LONGEST RUNNING CI POD AND THEY ARE ALREADY BALANCED
	var/list/unit_test_groups = list()

/datum/map_template/New(var/list/paths = null, rename = null, cache = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	. = ..()
	if(paths && !islist(paths))
		crash_with("Non-list paths passed into map template constructor.")
	if(paths)
		mappaths = paths
	for(var/mappath in mappaths)
		preload_size(mappath, cache)
	if(rename)
		name = rename

/datum/map_template/proc/preload_size(path, cache = FALSE)
	var/datum/parsed_map/parsed = new(file(path))
	var/bounds = parsed?.bounds
	if(bounds)
		width = bounds[MAP_MAXX] // Assumes all templates are rectangular, have a single Z level, and begin at 1,1,1
		height = bounds[MAP_MAXY]
		if(cache)
			cached_map = parsed
	return bounds

/datum/map_template/proc/initTemplateBounds(list/bounds)
	if (!bounds) //something went wrong
		stack_trace("[name] template failed to initialize correctly!")
		return

	var/list/atom/movable/movables = list()
	var/list/area/areas = list()

	var/list/turfs = block(
		locate(
			bounds[MAP_MINX],
			bounds[MAP_MINY],
			bounds[MAP_MINZ]
			),
		locate(
			bounds[MAP_MAXX],
			bounds[MAP_MAXY],
			bounds[MAP_MAXZ]
			)
		)
	for(var/turf/current_turf as anything in turfs)
		var/area/current_turfs_area = current_turf.loc
		areas |= current_turfs_area
		if(!SSatoms.initialized)
			continue

		for(var/movable_in_turf in current_turf)
			movables += movable_in_turf

	SSatoms.InitializeAtoms(areas + turfs + movables, returns_created_atoms ? created_atoms : null)

/datum/map_template/proc/load_new_z(var/no_changeturf = TRUE)
	var/x = round((world.maxx - width) * 0.5) + 1
	var/y = round((world.maxy - height) * 0.5) + 1

	//Since SSicon_smooth.add_to_queue() manually wakes the subsystem, we have to use enable/disable.
	SSicon_smooth.can_fire = FALSE
	var/initial_z = world.maxz + 1

	for (var/mappath in mappaths)
		var/datum/parsed_map/parsed = load_map(
			file(mappath),
			x,
			y,
			world.maxz + 1,
			no_changeturf = (SSatoms.initialized == INITIALIZATION_INSSATOMS),
			place_on_top = should_place_on_top,
			new_z = TRUE,
		)
		var/list/bounds = parsed.bounds
		if(!bounds)
			return FALSE

		//initialize things that are normally initialized after map load
		initTemplateBounds(bounds)
		smooth_zlevel(world.maxz)
		after_load(world.maxz)

		log_game("Z-level [name] loaded at [x], [y], [world.maxz]")
		message_admins("Z-level [name] loaded at [x], [y], [world.maxz]")
		loaded++

	for(var/light_z = initial_z to world.maxz)
		create_lighting_overlays_zlevel(light_z)

	SSicon_smooth.can_fire = TRUE

////////////////////////////////
	var/shuttle_state = pre_init_shuttles()
	init_shuttles(shuttle_state)

	return locate(world.maxx/2, world.maxy/2, world.maxz)

/datum/map_template/proc/pre_init_shuttles()
	. = SSshuttle.block_queue
	SSshuttle.block_queue = TRUE

/datum/map_template/proc/init_shuttles(var/pre_init_state)
	for (var/shuttle_type in shuttles_to_initialise)
		LAZYADD(SSshuttle.shuttles_to_initialize, shuttle_type) // queue up for init.
	SSshuttle.block_queue = pre_init_state
	SSshuttle.clear_init_queue() // We will flush the queue unless there were other blockers, in which case they will do it.

/datum/map_template/proc/init_atoms(var/list/atoms)
	if (SSatoms.initialized == INITIALIZATION_INSSATOMS)
		return // let proper initialisation handle it later

	var/list/turf/turfs = list()
	var/list/obj/machinery/atmospherics/atmos_machines = list()
	var/list/obj/machinery/machines = list()
	var/list/obj/structure/cable/cables = list()
	var/list/obj/machinery/power/apc/apcs = list()

	for(var/atom/A as anything in atoms)
		if(isnull(A) || (A.flags_1 & INITIALIZED_1))
			atoms -= A
			continue
		if(istype(A, /turf))
			turfs += A
			continue
		if(istype(A, /obj/structure/cable))
			cables += A
			continue
		if(istype(A,/obj/effect/landmark/map_load_mark))
			LAZYADD(subtemplates_to_spawn, A)
			continue

		//Not mutually exclusive anymore section, no continue here, keep checking

		if(istype(A, /obj/machinery/atmospherics))
			atmos_machines += A
		if(istype(A, /obj/machinery))
			machines += A
		if(istype(A, /obj/machinery/power/apc))
			apcs += A

	var/notsuspended
	if(!SSmachinery.can_fire)
		SSmachinery.can_fire = FALSE
		notsuspended = TRUE

	SSatoms.InitializeAtoms(atoms) // The atoms should have been getting queued there. This flushes the queue.

	SSmachinery.setup_powernets_for_cables(cables)
	SSmachinery.setup_atmos_machinery(atmos_machines)
	if(notsuspended)
		SSmachinery.can_fire = TRUE

	for (var/i in apcs)
		var/obj/machinery/power/apc/apc = i
		apc.update() // map-loading areas and APCs is weird, okay

	for (var/i in machines)
		var/obj/machinery/machine = i
		machine.power_change()

	for (var/i in turfs)
		var/turf/T = i
		T.post_change(FALSE)
		if(template_flags & TEMPLATE_FLAG_NO_RUINS)
			T.turf_flags |= TURF_NORUINS
		if(istype(T,/turf/simulated))
			var/turf/simulated/sim = T
			sim.update_air_properties()

/datum/map_template/proc/load(turf/T, centered = FALSE)
	if(centered)
		T = locate(T.x - round(width/2) , T.y - round(height/2) , T.z)
	if(!T)
		return
	if((T.x+width) - 1 > world.maxx)
		return
	if((T.y+height) - 1 > world.maxy)
		return

	for(var/mappath in mappaths)

		// Accept cached maps, but don't save them automatically - we don't want
		// ruins clogging up memory for the whole round.
		var/datum/parsed_map/parsed = cached_map || new(file(mappath))
		cached_map = keep_cached_map ? parsed : null

		var/shuttle_state = pre_init_shuttles()

		//Since SSicon_smooth.add_to_queue() manually wakes the subsystem, we have to use enable/disable.
		SSicon_smooth.can_fire = FALSE

		if(!parsed.load(
			T.x,
			T.y,
			T.z,
			crop_map = TRUE,
			no_changeturf = (SSatoms.initialized == INITIALIZATION_INSSATOMS),
			place_on_top = should_place_on_top,
		))
			continue

		var/list/bounds = parsed.bounds
		if(!bounds)
			continue

		//initialize things that are normally initialized after map load
		initTemplateBounds(bounds)

		//initialize things that are normally initialized after map load
		init_shuttles(shuttle_state)

		SSicon_smooth.can_fire = TRUE
		message_admins("[name] loaded at [T.x], [T.y], [T.z]")
		log_game("[name] loaded at [T.x], [T.y], [T.z]")

	return TRUE

/datum/map_template/proc/get_affected_turfs(turf/T, centered = FALSE)
	var/turf/placement = T
	if(centered)
		var/turf/corner = locate(placement.x - round(width / 2), placement.y - round(height / 2), placement.z)
		if(corner)
			placement = corner
	return block(placement, locate(placement.x + width-1, placement.y + height-1, placement.z))

/datum/map_template/proc/extend_bounds_if_needed(var/list/existing_bounds, var/list/new_bounds)
	var/list/bounds_to_combine = existing_bounds.Copy()
	for (var/min_bound in list(MAP_MINX, MAP_MINY, MAP_MINZ))
		bounds_to_combine[min_bound] = min(existing_bounds[min_bound], new_bounds[min_bound])
	for (var/max_bound in list(MAP_MAXX, MAP_MAXY, MAP_MAXZ))
		bounds_to_combine[max_bound] = max(existing_bounds[max_bound], new_bounds[max_bound])
	return bounds_to_combine

/datum/map_template/proc/after_load(z)
	for(var/obj/effect/landmark/map_load_mark/mark in subtemplates_to_spawn)
		subtemplates_to_spawn -= mark
		if(LAZYLEN(mark.templates))
			var/template = pick(mark.templates)
			var/datum/map_template/M = new template()
			M.load(get_turf(mark), TRUE)
			qdel(mark)
	LAZYCLEARLIST(subtemplates_to_spawn)
