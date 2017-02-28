#define OPENTURF_PLANE -80

/var/list/openturf_update_queue = list()

/datum/controller/process/openturf/setup()
	name = "openturf"
	schedule_interval = 5
	start_delay = 4

/datum/controller/process/openturf/doWork()
	while (openturf_update_queue.len)
		var/turf/simulated/open/T = openturf_update_queue[openturf_update_queue.len]
		openturf_update_queue.len--

		if (!T || !T.below)
			continue

		if (!T.openspace_overlays)
			T.openspace_overlays = list()

		for (var/thing in T.openspace_overlays)
			returnToPool(thing)

		var/list/things = T.below.contents + T.below
		for (var/thing in things)
			var/atom/movable/AM = thing
			if (!AM || istype(AM, /atom/movable/lighting_overlay))
				continue

			var/atom/movable/openspace_overlay/OO = getFromPool(/atom/movable/openspace_overlay, T)
			// Just let DM copy the atom's appearance.
			// This way we preserve layering & appearance without having to 
			// duplicate a lot of vars.
			OO.appearance = AM
			// Reset these vars because appearance probably overwrote them.
			OO.plane = OPENTURF_PLANE
			//OO.mouse_opacity = FALSE
			OO.color = list(
				0.5, 0, 0,
				0, 0.5, 0,
				0, 0, 0.5
			)
			T.openspace_overlays += OO

		// This is basically (F_)SCHECK, we just want to return instead of sleeping the proc.
		if (world.tick_usage > 100 || (world.tick_usage - tick_start) > tick_allowance)
			return
