/datum/controller/subsystem/asteroid
	name = "Asteroid"
	flags = SS_NO_FIRE | SS_NO_DISPLAY
	init_order = SS_INIT_ASTEROID

/datum/controller/subsystem/asteroid/Initialize(timeofday)
	if(config.generate_asteroid)
		current_map.generate_asteroid()

	..()
