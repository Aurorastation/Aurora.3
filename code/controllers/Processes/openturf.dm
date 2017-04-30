#define OPENTURF_PLANE -80
#define OPENTURF_CAP_PLANE -79

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
				var/atom/movable/openspace/overlay/OO = new(T)
				OO.assume_appearance(object)
				LAZYADD(T.openspace_overlays, OO)

		// The turf overlay is handled specially so attackby is proxied.
		if ("\ref[T.below]" != T.last_seen_turf)
			T.last_seen_turf = "\ref[T.below]"
			
			if (!T.turf_overlay)
				T.turf_overlay = new(T)

			var/atom/movable/openspace/overlay/below_OO = T.turf_overlay

			if (istype(T.below, /turf/space))
				below_OO.assume_appearance(T.below, override_plane = FALSE)
			else
				below_OO.assume_appearance(T.below)

		if (!T.shadower)
			T.shadower = new(T)

		// TODO: Offset + display wall for openspace instead of just dimming.
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
