SUBSYSTEM_DEF(mapping)
	name = "Mapping"
	init_order = INIT_ORDER_MAPPING
	runlevels = ALL

	/// Whatever map is currently loaded. Null until SSmapping Initialize() starts.
	var/datum/map/current_map

	var/list/known_maps = list()

	var/list/mapload_callbacks = list()
	var/map_override	// If set, SSmapping will forcibly load this map. If the map does not exist, mapload will fail and SSmapping will panic.
	var/list/spawn_locations = list()

	var/datum/space_sector/current_sector
	var/list/possible_sectors = list()

	var/list/map_templates = list()
	var/list/space_ruins_templates = list()
	var/list/exoplanet_ruins_templates = list()
	var/list/away_sites_templates = list()
	var/list/submaps = list()

	var/datum/space_level/isolated_ruins_z //Created on demand during ruin loading.

	var/list/shuttle_templates = list()
	var/list/shelter_templates = list()
	var/list/holodeck_templates = list()

	var/list/areas_in_z = list()
	/// List of z level (as number) -> plane offset of that z level
	/// Used to maintain the plane cube
	var/list/z_level_to_plane_offset = list()
	/// List of z level (as number) -> list of all z levels vertically connected to ours
	/// Useful for fast grouping lookups and such
	var/list/z_level_to_stack = list()
	/// List of z level (as number) -> The lowest plane offset in that z stack
	var/list/z_level_to_lowest_plane_offset = list()
	// This pair allows for easy conversion between an offset plane, and its true representation
	// Both are in the form "input plane" -> output plane(s)
	/// Assoc list of string plane values to their true, non offset representation
	var/list/plane_offset_to_true
	/// Assoc list of true string plane values to a list of all potential offset planess
	var/list/true_to_offset_planes
	/// Assoc list of string plane to the plane's offset value
	var/list/plane_to_offset
	/// List of planes that do not allow for offsetting
	var/list/plane_offset_blacklist
	/// List of render targets that do not allow for offsetting
	var/list/render_offset_blacklist
	/// List of plane masters that are of critical priority
	var/list/critical_planes
	/// The largest plane offset we've generated so far
	var/max_plane_offset = 0

	var/loading_ruins = FALSE
	var/list/turf/unused_turfs = list() //Not actually unused turfs they're unused but reserved for use for whatever requests them. "[zlevel_of_turf]" = list(turfs)
	var/list/datum/turf_reservations //list of turf reservations
	var/list/used_turfs = list() //list of turf = datum/turf_reservation
	/// List of lists of turfs to reserve
	var/list/lists_to_reserve = list()

	var/list/reservation_ready = list()
	var/clearing_reserved_turfs = FALSE
	var/datum/space_level/transit
	var/datum/space_level/empty_space
	var/space_levels_so_far = 0

	var/station_start  // should only be used for maploading-related tasks

	///list of all z level datums in the order of their z (z level 1 is at index 1, etc.)
	var/list/datum/space_level/z_list = list()
	var/num_of_res_levels = 1

	///list of all z level indices that form multiz connections and whether theyre linked up or down.
	///list of lists, inner lists are of the form: list("up or down link direction" = TRUE)
	var/list/multiz_levels = list()

	/// list of traits and their associated z leves
	var/list/z_trait_levels = list()

	/// True when in the process of adding a new Z-level, global locking
	var/adding_new_zlevel = FALSE

	/// list of lazy templates that have been loaded
	var/list/loaded_lazy_templates

	///shows the default gravity value for each z level. recalculated when gravity generators change.
	///List in the form: list(z level num = max generator gravity in that z level OR the gravity level trait)
	var/list/gravity_by_z_level = list()

/datum/controller/subsystem/mapping/PreInit()
	. = ..()
	var/datum/map/M
	for (var/type in subtypesof(/datum/map))
		M = new type
		if (!M.path)
			log_mapping("Map [M.name] ([M.type]) has no path set, discarding.")
			qdel(M)
			continue

		known_maps[M.path] = M

	current_map = known_maps["sccv_horizon"] // Let's just assume we're on the Horizon for early init stuff

