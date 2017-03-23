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

		if (T.is_above_space())
			T.shadower.hide()
		else
			T.shadower.show()

		T.appearance = T.below
		if (!istype(T.below, /turf/space))
			T.plane = OPENTURF_PLANE
		else
			T.plane = PLANE_SPACE_BACKGROUND

		for (var/thing in T.below)
			var/atom/movable/object = thing
			if (QDELETED(object) || object.no_z_overlay)
				continue

			if (!object.bound_overlay)
				object.bound_overlay = new(T)

			// Atom exists & doesn't have an overlay, generate one.
			var/atom/movable/openspace/overlay/OO = object.bound_overlay
			OO.associated_atom = object
			OO.dir = object.dir
			OO.appearance = object
			OO.plane = OPENTURF_PLANE

		T.updating = FALSE
