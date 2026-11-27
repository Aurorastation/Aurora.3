/// Things with this component can be leaned onto
/datum/component/leanable
	/// How much will mobs that lean onto this object be offset
	var/leaning_offset = 11
	/// List of mobs currently leaning on our parent
	var/list/leaning_mobs
	/// Is this object currently leanable?
	var/is_currently_leanable = TRUE

/datum/component/leanable/Initialize(mob/living/leaner, leaning_offset = 11)
	. = ..()
	src.leaning_offset = leaning_offset
	mousedrop_receive(parent, leaner, leaner)

/datum/component/leanable/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOUSEDROPPED_ONTO, PROC_REF(mousedrop_receive))
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))
	RegisterSignal(parent, COMSIG_ATOM_DENSITY_CHANGED, PROC_REF(on_density_change))
	var/atom/leanable_atom = parent
	is_currently_leanable = leanable_atom.density

/datum/component/leanable/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, list(
		COMSIG_MOVABLE_MOVED,
		COMSIG_MOUSEDROPPED_ONTO,
		COMSIG_ATOM_DENSITY_CHANGED,
	))

/datum/component/leanable/Destroy(force)
	stop_leaning_leaners()
	return ..()

/datum/component/leanable/proc/stop_leaning_leaners(fall)
	for (var/mob/living/leaner as anything in leaning_mobs)
		if(fall)
			leaner.visible_message(SPAN_WARNING("[leaner] loses their balance!"), SPAN_DANGER("You lose balance!"))
			leaner.Weaken(rand(3,5))
		leaner.stop_leaning()
	LAZYCLEARLIST(leaning_mobs)

/datum/component/leanable/proc/on_moved(datum/source)
	SIGNAL_HANDLER

	for (var/mob/living/leaner as anything in leaning_mobs)
		leaner.stop_leaning()

/datum/component/leanable/proc/mousedrop_receive(atom/source, atom/movable/dropped, mob/user, params)
	if (dropped != user)
		return
	if (!iscarbon(dropped))
		return
	var/mob/living/leaner = dropped
	var/can_lean = TRUE

	if (HAS_TRAIT_FROM(leaner, TRAIT_UNDENSE, TRAIT_LEANING))
		return

	if(istype(leaner.l_hand, /obj/item/grab) || istype(leaner.r_hand, /obj/item/grab))
		can_lean = FALSE
	if(leaner.incapacitated())
		can_lean = FALSE
	if(leaner.resting)
		can_lean = FALSE
	if(leaner.buckled_to)
		can_lean = FALSE

	if(!is_currently_leanable || !can_lean)
		return COMPONENT_CANCEL_MOUSEDROPPED_ONTO
	var/lean_direction
	var/border_lean = FALSE
	var/obj/border_support
	if(istype(source, /obj/structure/window))
		var/obj/structure/window/window = source
		if(!window.is_full_window())
			border_support = window
	else if(istype(source, /obj/structure/machinery/door/window))
		border_support = source
	if(border_support)
		if(!border_support.anchored || !border_support.density || !isturf(leaner.loc))
			return COMPONENT_CANCEL_MOUSEDROPPED_ONTO
		// Panes and windoors occupy the edge between their turf and the turf in dir.
		if(leaner.loc == border_support.loc)
			lean_direction = REVERSE_DIR(border_support.dir)
		else if(leaner.loc == get_step(border_support, border_support.dir))
			lean_direction = border_support.dir
		else
			return COMPONENT_CANCEL_MOUSEDROPPED_ONTO
		border_lean = TRUE
	leaner.start_leaning(source, leaning_offset, lean_direction, border_lean)
	LAZYADD(leaning_mobs, leaner)
	RegisterSignals(leaner, list(COMSIG_LIVING_STOPPED_LEANING, COMSIG_QDELETING), PROC_REF(stopped_leaning), override = TRUE)
	return COMPONENT_CANCEL_MOUSEDROPPED_ONTO

/**
 * Makes the mob lean on an atom
 * Arguments
 *
 * * atom/lean_target - the target the mob is trying to lean on
 * * leaning_offset - pixel offset to apply on the mob when leaning
 * * lean_direction - optional facing direction for supports on a turf edge
 * * border_lean - use a small shift towards the edge without wall occlusion
 */
