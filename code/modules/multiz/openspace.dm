/turf
	// Reference to any open turf that might be above us to speed up atom Entered() updates.
	var/tmp/turf/simulated/open/above
	var/tmp/oo_light_set	// If the turf has had a light set by starlight.

/turf/Entered(atom/movable/thing, atom/oldLoc)
	. = ..()
	if (above && !istype(oldLoc, /turf/simulated/open))
		above.update_icon()

/turf/Destroy()
	above = null
	return ..()

/atom/movable
	var/tmp/atom/movable/openspace/overlay/bound_overlay	// The overlay that is directly mirroring us that we proxy movement to.
	var/no_z_overlay	// If TRUE, this atom will not be drawn on open turfs.

/atom/movable/Destroy()
	. = ..()
	if (bound_overlay)
		if (istype(bound_overlay.loc, /turf/simulated/open))
			bound_overlay.loc:update_icon()

		QDEL_NULL(bound_overlay)

/atom/movable/Move()
	. = ..()
	if (bound_overlay)
		// These should only ever be located on open-turf tiles.
		var/turf/the_loc = bound_overlay.loc
		if (!istype(the_loc, /turf/simulated/open))
			addtimer(CALLBACK(bound_overlay, /atom/movable/openspace/overlay/.proc/check_existence), 1 SECOND, TIMER_UNIQUE | TIMER_OVERRIDE)
		else
			bound_overlay.forceMove(get_step(src, UP))

/atom/movable/forceMove(atom/dest)
	. = ..(dest)
	if (bound_overlay)
		// These should only ever be located on open-turf tiles.
		var/turf/the_loc = bound_overlay.loc
		if (!istype(the_loc, /turf/simulated/open))
			addtimer(CALLBACK(bound_overlay, /atom/movable/openspace/overlay/.proc/check_existence), 1 SECOND, TIMER_UNIQUE)
		else
			bound_overlay.forceMove(get_step(src, UP))

/atom/movable/proc/update_oo()
	if (!bound_overlay)
		return

	// check_existence returns TRUE if the overlay is valid.
	if (bound_overlay.check_existence())
		SSopenturf.queued_overlays += bound_overlay

/atom/movable/proc/get_above_oo()
	. = list()
	var/atom/movable/curr = src
	while (curr.bound_overlay)
		. += curr.bound_overlay
		curr = curr.bound_overlay

// -- Openspace movables --

/atom/movable/openspace
	name = ""
	simulated = FALSE
	anchored = TRUE
	mouse_opacity = FALSE

/atom/movable/openspace/can_fall()
	return FALSE

// No blowing up abstract objects.
/atom/movable/openspace/ex_act(ex_sev)
	return

/atom/movable/openspace/singularity_act()
	return

/atom/movable/openspace/singularity_pull()
	return

/atom/movable/openspace/singuloCanEat()
	return

// Used to darken the atoms on the openturf without fucking up colors.
/atom/movable/openspace/multiplier
	name = "openspace multiplier"
	desc = "You shouldn't see this."
	icon = 'icons/misc/openspace.dmi'
	icon_state = "white"
	plane = OPENTURF_CAP_PLANE
	blend_mode = BLEND_MULTIPLY
	color = list(
		0.75, 0, 0,
		0, 0.75, 0,
		0, 0, 0.75
	)
	no_z_overlay = TRUE

/atom/movable/openspace/multiplier/Destroy()
	var/turf/simulated/open/myturf = loc
	if (istype(myturf))
		myturf.shadower = null

	return ..()

// /atom/movable/openspace/overlay is in openspace_overlay.dm
