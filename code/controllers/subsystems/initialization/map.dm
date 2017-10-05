var/datum/controller/subsystem/map/SSmap
var/datum/map/current_map
var/map_override = "aurora"

/datum/controller/subsystem/map
	name = "Map"
	flags = SS_NO_FIRE
	init_order = 30

	var/list/known_maps
	var/dmm_suite/maploader
	var/list/height_markers = list()

/datum/controller/subsystem/map/New()
	NEW_SS_GLOBAL(SSmap)

/datum/controller/subsystem/map/Initialize(timeofday)
	maploader = new
	lobby_image = new/obj/effect/lobby_image()
	known_maps = list()
	var/datum/map/M
	for (var/type in subtypesof(/datum/map))
		M = new type
		if (!M.path)
			log_debug("SSmap: Map [M.name] ([M.type]) has no path set, discarding.")
			qdel(M)
			continue
		
		known_maps[M.path] = M

	if (!map_override)
		map_override = get_loaded_map()

	current_map = known_maps[map_override]
	if (!current_map)
		world.map_panic()

	admin_notice("<span class='danger'>Loading map [current_map.name].</span>")
	world.log << "current_map=[current_map]"
	// Begin loading the maps.
	var/regex/mapregex = new(".*\\.dmm$")
	var/maps_loaded = 0
	for (var/mfile in flist("maps/[current_map.path]/"))
		if (!mapregex.Find(mfile))
			world.log << "Skipping [mfile]."
			continue

		world.log << "Loading [mfile]."
		mfile = "maps/[current_map.path]/[mfile]"

		if (!maploader.load_map(file(mfile), 0, 0, no_changeturf = TRUE))
			world.log << "Map [mfile] failed to load!"

		maps_loaded++
		CHECK_TICK

	if (!maps_loaded)
		log_debug("No maps loaded!")
		world.map_panic()

	for (var/thing in height_markers)
		var/obj/effect/landmark/map_data/marker = thing
		marker.setup()

	admin_notice("<span class='danger'>Loaded [maps_loaded] levels.</span>")

	..()

/datum/controller/subsystem/map/proc/get_loaded_map()
	. = "aurora"

// Called when there's a fatal, unrecoverable error in mapload. This reboots the server.
/world/proc/map_panic()
	to_chat(world, "<span class='danger'>Fatal error during map setup, unable to continue! Server will reboot in 60 seconds.</span>")
	sleep(1 MINUTE)
	world.Reboot()

/proc/station_name()
	. = current_map.station_name

	var/sname
	if (config && config.server_name)
		sname = "[config.server_name]: [name]"
	else
		sname = station_name

	if (world.name != sname)
		world.name = sname
