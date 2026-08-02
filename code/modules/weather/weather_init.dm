INITIALIZE_IMMEDIATE(/obj/abstract/weather_system)
/obj/abstract/weather_system/Initialize(var/ml, var/target_z, var/initial_weather)
	// Track our affected z-levels before registration; the holder moves to nullspace below.
	affecting_zs = GetConnectedZlevels(target_z)

	. = ..()

	set_invisibility(0)

	// Bookkeeping/rightclick guards.
	verbs.Cut()
	forceMove(null)
	RegisterSignal(SSmapping, COMSIG_PLANE_OFFSET_INCREASE, PROC_REF(on_plane_offset_increase))
	ensure_vis_contents_for_offsets(0, SSmapping.max_plane_offset)

	// Initialize our state machine.
	weather_system = add_state_machine(src, /datum/state_machine/weather)
	if(!weather_system)
		return INITIALIZE_HINT_QDEL
	weather_system.set_state(initial_weather || /singleton/state/weather/calm)
	SSweather.register_weather_system(src)

	// If we're post-init, init immediately.
	if(SSweather.initialized)
		addtimer(CALLBACK(src, PROC_REF(init_weather)), 0)

// Start the weather effects from the highest point; they will propagate downwards during update.
/obj/abstract/weather_system/proc/init_weather()
	// Track all z-levels.
	for(var/highest_z in affecting_zs)
		var/turfcount = 0
		if(SSmapping.multiz_levels[highest_z][Z_LEVEL_UP])
			continue
		// Update turf weather.
		for(var/turf/T as anything in block(locate(1, 1, highest_z), locate(world.maxx, world.maxy, highest_z)))
			T.update_weather(src)
			turfcount++
			CHECK_TICK
		log_debug("Initialized weather for [turfcount] turf\s from z[highest_z].")
