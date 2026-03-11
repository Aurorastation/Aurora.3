/mob/living/proc/check_grab_hand(defer_hand)
	if(defer_hand)
		if(!get_empty_hand_slot())
			to_chat(SPAN_WARNING("Your hands are full!"))
			return FALSE
	else if(get_active_hand())
		var/mob/living/carbon/human/H = src
		var/body_part_name = "hand"
		if(istype(H))
			body_part_name = LAZYACCESS(H.organs_by_name, get_active_held_item_slot())
		to_chat(src, SPAN_WARNING("Your [body_part_name] is full!"))
		return FALSE
	return TRUE

/// Fires when a mob attempts to grab a target. Must return TRUE if the mob is capable of grabbing, and FALSE with a warning message otherwise.
/mob/living/proc/can_grab(atom/movable/target, target_zone, defer_hand = FALSE)
	if(!ismob(target) && target.anchored)
		to_chat(src, SPAN_WARNING("\The [target] won't budge!"))
		return FALSE
	if(!check_grab_hand(defer_hand))
		return FALSE
	if(LAZYLEN(grabbed_by))
		to_chat(src, SPAN_WARNING("You're already being grappled!"))
		return FALSE
	for(var/obj/item/grab/G as anything in get_active_grabs())
		if(G.grabbed != target)
			continue
		if(!target_zone || !ismob(target))
			to_chat(src, SPAN_WARNING("You already have a grip on \the [target]!"))
			return FALSE
		if(G.target_zone == target_zone)
			var/obj/O = G.get_targeted_organ()
			if(O)
				to_chat(src, SPAN_WARNING("You already have a grip on \the [target]'s [O.name]!"))
				return FALSE
	return TRUE

/mob/try_make_grab(mob/living/user, grab_tag = /singleton/grab/normal/passive, defer_hand = FALSE)
	return ..(user, /singleton/grab/normal/passive, FALSE)

/mob/living/proc/make_grab(atom/movable/target, grab_tag = null, defer_hand = FALSE)
	var/atom/movable/original_target = target
	var/mob/grabbing_mob = (ismob(target) && target)
	while(istype(grabbing_mob) && grabbing_mob.buckled_to)
		grabbing_mob = grabbing_mob.buckled_to
	if(grabbing_mob && grabbing_mob != original_target)
		target = grabbing_mob
		to_chat(src, SPAN_WARNING("As \the [original_target] is buckled to \the [target], you try to grab that instead!"))

	if(!istype(target))
		return

	if(!grab_tag && ismob(target))
		var/datum/species/my_species = get_species(TRUE)
		if(istype(my_species) && my_species.grab_type)
			grab_tag = my_species.grab_type

	if(HAS_TRAIT(src, TRAIT_AGGRESSIVE_GRAB) && grab_tag == /singleton/grab/normal/passive)
		grab_tag = /singleton/grab/normal/aggressive

	face_atom(target)
	var/obj/item/grab/G
	if(ispath(grab_tag, /singleton/grab) && can_grab(target, zone_sel.selecting, defer_hand = defer_hand) && target.can_be_grabbed(src, zone_sel.selecting, defer_hand))
		G = new/obj/item/grab(src, target, grab_tag, defer_hand)
		if(grabbing_mob)
			grabbing_mob.LAssailant = WEAKREF(src)

	if(QDELETED(G))
		if(original_target != src && ismob(original_target))
			to_chat(original_target, SPAN_WARNING("\The [src] fails to grab you!"))
	return G

/mob/living/add_grab(obj/item/grab/G, defer_hand = FALSE)
	if(has_had_gripper)
		if(defer_hand)
			. = put_in_hands(G)
		else
			. = put_in_active_hand(G)
		return

	for(var/obj/item/grab/other_grab in contents)
		if(other_grab != G)
			return FALSE
	G.forceMove(src)
	return TRUE

/mob/living/ProcessGrabs()
	if(LAZYLEN(grabbed_by))
		execute_resist()

/mob/living/give_control_grab(mob/living/M)
	return(isliving(M) && M == buckled) ? M.make_grab(src, /singleton/grab/simple/control) : ..()
