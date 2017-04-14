#define OPENTURF_MAX_PLANE -71
#define OPENTURF_CAP_PLANE -70      // The multiplier goes here so it'll be on top of every other overlay.
#define OPENTURF_MAX_DEPTH 10		// The maxiumum number of planes deep we'll go before we just dump everything on the same plane.

/var/datum/controller/subsystem/openturf/SSopenturf

/var/global/list/all_openspace_overlays
/var/global/total_openspace_turfs = 0

/datum/controller/subsystem/openturf
	name = "Open Space"
	flags = SS_BACKGROUND | SS_FIRE_IN_LOBBY
	wait = 2
	init_order = SS_INIT_OPENTURF
	priority = SS_PRIORITY_OPENTURF

	var/list/queued_turfs = list()
	var/list/queued_overlays = list()
	var/list/current_turfs
	var/list/current_overlays

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
	..("Q:{T:[LAZYLEN(queued_turfs)]|O:[LAZYLEN(current_overlays)]} T:{T:[total_openspace_turfs]|O:[all_openspace_overlays.len]}")

/datum/controller/subsystem/openturf/Initialize(timeofday)
	// Flush the queue.
	fire(FALSE, TRUE)
	..()

/datum/controller/subsystem/openturf/fire(resumed = 0, no_mc_tick = FALSE)
	if (!resumed)
		current_turfs = queued_turfs
		queued_turfs = list()
		current_overlays = queued_overlays
		queued_overlays = list()

	var/list/curr_turfs = current_turfs
	var/list/curr_ov = current_overlays

	while (curr_turfs.len)
		var/turf/simulated/open/T = curr_turfs[curr_turfs.len]
		curr_turfs.len--

		if (!T || !T.below)
			continue

		if (!T.shadower)	// If we don't have our shadower yet, create it.
			T.shadower = new(T)

		// Figure out how many z-levels down we are.
		var/depth = calculate_depth(T)
		if (depth > OPENTURF_MAX_DEPTH)
			depth = OPENTURF_MAX_DEPTH

		// Update the openturf itself.
		T.appearance = T.below

		// Handle space parallax & starlight.
		if (T.is_above_space())
			T.plane = PLANE_SPACE_BACKGROUND
			if (config.starlight)
				T.set_light(config.starlight, 0.5)
		else
			T.plane = OPENTURF_MAX_PLANE - depth
			if (config.starlight)
				T.set_light(0)

		// If there's an openturf above us, queue it too.
		if (T.above)
			T.above.update_icon()

		// Add everything below us to the update queue.
		for (var/thing in T.below)
			var/atom/movable/object = thing
			if (QDELETED(object) || object.no_z_overlay)
				// Don't queue deleted stuff or stuff that doesn't need an overlay.
				continue

			// Cache our already-calculated depth so we don't need to re-calculate it a bunch of times.

			if (!object.bound_overlay)	// Generate a new overlay if the atom doesn't already have one.
				object.bound_overlay = new(T)
				object.bound_overlay.associated_atom = object

			var/atom/movable/openspace/overlay/OO = object.bound_overlay

			OO.depth = depth

			queued_overlays += OO

		T.updating = FALSE

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			return

	while (curr_ov.len)
		var/atom/movable/openspace/overlay/OO = curr_ov[curr_ov.len]
		curr_ov.len--

		if (QDELETED(OO))
			if (no_mc_tick)
				CHECK_TICK
			else if (MC_TICK_CHECK)
				return

			continue

		if (QDELETED(OO.associated_atom))	// This shouldn't happen, but just in-case.
			qdel(OO)

			if (no_mc_tick)
				CHECK_TICK
			else if (MC_TICK_CHECK)
				return

			continue

		// Actually update the overlay.
		OO.dir = OO.associated_atom.dir
		OO.appearance = OO.associated_atom
		OO.plane = OPENTURF_MAX_PLANE - OO.depth

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/openturf/proc/calculate_depth(turf/simulated/open/T)
	. = 0
	while (T && istype(T.below, /turf/simulated/open))
		T = T.below
		.++
