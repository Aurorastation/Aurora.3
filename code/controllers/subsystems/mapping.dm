SUBSYSTEM_DEF(mapping)
	name = "Mapping"
	init_order = INIT_ORDER_AWAY_MAPS
	flags = SS_NO_FIRE

	var/list/map_templates = list()
	var/list/space_ruins_templates = list()
	var/list/exoplanet_ruins_templates = list()
	var/list/away_sites_templates = list()
	var/list/submaps = list()

	/// Not actually unused turfs they're unused but reserved for use for whatever requests them. "[zlevel_of_turf]" = list(turfs)
	var/list/unused_turfs = list()
	/// List of actual datum/turf_reservations - reservation-centric
	var/list/turf_reservations = list()
	/// List of turfs that are currently reserved and in use - turf-centric, used to get the reservations from turfs
	var/list/used_turfs = list()
	var/list/reservation_ready = list()
	var/clearing_reserved_turfs = FALSE
	var/num_of_res_levels = 0

	/// List of z level (as number) -> list of all z levels vertically connected to ours
	/// Useful for fast grouping lookups and such
	var/list/z_level_to_stack = list()

	///list of all z level datums in the order of their z (z level 1 is at index 1, etc.)
	var/list/datum/space_level/z_list = list()

	///list of all z level indices that form multiz connections and whether theyre linked up or down.
	///list of lists, inner lists are of the form: list("up or down link direction" = TRUE)
	var/list/multiz_levels = list()

	/// list of traits and their associated z leves
	var/list/z_trait_levels = list()

	/// True when in the process of adding a new Z-level, global locking
	var/adding_new_zlevel = FALSE

/datum/controller/subsystem/mapping/Initialize(timeofday)
	//If we're in fastboot and not spawning exoplanets or awaysites
	//this is different from TG and Bay, which always preload, but it saves a lot of time for us
	//so we'll do it this way and hope for the best
	if(!GLOB.config.fastboot || GLOB.config.exoplanets["enable_loading"] || GLOB.config.awaysites["enable_loading"])
		// Load templates and build away sites.
		preloadTemplates()

		SSatlas.current_map.build_away_sites()
		SSatlas.current_map.build_exoplanets()

	return SS_INIT_SUCCESS

/datum/controller/subsystem/mapping/Recover()
	flags |= SS_NO_INIT
	map_templates = SSmapping.map_templates
	space_ruins_templates = SSmapping.space_ruins_templates
	exoplanet_ruins_templates = SSmapping.exoplanet_ruins_templates
	away_sites_templates = SSmapping.away_sites_templates
	unused_turfs = SSmapping.unused_turfs
	turf_reservations = SSmapping.turf_reservations
	used_turfs = SSmapping.used_turfs
	reservation_ready = SSmapping.reservation_ready
	clearing_reserved_turfs = SSmapping.clearing_reserved_turfs
	num_of_res_levels = SSmapping.num_of_res_levels

/datum/controller/subsystem/mapping/proc/preloadTemplates(path = "maps/templates/") //see master controller setup
	var/list/filelist = flist(path)
	for(var/map in filelist)
		var/datum/map_template/T = new(path = "[path][map]", rename = "[map]")
		map_templates[T.id] = T
	preloadBlacklistableTemplates()

/datum/controller/subsystem/mapping/proc/preloadBlacklistableTemplates()
	// Still supporting bans by filename
	var/list/banned_exoplanet_dmms = generateMapList("config/exoplanet_ruin_blacklist.txt")
	var/list/banned_space_dmms = generateMapList("config/space_ruin_blacklist.txt")
	var/list/banned_away_site_dmms = generateMapList("config/away_site_blacklist.txt")

	if (!banned_exoplanet_dmms || !banned_space_dmms || !banned_away_site_dmms)
		log_admin("One or more map blacklist files are not present in the config directory!")

	var/list/banned_maps = list() + banned_exoplanet_dmms + banned_space_dmms + banned_away_site_dmms

	for(var/item in sortList(subtypesof(/datum/map_template), GLOBAL_PROC_REF(cmp_ruincost_priority)))
		var/datum/map_template/map_template_type = item
		// screen out the abstract subtypes
		if(!initial(map_template_type.id))
			continue
		var/datum/map_template/MT = new map_template_type()

		if (banned_maps)
			if(banned_maps.Find(MT.mappath))
				continue

		map_templates[MT.id] = MT

		// This is nasty..
		if(istype(MT, /datum/map_template/ruin/exoplanet))
			exoplanet_ruins_templates[MT.id] = MT
		else if(istype(MT, /datum/map_template/ruin/space))
			space_ruins_templates[MT.id] = MT
		else if(istype(MT, /datum/map_template/ruin/away_site))
			away_sites_templates[MT.id] = MT

