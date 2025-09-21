/// Things with this component can be leaned onto
/datum/component/leanable
	/// How much will mobs that lean onto this object be offset
	var/leaning_offset = 11
	/// List of mobs currently leaning on our parent
	var/list/leaning_mobs = list()
	/// Is this object currently leanable?
	var/is_currently_leanable = TRUE


/turf/simulated/wall/mouse_drop_receive(atom/dropped, mob/user, params)
	if(!ismob(dropped))
		return

	var/mob/living/carbon/human/current_mob = dropped

	// wall leaning by androbetel
	if(!ishuman(current_mob))
		return

	if(current_mob != user)
		return

	var/mob/living/carbon/hiding_human = current_mob
	var/can_lean = TRUE

	if(istype(user.l_hand, /obj/item/grab) || istype(user.r_hand, /obj/item/grab))
		to_chat(user, SPAN_WARNING("You can't lean while grabbing someone!"))
		can_lean = FALSE
	if(current_mob.incapacitated())
		to_chat(user, SPAN_WARNING("You can't lean while incapacitated!"))
		can_lean = FALSE
	if(current_mob.resting)
		to_chat(user, SPAN_WARNING("You can't lean while resting!"))
		can_lean = FALSE
	if(current_mob.buckled_to)
		to_chat(user, SPAN_WARNING("You can't lean while buckled!"))
		can_lean = FALSE

	var/direction = get_dir(src, current_mob)
	var/shift_pixel_x = 0
	var/shift_pixel_y = 0

	if(!can_lean)
		return
	switch(direction)
		if(NORTH)
			shift_pixel_y = -10
		if(SOUTH)
			shift_pixel_y = 16
		if(WEST)
			shift_pixel_x = 10
		if(EAST)
			shift_pixel_x = -10
		else
			return

	for(var/mob/living/carbon/human/hiding in hiding_humans)
		if(hiding_humans[hiding] == direction)
			return

	LAZYADD(hiding_humans, current_mob)
	hiding_humans[current_mob] = direction
	hiding_human.Moved() //just to be safe
	hiding_human.set_dir(direction)
	animate(hiding_human, pixel_x = shift_pixel_x, pixel_y = shift_pixel_y, time = 1)
	if(direction == NORTH)
		hiding_human.add_filter("cutout", 1, alpha_mask_filter(icon = icon('icons/effects/effects.dmi', "cutout")))
	hiding_human.density = FALSE
	ADD_TRAIT(hiding_human, TRAIT_UNDENSE, TRAIT_SOURCE_WALL_LEANING)
	RegisterSignals(hiding_human, list(COMSIG_MOVABLE_MOVED, COMSIG_MOB_RESISTED), PROC_REF(unhide_human), hiding_human)
	..()

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
	switch(dir)
		if(NORTH)
			shift_pixel_y = -10
		if(SOUTH)
			shift_pixel_y = 16
		if(EAST)
			shift_pixel_x = 10
		if(WEST)
			shift_pixel_x = -10

	animate(src, pixel_x = shift_pixel_x, pixel_y = shift_pixel_y, time = 1)
	set_dir(direction)
	if(direction == NORTH)
		src.add_filter("cutout", 1, alpha_mask_filter(icon = icon('icons/effects/effects.dmi', "cutout")))
	src.density = FALSE
	ADD_TRAIT(src, TRAIT_UNDENSE, TRAIT_SOURCE_WALL_LEANING)
	ADD_TRAIT(src, TRAIT_LEANING, TRAIT_SOURCE_WALL_LEANING)
	visible_message(
		span_notice("[src] leans against [lean_target]."),
		span_notice("You lean against [lean_target]."),
	)
	RegisterSignals(src, list(COMSIG_MOVABLE_MOVED, COMSIG_MOB_RESISTED), PROC_REF(stop_leaning), src)
	..()

/mob/living/proc/stop_leaning()
	SIGNAL_HANDLER

	density = FALSE
	pixel_x = initial(pixel_x)
	pixel_y = initial(pixel_y)
	layer = initial(layer)
	UnregisterSignal(src, list(
		COMSIG_MOVABLE_MOVED,
		COMSIG_MOB_RESISTED,
	))
	SEND_SIGNAL(src, COMSIG_LIVING_STOPPED_LEANING)
	to_chat(to_unhide, SPAN_NOTICE("You stop leaning on the wall."))
	REMOVE_TRAIT(src, TRAIT_UNDENSE, TRAIT_SOURCE_WALL_LEANING)
	REMOVE_TRAIT(src, TRAIT_LEANING, TRAIT_SOURCE_WALL_LEANING)
	remove_filter("cutout")