/datum/controller/subsystem/mapping/proc/get_selected_map()
	. = "sccv_horizon"
	if (GLOB.config.override_map)
		if (known_maps[GLOB.config.override_map])
			. = GLOB.config.override_map
			log_mapping("Using configured map.")
		else
			log_config("-- WARNING: CONFIGURED MAP DOES NOT EXIST, IGNORING! --")
			log_mapping("-- WARNING: CONFIGURED MAP DOES NOT EXIST, IGNORING! --")

/datum/controller/subsystem/mapping/Initialize(timeofday)
	if(initialized)
		return SS_INIT_SUCCESS
#ifdef DEFAULT_MAP
	map_override = DEFAULT_MAP
#else
	map_override = get_selected_map()
#endif
	load_world()
	InitializeSectors()
	setup_sector()
	setup_spawnpoints()
	//If we're in fastboot and not spawning exoplanets or awaysites
	//this is different from TG and Bay, which always preload, but it saves a lot of time for us
	//so we'll do it this way and hope for the best
	if(!GLOB.config.fastboot || GLOB.config.exoplanets["enable_loading"] || GLOB.config.awaysites["enable_loading"])
		// Load templates and build away sites.
		preloadTemplates()

		var/datum/space_level/base_transit = add_reservation_zlevel()
		initialize_reserved_level(base_transit.z_value)
		SSmapping.current_map.build_away_sites()
		SSmapping.current_map.build_exoplanets()
		calculate_default_z_level_gravities()

	return SS_INIT_SUCCESS

/datum/controller/subsystem/mapping/proc/setup_sector()
	var/chosen_sector
	var/using_sector_config = FALSE

	if(GLOB.config.current_space_sector)
		chosen_sector = GLOB.config.current_space_sector
		using_sector_config = TRUE
	else
		chosen_sector = current_map.default_sector

	var/datum/space_sector/selected_sector = SSmapping.possible_sectors[chosen_sector]

	if(!selected_sector)
		if(using_sector_config)
			log_config("[chosen_sector] used in the config file is not a valid space sector")
			log_mapping("[chosen_sector] used in the config file is not a valid space sector")
		current_sector = new /datum/space_sector/tau_ceti //if all fails, we go with tau ceti
		log_mapping("Unable to select [chosen_sector] as a valid space sector. Tau Ceti will be used instead.")
	else
		current_sector = selected_sector

	current_sector.setup_current_sector()

/datum/controller/subsystem/mapping/proc/InitializeSectors()
	SHOULD_NOT_SLEEP(TRUE)

	for (var/type in subtypesof(/datum/space_sector))
		var/datum/space_sector/space_sector = new type()

		possible_sectors[space_sector.name] = space_sector

	if (!possible_sectors.len)
		crash_with("No space sectors located in SSmapping.")

/datum/controller/subsystem/mapping/Recover()
	flags |= SS_NO_INIT
	map_templates = SSmapping.map_templates
	shuttle_templates = SSmapping.shuttle_templates
	space_ruins_templates = SSmapping.space_ruins_templates
	exoplanet_ruins_templates = SSmapping.exoplanet_ruins_templates
	away_sites_templates = SSmapping.away_sites_templates
	areas_in_z = SSmapping.areas_in_z

/datum/controller/subsystem/mapping/fire(resumed)
	// Cache for sonic speed
	var/list/unused_turfs = src.unused_turfs
	var/list/world_contents = GLOB.areas_by_type[world.area].contents
	var/list/world_turf_contents_by_z = GLOB.areas_by_type[world.area].turfs_by_zlevel
	var/list/lists_to_reserve = src.lists_to_reserve
	var/index = 0
	while(index < length(lists_to_reserve))
		var/list/packet = lists_to_reserve[index + 1]
		var/packetlen = length(packet)
		while(packetlen)
			if(MC_TICK_CHECK)
				if(index)
					lists_to_reserve.Cut(1, index)
				return
			var/turf/T = packet[packetlen]
			T.empty(RESERVED_TURF_TYPE, RESERVED_TURF_TYPE, null, TRUE)
			LAZYINITLIST(unused_turfs["[T.z]"])
			unused_turfs["[T.z]"] |= T
			var/area/old_area = T.loc
			LISTASSERTLEN(old_area.turfs_to_uncontain_by_zlevel, T.z, list())
			old_area.turfs_to_uncontain_by_zlevel[T.z] += T
			T.turf_flags = UNUSED_RESERVATION_TURF
			world_contents += T
			LISTASSERTLEN(world_turf_contents_by_z, T.z, list())
			world_turf_contents_by_z[T.z] += T
			packet.len--
			packetlen = length(packet)

		index++
	lists_to_reserve.Cut(1, index)

