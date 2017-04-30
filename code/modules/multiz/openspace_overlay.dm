// The visual representation of an atom under an openspace turf.
/atom/movable/openspace/overlay
	plane = OPENTURF_PLANE
	var/atom/movable/associated_atom

/atom/movable/openspace/overlay/proc/assume_appearance(atom/movable/target, override_plane = TRUE)
	// Bind ourselves to our atom so we follow it around.
	associated_atom = target
	target.bound_overlay = src

	dir = target.dir

	// Just let DM copy the atom's appearance.
	// This way we preserve layering & appearance without having to 
	// duplicate a lot of vars.

#if DM_VERSION > 510
	// Nice fast method with minimal appearance churn, but requires 511.

	var/mutable_appearance/MA = new(target)
	// Override these vars manually.
	if (override_plane)		// Space turfs should not have their plane overwritten.
		MA.plane = OPENTURF_PLANE

	//MA.pixel_x -= WORLD_ICON_SIZE / 4
	//MA.pixel_y -= WORLD_ICON_SIZE / 4
	appearance = MA
#else
	// Somewhat slower method that involves more appearance churn, but works with BYOND 510.
	appearance = target
	if (override_plane)
		plane = OPENTURF_PLANE

	//pixel_x -= WORLD_ICON_SIZE / 4
	//pixel_y -= WORLD_ICON_SIZE / 4
#endif

/atom/movable/openspace/overlay/forceMove(atom/dest)
	. = ..()
	check_existence()

/atom/movable/openspace/overlay/Move()
	. = ..()
	check_existence()

/atom/movable/openspace/overlay/proc/check_existence()
	set waitfor = FALSE
	if (!istype(loc, /turf/simulated/open))
		qdel(src)

/atom/movable/openspace/overlay/Destroy()
	if (associated_atom)
		associated_atom.bound_overlay = null
		associated_atom = null

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
	user << span("notice", "You can't reach that!")

/atom/movable/openspace/overlay/attack_hand(mob/user as mob)
	user << span("notice", "You can't reach that!")

/atom/movable/openspace/overlay/attack_generic(mob/user as mob)
	user << span("notice", "You can't reach that!")

/atom/movable/openspace/overlay/turf/attackby(obj/item/C as obj, mob/user as mob)
	if (istype(loc, /turf/simulated/open))
		return loc.attackby(C, user)
	else
		. = ..()
		qdel(src)		// These things should only exist on openturf tiles.
