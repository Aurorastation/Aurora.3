INITIALIZE_IMMEDIATE(/obj/abstract/weather_system)
/obj/abstract/weather_system/Initialize(var/ml, var/target_z, var/initial_weather)
	SSweather.register_weather_system(src)

	. = ..()

	set_invisibility(0)

	// Bookkeeping/rightclick guards.
	verbs.Cut()
	forceMove(null)
	lightning_overlay = new
	vis_contents_additions = list(src, lightning_overlay)

	// Initialize our state machine.
	weather_system = add_state_machine(src, /datum/state_machine/weather)
	weather_system.set_state(initial_weather || /singleton/state/weather/calm)

	// Track our affected z-levels.
	affecting_zs = GetConnectedZlevels(target_z)

	// If we're post-init, init immediately.
	if(SSweather.initialized)
		addtimer(CALLBACK(src, PROC_REF(init_weather)), 0)

// Start the weather effects from the highest point; they will propagate downwards during update.
/obj/abstract/weather_system/proc/init_weather()
	// Track all z-levels.
	for(var/highest_z in affecting_zs)
		var/turfcount = 0
		if(HasAbove(highest_z))
			continue
		// Update turf weather.
		for(var/turf/T as anything in block(locate(1, 1, highest_z), locate(world.maxx, world.maxy, highest_z)))
			T.update_weather(src)
			turfcount++
			CHECK_TICK
		log_debug("Initialized weather for [turfcount] turf\s from z[highest_z].")