/datum/controller/subsystem/mapping/proc/wipe_reservations(wipe_safety_delay = 100)
	if(clearing_reserved_turfs || !initialized) //in either case this is just not needed.
		return
	clearing_reserved_turfs = TRUE
	SSshuttle.transit_requesters.Cut()
	message_admins("Clearing dynamic reservation space.")
	do_wipe_turf_reservations()
	clearing_reserved_turfs = FALSE

/datum/controller/subsystem/mapping/proc/safety_clear_transit(obj/effect/shuttle_landmark/transit/T, datum/shuttle/shuttle, list/returning)
	var/error = shuttle.transit_to_landmark(shuttle.next_location, shuttle.overmap_shuttle.fore_dir)
	if(!error)
		returning += shuttle
		qdel(T, TRUE)

/// Adds a new reservation z level. A bit of space that can be handed out on request
/// Of note, reservations default to transit turfs, to make their most common use, shuttles, faster
/datum/controller/subsystem/mapping/proc/add_reservation_zlevel(for_shuttles)
	num_of_res_levels++
	return add_new_zlevel("Transit/Reserved #[num_of_res_levels]", list(ZTRAIT_RESERVED = TRUE))

/// Requests a /datum/turf_reservation based on the given width, height, and z_size. You can specify a z_reservation to use a specific z level, or leave it null to use any z level.
/datum/controller/subsystem/mapping/proc/request_turf_block_reservation(
	width,
	height,
	z_size = 1,
	z_reservation = null,
	reservation_type = /datum/turf_reservation,
	turf_type_override = null,
)
	UNTIL((!z_reservation || reservation_ready["[z_reservation]"]) && !clearing_reserved_turfs)
	var/datum/turf_reservation/reserve = new reservation_type
	if(!isnull(turf_type_override))
		reserve.turf_type = turf_type_override
	if(!z_reservation)
		for(var/i in levels_by_trait(ZTRAIT_RESERVED))
			if(reserve.reserve(width, height, z_size, i))
				return reserve
		//If we didn't return at this point, theres a good chance we ran out of room on the exisiting reserved z levels, so lets try a new one
		var/datum/space_level/newReserved = add_reservation_zlevel()
		initialize_reserved_level(newReserved.z_value)
		if(reserve.reserve(width, height, z_size, newReserved.z_value))
			return reserve
	else
		if(!level_trait(z_reservation, ZTRAIT_RESERVED))
			qdel(reserve)
			return
		else
			if(reserve.reserve(width, height, z_size, z_reservation))
				return reserve
	QDEL_NULL(reserve)

///Sets up a z level as reserved
///This is not for wiping reserved levels, use wipe_reservations() for that.
///If this is called after SSatom init, it will call Initialize on all turfs on the passed z, as its name promises
/datum/controller/subsystem/mapping/proc/initialize_reserved_level(z)
	UNTIL(!clearing_reserved_turfs) //regardless, lets add a check just in case.
	clearing_reserved_turfs = TRUE //This operation will likely clear any existing reservations, so lets make sure nothing tries to make one while we're doing it.
	if(!level_trait(z,ZTRAIT_RESERVED))
		clearing_reserved_turfs = FALSE
		CRASH("Invalid z level prepared for reservations.")
	var/list/reserved_block = block(
		SHUTTLE_TRANSIT_BORDER, SHUTTLE_TRANSIT_BORDER, z,
		world.maxx - SHUTTLE_TRANSIT_BORDER, world.maxy - SHUTTLE_TRANSIT_BORDER, z
	)
	for(var/turf/T as anything in reserved_block)
		// No need to empty() these, because they just got created and are already /turf/open/space/basic.
		T.turf_flags = UNUSED_RESERVATION_TURF
		T.blocks_air = TRUE
		CHECK_TICK

	// Gotta create these suckers if we've not done so already
	if(SSatoms.initialized)
		SSatoms.InitializeAtoms(Z_TURFS(z))

	unused_turfs["[z]"] = reserved_block
	reservation_ready["[z]"] = TRUE
	clearing_reserved_turfs = FALSE

