#define OPENTURF_MAX_PLANE -71
#define OPENTURF_CAP_PLANE -70      // The multiplier goes here so it'll be on top of every other overlay.
#define OPENTURF_MAX_DEPTH 10		// The maxiumum number of planes deep we'll go before we just dump everything on the same plane.

/var/datum/controller/subsystem/openturf/SSopenturf

/var/global/list/all_openspace_overlays
/var/global/total_openspace_turfs = 0

/datum/controller/subsystem/openturf
	name = "Open Space"
	flags = SS_BACKGROUND
	wait = 2
	init_order = SS_INIT_OPENTURF
	priority = SS_PRIORITY_OPENTURF

	var/list/queued = list()
	var/list/currentrun

/datum/controller/subsystem/openturf/New()
	NEW_SS_GLOBAL(SSopenturf)
	LAZYINITLIST(all_openspace_overlays)

/datum/controller/subsystem/openturf/proc/update_all()
	can_fire = FALSE
	for (var/thing in all_openspace_overlays)
		var/atom/movable/AM = thing

		var/turf/simulated/open/T = get_turf(AM)
		if (istype(T))
			T.update()
		else
			qdel(AM)

		CHECK_TICK

	next_fire = world.time + wait
	can_fire = TRUE

/datum/controller/subsystem/openturf/stat_entry()
	..("Q:[queued.len] OO:[all_openspace_overlays.len] OT:[total_openspace_turfs]") 

/datum/controller/subsystem/openturf/Initialize(timeofday)
	// Flush the queue.
	fire(FALSE, TRUE)
	..()

/datum/controller/subsystem/openturf/fire(resumed = 0, no_mc_tick = FALSE)
	if (!resumed)
		currentrun = queued
		queued = list()

	var/list/curr = currentrun

	while (curr.len)
		var/turf/simulated/open/T = curr[curr.len]
		curr.len--

		if (!T || !T.below)
			continue

		if (!T.shadower)
			T.shadower = new(T)

		var/depth = calculate_depth(T)
		if (depth > OPENTURF_MAX_DEPTH)
			depth = OPENTURF_MAX_DEPTH

		T.appearance = T.below
		if (T.is_above_space())
			T.plane = PLANE_SPACE_BACKGROUND
			if (config.starlight)
				T.set_light(config.starlight, 0.5)
		else
			T.plane = OPENTURF_MAX_PLANE - depth
			if (config.starlight)
				T.set_light(0)

		if (T.above)
			T.above.update_icon()

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
			OO.plane = OPENTURF_MAX_PLANE - depth

		T.updating = FALSE

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/openturf/proc/calculate_depth(turf/simulated/open/T)
	. = 0
	while (T && istype(T.below, /turf/simulated/open))
		T = T.below
		.++
