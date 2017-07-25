#define OPENTURF_MAX_PLANE -71
#define OPENTURF_CAP_PLANE -70      // The multiplier goes here so it'll be on top of every other overlay.
#define OPENTURF_MAX_DEPTH 10		// The maxiumum number of planes deep we'll go before we just dump everything on the same plane.
#define SHADOWER_DARKENING_FACTOR 0.4	// The multiplication factor for openturf shadower darkness. Lighting will be multiplied by this.
#define SHADOWER_LAYER 0

/var/datum/controller/subsystem/openturf/SSopenturf

/datum/controller/subsystem/openturf
	name = "Open Space"
	flags = SS_BACKGROUND | SS_FIRE_IN_LOBBY
	wait = 1
	init_order = SS_INIT_OPENTURF
	priority = SS_PRIORITY_OPENTURF

	var/list/queued_turfs = list()
	var/list/qt_idex = 1
	var/list/queued_overlays = list()
	var/list/qo_idex = 1

	var/list/openspace_overlays = list()
	var/list/openspace_turfs = list()

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
	// Flush the queue.
	fire(FALSE, TRUE)
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

	while (curr_turfs.len && qt_idex <= curr_turfs.len)
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
		var/depth = calculate_depth(T)
		if (depth > OPENTURF_MAX_DEPTH)
			depth = OPENTURF_MAX_DEPTH

		// Update the openturf itself.
		T.appearance = T.below
		T.name = initial(T.name)
		T.desc = "Below seems to be \a [T.below]."
		T.opacity = FALSE

		// Handle space parallax & starlight.
		if (T.is_above_space())
			T.plane = PLANE_SPACE_BACKGROUND
			/*if (config.starlight)	// Openturf starlight is broken. SSlighting and SSopenturf will fight if this is un-commented-out. Maybe someone will fix it someday.
				T.set_light(config.starlight, 0.5)*/
		else
			T.plane = OPENTURF_MAX_PLANE - depth
			/*if (config.starlight && T.light_range != 0)
				T.set_light(0)*/

		// Add everything below us to the update queue.
		for (var/thing in T.below)
			var/atom/movable/object = thing
			if (QDELETED(object) || object.no_z_overlay)
				// Don't queue deleted stuff or stuff that doesn't need an overlay.
				continue

			if (istype(object, /atom/movable/lighting_overlay))	// Special case.
				var/atom/movable/openspace/multiplier/shadower = T.shadower
				// This is duplicated in lighting_overlay.dm for performance reasons.
				shadower.appearance = object
				shadower.plane = OPENTURF_CAP_PLANE
				shadower.layer = SHADOWER_LAYER
				shadower.invisibility = 0
				if (shadower.icon_state == LIGHTING_BASE_ICON_STATE)
					// We're using a color matrix, so just darken the colors.
					var/list/c_list = shadower.color
					c_list[CL_MATRIX_RR] *= SHADOWER_DARKENING_FACTOR
					c_list[CL_MATRIX_RG] *= SHADOWER_DARKENING_FACTOR
					c_list[CL_MATRIX_RB] *= SHADOWER_DARKENING_FACTOR
					c_list[CL_MATRIX_GR] *= SHADOWER_DARKENING_FACTOR
					c_list[CL_MATRIX_GG] *= SHADOWER_DARKENING_FACTOR
					c_list[CL_MATRIX_GB] *= SHADOWER_DARKENING_FACTOR
					c_list[CL_MATRIX_BR] *= SHADOWER_DARKENING_FACTOR
					c_list[CL_MATRIX_BG] *= SHADOWER_DARKENING_FACTOR
					c_list[CL_MATRIX_BB] *= SHADOWER_DARKENING_FACTOR
					c_list[CL_MATRIX_AR] *= SHADOWER_DARKENING_FACTOR
					c_list[CL_MATRIX_AG] *= SHADOWER_DARKENING_FACTOR
					c_list[CL_MATRIX_AB] *= SHADOWER_DARKENING_FACTOR
					shadower.color = c_list
				else
					shadower.color = list(
						SHADOWER_DARKENING_FACTOR, 0, 0,
						0, SHADOWER_DARKENING_FACTOR, 0,
						0, 0, SHADOWER_DARKENING_FACTOR
					)

				if (shadower.bound_overlay)
					shadower.update_above()
			else
				if (!object.bound_overlay)	// Generate a new overlay if the atom doesn't already have one.
					object.bound_overlay = new(T)
					object.bound_overlay.associated_atom = object

				var/atom/movable/openspace/overlay/OO = object.bound_overlay

				// Cache our already-calculated depth so we don't need to re-calculate it a bunch of times.
				OO.depth = depth

				queued_overlays += OO

		T.updating = FALSE

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break

	if (qt_idex > 1 && qo_idex <= curr_turfs.len)
		curr_turfs.Cut(1, qt_idex)
		qt_idex = 1

	if (!no_mc_tick)
		MC_SPLIT_TICK

	while (curr_ov.len && qo_idex <= curr_ov.len)
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
		OO.plane = OPENTURF_MAX_PLANE - OO.depth
		OO.opacity = FALSE
		OO.queued = FALSE

		if (istype(OO.associated_atom, /atom/movable/openspace/multiplier) && OO.plane < OPENTURF_MAX_PLANE)	// Special case for multipliers.
			OO.plane++

		if (OO.bound_overlay)	// If we have a bound overlay, queue it too.
			OO.update_above()

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break

		if (qo_idex > 1 && qo_idex <= curr_ov.len)
			curr_ov.Cut(1, qo_idex)
			qo_idex = 1

/datum/controller/subsystem/openturf/proc/calculate_depth(turf/simulated/open/T)
	. = 0
	while (T && isopenturf(T.below))
		T = T.below
		.++
