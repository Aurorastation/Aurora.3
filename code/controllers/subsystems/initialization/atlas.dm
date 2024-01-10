// This file controls round-start runtime maploading.

var/datum/map/current_map	// Whatever map is currently loaded. Null until SSatlas Initialize() starts.

SUBSYSTEM_DEF(atlas)
	name = "Atlas"
	flags = SS_NO_FIRE
	init_order = SS_INIT_MAPLOAD
	init_stage = INITSTAGE_EARLY

	var/list/known_maps = list()
	var/dmm_suite/maploader

	var/list/mapload_callbacks = list()
	var/map_override	// If set, SSatlas will forcibly load this map. If the map does not exist, mapload will fail and SSatlas will panic.
	var/list/spawn_locations = list()

	var/datum/space_sector/current_sector
	var/list/possible_sectors = list()
	//Note that the dirs here are REVERSE because they're used for entry points, so it'd be the dir facing starboard for example.
	//These are strings because otherwise the list indexes would be out of bounds. Thanks BYOND.
	var/list/naval_to_dir = list(
		"1" = list(
			"starboard" = WEST,
			"port" = EAST,
			"fore" = SOUTH,
			"aft" = NORTH
		),
		"2" = list(
			"starboard" = EAST,
			"port" = WEST,
			"fore" = NORTH,
			"aft" = SOUTH
		),
		"4" = list(
			"starboard" = NORTH,
			"port" = SOUTH,
			"fore" = WEST,
			"aft" = EAST
		),
		"4" = list(
			"starboard" = NORTH,
			"port" = SOUTH,
			"fore" = WEST,
			"aft" = EAST
		),
		"8" = list(
			"starboard" = SOUTH,
			"port" = NORTH,
			"fore" = EAST,
			"aft" = WEST
		)
	)

	var/list/headings_to_naval = list(
		"1" = list(
			"1" = "aft",
			"2" = "fore",
			"4" = "port",
			"5" = "port",
			"6" = "port",
			"8" = "starboard",
			"9" = "starboard",
			"10" = "starboard"
		),
		"2" = list(
			"1" = "fore",
			"2" = "aft",
			"4" = "starboard",
			"5" = "starboard",
			"6" = "starboard",
			"8" = "port",
			"9" = "port",
			"10" = "port"
		),
		"4" = list(
			"1" = "starboard",
			"2" = "port",
			"4" = "aft",
			"5" = "starboard",
			"6" = "port",
			"8" = "fore",
			"9" = "starboard",
			"10" = "port"
		),
		"5" = list( //northeast
			"1" = "starboard",
			"2" = "port",
			"4" = "port",
			"5" = "aft",
			"6" = "port",
			"8" = "starboard",
			"9" = "starboard",
			"10" = "fore"
		),
		"6" = list( //southeast
			"1" = "starboard",
			"2" = "port",
			"4" = "starboard",
			"5" = "starboard",
			"6" = "aft",
			"8" = "port",
			"9" = "fore",
			"10" = "port"
		),
		"8" = list(
			"1" = "port",
			"2" = "starboard",
			"4" = "fore",
			"5" = "port",
			"6" = "starboard",
			"8" = "aft",
			"9" = "port",
			"10" = "starboard"
		),
		"9" = list(  //northwest
			"1" = "port",
			"2" = "starboard",
			"4" = "port",
			"5" = "port",
			"6" = "fore",
			"8" = "starboard",
			"9" = "aft",
			"10" = "starboard"
		),
		"10" = list( //southwest
			"1" = "port",
			"2" = "starboard",
			"4" = "starboard",
			"5" = "fore",
			"6" = "starboard",
			"8" = "port",
			"9" = "port",
			"10" = "aft"
		)
	)

/datum/controller/subsystem/atlas/stat_entry(msg)
	msg = "W:{X:[world.maxx] Y:[world.maxy] Z:[world.maxz]} ZL:[GLOB.z_levels]"
	return ..()

/datum/controller/subsystem/atlas/Initialize(timeofday)
	// Quick sanity check.
	if (world.maxx != WORLD_MIN_SIZE || world.maxy != WORLD_MIN_SIZE || world.maxz != 1)
		to_world("<span class='warning'>WARNING: Suspected pre-compiled map: things may break horribly!</span>")
		log_subsystem_atlas("-- WARNING: Suspected pre-compiled map! --")

	maploader = new

	var/datum/map/M
	for (var/type in subtypesof(/datum/map))
		M = new type
		if (!M.path)
			log_subsystem_atlas("Map [M.name] ([M.type]) has no path set, discarding.")
			qdel(M)
			continue

		known_maps[M.path] = M

#ifdef DEFAULT_MAP
	map_override = DEFAULT_MAP
	log_subsystem_atlas("Using compile-selected map.")