/datum/controller/subsystem/mapping/proc/generate_linkages_for_z_level(z_level)
	if(!isnum(z_level) || z_level <= 0)
		return FALSE

	if(multiz_levels.len < z_level)
		multiz_levels.len = z_level

	var/z_above = level_trait(z_level, ZTRAIT_UP)
	var/z_below = level_trait(z_level, ZTRAIT_DOWN)
	if(!(z_above == TRUE || z_above == FALSE || z_above == null) || !(z_below == TRUE || z_below == FALSE || z_below == null))
		stack_trace("Warning, numeric mapping offsets are deprecated. Instead, mark z level connections by setting UP/DOWN to true if the connection is allowed")
	multiz_levels[z_level] = new /list(LARGEST_Z_LEVEL_INDEX)
	multiz_levels[z_level][Z_LEVEL_UP] = !!z_above
	multiz_levels[z_level][Z_LEVEL_DOWN] = !!z_below

/// Takes a z level datum, and tells the mapping subsystem to manage it
/// Also handles things like plane offset generation, and other things that happen on a z level to z level basis
/datum/controller/subsystem/mapping/proc/manage_z_level(datum/space_level/new_z, filled_with_space, contain_turfs = TRUE)
	// First, add the z
	z_list += new_z

	// Then we build our lookup lists
	var/z_value = new_z.z_value

	z_level_to_stack.len += 1
	// Bare minimum we have ourselves
	z_level_to_stack[z_value] = list(z_value)

/datum/controller/subsystem/mapping/proc/get_reservation_from_turf(turf/T)
	RETURN_TYPE(/datum/turf_reservation)
	return used_turfs[T]

/// Adds a new reservation z level. A bit of space that can be handed out on request
/// Of note, reservations default to transit turfs, to make their most common use, shuttles, faster
/datum/controller/subsystem/mapping/proc/add_reservation_zlevel(for_shuttles)
	num_of_res_levels++
	return add_new_zlevel("Transit/Reserved #[num_of_res_levels]", list(ZTRAIT_RESERVED = TRUE), contain_turfs = FALSE)

/// Sets up a z level as reserved
/// This is not for wiping reserved levels, use wipe_reservations() for that.
/// If this is called after SSatom init, it will call Initialize on all turfs on the passed z, as its name promises
/datum/controller/subsystem/mapping/proc/initialize_reserved_level(z)
	UNTIL(!clearing_reserved_turfs) //regardless, lets add a check just in case.
	clearing_reserved_turfs = TRUE //This operation will likely clear any existing reservations, so lets make sure nothing tries to make one while we're doing it.

	if(!level_trait(z, ZTRAIT_RESERVED))
		clearing_reserved_turfs = FALSE
		CRASH("Invalid z level prepared for reservations.")

	var/min_x = SHUTTLE_TRANSIT_BORDER
	var/min_y = SHUTTLE_TRANSIT_BORDER
	var/max_x = world.maxx - SHUTTLE_TRANSIT_BORDER
	var/max_y = world.maxy - SHUTTLE_TRANSIT_BORDER
	if(min_x > max_x || min_y > max_y)
		clearing_reserved_turfs = FALSE
		CRASH("World bounds are too small for dynamic reservations with SHUTTLE_TRANSIT_BORDER [SHUTTLE_TRANSIT_BORDER].")

	var/list/reserved_block = block(locate(min_x, min_y, z), locate(max_x, max_y, z))
	var/list/prepared_block = list()
	var/area/space/space_area = locate(/area/space)
	for(var/turf/T as anything in reserved_block)
		var/turf/reservation_turf = reset_turf_for_reservation(T, space_area)
		if(!reservation_turf)
			continue
		reservation_turf.turf_flags = (reservation_turf.turf_flags | UNUSED_RESERVATION_TURF) & ~RESERVATION_TURF
		prepared_block += reservation_turf
		CHECK_TICK

	unused_turfs["[z]"] = prepared_block
	reservation_ready["[z]"] = TRUE
	clearing_reserved_turfs = FALSE

