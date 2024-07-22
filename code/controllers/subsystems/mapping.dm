SUBSYSTEM_DEF(mapping)
	name = "Mapping"
	init_order = INIT_ORDER_AWAY_MAPS
	flags = SS_NO_FIRE

	var/list/map_templates = list()
	var/list/space_ruins_templates = list()
	var/list/exoplanet_ruins_templates = list()
	var/list/away_sites_templates = list()
	var/list/submaps = list()
	var/list/submap_archetypes = list()

	var/list/used_turfs = list() //list of turf = datum/turf_reservation -- Currently unused

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
	// Load templates and build away sites.
	preloadTemplates()
	for(var/atype in subtypesof(/singleton/submap_archetype))
		submap_archetypes[atype] = new atype

	SSatlas.current_map.build_away_sites()
	SSatlas.current_map.build_exoplanets()

	return SS_INIT_SUCCESS

/datum/controller/subsystem/mapping/Recover()
	flags |= SS_NO_INIT
	map_templates = SSmapping.map_templates
	space_ruins_templates = SSmapping.space_ruins_templates
	exoplanet_ruins_templates = SSmapping.exoplanet_ruins_templates
	away_sites_templates = SSmapping.away_sites_templates

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
			var/is_banned = FALSE
			if(banned_maps.Find(MT.mappath))
				is_banned = TRUE
				break
			if (is_banned)
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
