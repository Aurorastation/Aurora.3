// The visual representation of an atom under an openspace turf.
/atom/movable/openspace/overlay
	plane = OPENTURF_MAX_PLANE
	var/atom/movable/associated_atom
	var/depth

/atom/movable/openspace/overlay/New()
	SSopenturf.openspace_overlays += src

/atom/movable/openspace/overlay/Destroy()
	SSopenturf.openspace_overlays -= src

	if (associated_atom)
		associated_atom.bound_overlay = null
		associated_atom = null

	return ..()

/atom/movable/openspace/overlay/attackby(obj/item/W, mob/user)
	user << span("notice", "\The [src] is too far away.")

/atom/movable/openspace/overlay/attack_hand(mob/user as mob)
	user << span("notice", "You cannot reach \the [src] from here.")

/atom/movable/openspace/overlay/attack_generic(mob/user as mob)
	user << span("notice", "You cannot reach \the [src] from here.")

/atom/movable/openspace/overlay/forceMove(atom/dest)
	. = ..()
	check_existence()

/atom/movable/openspace/overlay/Move()
	. = ..()
	check_existence()

// Checks if we've moved off of an openturf.
// Returns TRUE if we're continuing to exist, FALSE if we're deleting ourselves.
/atom/movable/openspace/overlay/proc/check_existence()
	if (!istype(loc, /turf/simulated/open))
		qdel(src)
		return FALSE
	else
		return TRUE
