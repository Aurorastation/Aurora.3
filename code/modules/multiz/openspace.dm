/atom
	var/atom/movable/openspace/overlay/bound_overlay
	// Var so we can prevent Entered() from moving the overlay if we've already done it elsewhere.
	var/tmp/checked_movement_this_tick = FALSE

/atom/Entered()
	..()
	if (bound_overlay && !checked_movement_this_tick)
		// These should only ever be located 
		var/turf/the_loc = bound_overlay.loc
		if (!istype(the_loc, /turf/simulated/open))
			qdel(bound_overlay)
			bound_overlay = null
		else
			var/turf/simulated/open/openturf = the_loc
			openturf.update()

/atom/Destroy()
	. = ..()
	if (bound_overlay)
		if (istype(bound_overlay.loc, /turf/simulated/open))
			bound_overlay.loc:update()
		qdel(bound_overlay)
		bound_overlay = null

/turf
	// Reference to any open turf that might be above us to speed up atom Entered() updates.
	var/tmp/turf/simulated/open/above


/turf/Entered()
	..()
	if (above)
		above.update_icon()

/turf/Destroy()
	. = ..()
	above = null

// -- Openspace movables --

/atom/movable/openspace
	name = ""
	simulated = FALSE
	anchored = TRUE
	mouse_opacity = FALSE

// Used to darken the atoms on the openturf without fucking up colors.
/atom/movable/openspace/multiplier
	icon = 'icons/misc/openspace.dmi'
	icon_state = "white"
	plane = OPENTURF_CAP_PLANE
	blend_mode = BLEND_MULTIPLY
	color = list(
		0.5, 0, 0,
		0, 0.5, 0,
		0, 0, 0.5
	)
