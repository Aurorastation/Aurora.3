/atom
	var/atom/movable/openspace/overlay/bound_overlay

/atom/movable/openspace
	name = ""
	simulated = FALSE
	anchored = TRUE
	mouse_opacity = FALSE

// Used to darken the atoms on the openturf without fucking up colors.
/atom/movable/openspace/multiplier
	plane = OPENTURF_CAP_PLANE
	blend_mode = BLEND_MULTIPLY
	color = list(
		0.5, 0, 0,
		0, 0.5, 0,
		0, 0, 0.5
	)
