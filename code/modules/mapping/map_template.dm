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
	var/static/dmm_suite/maploader = new
	var/list/shuttles_to_initialise = list()
	var/base_turf_for_zs = null
	var/accessibility_weight = 0
	var/template_flags = TEMPLATE_FLAG_ALLOW_DUPLICATES

	///A list of groups, as strings, that this template belongs to. When adding new map templates, try to keep this balanced on the CI execution time, or consider adding a new one
	///ONLY IF IT'S THE LONGEST RUNNING CI POD AND THEY ARE ALREADY BALANCED
	var/list/unit_test_groups = list()

/datum/map_template/New(path = null, rename = null, cache = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	. = ..()
	if(path)
		mappath = path
	if(mappath)
		preload_size(mappath, cache)
	if(rename)
		name = rename

/datum/map_template/proc/preload_size(path)
	var/list/bounds = list(1.#INF, 1.#INF, 1.#INF, -1.#INF, -1.#INF, -1.#INF)

	var/datum/map_load_metadata/M = maploader.load_map_impl(file(mappath), 1, 1, cropMap=FALSE, measureOnly=TRUE, no_changeturf=TRUE)
	if(M)
		bounds = extend_bounds_if_needed(bounds, M.bounds)
	else
		return FALSE

	width = bounds[MAP_MAXX] - bounds[MAP_MINX] + 1
	height = bounds[MAP_MAXY] - bounds[MAP_MINX] + 1
	return bounds

/datum/map_template/proc/load_new_z(var/no_changeturf = TRUE)
	var/x = round((world.maxx - width)/2)
	var/y = round((world.maxy - height)/2)
	var/initial_z = world.maxz + 1

	if (x < 1) x = 1
	if (y < 1) y = 1

	var/list/bounds = list(1.#INF, 1.#INF, 1.#INF, -1.#INF, -1.#INF, -1.#INF)
	var/list/atoms_to_initialise = list()
	var/shuttle_state = pre_init_shuttles()

	//Since SSicon_smooth.add_to_queue() manually wakes the subsystem, we have to use enable/disable.
	SSicon_smooth.can_fire = FALSE

	var/datum/space_level/base_level = null
	for(var/traits_for_level in traits)
		var/datum/space_level/level = SSmapping.add_new_zlevel(name, traits_for_level, contain_turfs = FALSE)
		if(!base_level)
			base_level = level
		GLOB.map_templates["[level.z_value]"] = src

	var/datum/map_load_metadata/M = maploader.load_map(file(mappath), x, y, base_level.z_value, no_changeturf = no_changeturf)

	if(M)
		bounds = extend_bounds_if_needed(bounds, M.bounds)
		atoms_to_initialise += M.atoms_to_initialise
	else
		SSicon_smooth.can_fire = TRUE
		return FALSE

	for (var/z_index = bounds[MAP_MINZ]; z_index <= bounds[MAP_MAXZ]; z_index++)
		if (accessibility_weight)
			SSatlas.current_map.accessible_z_levels[num2text(z_index)] = accessibility_weight
		if (base_turf_for_zs)
			SSatlas.current_map.base_turf_by_z[num2text(z_index)] = base_turf_for_zs
		SSatlas.current_map.player_levels |= z_index

	smooth_zlevel(world.maxz)
	require_area_resort()

	post_exoplanet_generation(bounds)

	//initialize things that are normally initialized after map load
	init_atoms(atoms_to_initialise)
	init_shuttles(shuttle_state)
	for(var/light_z = initial_z to world.maxz)
		create_lighting_overlays_zlevel(light_z)
	log_game("Z-level [name] loaded at [x], [y], [world.maxz]")
	message_admins("Z-level [name] loaded at [x], [y], [world.maxz]")
	SSicon_smooth.can_fire = TRUE
	loaded++

	return bounds

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
		else if(istype(A, /turf))
			turfs += A
		else if(istype(A, /obj/structure/cable))
			cables += A

		//Not mutually exclusive anymore section, pay close attention!
		if(istype(A, /obj/machinery))
			machines += A
			if(istype(A, /obj/machinery/atmospherics))
				atmos_machines += A
			else if(istype(A, /obj/machinery/power/apc))
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

	for (var/obj/machinery/power/apc/apc as anything in apcs)
		apc.update() // map-loading areas and APCs is weird, okay

	for (var/obj/machinery/machine as anything in machines)
		machine.power_change()

	for (var/turf/T as anything in turfs)
		T.post_change(FALSE)
		if(template_flags & TEMPLATE_FLAG_NO_RUINS)
			T.turf_flags |= TURF_NORUINS
		if(istype(T,/turf/simulated))
			var/turf/simulated/sim = T
			sim.update_air_properties()

/datum/map_template/proc/load(turf/T, centered = FALSE)
	if(centered)
		T = locate(T.x - round(width / 2) , T.y - round(height / 2) , T.z)
	if(!T)
		return
	if(T.x + width > world.maxx)
		return
	if(T.y + height > world.maxy)
		return

	var/list/atoms_to_initialise = list()
	var/shuttle_state = pre_init_shuttles()

	//Since SSicon_smooth.add_to_queue() manually wakes the subsystem, we have to use enable/disable.
	SSicon_smooth.can_fire = FALSE

	var/datum/map_load_metadata/M = maploader.load_map(file(mappath), T.x, T.y, T.z, cropMap=TRUE)
	if(M)
		atoms_to_initialise += M.atoms_to_initialise
	else
		SSicon_smooth.can_fire = TRUE
		return FALSE

	//initialize things that are normally initialized after map load
	init_atoms(atoms_to_initialise)
	init_shuttles(shuttle_state)

	SSicon_smooth.can_fire = TRUE
	message_admins("[name] loaded at [T.x], [T.y], [T.z]")
	log_game("[name] loaded at [T.x], [T.y], [T.z]")
	return TRUE

/datum/map_template/proc/get_affected_turfs(turf/T, centered = FALSE)
	SHOULD_NOT_SLEEP(TRUE)
	RETURN_TYPE(/list/turf)

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

/**
 * In case the away site spawns with an exoplanet, use this proc to handle any post-generation.
 * For example, turning market turfs into exoplanet turfs with themes.
 */
/datum/map_template/proc/post_exoplanet_generation(bounds)
	return
