/atom
	var/tmp/atom/movable/openspace/overlay/bound_overlay	// The overlay that is directly mirroring us that we proxy movement to.
	var/no_z_overlay	// If TRUE, this atom will not be drawn on open turfs.

/atom/Destroy()
	. = ..()
	if (bound_overlay)
		if (istype(bound_overlay.loc, /turf/simulated/open))
			bound_overlay.loc:update()

		QDEL_NULL(bound_overlay)

/turf
	// Reference to any open turf that might be above us to speed up atom Entered() updates.
	var/tmp/turf/simulated/open/above
	var/tmp/oo_light_set	// If the turf has had a light set by starlight.

/turf/Entered(atom/movable/thing, atom/oldLoc)
	..()
	if (above && !istype(oldLoc, /turf/simulated/open))
		above.update_icon()

/turf/Destroy()
	. = ..()
	above = null

/atom/movable
	var/tmp/destroy_oo_next_move

/atom/movable/Move()
	..()
	if (bound_overlay)
		if (destroy_oo_next_move)
			QDEL_NULL(bound_overlay)
			destroy_oo_next_move = FALSE
		else
			// These should only ever be located on open-turf tiles.
			var/turf/the_loc = bound_overlay.loc
			if (!istype(the_loc, /turf/simulated/open))
				destroy_oo_next_move = TRUE
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
		0.75, 0, 0,
		0, 0.75, 0,
		0, 0, 0.75
	)


// /atom/movable/openspace/overlay is in openspace_overlay.dm
