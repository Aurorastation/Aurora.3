/datum/map_template
	var/name = "Default Template Name"
	var/id = null // All maps that should be loadable during runtime need an id
	var/width = 0
	var/height = 0
	var/mappath = null
	/**
	 * A list of traits for the zlevels of the map
	 *
	 * Each element is one zlevel, starting from the bottom one up
	 *
	 * Works the same as the variable in `/datum/map`
	 */
	var/list/traits = list(
		//Z1 (The define is a list), this is set as default because most templates only have a single zlevel
		ZTRAITS_AWAY
		)
	var/loaded = 0 // Times loaded this round
	var/datum/parsed_map/cached_map
	var/keep_cached_map = FALSE
	var/list/shuttles_to_initialise = list()
	var/base_turf_for_zs = null
	var/accessibility_weight = 0
	var/template_flags = TEMPLATE_FLAG_ALLOW_DUPLICATES

	///A list of groups, as strings, that this template belongs to. When adding new map templates, try to keep this balanced on the CI execution time, or consider adding a new one
	///ONLY IF IT'S THE LONGEST RUNNING CI POD AND THEY ARE ALREADY BALANCED
	var/list/unit_test_groups = list()

	///Default area associated with the map template
	var/default_area

	///if true, turfs loaded from this template are placed on top of the turfs already there, defaults to TRUE
	var/should_place_on_top = TRUE

	///if true, creates a list of all atoms created by this template loading, defaults to FALSE
	var/returns_created_atoms = FALSE

	///the list of atoms created by this template being loaded, only populated if returns_created_atoms is TRUE
	var/list/created_atoms = list()
	//make sure this list is accounted for/cleared if you request it from ssatoms!