/// Requests a /datum/turf_reservation based on the given width, height, and z_size. You can specify a z_reservation to use a specific z level, or leave it null to use any z level.
/datum/controller/subsystem/mapping/proc/request_turf_block_reservation(
	width,
	height,
	z_size = 1,
	z_reservation = null,
	reservation_type = /datum/turf_reservation,
	turf_type_override = null,
)
	UNTIL(!clearing_reserved_turfs)

	var/datum/turf_reservation/reserve = new reservation_type
	if(!isnull(turf_type_override))
		reserve.turf_type = turf_type_override

	if(!z_reservation)
		for(var/reserved_z in levels_by_trait(ZTRAIT_RESERVED))
			if(!reservation_ready["[reserved_z]"])
				continue
			if(reserve.reserve(width, height, z_size, reserved_z))
				return reserve

		// If we didn't return at this point, theres a good chance we ran out of room on the existing reserved z levels, so lets try a new one
		var/datum/space_level/newReserved = add_reservation_zlevel()
		initialize_reserved_level(newReserved.z_value)
		if(reserve.reserve(width, height, z_size, newReserved.z_value))
			return reserve
	else
		if(!level_trait(z_reservation, ZTRAIT_RESERVED))
			qdel(reserve)
			return
		if(!reservation_ready["[z_reservation]"])
			initialize_reserved_level(z_reservation)
		if(reserve.reserve(width, height, z_size, z_reservation))
			return reserve

	QDEL_NULL(reserve)

/// Schedules a group of turfs to be handed back to the reservation system's control
/// If await is true, will sleep until the turfs are finished work
/datum/controller/subsystem/mapping/proc/reserve_turfs(list/turfs, await = FALSE)
	if(!islist(turfs) || !length(turfs))
		return
	if(await)
		return reset_turf_reservation_list(turfs)
	INVOKE_ASYNC(src, PROC_REF(reset_turf_reservation_list), turfs)

/datum/controller/subsystem/mapping/proc/reset_turf_reservation_list(list/turfs)
	var/area/space/space_area = locate(/area/space)
	while(length(turfs))
		var/turf/T = turfs[length(turfs)]
		turfs.len--
		if(!istype(T))
			continue
		var/turf/reservation_turf = reset_turf_for_reservation(T, space_area)
		if(!reservation_turf)
			continue
		reservation_turf.turf_flags = (reservation_turf.turf_flags | UNUSED_RESERVATION_TURF) & ~RESERVATION_TURF
		LAZYINITLIST(unused_turfs["[reservation_turf.z]"])
		unused_turfs["[reservation_turf.z]"] |= reservation_turf
		CHECK_TICK

/datum/controller/subsystem/mapping/proc/reset_turf_for_reservation(turf/T, area/target_area)
	RETURN_TYPE(/turf)
	if(!istype(T))
		return
	if(T.type != RESERVED_TURF_TYPE)
		T = T.ChangeTurf(RESERVED_TURF_TYPE, TRUE, FALSE, TRUE)
	if(target_area && T.loc != target_area)
		T.change_area(T.loc, target_area)
	T.baseturf = RESERVED_TURF_TYPE
	T.blocks_air = TRUE
	return T


/proc/generateMapList(filename)
	var/list/potentialMaps = list()
	var/list/Lines = world.file2list(filename)
	if(!Lines.len)
		return
	for (var/t in Lines)
		if (!t)
			continue
		t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue
		var/pos = findtext(t, " ")
		var/name = null
		if (pos)
			name = lowertext(copytext(t, 1, pos))
		else
			name = lowertext(t)
		if (!name)
			continue
		potentialMaps.Add(t)
	return potentialMaps
