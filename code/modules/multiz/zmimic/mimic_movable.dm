/atom/movable
	/// The mimic (if any) that's *directly* copying us.
	var/tmp/atom/movable/openspace/mimic/bound_overlay
	/// If TRUE, this atom is ignored by Z-Mimic.
	var/z_flags

/atom/movable/set_dir(ndir)
	. = ..()
	if (. && bound_overlay)
		bound_overlay.set_dir(ndir)

/atom/movable/update_above()
	if (!bound_overlay || !isturf(loc))
		return

	var/turf/T = loc

	if (TURF_IS_MIMICING(T.above))
		SSzcopy.queued_overlays += bound_overlay
		bound_overlay.queued += 1
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
	SHOULD_CALL_PARENT(FALSE)
	return

/atom/movable/openspace/singularity_act()
	return

/atom/movable/openspace/singularity_pull()
	return

/atom/movable/openspace/singuloCanEat()
	return

// -- MULTIPLIER / SHADOWER --

// Holder object used for dimming openspaces & copying lighting of below turf.
/atom/movable/openspace/multiplier
	name = "openspace multiplier"
	desc = DESC_PARENT
	icon = 'icons/effects/lighting_overlay.dmi'
	icon_state = "dark"
	plane = OPENTURF_MAX_PLANE
	layer = MIMICED_LIGHTING_LAYER
//	blend_mode = BLEND_MULTIPLY
	color = "#00000033"

/atom/movable/openspace/multiplier/Destroy()
	var/turf/myturf = loc
	if (istype(myturf))
		myturf.shadower = null

	return ..()

/atom/movable/openspace/multiplier/proc/copy_lighting(atom/movable/lighting_overlay/LO)
	appearance = LO
	layer = MIMICED_LIGHTING_LAYER
	plane = OPENTURF_MAX_PLANE
	set_invisibility(0)
	if (icon_state == null)
		blend_mode = BLEND_MULTIPLY
		// We're using a color matrix, so just darken the colors across the board.
		// Bay stores lights as inverted so the lighting PM can invert it for darksight, but
		//   we don't have a plane master, so invert it again.
		var/list/c_list = color
		c_list[CL_MATRIX_RR] *= -SHADOWER_DARKENING_FACTOR
		c_list[CL_MATRIX_RG] *= -SHADOWER_DARKENING_FACTOR
		c_list[CL_MATRIX_RB] *= -SHADOWER_DARKENING_FACTOR
		c_list[CL_MATRIX_GR] *= -SHADOWER_DARKENING_FACTOR
		c_list[CL_MATRIX_GG] *= -SHADOWER_DARKENING_FACTOR
		c_list[CL_MATRIX_GB] *= -SHADOWER_DARKENING_FACTOR
		c_list[CL_MATRIX_BR] *= -SHADOWER_DARKENING_FACTOR
		c_list[CL_MATRIX_BG] *= -SHADOWER_DARKENING_FACTOR
		c_list[CL_MATRIX_BB] *= -SHADOWER_DARKENING_FACTOR
		c_list[CL_MATRIX_AR] *= -SHADOWER_DARKENING_FACTOR
		c_list[CL_MATRIX_AG] *= -SHADOWER_DARKENING_FACTOR
		c_list[CL_MATRIX_AB] *= -SHADOWER_DARKENING_FACTOR
		color = c_list
	else
		// Not a color matrix, so we just ignore the lighting values.
		icon_state = "dark"	// this is actually just a white sprite, which is what this blending needs
		color = list(
			SHADOWER_DARKENING_FACTOR, 0, 0,
			0, SHADOWER_DARKENING_FACTOR, 0,
			0, 0, SHADOWER_DARKENING_FACTOR
		)

	var/turf/parent = loc
	ASSERT(isturf(parent))
	if (LAZYLEN(parent.ao_overlays_mimic))
		overlays += parent.ao_overlays_mimic

	if (bound_overlay)
		update_above()

// -- OPENSPACE OVERLAY --
// todo: rename

