/turf
	// Reference to any open turf that might be above us to speed up atom Entered() updates.
	var/tmp/turf/above
	var/tmp/turf/below
	var/tmp/atom/movable/openspace/turf_overlay/bound_overlay
	var/z_mimic_flags = Z_NO_MIMIC
	var/tmp/atom/movable/openspace/multiplier/z_shadower		// Overlay used to multiply color of all OO overlays at once.

/turf/Entered(atom/movable/thing, atom/oldLoc)
	. = ..()
	if (!thing.bound_overlay && TURF_IS_ZMIMICING(above) && !TURF_IS_ZMIMICING(oldLoc) && !thing.no_z_overlay)
		above.update_z_mimic()

/turf/update_above()
	if (above && (above.z_mimic_flags & Z_MIMIC))
		above.update_z_mimic()

/turf/proc/update_z_mimic(recurse = TRUE)
	if (!(z_mimic_flags & Z_MIMIC))
		return

	if (below && !(z_mimic_flags & Z_QUEUED))	
		z_mimic_flags |= Z_QUEUED
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
