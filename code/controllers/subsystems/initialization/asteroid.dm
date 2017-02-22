/datum/subsystem/asteroid
	name = "Asteroid Generation"
	flags = SS_NO_FIRE
	init_order = SS_INIT_ASTEROID

/datum/subsystem/asteroid/Initialize(timeofday)
	if(config.generate_asteroid)
		// These values determine the specific area that the map is applied to.
		// If you do not use the official Baycode moonbase map, you will need to change them.
		//Create the mining Z-level.
		new /datum/random_map/automata/cave_system(null,1,1,5,255,255)
		//new /datum/random_map/noise/volcanism(null,1,1,5,255,255) // Not done yet! Pretty, though.
		// Create the mining ore distribution map.
		new /datum/random_map/noise/ore(null, 1, 1, 5, 64, 64)

	..()
