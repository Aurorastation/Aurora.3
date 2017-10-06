// This file controls round-start runtime maploading.

// First, some globals.
var/datum/map/current_map	// Whatever map is currently loaded. Null until SSmap Initialize() starts.
var/map_override = "aurora"	// If set, SSmap will forcibly load this map. If the map does not exist, mapload will fail and SSmap will panic.

// Legacy-ish map vars, mostly because I don't want to refactor the 100+ mentions to them. Overwritten by SSmap.Initialize()
var/station_name  = "Someone fucked up and loaded this name before the map"
var/station_short = "Someone fucked up and loaded this name before the map"
var/dock_name     = "Someone fucked up and loaded this name before the map"
var/boss_name     = "Someone fucked up and loaded this name before the map"
var/boss_short    = "Someone fucked up and loaded this name before the map"
var/company_name  = "Someone fucked up and loaded this name before the map"
var/company_short = "Someone fucked up and loaded this name before the map"

var/datum/controller/subsystem/map/SSmap

/datum/controller/subsystem/map
	name = "Map"
	flags = SS_NO_FIRE
	init_order = SS_INIT_MAPLOAD

	var/list/known_maps = list()
	var/dmm_suite/maploader
	var/list/height_markers = list()

/datum/controller/subsystem/map/New()
	NEW_SS_GLOBAL(SSmap)

/datum/controller/subsystem/map/Initialize(timeofday)
	lobby_image = new /obj/effect/lobby_image
	maploader = new

	var/datum/map/M
	for (var/type in subtypesof(/datum/map))
		M = new type
		if (!M.path)
			log_debug("SSmap: Map [M.name] ([M.type]) has no path set, discarding.")
			qdel(M)
			continue

		known_maps[M.path] = M

	if (!map_override)
		map_override = get_selected_map()

	admin_notice("<span class='danger'>Loading map [map_override].</span>", R_DEBUG)
	log_ss("map", "Using map '[map_override]'.")

	current_map = known_maps[map_override]
	if (!current_map)
		world.map_panic("Selected map does not exist!")

	copy_names()

	world.update_status()

	// Begin loading the maps.
	var/maps_loaded = load_map_directory("maps/[current_map.path]/")

	log_ss("map", "Loaded [maps_loaded] maps.")
	admin_notice("<span class='danger'>Loaded [maps_loaded] levels.</span>")

	if (!maps_loaded)
		world.map_panic("No maps loaded!")

	setup_multiz()

	QDEL_NULL(maploader)

	..()

/datum/controller/subsystem/map/proc/load_map_directory(directory)
	. = 0
	if (!directory)
		CRASH("No directory supplied.")

	var/static/regex/mapregex = new(".+\\.dmm$")
	var/list/files = flist(directory)
	sortTim(files, /proc/cmp_text_asc)
	for (var/mfile in files)
		if (!mapregex.Find(mfile))
			continue

		log_ss("map", "Loading '[mfile]'.")

		mfile = "[directory][mfile]"

		if (!maploader.load_map(file(mfile), 0, 0, no_changeturf = TRUE))
			log_ss("map", "Failed to load '[mfile]'!")

		.++
		CHECK_TICK

/datum/controller/subsystem/map/proc/setup_multiz()
	for (var/thing in height_markers)
		var/obj/effect/landmark/map_data/marker = thing
		marker.setup()

/datum/controller/subsystem/map/proc/get_selected_map()
	. = "aurora"

/datum/controller/subsystem/map/proc/copy_names()
	station_name = current_map.station_name
	station_short = current_map.station_short
	dock_name = current_map.dock_name
	boss_name = current_map.boss_name
	boss_short = current_map.boss_short
	company_name = current_map.company_name
	company_short = current_map.company_short

	admin_departments = list(
		"[boss_name]",
		"[current_map.system_name] Government", 
		"Supply"
	)

	priority_announcement = new(do_log = 0)
	command_announcement = new(do_log = 0, do_newscast = 1)

	log_debug("SSmap: Copied names from current_map.")

// Called when there's a fatal, unrecoverable error in mapload. This reboots the server.
/world/proc/map_panic(reason)
	to_chat(world, "<span class='danger'>Fatal error during map setup, unable to continue! Server will reboot in 60 seconds.</span>")
	log_ss("map", "-- FATAL ERROR DURING MAP SETUP: [uppertext(reason)] --")
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
		world.log << "Set world.name to [sname]."

/proc/system_name()
	ASSERT(current_map)
	return current_map.system_name

/proc/commstation_name()
	ASSERT(current_map)
	return current_map.dock_name
