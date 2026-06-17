SUBSYSTEM_DEF(mapping)
	name = "Mapping"
	init_order = INIT_ORDER_AWAY_MAPS
	flags = SS_NO_FIRE

	var/list/map_templates = list()
	var/list/space_ruins_templates = list()
	var/list/exoplanet_ruins_templates = list()
	var/list/away_sites_templates = list()
	var/list/submaps = list()

	var/list/used_turfs = list() //list of turf = datum/turf_reservation -- Currently unused

	/// List of z level (as number) -> list of all z levels vertically connected to ours
	/// Useful for fast grouping lookups and such
	var/list/z_level_to_stack = list()

	/// List of z level (as number) -> plane offset of that z level.
	/// Used to maintain the plane cube.
	var/list/z_level_to_plane_offset = list()

	/// List of z level (as number) -> the lowest plane offset in that z stack.
	var/list/z_level_to_lowest_plane_offset = list()

	/// Assoc list of string plane values to their true, non-offset representation.
	var/list/plane_offset_to_true

	/// Assoc list of true string plane values to a list of all potential offset planes.
	var/list/true_to_offset_planes

	/// Assoc list of string plane values to the plane's offset value.
	var/list/plane_to_offset

	/// List of planes that do not allow for offsetting.
	var/list/plane_offset_blacklist

	/// List of render targets that do not allow for offsetting.
	var/list/render_offset_blacklist

	/// List of plane masters that are of critical priority.
	var/list/critical_planes

	/// The largest plane offset generated so far.
	var/max_plane_offset = 0

	/// TRUE after the base plane offset lookup lists have been generated.
	var/plane_offset_lists_initialized = FALSE

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
	initialize_plane_offset_lists()
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
	z_level_to_plane_offset = SSmapping.z_level_to_plane_offset
	z_level_to_stack = SSmapping.z_level_to_stack
	z_level_to_lowest_plane_offset = SSmapping.z_level_to_lowest_plane_offset
	plane_offset_to_true = SSmapping.plane_offset_to_true
	true_to_offset_planes = SSmapping.true_to_offset_planes
	plane_to_offset = SSmapping.plane_to_offset
	plane_offset_blacklist = SSmapping.plane_offset_blacklist
	render_offset_blacklist = SSmapping.render_offset_blacklist
	critical_planes = SSmapping.critical_planes
	max_plane_offset = SSmapping.max_plane_offset
	plane_offset_lists_initialized = SSmapping.plane_offset_lists_initialized

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
	initialize_plane_offset_lists()

	// First, add the z
	z_list += new_z

	// Then we build our lookup lists
	var/z_value = new_z.z_value

	// We always grow bottom-up, but use z_value for safety around manual map loads.
	if(z_level_to_plane_offset.len < z_value)
		z_level_to_plane_offset.len = z_value
	if(z_level_to_lowest_plane_offset.len < z_value)
		z_level_to_lowest_plane_offset.len = z_value
	if(z_level_to_stack.len < z_value)
		z_level_to_stack.len = z_value

	// Bare minimum we have ourselves
	z_level_to_stack[z_value] = list(z_value)
	// 0 is the default value. Connected stacks update it below.
	z_level_to_plane_offset[z_value] = 0
	z_level_to_lowest_plane_offset[z_value] = 0

	if(new_z.traits?[ZTRAIT_DOWN])
		update_plane_tracking(new_z)

/// Initializes the plane cube lookup tables. Atlas can add z-levels before this subsystem's Initialize(), so manage_z_level() also calls this.
/datum/controller/subsystem/mapping/proc/initialize_plane_offset_lists()
	if(plane_offset_lists_initialized)
		return

	z_level_to_plane_offset ||= list()
	z_level_to_lowest_plane_offset ||= list()
	z_level_to_stack ||= list()
	plane_offset_to_true = list()
	true_to_offset_planes = list()
	plane_to_offset = list()
	plane_offset_blacklist = list()
	render_offset_blacklist = list()
	critical_planes = list()
	max_plane_offset = 0

	// VERY special cases for FLOAT_PLANE, so it will be treated as expected by plane management logic.
	plane_offset_to_true["[FLOAT_PLANE]"] = FLOAT_PLANE
	true_to_offset_planes["[FLOAT_PLANE]"] = list(FLOAT_PLANE)
	plane_to_offset["[FLOAT_PLANE]"] = 0
	plane_offset_blacklist["[FLOAT_PLANE]"] = TRUE

	create_plane_offsets(0, 0)
	plane_offset_lists_initialized = TRUE

