/atom/movable
	var/tmp/atom/movable/openspace/overlay/bound_overlay	// The overlay that is directly mirroring us that we proxy movement to.
	var/no_z_overlay	// If TRUE, this atom will not be drawn on open turfs.

/atom/movable/Destroy()
	. = ..()
	if (bound_overlay)
		QDEL_NULL(bound_overlay)

/atom/movable/forceMove(atom/dest)
	. = ..(dest)
	if (bound_overlay)
		// The overlay will handle cleaning itself up on non-openspace turfs.
		if (isturf(dest))
			bound_overlay.forceMove(get_step(src, UP))
			bound_overlay.set_dir(dir)
		else	// Not a turf, so we need to destroy immediately instead of waiting for the destruction timer to proc.
			qdel(bound_overlay)

/atom/movable/set_dir(ndir)
	. = ..()
	if (. && bound_overlay)
		bound_overlay.set_dir(ndir)

/atom/movable/update_above()
	if (!bound_overlay)
		return

	if (TURF_IS_MIMICING(loc))
		if (!bound_overlay.queued)
			SSzcopy.queued_overlays += bound_overlay
			bound_overlay.queued = TRUE
	else
		qdel(bound_overlay)

// Grabs a list of every openspace object that's directly or indirectly mimicing this object. Returns an empty list if none found.
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

/atom/movable/openspace/shuttle_move()
	return

// Holder object used for dimming openspaces & copying lighting of below turf.
/atom/movable/openspace/multiplier
	name = "openspace multiplier"
	desc = "You shouldn't see this."
	icon = 'icons/effects/lighting_overlay.dmi'
	icon_state = "blank"
	plane = OPENTURF_CAP_PLANE
	layer = LIGHTING_LAYER
	blend_mode = BLEND_MULTIPLY
	color = list(
		SHADOWER_DARKENING_FACTOR, 0, 0,
		0, SHADOWER_DARKENING_FACTOR, 0,
		0, 0, SHADOWER_DARKENING_FACTOR
	)

/atom/movable/openspace/multiplier/Destroy()
	var/turf/myturf = loc
	if (istype(myturf))
		myturf.shadower = null

	return ..()

/atom/movable/openspace/multiplier/proc/copy_lighting(atom/movable/lighting_overlay/LO)
	appearance = LO
	layer = LIGHTING_LAYER + 0.001
	plane = OPENTURF_CAP_PLANE
	invisibility = 0
	if (icon_state == LIGHTING_BASE_ICON_STATE)
		// We're using a color matrix, so just darken the colors across the board.
		var/list/c_list = color
		c_list[CL_MATRIX_RR] *= SHADOWER_DARKENING_FACTOR
		c_list[CL_MATRIX_RG] *= SHADOWER_DARKENING_FACTOR
		c_list[CL_MATRIX_RB] *= SHADOWER_DARKENING_FACTOR
		c_list[CL_MATRIX_GR] *= SHADOWER_DARKENING_FACTOR
		c_list[CL_MATRIX_GG] *= SHADOWER_DARKENING_FACTOR
		c_list[CL_MATRIX_GB] *= SHADOWER_DARKENING_FACTOR
		c_list[CL_MATRIX_BR] *= SHADOWER_DARKENING_FACTOR
		c_list[CL_MATRIX_BG] *= SHADOWER_DARKENING_FACTOR
		c_list[CL_MATRIX_BB] *= SHADOWER_DARKENING_FACTOR
		c_list[CL_MATRIX_AR] *= SHADOWER_DARKENING_FACTOR
		c_list[CL_MATRIX_AG] *= SHADOWER_DARKENING_FACTOR
		c_list[CL_MATRIX_AB] *= SHADOWER_DARKENING_FACTOR
		color = c_list
	else
		// Not a color matrix, so we can just use the color var ourselves.
		color = list(
			SHADOWER_DARKENING_FACTOR, 0, 0,
			0, SHADOWER_DARKENING_FACTOR, 0,
			0, 0, SHADOWER_DARKENING_FACTOR
		)

	if (our_overlays || priority_overlays)
		compile_overlays()
	else if (bound_overlay)
		// compile_overlays() calls update_above().
		update_above()

// Object used to hold a mimiced atom's appearance.
/atom/movable/openspace/overlay
	plane = OPENTURF_MAX_PLANE
	var/atom/movable/associated_atom
	var/depth
	var/queued = FALSE
	var/destruction_timer

/atom/movable/openspace/overlay/New()
	initialized = TRUE
	SSzcopy.openspace_overlays += src

/atom/movable/openspace/overlay/Destroy()
	SSzcopy.openspace_overlays -= src

	if (associated_atom)
		associated_atom.bound_overlay = null
		associated_atom = null

	if (destruction_timer)
		deltimer(destruction_timer)

	return ..()

/atom/movable/openspace/overlay/attackby(obj/item/W, mob/user)
	to_chat(user, span("notice", "\The [src] is too far away."))

/atom/movable/openspace/overlay/attack_hand(mob/user as mob)
	to_chat(user, span("notice", "You cannot reach \the [src] from here."))

/atom/movable/openspace/overlay/attack_generic(mob/user as mob)
	to_chat(user, span("notice", "You cannot reach \the [src] from here."))

/atom/movable/openspace/overlay/examine(mob/examiner)
	associated_atom.examine(examiner)

/atom/movable/openspace/overlay/forceMove(turf/dest)
	. = ..()
	if (TURF_IS_MIMICING(dest))
		if (destruction_timer)
			deltimer(destruction_timer)
			destruction_timer = null
	else if (!destruction_timer)
		destruction_timer = addtimer(CALLBACK(GLOBAL_PROC, /proc/qdel, src), 10 SECONDS, TIMER_STOPPABLE)

// Called when the turf we're on is deleted/changed.
/atom/movable/openspace/overlay/proc/owning_turf_changed()
	if (!destruction_timer)
		destruction_timer = addtimer(CALLBACK(GLOBAL_PROC, /proc/qdel, src), 10 SECONDS, TIMER_STOPPABLE)

// This one's a little different because it's mimicing a turf.
/atom/movable/openspace/turf_overlay
	plane = OPENTURF_MAX_PLANE

/atom/movable/openspace/turf_overlay/attackby(obj/item/W, mob/user)
	loc.attackby(W, user)

/atom/movable/openspace/turf_overlay/attack_hand(mob/user as mob)
	loc.attack_hand(user)

/atom/movable/openspace/turf_overlay/attack_generic(mob/user as mob)
	loc.attack_generic(user)

/atom/movable/openspace/turf_overlay/examine(mob/examiner)
	loc.examine(examiner)
