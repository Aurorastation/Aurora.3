/atom/movable
	var/atom/movable/openspace_overlay/bound_overlay

/atom/movable/openspace_overlay
	name = ""
	simulated = FALSE
	anchored = TRUE
	plane = OPENTURF_PLANE
	var/atom/movable/associated_atom

/atom/movable/openspace_overlay/proc/assume_appearance(atom/movable/target)
	// Bind ourselves to our atom so we follow it around.
	associated_atom = target
	target.bound_overlay = src

	// Just let DM copy the atom's appearance.
	// This way we preserve layering & appearance without having to 
	// duplicate a lot of vars.
	appearance = target
	// Reset these vars because appearance probably overwrote them.
	dir = target.dir
	plane = OPENTURF_PLANE
	color = list(
		0.5, 0, 0,
		0, 0.5, 0,
		0, 0, 0.5
	)
	//pixel_x = 10
	pixel_y = -10

/atom/movable/openspace_overlay/forceMove(atom/dest)
	. = ..()
	check_existence()

/atom/movable/openspace_overlay/Move()
	. = ..()
	check_existence()

/atom/movable/openspace_overlay/proc/check_existence()
	set waitfor = FALSE
	if (!istype(loc, /turf/simulated/open))
		qdel(src)

/atom/movable/openspace_overlay/Destroy()
	if (associated_atom)
		associated_atom.bound_overlay = null
		associated_atom = null

	return ..()

// No blowing up abstract objects.
/atom/movable/openspace_overlay/ex_act(ex_sev)
	return

/atom/movable/openspace_overlay/singularity_act()
	return

/atom/movable/openspace_overlay/singularity_pull()
	return

/atom/movable/openspace_overlay/singuloCanEat()
	return

/atom/movable/openspace_overlay/attackby(obj/item/W, mob/user)
	user << span("notice", "You can't reach that!")

/atom/movable/openspace_overlay/attack_hand(mob/user as mob)
	user << span("notice", "You can't reach that!")

/atom/movable/openspace_overlay/attack_generic(mob/user as mob)
	user << span("notice", "You can't reach that!")

/atom/movable/openspace_overlay/turf/attackby(obj/item/C as obj, mob/user as mob)
	if (istype(loc, /turf/simulated/open))
		return loc.attackby(C, user)
	else
		. = ..()
		qdel(src)		// These things should only exist on openturf tiles.
