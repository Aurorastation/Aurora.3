/turf
	// Reference to any open turf that might be above us to speed up atom Entered() updates.
	var/tmp/turf/simulated/open/above

/turf/Entered(atom/movable/thing, atom/oldLoc)
	..()
	if (above && !istype(oldLoc, /turf/simulated/open))
		above.update_icon()

/turf/Destroy()
	. = ..()
	above = null

/atom/movable
	var/tmp/atom/movable/openspace/overlay/bound_overlay	// The overlay that is directly mirroring us that we proxy movement to.
	var/no_z_overlay	// If TRUE, this atom will not be drawn on open turfs.

/atom/movable/Destroy()
	. = ..()
	if (bound_overlay)
		if (istype(bound_overlay.loc, /turf/simulated/open))
			bound_overlay.loc:update()

		QDEL_NULL(bound_overlay)

/atom/movable/Move()
	..()
	if (bound_overlay)
		// These should only ever be located on open-turf tiles.
		var/turf/the_loc = bound_overlay.loc
		if (!istype(the_loc, /turf/simulated/open))
			QDEL_NULL(bound_overlay)
		else
			bound_overlay.forceMove(get_step(src, UP))

// -- Openspace movables --

/atom/movable/openspace
	name = ""
	simulated = FALSE
	anchored = TRUE
	mouse_opacity = FALSE

// Used to darken the atoms on the openturf without fucking up colors.
/atom/movable/openspace/multiplier
	name = "openspace multiplier"
	desc = "You shoudn't see this."
	icon = 'icons/misc/openspace.dmi'
	icon_state = "white"
	plane = OPENTURF_CAP_PLANE
	blend_mode = BLEND_MULTIPLY
	color = list(
		0.5, 0, 0,
		0, 0.5, 0,
		0, 0, 0.5
	)

// /atom/movable/openspace/overlay is in openspace_overlay.dm
