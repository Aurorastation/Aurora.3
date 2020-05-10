// This file controls round-start runtime maploading.

var/datum/map/current_map	// Whatever map is currently loaded. Null until SSatlas Initialize() starts.

var/datum/controller/subsystem/atlas/SSatlas

/datum/controller/subsystem/atlas
	name = "Atlas"
	flags = SS_NO_FIRE
	init_order = SS_INIT_MAPLOAD

	var/list/known_maps = list()
	var/dmm_suite/maploader
	var/list/height_markers = list()

	var/list/mapload_callbacks = list()
	var/map_override	// If set, SSatlas will forcibly load this map. If the map does not exist, mapload will fail and SSatlas will panic.
	var/list/spawn_locations = list()

	var/list/list/connected_z_cache = list()
	var/z_levels = 0	// Each bit represents a connection between adjacent levels.  So the first bit means levels 1 and 2 are connected.

/datum/controller/subsystem/atlas/stat_entry()
	..("W:{X:[world.maxx] Y:[world.maxy] Z:[world.maxz]} ZL:[z_levels]")

/datum/controller/subsystem/atlas/New()
	NEW_SS_GLOBAL(SSatlas)

/datum/controller/subsystem/atlas/Initialize(timeofday)
	// Quick sanity check.
	if (world.maxx != WORLD_MIN_SIZE || world.maxy != WORLD_MIN_SIZE || world.maxz != 1)
		to_world("<span class='warning'>WARNING: Suspected pre-compiled map: things may break horribly!</span>")
		log_ss("atlas", "-- WARNING: Suspected pre-compiled map! --")

	maploader = new

	var/datum/map/M
	for (var/type in subtypesof(/datum/map))
		M = new type
		if (!M.path)
			log_debug("SSatlas: Map [M.name] ([M.type]) has no path set, discarding.")
			qdel(M)
			continue

		known_maps[M.path] = M

#ifdef DEFAULT_MAP
	map_override = DEFAULT_MAP
	log_ss("atlas", "Using compile-selected map.")
#endif
	if (!map_override)
		map_override = get_selected_map()

	admin_notice("<span class='danger'>Loading map [map_override].</span>", R_DEBUG)
	log_ss("atlas", "Using map '[map_override]'.")

	current_map = known_maps[map_override]
	if (!current_map)
		world.map_panic("Selected map does not exist!")

	load_map_meta()
	setup_spawnpoints()

	world.update_status()

	// Begin loading the maps.
	var/maps_loaded = load_map_directory("maps/[current_map.path]/", TRUE)

	log_ss("atlas", "Loaded [maps_loaded] maps.")
	admin_notice("<span class='danger'>Loaded [maps_loaded] levels.</span>")

	if (!maps_loaded)
		world.map_panic("No maps loaded!")

	setup_multiz()

	QDEL_NULL(maploader)

	..()

/datum/controller/subsystem/atlas/proc/load_map_directory(directory, overwrite_default_z = FALSE)
	. = 0
	if (!directory)
		CRASH("No directory supplied.")

	var/static/regex/mapregex = new(".+\\.dmm$")
	var/list/files = flist(directory)
	sortTim(files, /proc/cmp_text_asc)
	var/mfile
	var/first_dmm = TRUE
	var/time
	for (var/i in 1 to files.len)
		mfile = files[i]
		if (!mapregex.Find(mfile))
			continue

		log_ss("atlas", "Loading '[mfile]'.")
		time = world.time

		mfile = "[directory][mfile]"

		var/target_z = 0
		if (overwrite_default_z && first_dmm)
			target_z = 1
			first_dmm = FALSE
			log_ss("atlas", "Overwriting first Z.")

		if (!maploader.load_map(file(mfile), 0, 0, target_z, no_changeturf = TRUE))
			log_ss("atlas", "Failed to load '[mfile]'!")
		else
			log_ss("atlas", "Loaded level in [(world.time - time)/10] seconds.")

		.++
		CHECK_TICK

/datum/controller/subsystem/atlas/proc/setup_multiz()
	for (var/thing in height_markers)
		var/obj/effect/landmark/map_data/marker = thing
		log_debug("atlas: setting up Z marker on level [marker.z] with height [marker.height].")
		marker.setup()

	connected_z_cache.Cut()

/datum/controller/subsystem/atlas/proc/get_selected_map()
	if (config.override_map)
		if (known_maps[config.override_map])
			. = config.override_map
			log_ss("atlas", "Using configured map.")
		else
			log_ss("atlas", "-- WARNING: CONFIGURED MAP DOES NOT EXIST, IGNORING! --")
			. = "aurora"
	else
		. = "aurora"

/datum/controller/subsystem/atlas/proc/load_map_meta()
	// This needs to be done after current_map is set, but before mapload.
	lobby_image = new /obj/effect/lobby_image

	admin_departments = list(
		"[current_map.boss_name]",
		"External Routing",
		"Supply"
	)

	priority_announcement = new(do_log = 0)
	command_announcement = new(do_log = 0, do_newscast = 1)

	log_debug("atlas: running [LAZYLEN(mapload_callbacks)] mapload callbacks.")
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

// Called when there's a fatal, unrecoverable error in mapload. This reboots the server.
/world/proc/map_panic(reason)
	to_chat(world, "<span class='danger'>Fatal error during map setup, unable to continue! Server will reboot in 60 seconds.</span>")
	log_ss("atlas", "-- FATAL ERROR DURING MAP SETUP: [uppertext(reason)] --")
	sleep(1 MINUTE)
	world.Reboot()

/proc/station_name()
	ASSERT(current_map)
	. = current_map.station_name

	var/sname
	if (config && config.server_name)
		sname = "[config.server_name]: [.]"
	else
		sname = .

	if (world.name != sname)
		world.name = sname
		world.log <<  "Set world.name to [sname]."

/proc/system_name()
	ASSERT(current_map)
	return current_map.system_name

/proc/commstation_name()
	ASSERT(current_map)
	return current_map.dock_name