/datum/map_template/New(path = null, rename = null, cache = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	. = ..()
	if(path)
		mappath = path
	if(mappath)
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

/datum/map_template/proc/load_new_z(secret = FALSE)
	var/x = round((world.maxx - width) * 0.5) + 1
	var/y = round((world.maxy - height) * 0.5) + 1

	var/shuttle_state = pre_init_shuttles()
	//Since SSicon_smooth.add_to_queue() manually wakes the subsystem, we have to use enable/disable.
	SSicon_smooth.can_fire = FALSE

	var/datum/space_level/level = SSmapping.add_new_zlevel(name, secret ? ZTRAITS_AWAY_SECRET : ZTRAITS_AWAY, contain_turfs = FALSE)
	var/datum/parsed_map/parsed = load_map(
		file(mappath),
		x,
		y,
		level.z_value,
		no_changeturf = (SSatoms.initialized == INITIALIZATION_INSSATOMS),
		place_on_top = should_place_on_top,
		new_z = TRUE,
	)
	var/list/bounds = parsed.bounds
	if(!bounds)
		SSicon_smooth.can_fire = TRUE
		return FALSE

	smooth_zlevel(world.maxz)
	require_area_resort()

	post_exoplanet_generation(bounds)

	//initialize things that are normally initialized after map load
	initTemplateBounds(bounds)
	init_shuttles(shuttle_state)
	create_lighting_overlays_zlevel(world.maxz)
	log_game("Z-level [name] loaded at [x], [y], [world.maxz]")
	message_admins("Z-level [name] loaded at [x], [y], [world.maxz]")
	SSicon_smooth.can_fire = TRUE

	return level

/datum/map_template/proc/pre_init_shuttles()
	. = SSshuttle.block_queue
	SSshuttle.block_queue = TRUE

/datum/map_template/proc/init_shuttles(var/pre_init_state)
	for (var/shuttle_type in shuttles_to_initialise)
		LAZYADD(SSshuttle.shuttles_to_initialize, shuttle_type) // queue up for init.
	SSshuttle.block_queue = pre_init_state
	SSshuttle.clear_init_queue() // We will flush the queue unless there were other blockers, in which case they will do it.

/datum/map_template/proc/initTemplateBounds(list/bounds)
	if (!bounds) //something went wrong
		stack_trace("[name] template failed to initialize correctly!")
		return

	var/list/area/areas = list()
	var/list/atom/movable/movables = list()
	var/list/obj/machinery/atmospherics/atmos_machines = list()
	var/list/obj/machinery/machines = list()
	var/list/obj/structure/cable/cables = list()
	var/list/obj/machinery/power/apc/apcs = list()

	var/list/turfs = block(
		bounds[MAP_MINX], bounds[MAP_MINY], bounds[MAP_MINZ],
		bounds[MAP_MAXX], bounds[MAP_MAXY], bounds[MAP_MAXZ]
	)

	for(var/turf/current_turf as anything in turfs)
		var/area/current_turfs_area = current_turf.loc
		areas |= current_turfs_area
		if(SSatoms.initialized == INITIALIZATION_INSSATOMS)
			continue

		for(var/atom/movable_in_turf as anything in current_turf)
			if(isnull(movable_in_turf) || (movable_in_turf.flags_1 & INITIALIZED_1))
				continue
			movables += movable_in_turf
			if(istype(movable_in_turf, /obj/structure/cable))
				cables += movable_in_turf
				continue
			if(istype(movable_in_turf, /obj/machinery))
				machines += movable_in_turf
				if(istype(movable_in_turf, /obj/machinery/atmospherics))
					atmos_machines += movable_in_turf
				if(istype(movable_in_turf, /obj/machinery/power/apc))
					apcs += movable_in_turf

	var/notsuspended
	if(!SSmachinery.can_fire)
		SSmachinery.can_fire = FALSE
		notsuspended = TRUE

	// Not sure if there is some importance here to make sure the area is in z
	// first or not.  Its defined In Initialize yet its run first in templates
	// BEFORE so... hummm
	SSmapping.reg_in_areas_in_z(areas)
	for (var/turf/T as anything in turfs)
		T.post_change(FALSE)
		if(template_flags & TEMPLATE_FLAG_NO_RUINS)
			T.turf_flags |= TURF_NORUINS
	if(!SSatoms.initialized)
		return

	SSatoms.InitializeAtoms(areas + turfs + movables, returns_created_atoms ? created_atoms : null)
	SSmachinery.setup_powernets_for_cables(cables)
	SSmachinery.setup_atmos_machinery(atmos_machines)

	if(notsuspended)
		SSmachinery.can_fire = TRUE

	for (var/obj/machinery/power/apc/apc as anything in apcs)
		apc.update() // map-loading areas and APCs is weird, okay

	for (var/obj/machinery/machine as anything in machines)
		machine.power_change()

	for (var/turf/T as anything in turfs)
		if(istype(T,/turf/simulated))
			var/turf/simulated/sim = T
			sim.update_air_properties()

		if(SSlighting.initialized) //don't generate lighting overlays before SSlighting in case these templates are loaded before
			var/area/A = T.loc
			if(A?.area_has_base_lighting)
				continue
			T.static_lighting_build_overlay()

/datum/map_template/proc/load(turf/T, centered = FALSE)
	if(centered)
		T = locate(T.x - round(width/2) , T.y - round(height/2) , T.z)
	if(!T)
		return
	if((T.x+width) - 1 > world.maxx)
		return
	if((T.y+height) - 1 > world.maxy)
		return

	// do this but for ZAS

	// // Cache for sonic speed
	// var/list/to_rebuild = SSair.adjacent_rebuild
	// // iterate over turfs in the border and clear them from active atmos processing
	// for(var/turf/border_turf as anything in CORNER_BLOCK_OFFSET(T, width + 2, height + 2, -1, -1))
	// 	SSair.remove_from_active(border_turf)
	// 	to_rebuild -= border_turf
	// 	for(var/turf/sub_turf as anything in border_turf.atmos_adjacent_turfs)
	// 		sub_turf.atmos_adjacent_turfs?.Remove(border_turf)
	// 	border_turf.atmos_adjacent_turfs?.Cut()

	var/shuttle_state = pre_init_shuttles()

	//Since SSicon_smooth.add_to_queue() manually wakes the subsystem, we have to use enable/disable.
	SSicon_smooth.can_fire = FALSE

	// Accept cached maps, but don't save them automatically - we don't want
	// ruins clogging up memory for the whole round.
	var/datum/parsed_map/parsed = cached_map || new(file(mappath))
	cached_map = keep_cached_map ? parsed : null

	var/list/turf_blacklist = list()
	update_blacklist(T, turf_blacklist)

	UNSETEMPTY(turf_blacklist)
	parsed.turf_blacklist = turf_blacklist
	if(!parsed.load(
		T.x,
		T.y,
		T.z,
		crop_map = TRUE,
		no_changeturf = (SSatoms.initialized == INITIALIZATION_INSSATOMS),
		place_on_top = should_place_on_top,
	))
		SSicon_smooth.can_fire = TRUE
		return

	var/list/bounds = parsed.bounds
	if(!bounds)
		SSicon_smooth.can_fire = TRUE
		return

	require_area_resort()

	post_exoplanet_generation(bounds)

	//initialize things that are normally initialized after map load
	initTemplateBounds(bounds)
	init_shuttles(shuttle_state)

	SSicon_smooth.can_fire = TRUE
	message_admins("[name] loaded at [T.x], [T.y], [T.z]")
	log_game("[name] loaded at [T.x],[T.y],[T.z]")
	return bounds

/datum/map_template/proc/post_load()
	return

/datum/map_template/proc/update_blacklist(turf/T, list/input_blacklist)
	return

/datum/map_template/proc/get_affected_turfs(turf/T, centered = FALSE)
	SHOULD_NOT_SLEEP(TRUE)
	RETURN_TYPE(/list/turf)

	var/turf/placement = T
	if(centered)
		var/turf/corner = locate(placement.x - round(width / 2), placement.y - round(height / 2), placement.z)
		if(corner)
			placement = corner
	return block(placement.x, placement.y, placement.z, placement.x+width-1, placement.y+height-1, placement.z)

/datum/map_template/proc/extend_bounds_if_needed(var/list/existing_bounds, var/list/new_bounds)
	var/list/bounds_to_combine = existing_bounds.Copy()
	for (var/min_bound in list(MAP_MINX, MAP_MINY, MAP_MINZ))
		bounds_to_combine[min_bound] = min(existing_bounds[min_bound], new_bounds[min_bound])
	for (var/max_bound in list(MAP_MAXX, MAP_MAXY, MAP_MAXZ))
		bounds_to_combine[max_bound] = max(existing_bounds[max_bound], new_bounds[max_bound])
	return bounds_to_combine

/// Takes in a type path, locates an instance of that type in the cached map, and calculates its offset from the origin of the map, returns this offset in the form list(x, y).
/datum/map_template/proc/discover_offset(obj/marker)
	var/key
	var/list/models = cached_map.grid_models
	for(key in models)
		if(findtext(models[key], "[marker]")) // Yay compile time checks
			break // This works by assuming there will ever only be one mobile dock in a template at most

	for(var/datum/grid_set/gset as anything in cached_map.gridSets)
		var/ycrd = gset.ycrd
		for(var/line in gset.gridLines)
			var/xcrd = gset.xcrd
			for(var/j in 1 to length(line) step cached_map.key_len)
				if(key == copytext(line, j, j + cached_map.key_len))
					return list(xcrd, ycrd)
				++xcrd
			--ycrd


//for your ever biggening badminnery kevinz000
//❤ - Cyberboss
/proc/load_new_z_level(file, name, secret)
	var/datum/map_template/template = new(file, name, TRUE)
	if(!template.cached_map || template.cached_map.check_for_errors())
		return FALSE
	template.load_new_z(secret)
	return TRUE

/**
 * In case the away site spawns with an exoplanet, use this proc to handle any post-generation.
 * For example, turning market turfs into exoplanet turfs with themes.
 */
/datum/map_template/proc/post_exoplanet_generation(bounds)
	return
