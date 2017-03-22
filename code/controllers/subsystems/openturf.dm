#define OPENTURF_PLANE -80
#define OPENTURF_CAP_PLANE -79

/var/datum/controller/subsystem/openturf/SSopenturf

/datum/controller/subsystem/openturf
	name = "Open Space"
	flags = SS_BACKGROUND | SS_NO_INIT
	wait = 2

	var/list/queued = list()
	var/list/currentrun

/datum/controller/subsystem/openturf/fire(resumed = 0)
	if (!resumed)
		currentrun = queued
		queued = list()

	var/list/curr = currentrun

	while (curr.len && !MC_TICK_CHECK)
		var/turf/simulated/open/T = curr[curr.len]
		curr.len--

		if (!T || !T.below)
			continue

		for (var/thing in T.below)
			var/atom/movable/object = thing
			if (QDELETED(object) || object.bound_overlay || object.no_z_overlay)
				continue

			// Atom exists & doesn't have an overlay, generate one.
			var/atom/movable/openspace/overlay/OO = new(T)
			OO.assume_appearance(object)
			LAZYADD(T.openspace_overlays, OO)

		if ("\ref[T.below]" != T.last_seen_turf)
			T.last_seen_turf = "\ref[T.below]"

			// Generate the turf overlay if we don't have one.
			if (!T.turf_overlay)
				T.turf_overlay = new(T)

			var/atom/movable/openspace/overlay/below_OO = T.turf_overlay

			below_OO.assume_appearance(T.below, override_plane = !istype(T.below, /turf/space))

		// Guess.
		if (!T.shadower)
			T.shadower = new(T)

		T.updating = FALSE