/// Schedules a group of turfs to be handed back to the reservation system's control
/// If await is true, will sleep until the turfs are finished work
/datum/controller/subsystem/mapping/proc/reserve_turfs(list/turfs, await = FALSE)
	lists_to_reserve += list(turfs)
	if(await)
		UNTIL(!length(turfs))

//DO NOT CALL THIS PROC DIRECTLY, CALL wipe_reservations().
/datum/controller/subsystem/mapping/proc/do_wipe_turf_reservations()
	PRIVATE_PROC(TRUE)
	UNTIL(initialized) //This proc is for AFTER init, before init turf reservations won't even exist and using this will likely break things.
	for(var/i in turf_reservations)
		var/datum/turf_reservation/TR = i
		if(!QDELETED(TR))
			qdel(TR, TRUE)
	UNSETEMPTY(turf_reservations)
	var/list/clearing = list()
	for(var/l in unused_turfs) //unused_turfs is an assoc list by z = list(turfs)
		if(islist(unused_turfs[l]))
			clearing |= unused_turfs[l]
	clearing |= used_turfs //used turfs is an associative list, BUT, reserve_turfs() can still handle it. If the code above works properly, this won't even be needed as the turfs would be freed already.
	unused_turfs.Cut()
	used_turfs.Cut()
	reserve_turfs(clearing, await = TRUE)

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

/datum/controller/subsystem/mapping/proc/reg_in_areas_in_z(list/areas)
	for(var/B in areas)
		var/area/A = B
		A.reg_in_areas_in_z()

/datum/controller/subsystem/mapping/proc/calculate_default_z_level_gravities()
	for(var/z_level in 1 to length(z_list))
		calculate_z_level_gravity(z_level)

/datum/controller/subsystem/mapping/proc/generate_z_level_linkages()
	for(var/z_level in 1 to length(z_list))
		generate_linkages_for_z_level(z_level)

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

/datum/controller/subsystem/mapping/proc/calculate_z_level_gravity(z_level_number)
	if(!isnum(z_level_number) || z_level_number < 1)
		return FALSE

	var/max_gravity = 0

	for(var/obj/machinery/gravity_generator/main/grav_gen as anything in GLOB.gravity_generators["[z_level_number]"])
		max_gravity = max(grav_gen.setting, max_gravity)

	max_gravity = max_gravity || level_trait(z_level_number, ZTRAIT_GRAVITY) || 0//just to make sure no nulls
	gravity_by_z_level[z_level_number] = max_gravity
	return max_gravity

/// Takes a z level datum, and tells the mapping subsystem to manage it
/// Also handles things like plane offset generation, and other things that happen on a z level to z level basis
/datum/controller/subsystem/mapping/proc/manage_z_level(datum/space_level/new_z, filled_with_space, contain_turfs = TRUE)
	// First, add the z
	z_list += new_z

	// Then we build our lookup lists
	var/z_value = new_z.z_value

	gravity_by_z_level.len += 1
	z_level_to_stack.len += 1
	// Bare minimum we have ourselves
	z_level_to_stack[z_value] = list(z_value)

	if(contain_turfs)
		build_area_turfs(z_value, filled_with_space)

//Placeholder for now
/datum/controller/subsystem/mapping/proc/get_reservation_from_turf(turf/T)
	RETURN_TYPE(/datum/turf_reservation)
	return used_turfs[T]

/datum/controller/subsystem/mapping/proc/build_area_turfs(z_level, space_guaranteed)
	// If we know this is filled with default tiles, we can use the default area
	// Faster
	if(space_guaranteed)
		var/area/global_area = GLOB.areas_by_type[world.area]
		LISTASSERTLEN(global_area.turfs_by_zlevel, z_level, list())
		global_area.turfs_by_zlevel[z_level] = Z_TURFS(z_level)
		return

	for(var/turf/to_contain as anything in Z_TURFS(z_level))
		var/area/our_area = to_contain.loc
		LISTASSERTLEN(our_area.turfs_by_zlevel, z_level, list())
		our_area.turfs_by_zlevel[z_level] += to_contain

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

