/turf
	// Reference to any open turf that might be above us to speed up atom Entered() updates.
	var/tmp/turf/above
	var/tmp/turf/below
	var/tmp/atom/movable/openspace/turf_overlay/bound_overlay
	var/tmp/atom/movable/openspace/multiplier/shadower		// Overlay used to multiply color of all OO overlays at once.

/turf/Entered(atom/movable/thing, turf/oldLoc)
	. = ..()
	if (thing.bound_overlay || !thing.no_z_overlay || !above || !(above.flags & MIMIC_BELOW) || (isturf(oldLoc) && oldLoc.above && (oldLoc.above.flags & MIMIC_BELOW)))
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
		SSopenturf.queued_turfs += src

	if (recurse)
		update_above()	// Even if we're already updating, the turf above us might not be.

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
