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
	LAZYNULL(leaning_mobs)

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
	leaner.start_leaning(source, leaning_offset)
	LAZYADD(leaning_mobs, leaner)
	RegisterSignals(leaner, list(COMSIG_LIVING_STOPPED_LEANING, COMSIG_QDELETING), PROC_REF(stopped_leaning), override = TRUE)
	return COMPONENT_CANCEL_MOUSEDROPPED_ONTO

/**
 * Makes the mob lean on an atom
 * Arguments
 *
 * * atom/lean_target - the target the mob is trying to lean on
 * * leaning_offset - pixel offset to apply on the mob when leaning
 */
/mob/living/proc/start_leaning(atom/lean_target, leaning_offset)
	var/direction = get_dir(lean_target, src)
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
	animate(src, pixel_x = shift_pixel_x, pixel_y = shift_pixel_y, time = 1)
	if(direction == NORTH)
		src.add_filter("cutout", 1, alpha_mask_filter(icon = icon('icons/effects/effects.dmi', "cutout")))
	set_density(FALSE)
	ADD_TRAIT(src, TRAIT_UNDENSE, TRAIT_SOURCE_WALL_LEANING)
	ADD_TRAIT(src, TRAIT_LEANING, TRAIT_SOURCE_WALL_LEANING)
	visible_message(
		SPAN_NOTICE("[src] leans against [lean_target]."),
		SPAN_NOTICE("You lean against [lean_target]."),
	)
	RegisterSignals(src, list(COMSIG_MOVABLE_MOVED, COMSIG_MOB_RESISTED), PROC_REF(stop_leaning), src)

/mob/living/proc/stop_leaning()
	SIGNAL_HANDLER
	set_density(FALSE)
	pixel_x = initial(pixel_x)
	pixel_y = initial(pixel_y)
	layer = initial(layer)
	UnregisterSignal(src, list(
		COMSIG_MOVABLE_MOVED,
		COMSIG_MOB_RESISTED,
	))
	SEND_SIGNAL(src, COMSIG_LIVING_STOPPED_LEANING)
	to_chat(src, SPAN_NOTICE("You stop leaning on the wall."))
	REMOVE_TRAIT(src, TRAIT_UNDENSE, TRAIT_SOURCE_WALL_LEANING)
	REMOVE_TRAIT(src, TRAIT_LEANING, TRAIT_SOURCE_WALL_LEANING)
	remove_filter("cutout")

/datum/component/leanable/proc/stopped_leaning(datum/source)
	SIGNAL_HANDLER
	LAZYREMOVE(leaning_mobs, source)
	UnregisterSignal(source, list(COMSIG_LIVING_STOPPED_LEANING, COMSIG_QDELETING))

/datum/component/leanable/proc/on_density_change()
	SIGNAL_HANDLER
	is_currently_leanable = !is_currently_leanable
	if(!is_currently_leanable)
		stop_leaning_leaners(fall = TRUE)
		return
	stop_leaning_leaners()