/// Checks if today is a Port of Call day at current_sector.
/// Returns FALSE if no port_of_call defined in current_map.ports_of_call, or if today is not listed as a Port of Call day in current_sector.scheduled_port_visits
/datum/controller/subsystem/mapping/proc/is_port_call_day()
	if(!current_map || !current_sector)
		return FALSE
	if(current_map.ports_of_call && length(current_sector.scheduled_port_visits))
		/// Get today
		var/today = GLOB.all_days[GLOB.all_days.Find(time2text(world.realtime, "Day"))]
		if(today in current_sector.scheduled_port_visits) //checks if today is a port of call day
			return TRUE
	return FALSE

// Called when there's a fatal, unrecoverable error in mapload. This reboots the server.
/world/proc/map_panic(reason)
	to_chat(world, SPAN_DANGER("Fatal error during map setup, unable to continue! Server will reboot in 60 seconds."))
	log_mapping("-- FATAL ERROR DURING MAP SETUP: [uppertext(reason)] --")
	sleep(1 MINUTE)
	world.Reboot()

/// Called to retrieve the name of the station. When short is TRUE, the short name of the station will be provided instead.
/proc/station_name(var/short = FALSE)
	ASSERT(SSmapping.current_map)
	if(short)
		. = SSmapping.current_map.station_short
	else
		. = SSmapping.current_map.station_name

	var/sname
	if (GLOB.config && GLOB.config.server_name)
		sname = "[GLOB.config.server_name]: [.]"
	else
		sname = .

	if (world.name != sname)
		world.name = sname
		world.log <<  "Set world.name to [sname]."

/proc/commstation_name()
	ASSERT(SSmapping.current_map)
	return SSmapping.current_map.dock_name

#define INIT_ANNOUNCE(X) to_chat(world, SPAN_BOLDANNOUNCE("[X]")); log_world(X)
/datum/controller/subsystem/mapping/proc/load_group(list/errorList, name, path, files, list/traits, list/default_traits, silent = FALSE)
	. = list()
	var/start_time = world.time

	if (!islist(files))  // handle single-level maps
		files = list(files)

	// check that the total z count of all maps matches the list of traits
	var/total_z = 0
	var/list/parsed_maps = list()
	for (var/file in files)
		var/full_path = "maps/[path]/[file]"
		var/datum/parsed_map/pm = new(file(full_path))
		var/bounds = pm?.bounds
		if (!bounds)
			errorList |= full_path
			continue
		parsed_maps[pm] = total_z  // save the start Z of this file
		total_z += bounds[MAP_MAXZ] - bounds[MAP_MINZ] + 1

	if (!length(traits))  // null or empty - default
		for (var/i in 1 to total_z)
			traits += list(default_traits.Copy())
	else if (total_z != traits.len)  // mismatch
		INIT_ANNOUNCE("WARNING: [traits.len] trait sets specified for [total_z] z-levels in [path]!")
		if (total_z < traits.len)  // ignore extra traits
			traits.Cut(total_z + 1)
		while (total_z > traits.len)  // fall back to defaults on extra levels
			traits += list(default_traits.Copy())

	if(total_z > 1) // it's a multi z map
		for(var/z in 1 to total_z)
			if(z == 1) // bottom z-level
				traits[z]["Up"] = TRUE
			else if(z == total_z) // top z-level
				traits[z]["Down"] = TRUE
			else
				traits[z]["Down"] = TRUE
				traits[z]["Up"] = TRUE

	// preload the relevant space_level datums
	var/start_z = world.maxz
	var/i = 0
	for (var/level in traits)
		add_new_zlevel("[name][i ? " [i + 1]" : ""]", level, contain_turfs = FALSE)
		++i

	// load the maps
	for (var/P in parsed_maps)
		var/datum/parsed_map/pm = P
		var/bounds = pm.bounds
		var/x_offset = bounds ? round(world.maxx / 2 - bounds[MAP_MAXX] / 2) + 1 : 1
		var/y_offset = bounds ? round(world.maxy / 2 - bounds[MAP_MAXY] / 2) + 1 : 1
		if (!pm.load(x_offset, y_offset, start_z + parsed_maps[P], no_changeturf = TRUE, new_z = TRUE))
			errorList |= pm.original_path
	if(!silent)
		INIT_ANNOUNCE("Loaded [name] in [(world.time - start_time)/10]s!")
	return parsed_maps

