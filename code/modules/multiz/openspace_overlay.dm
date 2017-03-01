/atom/movable/openspace_overlay
	name = ""
	simulated = FALSE
	anchored = TRUE
	plane = OPENTURF_PLANE
	var/persistant = FALSE

/atom/movable/openspace_overlay/proc/assume_appearance(atom/movable/target)
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

/atom/movable/openspace_overlay/ex_act(ex_sev)
	return

/atom/movable/openspace_overlay/singularity_act()
	return

/atom/movable/openspace_overlay/singularity_pull()
	return

/atom/movable/openspace_overlay/singuloCanEat()
	return

/atom/movable/attackby(obj/item/W, mob/user)
	user << span("notice", "You can't reach that!")

/atom/movable/attack_hand(mob/user as mob)
	user << span("notice", "You can't reach that!")

/atom/movable/attack_generic(mob/user as mob)
	user << span("notice", "You can't reach that!")

/atom/movable/openspace_overlay/turf/attackby(obj/item/C as obj, mob/user as mob)
	if (istype(loc, /turf/simulated/open))
		return loc.attackby(C, user)
	else
		return ..()

/atom/movable/openspace_overlay/mob
	var/mob/associated_mob
	persistant = TRUE
