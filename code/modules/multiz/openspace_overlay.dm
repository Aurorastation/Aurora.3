// The visual representation of an atom under an openspace turf.
/atom/movable/openspace/overlay
	plane = OPENTURF_MAX_PLANE
	var/atom/movable/associated_atom

/atom/movable/openspace/overlay/New()
	global.all_openspace_overlays += src

/atom/movable/openspace/overlay/forceMove(atom/dest)
	. = ..()
	check_existence()

/atom/movable/openspace/overlay/Move()
	. = ..()
	check_existence()

/atom/movable/openspace/overlay/proc/check_existence()
	if (!istype(loc, /turf/simulated/open))
		qdel(src)

/atom/movable/openspace/overlay/Destroy()
	if (associated_atom)
		associated_atom.bound_overlay = null
		associated_atom = null

	global.all_openspace_overlays -= src

	return ..()

// No blowing up abstract objects.
/atom/movable/openspace/overlay/ex_act(ex_sev)
	return

/atom/movable/openspace/overlay/singularity_act()
	return

/atom/movable/openspace/overlay/singularity_pull()
	return

/atom/movable/openspace/overlay/singuloCanEat()
	return

/atom/movable/openspace/overlay/attackby(obj/item/W, mob/user)
	user << span("notice", "\The [src] is too far away.")

/atom/movable/openspace/overlay/attack_hand(mob/user as mob)
	user << span("notice", "You cannot reach \the [src] from here.")

/atom/movable/openspace/overlay/attack_generic(mob/user as mob)
	user << span("notice", "You cannot reach \the [src] from here.")
