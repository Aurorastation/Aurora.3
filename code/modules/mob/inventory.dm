//This proc is called whenever someone clicks an inventory ui slot.
/mob/proc/attack_ui(slot)
	var/obj/item/W = get_active_hand()
	var/obj/item/E = get_equipped_item(slot)
	if (istype(E))
		if(istype(W))
			E.attackby(W,src)
		else
			E.attack_hand(src)
	else
		equip_to_slot_if_possible(W, slot)

/**
 * Equips an item to a slot if possible
 *
 * Returns `FALSE` if it's not possible, `TRUE` otherwise
 *
 * This is a SAFE proc to equip items with
 *
 * * item_to_equip - An `obj/item` to try to equip
 * * slot - The slot to equip it to, one of the `slot_*` defines in `code\__DEFINES\items_clothing.dm`
 * * delete_on_fail - A boolean, if the item should be deleted if the equipping fails
 * * disable_warning - A boolean, if `TRUE` it does not send the eventual equipping failure feedback message to the mob
 * * redraw_mob - A boolean, if `TRUE` the icon is asked to be redrawn
 * * bypass_blocked_check - A boolean, if `TRUE` it does not check if the slot is accessible
 * * assisted_equip - A boolean, I have no idea wtf this is supposed to do, seems unused but, you're on your own here
 */
/mob/proc/equip_to_slot_if_possible(obj/item/item_to_equip, slot, delete_on_fail = FALSE, disable_warning = FALSE, redraw_mob = TRUE, bypass_blocked_check = FALSE, assisted_equip = FALSE)
	SHOULD_NOT_SLEEP(TRUE)

	if(!istype(item_to_equip) || !slot)
		return FALSE
	if(item_to_equip.item_flags & ITEM_FLAG_NO_MOVE) //Cannot move ITEM_FLAG_NO_MOVE items from one inventory slot to another. Cannot do canremove here because then BSTs spawn naked.
		return FALSE

	if(!item_to_equip.mob_can_equip(src, slot, disable_warning, bypass_blocked_check))
		if(delete_on_fail)
			qdel(item_to_equip)
		else if(!disable_warning)
			to_chat(src, SPAN_WARNING("You are unable to equip [item_to_equip]."))  //Only print if delete_on_fail is false
		return FALSE

	if(canUnEquip(item_to_equip))
		equip_to_slot(item_to_equip, slot, redraw_mob, assisted_equip) //This proc should not ever fail.
		return TRUE

//This is an UNSAFE proc. It merely handles the actual job of equipping. All the checks on whether you can or can't eqip need to be done before! Use mob_can_equip() for that task.
//In most cases you will want to use equip_to_slot_if_possible()
/**
 * Equips an item to a slot
 *
 * This is an _UNSAFE_ proc that does not perform any check, it merely handles the movement of the item,
 * all the prerequisite checks are left to the caller of this, therefore _DO NOT_ use it if you don't know what you're doing
 */
/mob/proc/equip_to_slot(obj/item/item_to_equip, slot, redraw_mob, assisted_equip)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)
	item_to_equip.on_slotmove(src, slot)
	return istype(item_to_equip) && !isnull(slot)

/**
 * Equips an item to the mob if possible, delete it otherwise
 *
 * Returns `TRUE` if the equipping was successful, `FALSE` otherwise
 *
 * * item_to_equip - An `/obj/item` to try to equip
 * * slot - The slot to equip it to, one of the `slot_*` defines in `code\__DEFINES\items_clothing.dm`
 */
