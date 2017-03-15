#define OPENTURF_PLANE -80

/var/list/openturf_update_queue = list()

/datum/controller/process/openturf
	var/list/turf_cache = list()
	var/icon/gradient

/datum/controller/process/openturf/setup()
	name = "openturf"
	schedule_interval = 5
	start_delay = 4
	gradient = icon('icons/turf/wall_gradient.png')

/datum/controller/process/openturf/doWork()
	while (openturf_update_queue.len)
		var/turf/simulated/open/T = openturf_update_queue[openturf_update_queue.len]
		openturf_update_queue.len--

		if (!T || !T.below)
			continue

		for (var/thing in T.below)
			var/atom/movable/object = thing
			if (!QDELETED(object) && !object.bound_overlay && !object.no_z_overlay)
				// Atom doesn't yet have an overlay, queue it.
				var/atom/movable/openspace_overlay/OO = new(T)
				OO.assume_appearance(object)
				LAZYADD(T.openspace_overlays, OO)

		// The turf overlay is handled specially so attackby is proxied.
		var/atom/movable/openspace_overlay/below_OO = new(T.below)
		if (istype(T.below, /turf/space))
			below_OO.assume_appearance(T.below, override_plane = FALSE)
		else
			below_OO.assume_appearance(T.below)
			
		LAZYADD(T.openspace_overlays, below_OO)

		/*var/turf/neighbour = get_step(src, NORTH)
		if (neighbour && !istype(neighbour, /turf/space))
			T.overlays.Cut()
			if ("[neighbour.type]" in turf_cache)
				T.overlays += turf_cache["[neighbour.type]"]
			else
				log_debug("openspace is generating a wall icon for type [neighbour.type].")
				var/icon/wall = new(neighbour.icon)
				wall.Blend(gradient, ICON_OVERLAY)
				turf_cache += "[neighbour.type]"
				turf_cache["[neighbour.type]"] = wall
				
				T.overlays += wall*/

		T.updating = FALSE

		// This is basically (F_)SCHECK, we just want to return instead of sleeping the proc.
		if (world.tick_usage > 100 || (world.tick_usage - tick_start) > tick_allowance)
			return
