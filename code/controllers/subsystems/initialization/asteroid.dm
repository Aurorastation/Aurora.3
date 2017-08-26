/datum/controller/subsystem/asteroid
	name = "Asteroid"
	flags = SS_NO_FIRE | SS_NO_DISPLAY
	init_order = SS_INIT_ASTEROID

/datum/controller/subsystem/asteroid/Initialize(timeofday)
	if(config.generate_asteroid)
		// These values determine the specific area that the map is applied to.

		// Create the chasms.
		new /datum/random_map/automata/cave_system/chasms(null,0,0,3,255,255)
		new /datum/random_map/automata/cave_system(null,0,0,3,255,255)
		new /datum/random_map/automata/cave_system/chasms(null,0,0,4,255,255)
		new /datum/random_map/automata/cave_system(null,0,0,4,255,255)
		new /datum/random_map/automata/cave_system/chasms(null,0,0,5,255,255)
		new /datum/random_map/automata/cave_system/high_yield(null,0,0,5,255,255)
		new /datum/random_map/automata/cave_system/chasms/surface(null,0,0,6,255,255)
		
		// Create the deep mining ore distribution map.
		new /datum/random_map/noise/ore(null, 0, 0, 5, 64, 64)
		new /datum/random_map/noise/ore(null, 0, 0, 4, 64, 64)
		new /datum/random_map/noise/ore(null, 0, 0, 3, 64, 64)
	..()