/mob/proc/equip_to_slot_or_del(obj/item/item_to_equip, slot, initial = TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	. = equip_to_slot_if_possible(item_to_equip, slot, TRUE, TRUE, FALSE, TRUE, initial)

// Convinience proc.  Collects crap that fails to equip either onto the mob's back, or drops it.
// Used in job equipping so shit doesn't pile up at the start loc.
/mob/living/carbon/human/proc/equip_or_collect(var/obj/item/W, var/slot)
	if(!istype(W))
		LOG_DEBUG("MobEquip: Error when equipping [W] for [src] in [slot]")
		return
	if(W.mob_can_equip(src, slot, TRUE, TRUE))
		//Mob can equip.  Equip it.
		equip_to_slot_or_del(W, slot)
	else
		//Mob can't equip it.  Put it their backpack or toss it on the floor
		if(istype(back, /obj/item/storage))
			var/obj/item/storage/S = back
			//Now, B represents a container we can insert W into.
			S.handle_item_insertion(W,1)
			return S

		var/turf/T = get_turf(src)
		if(istype(T))
			W.forceMove(T)
			return T

///The list of slots by priority. equip_to_appropriate_slot() uses this list. Doesn't matter if a mob type doesn't have a slot.
GLOBAL_LIST_INIT(slot_equipment_priority, list(
		slot_back_str,
		slot_wear_id_str,
		slot_w_uniform_str,
		slot_wear_suit_str,
		slot_wear_mask_str,
		slot_head_str,
		slot_shoes_str,
		slot_gloves_str,
		slot_l_ear_str,
		slot_r_ear_str,
		slot_glasses_str,
		slot_belt_str,
		slot_s_store_str,
		slot_tie_str,
		slot_l_store_str,
		slot_r_store_str,
		slot_wrists_str,
		slot_pants_str
	))

//Checks if a given slot can be accessed at this time, either to equip or unequip I
/mob/proc/slot_is_accessible(var/slot, var/obj/item/I, mob/user=null)
	return 1

//puts the item "W" into an appropriate slot in a human's inventory
//returns 0 if it cannot, 1 if successful
/mob/proc/equip_to_appropriate_slot(obj/item/W)
	if(!istype(W)) return FALSE

	for(var/slot in GLOB.slot_equipment_priority)
		if(equip_to_slot_if_possible(W, slot, delete_on_fail = FALSE, disable_warning = TRUE, redraw_mob = TRUE))
			return TRUE

	return FALSE

/mob/proc/equip_to_storage(obj/item/newitem)
	// Try put it in their backpack
	if(istype(src.back,/obj/item/storage))
		var/obj/item/storage/backpack = src.back
		if(backpack.can_be_inserted(newitem, 1))
			newitem.forceMove(src.back)
			return 1

	// Try to place it in any item that can store stuff, on the mob.
	for(var/obj/item/storage/S in src.contents)
		if(S.can_be_inserted(newitem, 1))
			newitem.forceMove(S)
			return 1
	return 0

//These procs handle putting s tuff in your hand. It's probably best to use these rather than setting l_hand = ...etc
//as they handle all relevant stuff like adding it to the player's screen and updating their overlays.

/// Returns the thing in our active hand
/mob/proc/get_active_hand()
	return null

/mob/proc/get_active_held_item_slot()
	return

/// Returns the thing(s) in our inactive hand
/mob/proc/get_inactive_held_items()
	return null

/mob/proc/get_held_items()
	var/list/held_obj = get_inactive_held_items()
	if(length(held_obj))
		. = held_obj.Copy()
	held_obj = get_active_hand()
	if(held_obj)
		LAZYADD(., held_obj)

/mob/proc/get_empty_hand_slot()
	return

/mob/proc/get_empty_hand_slots()
	return

/// Returns the thing if it's a subtype of the requested thing, taking priority of the active hand
/mob/proc/get_type_in_hands(var/type)
	. = get_active_hand()
	if(istype(., type))
		return .
	for(var/item in get_inactive_held_items())
		if(istype(item, type))
			return item
	return null

/mob/proc/get_held_tool(var/behaviour)
	if(!behaviour)
		return
	for(var/obj/item/I in get_held_items())
		if(I.tool_behaviour == behaviour)
			return I

/**
 * Puts the item in the active hand of the mob, if possible
 *
 * * item_to_equip - An `/obj/item` to try to equip in the hand
 *
 * Returns `TRUE` on success, `FALSE` otherwise
 */
/mob/proc/put_in_active_hand(obj/item/item_to_equip)
	SHOULD_NOT_SLEEP(TRUE)
	. = equip_to_slot_if_possible(item_to_equip, get_active_held_item_slot())

/**
 * Puts the item in (one of) our inactive hands, if possible
 *
 * * item_to_equip - An `/obj/item` to try to equip in the hand(s)
 *
 * Returns `TRUE` on success, `FALSE` otherwise
 */
/mob/proc/put_in_inactive_hand(obj/item/item_to_equip)
	SHOULD_NOT_SLEEP(TRUE)
	var/active_slot = get_active_held_item_slot()
	for(var/slot in get_empty_hand_slots())
		if(slot == active_slot)
			continue
		. = equip_to_slot_if_possible(item_to_equip, slot)
		if(.)
			break

/// put_in_hands(), but if it fails we del
/mob/proc/put_in_hands_or_del(obj/item/item_to_equip, check_adjacency = FALSE)
	SHOULD_NOT_SLEEP(TRUE)
	. = put_in_hands(item_to_equip, check_adjacency)
	if(!. && !QDELETED(item_to_equip))
		qdel(item_to_equip)

/// put_in_hands() but collects the item if there's no space
/mob/proc/put_in_hands_or_collect(obj/item/W)
	if(!istype(W))
		LOG_DEBUG("MobEquip: Error when equipping [W] for [src] in hands")
		return

	if(!src.put_in_hands(W))
		if(istype(back, /obj/item/storage))
			var/obj/item/storage/S = back
			S.handle_item_insertion(W, TRUE)
			return S

		var/turf/T = get_turf(src)
		if(istype(T))
			W.forceMove(T)
			return T

/**
 * Puts the item in an active hand if possible, failing that it tries an inactive hand
 *
 * If both fails, it drops the item on the floor and returns `FALSE`
 *
 * * item_to_equip - An `obj/item` to try to equip
 * * check_adjacency - A boolean, if `TRUE` it checks if the mob is adjacent to the target
 *
 * Returns `TRUE` on successful equip on an hand, `FALSE` otherwise
 */
/mob/proc/put_in_hands(obj/item/item_to_equip, check_adjacency = FALSE)
	SHOULD_NOT_SLEEP(TRUE)

	if(QDELETED(item_to_equip))
		return FALSE

	if(!istype(item_to_equip))
		return FALSE

	var/move_to_src = TRUE
	if(check_adjacency)
		move_to_src = FALSE
		var/turf/origin = get_turf(item_to_equip)
		if(Adjacent(origin))
			move_to_src = TRUE
	if(move_to_src)
		item_to_equip.forceMove(get_turf(src))
	else
		item_to_equip.forceMove(get_turf(item_to_equip))
	item_to_equip.reset_plane_and_layer()
	item_to_equip.dropped(src)

	return FALSE

// Removes an item from inventory and places it in the target atom.
// If canremove or other conditions need to be checked then use unEquip instead.
/mob/proc/drop_from_inventory(var/obj/item/W, var/atom/target)
	if(W)
		remove_from_mob(W)
		if(!(W && W.loc))
			return TRUE
		if(target)
			W.forceMove(target)
		W.do_drop_animation(src)
		update_icon()
		return TRUE
	return FALSE

//Drops the item from a given hand
/mob/proc/drop_from_hand(var/slot, var/atom/target)
	return FALSE

//Drops the item in our active hand. TODO: rename this to drop_active_hand or something

/mob/proc/drop_item(var/atom/Target)
	var/obj/item/I = get_active_hand()
	if(!istype(I))
		. = FALSE
		for(var/obj/item/grab/G as anything in get_active_grabs())
			qdel(G)
			. = TRUE
		return
	else if(!I.mob_can_unequip(src, get_active_held_item_slot(), dropping = TRUE))
		return FALSE
	. = drop_from_inventory(I, Target)

	if (!QDELETED(I))
		addtimer(CALLBACK(src, PROC_REF(make_item_drop_sound), I), 1)

/mob/proc/make_item_drop_sound(obj/item/I)
	if(QDELETED(I))
		return

	if(I.drop_sound)
		playsound(I, I.drop_sound, DROP_SOUND_VOLUME, 0, required_asfx_toggles = ASFX_DROPSOUND)

/*
	Removes the object from any slots the mob might have, calling the appropriate icon update proc.
	Does nothing else.

	DO NOT CALL THIS PROC DIRECTLY. It is meant to be called only by other inventory procs.
	It's probably okay to use it if you are transferring the item between slots on the same mob,
	but chances are you're safer calling remove_from_mob() or drop_from_inventory() anyways.

	As far as I can tell the proc exists so that mobs with different inventory slots can override
	the search through all the slots, without having to duplicate the rest of the item dropping.
*/
/mob/proc/u_equip(obj/W as obj)
	SHOULD_CALL_PARENT(TRUE)
	if (W == back)
		back = null
		update_inv_back(0)
		return TRUE
	else if (W == wear_mask)
		wear_mask = null
		update_inv_wear_mask(0)
		return TRUE
	return FALSE

/mob/proc/isEquipped(obj/item/I)
	if(!I)
		return 0
	return get_inventory_slot(I) != 0

/mob/proc/canUnEquip(obj/item/I)
	if(!I) //If there's nothing to drop, the drop is automatically successful.
		return TRUE
	if(istype(loc, /obj))
		var/obj/O = loc
		if(!O.can_hold_dropped_items())
			return FALSE
	var/slot = get_inventory_slot(I)
	if(!slot && !istype(I.loc, /obj/item/rig_module))
		return TRUE // already unequipped
	return I.mob_can_unequip(src, slot)

/mob/proc/get_inventory_slot(obj/item/I)
	for(var/s in GLOB.all_inventory_slots) //kind of worries me
		if(get_equipped_item(s) == I)
			return s

//This differs from remove_from_mob() in that it checks if the item can be unequipped first.
/mob/proc/unEquip(obj/item/I, force = 0, var/atom/target) //Force overrides NODROP for things like wizarditis and admin undress.
	if(!(force || canUnEquip(I)))
		return FALSE
	drop_from_inventory(I, target)
	return TRUE


//This function is an unsafe proc used to prepare an item for being moved to a slot, or from a mob to a container
//It should be equipped to a new slot or forcemoved somewhere immediately after this is called
/mob/proc/prepare_for_slotmove(obj/item/I)
	if(!canUnEquip(I))
		return 0

	src.u_equip(I)
	if (src.client)
		src.client.screen -= I
	I.reset_plane_and_layer()
	I.screen_loc = null

	I.on_slotmove(src)

	return 1


///Attemps to remove an object on a mob
/mob/proc/remove_from_mob(var/obj/O)
	SHOULD_NOT_SLEEP(TRUE)

	src.u_equip(O)
	if (src.client)
		src.client.screen -= O
	O.reset_plane_and_layer()
	O.screen_loc = null
	if(istype(O, /obj/item))
		var/obj/item/I = O
		I.forceMove(src.loc)
		I.dropped(src)
	return 1

/mob/proc/drop_held_items()
	for(var/thing in get_held_items())
		unEquip(thing)

//Returns the item equipped to the specified slot, if any.
/mob/proc/get_equipped_item(var/slot)
	SHOULD_CALL_PARENT(TRUE)
	switch(slot)
		if(slot_back_str) return back
		if(slot_wear_mask_str) return wear_mask

/**
 * Used to return a list of equipped items on a human mob; does not by default include held items, see include_flags
 *
 * Argument(s):
 * * Optional - include_flags, (see `code\__DEFINES\obj_flags.dm`) describes which optional things to include or not (pockets, accessories, held items)
 */
/mob/proc/get_equipped_items(include_flags = NONE)
	SHOULD_CALL_PARENT(TRUE)
	. = list()
	if(back)
		. += back
	if(wear_mask)
		. += wear_mask

	if(include_flags & INCLUDE_HELD)
		. |= get_held_items()

//Throwing stuff
/mob/proc/throw_item(atom/target)
	return FALSE

/mob/living/carbon/throw_item(atom/target)
	if(stat || !target || istype(target, /atom/movable/screen))
		return FALSE

	var/atom/movable/item = src.get_active_hand()
	if(!item)
		return FALSE

	var/throw_range = item.throw_range
	var/itemsize

	if(istype(item, /obj/item/grab))
		var/obj/item/grab/G = item
		item = G.throw_held() //throw the person instead of the grab
		if(ismob(item))
			var/mob/M = item
			if(M.mob_weight > get_mob_strength())
				to_chat(src, SPAN_WARNING("[M] is far too heavy for you to throw around!"))
				return

			throw_range = round(throw_range * (src.mob_size/M.mob_size))
			itemsize = round(M.mob_size/4)
			var/turf/start_T = get_turf(loc) //Get the start and target tile for the descriptors
			var/turf/end_T = get_turf(target)
			if(start_T && end_T)
				if(is_pacified())
					to_chat(src, SPAN_NOTICE("You gently let go of [M]."))
					src.remove_from_mob(item)
					item.loc = src.loc
					return TRUE
				var/start_T_descriptor = "<font color='#6b5d00'>tile at [start_T.x], [start_T.y], [start_T.z] in area [get_area(start_T)]</font>"
				var/end_T_descriptor = "<font color='#6b4400'>tile at [end_T.x], [end_T.y], [end_T.z] in area [get_area(end_T)]</font>"

				M.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been thrown by [usr.name] ([usr.ckey]) from [start_T_descriptor] with the target [end_T_descriptor]</font>"
				usr.attack_log += "\[[time_stamp()]\] <span class='warning'>Has thrown [M.name] ([M.ckey]) from [start_T_descriptor] with the target [end_T_descriptor]</span>"
				msg_admin_attack("[usr.name] ([usr.ckey]) has thrown [M.name] ([M.ckey]) from [start_T_descriptor] with the target [end_T_descriptor] (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[usr.x];Y=[usr.y];Z=[usr.z]'>JMP</a>)",ckey=key_name(usr),ckey_target=key_name(M))

			qdel(G)
		else
			return FALSE

	else if(istype(item, /obj/item))
		var/obj/item/I = item
		itemsize = I.w_class

	if(!item)
		return FALSE //Grab processing has a chance of returning null

	if(item.too_heavy_to_throw() && !(a_intent == I_HELP && Adjacent(target)))
		to_chat(src, SPAN_DANGER("You try to throw \the [item] with a lot of difficulty..."))
		if(do_after(src, 2 SECONDS))
			to_chat(src, SPAN_DANGER("<font size=4>Your grip slips and \the [item] falls onto your foot!</font>"))
			throw_fail_consequences(item)
			drop_item()
		return FALSE

	if(a_intent == I_HELP && Adjacent(target) && isitem(item))
		var/obj/item/I = item
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			if(H.in_throw_mode && H.a_intent == I_HELP && unEquip(I))
				I.on_give(src, target)
				if(!QDELETED(I)) // if on_give deletes the item, we don't want runtimes below
					H.put_in_hands(I) // If this fails it will just end up on the floor, but that's fitting for things like dionaea.
					visible_message("<b>[src]</b> hands \the [H] \a [I].", SPAN_NOTICE("You give \the [target] \a [I]."))
			else
				to_chat(src, SPAN_NOTICE("You offer \the [I] to \the [target]."))
				do_give(H)
			return TRUE

		var/turf/T = get_turf(target)
		if(T.density) //Don't put the item in dense turfs
			return TRUE //Takes off throw mode
		if(T.contains_dense_objects())
			for(var/obj/O in T)
				if(!O.density) //We don't care about you.
					continue
				if(O.CanPass(item, T)) //Items have CANPASS for tables/railings, allows placement. Also checks windows.
					continue
				if(istype(O, /obj/structure/closet/crate)) //Placing on/in crates is fine.
					continue
				return TRUE //Something is stopping us. Takes off throw mode.

		if(unEquip(I))
			if(!QDELETED(I))
				make_item_drop_sound(I)
				I.forceMove(T)
			return TRUE

	if(!unEquip(item) && !ismob(item)) //ismob override is here for grab throwing mobs
		return TRUE

	if(is_pacified())
		to_chat(src, SPAN_NOTICE("You set [item] down gently on the ground."))
		return TRUE

	//actually throw it!
	if(item)
		src.visible_message(SPAN_WARNING("[src] throws \a [item]."))
		if(!src.lastarea)
			src.lastarea = get_area(src.loc)
		if((istype(src.loc, /turf/space)) || (src.lastarea.has_gravity() == 0))
			if(prob((itemsize * itemsize * 20) * MOB_MEDIUM/src.mob_size)) // 20% chance with a tiny item, 40% with small, guaranteed above
				src.inertia_dir = get_dir(target, src)
				step(src, inertia_dir)
		if(istype(item,/obj/item))
			var/obj/item/W = item
			W.randpixel_xy()
			var/volume = W.get_volume_by_throwforce_and_or_w_class()
			playsound(src, 'sound/effects/throw.ogg', volume, TRUE, -1)

		// Animate the mob throwing.
		animate_throw()

		item.throw_at(target, throw_range, item.throw_speed, src)

		return TRUE

	return FALSE

/mob/proc/delete_inventory(var/include_carried = FALSE)
	for(var/obj/item/I as anything in get_equipped_items(include_carried ? INCLUDE_POCKETS|INCLUDE_HELD : 0))
		drop_from_inventory(I)
		qdel(I)

/mob/proc/get_covering_equipped_items(var/body_parts)
	. = list()
	for(var/entry in get_equipped_items())
		var/obj/item/I = entry
		if(I.body_parts_covered & body_parts)
			. += I

/mob/living/carbon/human/proc/equipOutfit(outfit, visualsOnly = FALSE)
	SHOULD_NOT_SLEEP(TRUE)

	var/obj/outfit/O = null

	if(ispath(outfit))
		O = new outfit
	else
		O = outfit
		if(!istype(O))
			return FALSE
	if(!O)
		return FALSE

	return O.equip(src, visualsOnly)

/mob/living/carbon/human/proc/preEquipOutfit(outfit, visualsOnly = FALSE)
	var/obj/outfit/O = null

	if(ispath(outfit))
		O = new outfit
	else
		O = outfit
		if(!istype(O))
			return FALSE
	if(!O)
		return FALSE

	return O.pre_equip(src, visualsOnly)

// Returns the first item which covers any given body part
/mob/proc/get_covering_equipped_item(var/body_parts)
	for(var/entry in get_equipped_items())
		var/obj/item/I = entry
		if(I.body_parts_covered & body_parts)
			return I

//When you drop an extremely heavy 406mm shell onto your foot. Oops!
/mob/living/carbon/proc/throw_fail_consequences(var/obj/item/I)
	apply_damage(45, DAMAGE_BRUTE, pick(list(BP_L_FOOT, BP_R_FOOT)), I, armor_pen = 30)
	I.throw_fail_consequences(src)

/mob/proc/has_held_item_slot()
	return TRUE

/mob/proc/get_bp_holding(var/thing)
	return FALSE

/mob/proc/is_holding(var/thing)
	return FALSE

/mob/proc/is_holding_offhand(var/thing)
	return FALSE