// Object used to hold a mimiced atom's appearance.
/atom/movable/openspace/mimic
	plane = OPENTURF_MAX_PLANE
	var/atom/movable/associated_atom
	var/depth
	var/queued = 0
	var/destruction_timer
	var/mimiced_type
	var/original_z
	var/override_depth
	var/have_performed_fixup = FALSE

/atom/movable/openspace/mimic/Initialize(mapload, ...)
	. = ..()
	SSzcopy.openspace_overlays += 1

/atom/movable/openspace/mimic/Destroy()
	SSzcopy.openspace_overlays -= 1

	if (associated_atom)
		associated_atom.bound_overlay = null
		associated_atom = null

	if (destruction_timer)
		deltimer(destruction_timer)

	return ..()

/atom/movable/openspace/mimic/attackby(obj/item/attacking_item, mob/user)
	to_chat(user, SPAN_NOTICE("\The [src] is too far away."))

/atom/movable/openspace/mimic/attack_hand(mob/user)
	to_chat(user, SPAN_NOTICE("You cannot reach \the [src] from here."))

/atom/movable/openspace/mimic/examine(mob/user, distance, is_adjacent, infix, suffix, show_extended)
	SHOULD_CALL_PARENT(FALSE)
	. = associated_atom.examine(arglist(args))	// just pass all the args to the copied atom

/atom/movable/openspace/mimic/forceMove(atom/destination)
	. = ..()
	if (TURF_IS_MIMICING(destination))
		if (destruction_timer)
			deltimer(destruction_timer)
			destruction_timer = null
	else if (!destruction_timer)
		destruction_timer = addtimer(CALLBACK(src, TYPE_PROC_REF(/datum, qdel_self)), 10 SECONDS, TIMER_STOPPABLE)

// Called when the turf we're on is deleted/changed.
/atom/movable/openspace/mimic/proc/owning_turf_changed()
	if (!destruction_timer)
		destruction_timer = addtimer(CALLBACK(src, TYPE_PROC_REF(/datum, qdel_self)), 10 SECONDS, TIMER_STOPPABLE)

// -- TURF PROXY --

// This thing holds the mimic appearance for non-OVERWRITE turfs.
/atom/movable/openspace/turf_proxy
	plane = OPENTURF_MAX_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	z_flags = ZMM_IGNORE  // Only one of these should ever be visible at a time, the mimic logic will handle that.

/atom/movable/openspace/turf_proxy/attackby(obj/item/attacking_item, mob/user)
	loc.attackby(attacking_item, user)

/atom/movable/openspace/turf_proxy/attack_hand(mob/user as mob)
	loc.attack_hand(user)

/atom/movable/openspace/turf_proxy/attack_generic(mob/user, damage, attack_message, environment_smash, armor_penetration, attack_flags, damage_type)
	loc.attack_generic(user)

/atom/movable/openspace/turf_proxy/examine(mob/user, distance, is_adjacent, infix, suffix, show_extended)
	SHOULD_CALL_PARENT(FALSE)
	. = loc.examine(arglist(args))


// -- TURF MIMIC --

// A type for copying non-overwrite turfs' self-appearance.
/atom/movable/openspace/turf_mimic
	plane = OPENTURF_MAX_PLANE	// These *should* only ever be at the top?
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/turf/delegate

/atom/movable/openspace/turf_mimic/Initialize(mapload, ...)
	. = ..()
	ASSERT(isturf(loc))
	var/turf/T = loc
	delegate = T.below

/atom/movable/openspace/turf_mimic/attackby(obj/item/attacking_item, mob/user)
	loc.attackby(attacking_item, user)

/atom/movable/openspace/turf_mimic/attack_hand(mob/user as mob)
	to_chat(user, SPAN_NOTICE("You cannot reach \the [src] from here."))

/atom/movable/openspace/turf_mimic/attack_generic(mob/user, damage, attack_message, environment_smash, armor_penetration, attack_flags, damage_type)
	to_chat(user, SPAN_NOTICE("You cannot reach \the [src] from here."))

/atom/movable/openspace/turf_mimic/examine(mob/user, distance, is_adjacent, infix, suffix, show_extended)
	SHOULD_CALL_PARENT(FALSE)
	. = delegate.examine(arglist(args))
