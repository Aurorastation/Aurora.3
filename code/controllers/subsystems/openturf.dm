#define OPENTURF_MAX_PLANE -71
#define OPENTURF_CAP_PLANE -70      // The multiplier goes here so it'll be on top of every other overlay.
#define OPENTURF_MAX_DEPTH 10		// The maxiumum number of planes deep we'll go before we just dump everything on the same plane.
#define SHADOWER_DARKENING_FACTOR 0.4	// The multiplication factor for openturf shadower darkness. Lighting will be multiplied by this.

/var/datum/controller/subsystem/openturf/SSopenturf

/datum/controller/subsystem/openturf
	name = "Open Space"
	wait = 1
	init_order = SS_INIT_OPENTURF
	priority = SS_PRIORITY_OPENTURF
	flags = SS_FIRE_IN_LOBBY

	var/list/queued_turfs = list()
	var/list/qt_idex = 1
	var/list/queued_overlays = list()
	var/list/qo_idex = 1

	var/list/openspace_overlays = list()
	var/list/openspace_turfs = list()

	var/starlight_enabled = FALSE

/datum/controller/subsystem/openturf/New()
	NEW_SS_GLOBAL(SSopenturf)

/datum/controller/subsystem/openturf/proc/update_all()
	disable()
	for (var/thing in openspace_overlays)
		var/atom/movable/AM = thing

		var/turf/simulated/open/T = get_turf(AM)
		if (istype(T))
			T.update_icon()
		else
			qdel(AM)

		CHECK_TICK

	for (var/thing in openspace_turfs)
		var/turf/simulated/open/T = thing
		T.update_icon()

	enable()

/datum/controller/subsystem/openturf/proc/hard_reset()
	disable()
	log_debug("SSopenturf: hard_reset() invoked.")
	var/num_deleted = 0
	for (var/thing in openspace_overlays)
		qdel(thing)
		num_deleted++
		CHECK_TICK
	
	log_debug("SSopenturf: deleted [num_deleted] overlays.")

	var/num_turfs = 0
	for (var/turf/simulated/open/T in turfs)
		T.update_icon()
		num_turfs++

		CHECK_TICK

	log_debug("SSopenturf: queued [num_turfs] openturfs for update. hard_reset() complete.")
	enable()

/datum/controller/subsystem/openturf/stat_entry()
	..("Q:{T:[queued_turfs.len - (qt_idex - 1)]|O:[queued_overlays.len - (qo_idex - 1)]} T:{T:[openspace_turfs.len]|O:[openspace_overlays.len]}")

/datum/controller/subsystem/openturf/Initialize(timeofday)
	starlight_enabled = config.starlight && config.openturf_starlight_permitted
	// Flush the queue.
	fire(FALSE, TRUE)
	if (starlight_enabled)
		var/t = REALTIMEOFDAY
		admin_notice("<span class='danger'>[src] setup completed in [(t - timeofday)/10] seconds!</span>", R_DEBUG)

		SSlighting.fire(FALSE, TRUE)
		admin_notice("<span class='danger'>Secondary [SSlighting] flush completed in [(REALTIMEOFDAY - t)/10] seconds!</span>", R_DEBUG)

		t = REALTIMEOFDAY

		fire(FALSE, TRUE)	// Fire /again/ to flush updates caused by the above.
		admin_notice("<span class='danger'>Secondary [src] flush completed in [(REALTIMEOFDAY - t)/10] seconds!</span>", R_DEBUG)

	..()

