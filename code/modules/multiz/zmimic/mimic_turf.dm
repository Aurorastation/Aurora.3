/turf
	// Reference to any open turf that might be above us to speed up atom Entered() updates.
	var/tmp/turf/above
	var/tmp/turf/below
	var/tmp/atom/movable/openspace/turf_overlay/bound_overlay
	var/tmp/atom/movable/openspace/multiplier/shadower		// Overlay used to multiply color of all OO overlays at once.

/turf/Entered(atom/movable/thing, turf/oldLoc)
	. = ..()
	if (thing.bound_overlay || thing.no_z_overlay || !TURF_IS_MIMICING(above))
		return
	above.update_mimic()

/turf/update_above()
	if (TURF_IS_MIMICING(above))
		above.update_mimic()

/turf/proc/update_mimic(recurse = TRUE)
	if (!(flags & MIMIC_BELOW))
		return

	if (below && !(flags & MIMIC_QUEUED))	
		flags |= MIMIC_QUEUED
		SSzcopy.queued_turfs += src

	if (recurse)
		update_above()	// Even if we're already updating, the turf above us might not be.

// Enables Z-mimic for a turf that didn't already have it enabled.
/turf/proc/enable_zmimic(additional_flags = 0)
	if (flags & MIMIC_BELOW)
		return FALSE

	flags |= MIMIC_BELOW | additional_flags
	setup_zmimic(FALSE)
	return TRUE

// Disables Z-mimic for a turf.
/turf/proc/disable_zmimic()
	if (!(flags & MIMIC_BELOW))
		return FALSE

	flags &= ~MIMIC_BELOW
	cleanup_zmimic()

// Sets up Z-mimic for this turf. You shouldn't call this directly 99% of the time.
/turf/proc/setup_zmimic(mapload)
	if (shadower)
		CRASH("Attempt to enable Z-mimic on already-enabled turf!")
	shadower = new(src)
	SSzcopy.openspace_turfs += src
	var/turf/under = GetBelow(src)
	if (under)
		below = under
		below.above = src

	update_mimic(!mapload)	// Only recursively update if the map isn't loading.

// Cleans up Z-mimic objects for this turf. You shouldn't call this directly 99% of the time.
/turf/proc/cleanup_zmimic()
	SSzcopy.openspace_turfs -= src
	if (flags & MIMIC_QUEUED)
		SSzcopy.queued_turfs -= src

	QDEL_NULL(shadower)

	for (var/atom/movable/openspace/overlay/OwO in src)	// wats this~?
		OwO.owning_turf_changed()

	if (above)
		above.update_mimic()

	if (below)
		below.above = null
		below = null

// Movable for mimicing turfs that don't allow appearance mutation.
/atom/movable/openspace/turf_overlay
	plane = OPENTURF_MAX_PLANE

/atom/movable/openspace/turf_overlay/attackby(obj/item/W, mob/user)
	loc.attackby(W, user)

/atom/movable/openspace/turf_overlay/attack_hand(mob/user as mob)
	loc.attack_hand(user)

/atom/movable/openspace/turf_overlay/attack_generic(mob/user as mob)
	loc.attack_generic(user)

/atom/movable/openspace/turf_overlay/examine(mob/examiner)
	loc.examine(examiner)