/// Walks down a connected z-stack and assigns plane offsets, with the top visible level at offset 0.
/datum/controller/subsystem/mapping/proc/update_plane_tracking(datum/space_level/update_with)
	var/plane_offset = 0
	var/datum/space_level/current_z = update_with
	var/list/datum/space_level/levels_checked = list()
	var/list/z_stack = list()

	while(current_z)
		var/z_level = current_z.z_value
		z_stack += z_level
		z_level_to_plane_offset[z_level] = plane_offset
		levels_checked += current_z

		if(!current_z.traits?[ZTRAIT_DOWN])
			break

		if(z_level <= 1)
			stack_trace("Z-level [z_level] is marked as having a level below it, but no lower managed z-level exists.")
			break

		current_z = z_list[z_level - 1]
		if(!current_z)
			stack_trace("Z-level [z_level] is marked as having a level below it, but z-level [z_level - 1] is not managed.")
			break

		plane_offset += 1

	for(var/datum/space_level/level_to_update as anything in levels_checked)
		z_level_to_lowest_plane_offset[level_to_update.z_value] = plane_offset
		z_level_to_stack[level_to_update.z_value] = z_stack

	var/old_max = max_plane_offset
	max_plane_offset = max(max_plane_offset, plane_offset)
	if(max_plane_offset == old_max)
		return

	generate_offset_lists(old_max + 1, max_plane_offset)
	SEND_SIGNAL(src, COMSIG_PLANE_OFFSET_INCREASE, old_max, max_plane_offset)

	if(max_plane_offset > MAX_EXPECTED_Z_DEPTH)
		stack_trace("Loaded a map deeper than the expected z depth. Multiz visual preference boundaries may not cover all offsets.")

/// Takes an offset to generate misc lists to, and a base to start from.
/datum/controller/subsystem/mapping/proc/generate_offset_lists(gen_from, new_offset)
	create_plane_offsets(gen_from, new_offset)
	for(var/offset in gen_from to new_offset)
		GLOB.starlight_objects += starlight_object(offset)
		GLOB.starlight_overlays += starlight_overlay(offset)

/datum/controller/subsystem/mapping/proc/create_plane_offsets(gen_from, new_offset)
	for(var/plane_offset in gen_from to new_offset)
		for(var/atom/movable/screen/plane_master/master_type as anything in subtypesof(/atom/movable/screen/plane_master) - /atom/movable/screen/plane_master/rendering_plate)
			var/plane_to_use = initial(master_type.plane)
			var/string_real = "[plane_to_use]"

			var/offset_plane = GET_NEW_PLANE(plane_to_use, plane_offset)
			var/string_plane = "[offset_plane]"

			if(initial(master_type.offsetting_flags) & BLOCKS_PLANE_OFFSETTING)
				plane_offset_blacklist[string_plane] = TRUE
				var/render_target = initial(master_type.render_target)
				if(!render_target)
					render_target = get_plane_master_render_base(initial(master_type.name))
				render_offset_blacklist[render_target] = TRUE
				if(plane_offset != 0)
					continue

			if(initial(master_type.critical) & PLANE_CRITICAL_DISPLAY)
				critical_planes[string_plane] = TRUE

			plane_offset_to_true[string_plane] = plane_to_use
			plane_to_offset[string_plane] = plane_offset

			if(!true_to_offset_planes[string_real])
				true_to_offset_planes[string_real] = list()

			true_to_offset_planes[string_real] |= offset_plane

/// Takes a turf or a z level, and returns a list of all the z levels that are connected to it.
/datum/controller/subsystem/mapping/proc/get_connected_levels(turf/connected)
	var/z_level = connected
	if(isturf(z_level))
		z_level = connected.z
	return z_level_to_stack[z_level]

//Placeholder for now
/datum/controller/subsystem/mapping/proc/get_reservation_from_turf(turf/T)
	RETURN_TYPE(/datum/turf_reservation)
	return used_turfs[T]


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