/datum/controller/subsystem/openturf/fire(resumed = FALSE, no_mc_tick = FALSE)
	if (!resumed)
		qt_idex = 1
		qo_idex = 1

	MC_SPLIT_TICK_INIT(2)
	if (!no_mc_tick)
		MC_SPLIT_TICK

	var/list/curr_turfs = queued_turfs
	var/list/curr_ov = queued_overlays

	while (qt_idex <= curr_turfs.len)
		var/turf/simulated/open/T = curr_turfs[qt_idex]
		curr_turfs[qt_idex] = null
		qt_idex++

		if (!istype(T) || !T.below)
			if (no_mc_tick)
				CHECK_TICK
			else if (MC_TICK_CHECK)
				break
			continue

		if (!T.shadower)	// If we don't have our shadower yet, create it.
			T.shadower = new(T)

		// Figure out how many z-levels down we are.
		var/depth = 0
		var/turf/simulated/open/Td = T
		while (Td && isopenturf(Td.below))
			Td = Td.below
			depth++
		if (depth > OPENTURF_MAX_DEPTH)
			depth = OPENTURF_MAX_DEPTH

		var/oo_target = OPENTURF_MAX_PLANE - depth
		var/t_target

		// Handle space parallax & starlight.
		if (T.is_above_space())
			t_target = PLANE_SPACE_BACKGROUND
			if (starlight_enabled && !T.light_range)
				T.set_light(config.starlight, 0.5)
		else
			t_target = oo_target
			if (starlight_enabled && T.light_range)
				T.set_light(0)

		if (T.no_mutate)
			// Some openturfs have icons, so we can't overwrite their appearance.
			if (!T.below.bound_overlay)
				T.below.bound_overlay = new(T)
			var/atom/movable/openspace/turf_overlay/TO = T.below.bound_overlay
			TO.appearance = T.below
			TO.name = T.name
			T.desc = TO.desc = "Below seems to be \a [T.below]."
			TO.plane = t_target
		else
			// This openturf doesn't care about its icon, so we can just overwrite it.
			if (T.below.bound_overlay)
				QDEL_NULL(T.below.bound_overlay)
			T.appearance = T.below
			T.name = initial(T.name)
			T.gender = NEUTER
			T.opacity = FALSE
			T.plane = t_target

		T.desc = "Below seems to be \a [T.below]."
		T.queue_ao()	// No need to recalculate ajacencies, shouldn't have changed.

		// Add everything below us to the update queue.
		for (var/thing in T.below)
			var/atom/movable/object = thing
			if (QDELETED(object) || object.no_z_overlay || object.loc != T.below)
				// Don't queue deleted stuff or stuff that doesn't need an overlay.
				continue

			if (object.type == /atom/movable/lighting_overlay)	// Special case.
				T.shadower.copy_lighting(object)
			else
				if (!object.bound_overlay)	// Generate a new overlay if the atom doesn't already have one.
					object.bound_overlay = new(T)
					object.bound_overlay.associated_atom = object

				var/atom/movable/openspace/overlay/OO = object.bound_overlay

				// Cache our already-calculated depth so we don't need to re-calculate it a bunch of times.
				OO.depth = oo_target

				queued_overlays += OO

		T.updating = FALSE

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break

	if (qt_idex > 1 && qt_idex <= curr_turfs.len)
		curr_turfs.Cut(1, qt_idex)
		qt_idex = 1

	if (!no_mc_tick)
		MC_SPLIT_TICK

	while (qo_idex <= curr_ov.len)
		var/atom/movable/openspace/overlay/OO = curr_ov[qo_idex]
		curr_ov[qo_idex] = null
		qo_idex++

		if (QDELETED(OO))
			if (no_mc_tick)
				CHECK_TICK
			else if (MC_TICK_CHECK)
				break
			continue

		if (QDELETED(OO.associated_atom))	// This shouldn't happen, but just in-case.
			qdel(OO)

			if (no_mc_tick)
				CHECK_TICK
			else if (MC_TICK_CHECK)
				break
			continue

		// Actually update the overlay.
		OO.dir = OO.associated_atom.dir
		OO.appearance = OO.associated_atom
		OO.plane = OO.depth
		OO.opacity = FALSE
		OO.queued = FALSE

		if (OO.bound_overlay)	// If we have a bound overlay, queue it too.
			OO.update_above()

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break

		if (qo_idex > 1 && qo_idex <= curr_ov.len)
			curr_ov.Cut(1, qo_idex)
			qo_idex = 1


/client/proc/analyze_openturf(turf/simulated/open/T)
	set name = "Analyze Openturf"
	set desc = "Show the layering of an openturf and everything it's mimicking."
	set category = "Debug"

	if (!check_rights(R_DEBUG|R_DEV))
		return

	if (!istype(T))
		usr << "Invalid Selection."
		return

	var/list/out = list(
		"<h1>Analysis of [T] at [T.x],[T.y],[T.z]</h1>",
		"<b>Queued for update:</b> [T.updating ? "Yes" : "No"]",
		"<b>Appearance Type:</b> [T.no_mutate ? "Movable Copy" : "Turf Overwrite"]",
		"<b>Has Shadower:</b> [T.shadower ? "Yes" : "No"]",
		"<b>Below:</b> [!T.below ? "(nothing)" : "[T.below] at [T.below.x],[T.below.y],[T.below.z]"]",
		"<ul>"
	)
	
	var/list/found_oo = list(T)
	for (var/thing in T)
		if (istype(thing, /atom/movable/openspace))
			found_oo += thing

	sortTim(found_oo, /proc/cmp_planelayer)
	for (var/thing in found_oo)
		var/atom/A = thing
		out += "<li>[A] ([A.type]) at plane [A.plane], layer [A.layer][istype(A, /atom/movable/openspace/overlay) ? ", Z-level [A:associated_atom.z]." : "."]</li>"

	out += "</ul>"

	usr << browse(out.Join("<br>"), "window=openturfanalysis-\ref[T]")
