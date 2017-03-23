// The visual representation of an atom under an openspace turf.
/atom/movable/openspace/overlay
	plane = OPENTURF_PLANE
	var/atom/movable/associated_atom

/atom/movable/openspace/overlay/New()
	global.all_openspace_overlays += src

/atom/movable/openspace/overlay/proc/assume_appearance(atom/target, override_plane = TRUE)
	// Bind ourselves to our atom so we follow it around.
	associated_atom = target
	if (istype(target, /atom/movable))
		var/atom/movable/AM = target
		AM.bound_overlay = src

	dir = target.dir

	// Just let DM copy the atom's appearance.
	// This way we preserve layering & appearance without having to 
	// duplicate a lot of vars.
	appearance = target

	// Space turfs shouldn't have their plane overridden, so this is a param.
	if (override_plane)
		plane = OPENTURF_PLANE

	//pixel_x -= WORLD_ICON_SIZE / 4
	//pixel_y -= WORLD_ICON_SIZE / 4

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

/atom/movable/openspace/overlay/turf/attackby(obj/item/C as obj, mob/user as mob)
	if (istype(loc, /turf/simulated/open))
		return loc.attackby(C, user)
	else
		. = ..()
		qdel(src)		// These things should only exist on openturf tiles.

/atom/movable/openspace/overlay/turf/Destroy()
	if (istype(loc, /turf/simulated/open))
		var/turf/simulated/open/T = loc
		T.turf_overlay = null
		T.update_icon()

	return ..()
