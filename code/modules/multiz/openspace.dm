/atom/proc/update_above()

/turf
	// Reference to any open turf that might be above us to speed up atom Entered() updates.
	var/tmp/turf/simulated/open/above
	//var/tmp/oo_light_set	// If the turf has had a light set by starlight.

/turf/Entered(atom/movable/thing, atom/oldLoc)
	. = ..()
	if (above && !thing.no_z_overlay && !thing.bound_overlay && !istype(oldLoc, /turf/simulated/open))
		above.update_icon()

/turf/Destroy()
	above = null
	return ..()

/turf/update_above()
	if (istype(above))
		above.update_icon()

/atom/movable
	var/tmp/atom/movable/openspace/overlay/bound_overlay	// The overlay that is directly mirroring us that we proxy movement to.
	var/no_z_overlay	// If TRUE, this atom will not be drawn on open turfs.

/atom/movable/Destroy()
	. = ..()
	QDEL_NULL(bound_overlay)

/atom/movable/Move()
	. = ..()
	if (bound_overlay)
		// The overlay will handle cleaning itself up on non-openspace turfs.
		bound_overlay.forceMove(get_step(src, UP))

/atom/movable/forceMove(atom/dest)
	. = ..(dest)
	if (bound_overlay)
		// The overlay will handle cleaning itself up on non-openspace turfs.
		bound_overlay.forceMove(get_step(src, UP))

/atom/movable/update_above()
	if (!bound_overlay)
		return

	// check_existence returns TRUE if the overlay is valid.
	if (bound_overlay.check_existence() && !bound_overlay.queued)
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

/atom/movable/openspace/shuttle_move()
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

/atom/movable/openspace/multiplier/Destroy()
	var/turf/simulated/open/myturf = loc
	if (istype(myturf))
		myturf.shadower = null

	return ..()

// The visual representation of an atom under an openspace turf.
/atom/movable/openspace/overlay
	plane = OPENTURF_MAX_PLANE
	var/atom/movable/associated_atom
	var/depth
	var/queued = FALSE
	var/destruction_timer

/atom/movable/openspace/overlay/New()
	initialized = TRUE
	SSopenturf.openspace_overlays += src

/atom/movable/openspace/overlay/Destroy()
	SSopenturf.openspace_overlays -= src

	if (associated_atom)
		associated_atom.bound_overlay = null
		associated_atom = null

	if (destruction_timer)
		deltimer(destruction_timer)

	return ..()

/atom/movable/openspace/overlay/attackby(obj/item/W, mob/user)
	user << span("notice", "\The [src] is too far away.")

/atom/movable/openspace/overlay/attack_hand(mob/user as mob)
	user << span("notice", "You cannot reach \the [src] from here.")

/atom/movable/openspace/overlay/attack_generic(mob/user as mob)
	user << span("notice", "You cannot reach \the [src] from here.")

/atom/movable/openspace/overlay/forceMove(atom/dest)
	. = ..()
	if (istype(dest, /turf/simulated/open))
		if (destruction_timer)
			deltimer(destruction_timer)
			destruction_timer = null
	else if (!destruction_timer)
		destruction_timer = addtimer(CALLBACK(GLOBAL_PROC, /proc/qdel, src), 10 SECONDS, TIMER_STOPPABLE)

// Checks if we've moved off of an openturf.
// Returns TRUE if we're continuing to exist, FALSE if we're deleting ourselves.
/atom/movable/openspace/overlay/proc/check_existence()
	if (!istype(loc, /turf/simulated/open))
		qdel(src)
		return FALSE
	else
		return TRUE

// Called when the turf we're on is deleted/changed.
/atom/movable/openspace/overlay/proc/owning_turf_changed()
	if (!destruction_timer)
		destruction_timer = addtimer(CALLBACK(GLOBAL_PROC, /proc/qdel, src), 10 SECONDS, TIMER_STOPPABLE)