/mob/living/proc/start_leaning(atom/lean_target, leaning_offset, lean_direction = null, border_lean = FALSE)
	var/direction = isnull(lean_direction) ? get_dir(lean_target, src) : lean_direction
	var/shift_pixel_x = 0
	var/shift_pixel_y = 0
	set_dir(direction)
	switch(dir)
		if(NORTH)
			shift_pixel_y = -10
		if(SOUTH)
			shift_pixel_y = 16
		if(EAST)
			shift_pixel_x = -10
		if(WEST)
			shift_pixel_x = 10
	var/small_border_shift = get_turf(lean_target) == loc
	if(border_lean && lean_target.dir == NORTH)
		// North-facing panes extend into the neighbouring turf, reversing the offsets.
		small_border_shift = !small_border_shift
	if(border_lean && small_border_shift)
		// Use the shorter shift on the side closest to the pane's sprite.
		shift_pixel_x = (direction & EAST) ? -4 : ((direction & WEST) ? 4 : 0)
		shift_pixel_y = (direction & NORTH) ? -4 : ((direction & SOUTH) ? 4 : 0)
	animate(src, pixel_x = shift_pixel_x, pixel_y = shift_pixel_y, time = 1)
	if(direction == NORTH && !border_lean)
		src.appearance_flags |= KEEP_TOGETHER
		src.add_filter("cutout", 1, alpha_mask_filter(y = 0, icon = icon('icons/effects/effects.dmi', "white")))
		animate(src.get_filter("cutout"), y = 10, time = 1, flags = ANIMATION_PARALLEL)
	if(direction == SOUTH && !border_lean)
		src.layer = ABOVE_DOOR_LAYER
	if(direction == SOUTH && border_lean)
		// The southern side is in front of the pane, including a north-facing
		// pane approached from its own turf.
		src.layer = max(initial(layer), lean_target.layer + 0.01)
	set_density(FALSE)
	ADD_TRAIT(src, TRAIT_UNDENSE, TRAIT_SOURCE_WALL_LEANING)
	ADD_TRAIT(src, TRAIT_LEANING, TRAIT_SOURCE_WALL_LEANING)
	visible_message(
		SPAN_NOTICE("[src] leans against [lean_target]."),
		SPAN_NOTICE("You lean against [lean_target]."),
	)
	RegisterSignals(src, list(COMSIG_MOVABLE_MOVED, COMSIG_MOB_RESISTED, COMSIG_MOB_LYING_DOWN), PROC_REF(stop_leaning), src)

/mob/living/proc/stop_leaning()
	SIGNAL_HANDLER
	set_density(TRUE)
	pixel_x = initial(pixel_x)
	pixel_y = initial(pixel_y)
	layer = initial(layer)
	UnregisterSignal(src, list(
		COMSIG_MOVABLE_MOVED,
		COMSIG_MOB_RESISTED,
		COMSIG_MOB_LYING_DOWN,
	))
	SEND_SIGNAL(src, COMSIG_LIVING_STOPPED_LEANING)
	to_chat(src, SPAN_NOTICE("You stop leaning on the wall."))
	REMOVE_TRAIT(src, TRAIT_UNDENSE, TRAIT_SOURCE_WALL_LEANING)
	REMOVE_TRAIT(src, TRAIT_LEANING, TRAIT_SOURCE_WALL_LEANING)
	appearance_flags &= ~KEEP_TOGETHER
	remove_filter("cutout")

/datum/component/leanable/proc/stopped_leaning(datum/source)
	SIGNAL_HANDLER
	LAZYREMOVE(leaning_mobs, source)
	UnregisterSignal(source, list(COMSIG_LIVING_STOPPED_LEANING, COMSIG_QDELETING))

/datum/component/leanable/proc/on_density_change()
	SIGNAL_HANDLER
	var/atom/support = parent
	is_currently_leanable = support.density
	if(!is_currently_leanable)
		stop_leaning_leaners(fall = TRUE)
		return
	stop_leaning_leaners()