/datum/controller/subsystem/mapping/proc/load_world()
	//if any of these fail, something has gone horribly, HORRIBLY, wrong
	var/list/failed_zs = list()

	admin_notice(SPAN_DANGER("Loading map [map_override]."), R_DEBUG)
	log_mapping("Using map '[map_override]'.")

	current_map = known_maps[map_override]
	if (!current_map)
		world.map_panic("Selected map does not exist!")

	// ensure we have space_level datums for compiled-in maps
	InitializeDefaultZLevels()

	load_map_meta()

	world.update_status()

	// load the station
	station_start = world.maxz + 1
	INIT_ANNOUNCE("Loading [current_map.name]...")
	load_group(failed_zs, current_map.name, current_map.path, "[current_map.path].dmm", current_map.traits, ZTRAITS_STATION)

	if(current_map.use_overmap)
		build_overmap()

	if(LAZYLEN(failed_zs)) //but seriously, unless the server's filesystem is messed up this will never happen
		var/msg = "RED ALERT! The following map files failed to load: [failed_zs[1]]"
		if(failed_zs.len > 1)
			for(var/I in 2 to failed_zs.len)
				msg += ", [failed_zs[I]]"
		msg += ". Yell at your server host!"
		INIT_ANNOUNCE(msg)

#undef INIT_ANNOUNCE

/datum/controller/subsystem/mapping/proc/build_overmap()
	log_module_sectors("Building overmap...")
	var/datum/space_level/overmap_spacelevel = SSmapping.add_new_zlevel("Overmap", ZTRAITS_OVERMAP, contain_turfs = FALSE)
	SSmapping.current_map.overmap_z = overmap_spacelevel.z_value

	log_module_sectors("Putting overmap on [SSmapping.current_map.overmap_z]")
	var/area/overmap/A = new
	GLOB.map_overmap = A
	for (var/square in block(locate(1,1,SSmapping.current_map.overmap_z), locate(SSmapping.current_map.overmap_size,SSmapping.current_map.overmap_size,SSmapping.current_map.overmap_z)))
		var/turf/T = square
		if(T.x == SSmapping.current_map.overmap_size || T.y == SSmapping.current_map.overmap_size)
			T = T.ChangeTurf(/turf/unsimulated/map/edge, flags = CHANGETURF_IGNORE_NEIGHBORS)
		else
			T = T.ChangeTurf(/turf/unsimulated/map, flags = CHANGETURF_IGNORE_NEIGHBORS)
		T.change_area(T.loc, A)

	SSmapping.current_map.sealed_levels |= SSmapping.current_map.overmap_z

	log_module_sectors("Overmap build complete.")
	return 1

/datum/controller/subsystem/mapping/proc/setup_spawnpoints()
	SHOULD_NOT_SLEEP(TRUE)

	for (var/type in current_map.spawn_types)
		var/datum/spawnpoint/S = new type
		spawn_locations[S.display_name] = S

/datum/controller/subsystem/mapping/proc/OnMapload(datum/callback/callback)
	if (!istype(callback))
		CRASH("Invalid callback.")

	mapload_callbacks += callback

/datum/controller/subsystem/mapping/proc/load_map_meta()
	SHOULD_NOT_SLEEP(TRUE)
	// This needs to be done after current_map is set, but before mapload.

	GLOB.admin_departments = list(
		"[current_map.boss_name]",
		"External Routing",
		"Supply"
	)

	priority_announcement = new(do_log = 0)
	command_announcement = new(do_log = 0, do_newscast = 1)

	log_mapping("running [LAZYLEN(mapload_callbacks)] mapload callbacks.")
	for (var/thing in mapload_callbacks)
		var/datum/callback/cb = thing
		cb.InvokeAsync()

	mapload_callbacks.Cut()
