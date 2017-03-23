#define OPENTURF_PLANE -80           // Generated openturf overlays get dumped here.
#define OPENTURF_CAP_PLANE -79       // The multiplier goes here so it'll be on top of every other overlay.

/var/datum/controller/subsystem/openturf/SSopenturf

/var/global/list/all_openspace_overlays
/var/global/total_openspace_turfs = 0

/datum/controller/subsystem/openturf
	name = "Open Space"
	flags = SS_BACKGROUND | SS_NO_INIT | SS_FIRE_IN_LOBBY
	wait = 2

	var/list/queued = list()
	var/list/currentrun

/datum/controller/subsystem/openturf/New()
	NEW_SS_GLOBAL(SSopenturf)
	LAZYINITLIST(all_openspace_overlays)

/datum/controller/subsystem/openturf/stat_entry()
	..("Q:[queued.len] OO:[all_openspace_overlays.len] OT:[total_openspace_turfs]") 

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

		if (!T.shadower)
			T.shadower = new(T)

		if ("\ref[T.below]" != T.last_seen_turf)
			T.last_seen_turf = "\ref[T.below]"

			// Generate the turf overlay if we don't have one.
			if (!T.turf_overlay)
				T.turf_overlay = new(T)

			var/atom/movable/openspace/overlay/below_OO = T.turf_overlay
			if (istype(T.below, /turf/space))
				below_OO.assume_appearance(T.below, override_plane = FALSE)
			else
				below_OO.assume_appearance(T.below)

		for (var/thing in T.below)
			var/atom/movable/object = thing
			if (QDELETED(object) || object.no_z_overlay)
				continue

			if (!object.bound_overlay)
				object.bound_overlay = new(T)

			// Atom exists & doesn't have an overlay, generate one.
			var/atom/movable/openspace/overlay/OO = object.bound_overlay
			OO.assume_appearance(object)

		T.updating = FALSE
