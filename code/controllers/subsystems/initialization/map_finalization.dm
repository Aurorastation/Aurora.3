// The area list is put together here, because some things need it early on. Turrets controls, for example.

/datum/controller/subsystem/finalize
	name = "Map Finalization"
	flags = SS_NO_FIRE | SS_NO_DISPLAY
	init_order = SS_INIT_MAPFINALIZE

/datum/controller/subsystem/finalize/Initialize(timeofday)
	// Setup the global antag uplink. This needs to be done after SSatlas as it requires current_map.
	global.uplink = new

	var/time = world.time
	current_map.finalize_load()
	log_ss("map_finalization", "Finalized map in [(world.time - time)/10] seconds.")

	if(config.generate_asteroid)
		time = world.time
		current_map.generate_asteroid()
		log_ss("map_finalization", "Generated asteroid in [(world.time - time)/10] seconds.")

	// Generate the area list.
	resort_all_areas()

	// This is dependant on markers.
	populate_antag_spawns()

	..()

/proc/resort_all_areas()
	all_areas = list()
	for (var/area/A in world)
		all_areas += A

	sortTim(all_areas, /proc/cmp_name_asc)