#endif
	if (!map_override)
		map_override = get_selected_map()

	admin_notice("<span class='danger'>Loading map [map_override].</span>", R_DEBUG)
	log_subsystem_atlas("Using map '[map_override]'.")

	current_map = known_maps[map_override]
	if (!current_map)
		world.map_panic("Selected map does not exist!")

	load_map_meta()
	setup_spawnpoints()

	world.update_status()

	// Begin loading the maps.
	var/maps_loaded = load_map_directory("maps/[current_map.path]/", TRUE)

	log_subsystem_atlas("Loaded [maps_loaded] maps.")
	admin_notice("<span class='danger'>Loaded [maps_loaded] levels.</span>")

	if (!maps_loaded)
		world.map_panic("No maps loaded!")

	QDEL_NULL(maploader)

	InitializeSectors()

	var/chosen_sector
	var/using_sector_config = FALSE

	if(GLOB.config.current_space_sector)
		chosen_sector = GLOB.config.current_space_sector
		using_sector_config = TRUE
	else
		chosen_sector = current_map.default_sector

	var/datum/space_sector/selected_sector = SSatlas.possible_sectors[chosen_sector]

	if(!selected_sector)
		if(using_sector_config)
			log_config("[chosen_sector] used in the config file is not a valid space sector")
			log_subsystem_atlas("[chosen_sector] used in the config file is not a valid space sector")
		current_sector = new /datum/space_sector/tau_ceti //if all fails, we go with tau ceti
		log_subsystem_atlas("Unable to select [chosen_sector] as a valid space sector. Tau Ceti will be used instead.")
	else
		current_sector = selected_sector

	return SS_INIT_SUCCESS

/datum/controller/subsystem/atlas/proc/load_map_directory(directory, overwrite_default_z = FALSE)
	. = 0
	if (!directory)
		CRASH("No directory supplied.")

	var/static/regex/mapregex = new(".+\\.dmm$")
	var/list/files = flist(directory)
	sortTim(files, GLOBAL_PROC_REF(cmp_text_asc))
	var/mfile
	var/first_dmm = TRUE
	var/time
	for (var/i in 1 to files.len)
		mfile = files[i]
		if (!mapregex.Find(mfile))
			continue

		log_subsystem_atlas("Loading '[mfile]'.")
		time = world.time

		mfile = "[directory][mfile]"

		var/target_z = 0
		if (overwrite_default_z && first_dmm)
			target_z = 1
			first_dmm = FALSE
			log_subsystem_atlas("Overwriting first Z.")

		if (!maploader.load_map(file(mfile), 0, 0, target_z, no_changeturf = TRUE))
			log_subsystem_atlas("Failed to load '[mfile]'!")
		else
			log_subsystem_atlas("Loaded level in [(world.time - time)/10] seconds.")

		.++
		CHECK_TICK

/datum/controller/subsystem/atlas/proc/get_selected_map()
	if (GLOB.config.override_map)
		if (known_maps[GLOB.config.override_map])
			. = GLOB.config.override_map
			log_subsystem_atlas("Using configured map.")
		else
			log_config("-- WARNING: CONFIGURED MAP DOES NOT EXIST, IGNORING! --")
			log_subsystem_atlas("-- WARNING: CONFIGURED MAP DOES NOT EXIST, IGNORING! --")
			. = "sccv_horizon"
	else
		. = "sccv_horizon"

/datum/controller/subsystem/atlas/proc/load_map_meta()
	// This needs to be done after current_map is set, but before mapload.

	admin_departments = list(
		"[current_map.boss_name]",
		"External Routing",
		"Supply"
	)

	priority_announcement = new(do_log = 0)
	command_announcement = new(do_log = 0, do_newscast = 1)

	log_subsystem_atlas("running [LAZYLEN(mapload_callbacks)] mapload callbacks.")
	for (var/thing in mapload_callbacks)
		var/datum/callback/cb = thing
		cb.InvokeAsync()
		CHECK_TICK

	mapload_callbacks.Cut()
	mapload_callbacks = null

/datum/controller/subsystem/atlas/proc/OnMapload(datum/callback/callback)
	if (!istype(callback))
		CRASH("Invalid callback.")

	mapload_callbacks += callback

/datum/controller/subsystem/atlas/proc/setup_spawnpoints()
	for (var/type in current_map.spawn_types)
		var/datum/spawnpoint/S = new type
		spawn_locations[S.display_name] = S

/datum/controller/subsystem/atlas/proc/InitializeSectors()
	for (var/type in subtypesof(/datum/space_sector))
		var/datum/space_sector/space_sector = new type()

		possible_sectors[space_sector.name] = space_sector

	if (!possible_sectors.len)
		crash_with("No space sectors located in SSatlas.")

// Called when there's a fatal, unrecoverable error in mapload. This reboots the server.
/world/proc/map_panic(reason)
	to_chat(world, "<span class='danger'>Fatal error during map setup, unable to continue! Server will reboot in 60 seconds.</span>")
	log_subsystem_atlas("-- FATAL ERROR DURING MAP SETUP: [uppertext(reason)] --")
	sleep(1 MINUTE)
	world.Reboot()

/proc/station_name()
	ASSERT(current_map)
	. = current_map.station_name

	var/sname
	if (GLOB.config && GLOB.config.server_name)
		sname = "[GLOB.config.server_name]: [.]"
	else
		sname = .

	if (world.name != sname)
		world.name = sname
		world.log <<  "Set world.name to [sname]."

/proc/commstation_name()
	ASSERT(current_map)
	return current_map.dock_name
