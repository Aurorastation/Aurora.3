/mob/living/carbon/human/proc/handle_strip(var/slot_to_strip, var/mob/living/user)
	if(!slot_to_strip || !can_strip(user))
		return FALSE

	var/obj/item/target_slot = get_strip_item(text2num(slot_to_strip))

	switch(slot_to_strip)
		// Handle things that are part of this interface but not removing/replacing a given item.
		if("mask")
			var/obj/item/clothing/mask/M = wear_mask
			if(!istype(M) || !M.adjustable || is_strip_slot_obscured(slot_wear_mask))
				return FALSE
			visible_message(SPAN_WARNING("\The [user] is trying to adjust \the [src]'s mask!"))
			if(do_after(user, HUMAN_STRIP_DELAY, src, do_flags = DO_EQUIP))
				if(can_strip(user) && wear_mask == M && M.adjustable && !is_strip_slot_obscured(slot_wear_mask))
					M.adjust_mask(user, FALSE)
			return TRUE
		if("tank")
			var/obj/item/tank/T = internal
			if(!istype(T))
				return FALSE
			visible_message(SPAN_WARNING("\The [user] is taking a look at \the [src]'s air tank."))
			if(do_after(user, HUMAN_STRIP_DELAY, src, do_flags = DO_EQUIP))
				if(!can_strip(user) || QDELETED(T) || internal != T)
					return FALSE
				to_chat(user, SPAN_NOTICE("\The [T] has [XGM_PRESSURE(T.air_contents)] kPA left."))
				to_chat(user, SPAN_NOTICE("The [T] is set to release [T.distribute_pressure] kPA."))
			return TRUE
		if("pockets")
			return strip_menu?.search_pockets(user)
		if("splints")
			if(!can_remove_strip_splints())
				return FALSE
			visible_message(SPAN_DANGER("\The [user] is trying to remove \the [src]'s splints!"))
			if(do_after(user, HUMAN_STRIP_DELAY, src, do_flags = DO_EQUIP) && can_strip(user) && can_remove_strip_splints())
				remove_splints(user)
			return 1
		if("sensors")
			var/obj/item/clothing/under/suit = w_uniform
			if(!istype(suit) || suit.has_sensor != 1 || is_strip_slot_obscured(slot_w_uniform))
				return FALSE
			visible_message(SPAN_DANGER("\The [user] is trying to set \the [src]'s sensors!"))
			if(do_after(user, HUMAN_STRIP_DELAY, src, do_flags = DO_EQUIP))
				if(can_strip(user) && w_uniform == suit && suit.has_sensor == 1 && !is_strip_slot_obscured(slot_w_uniform))
					toggle_sensors(user)
			return 1
		if("internals")
			if(!can_toggle_strip_internals())
				return FALSE
			var/obj/item/tank/previous_internal = internal
			visible_message(SPAN_DANGER("\The [usr] is trying to set \the [src]'s internals!"))
			if(do_after(user, HUMAN_STRIP_DELAY, src, do_flags = DO_EQUIP))
				if(can_strip(user) && internal == previous_internal && can_toggle_strip_internals())
					toggle_internals(user)
			return 1
		if("tie")
			var/obj/item/clothing/under/suit = w_uniform
			if(!istype(suit) || !LAZYLEN(suit.accessories))
				return 0
			var/obj/item/clothing/accessory/A
			if(LAZYLEN(suit.accessories) > 1)
				A = tgui_input_list(user, "Select which accessory to strip.", "Remove Accessory", suit.accessories.Copy())
			else
				A = suit.accessories[1]

			if(!istype(A) || !can_strip(user) || w_uniform != suit || !(A in suit.accessories) || is_strip_slot_obscured(slot_w_uniform))
				return FALSE
			visible_message(SPAN_DANGER("\The [usr] is trying to remove \the [src]'s [A.name]!"))

			if(!do_after(user, HUMAN_STRIP_DELAY, src, do_flags = DO_EQUIP))
				return 0

			if(!can_strip(user) || !A || w_uniform != suit || !(A in suit.accessories) || is_strip_slot_obscured(slot_w_uniform))
				return 0

			if(istype(A, /obj/item/clothing/accessory/badge) || istype(A, /obj/item/clothing/accessory/medal))
				user.visible_message(SPAN_DANGER("\The [user] tears off \the [A] from [src]'s [suit.name]!"))
			attack_log += "\[[time_stamp()]\] <font color='orange'>Has had \the [A] removed by [user.name] ([user.ckey])</font>"
			user.attack_log += "\[[time_stamp()]\] <span class='warning'>Attempted to remove [name]'s ([ckey]) [A.name]</span>"
			suit.remove_accessory(src, A)
			return 1

	if(!get_strip_slots(strip_menu?.pockets_revealed(user))[slot_to_strip] || is_strip_slot_obscured(text2num(slot_to_strip)))
		return FALSE

	// Are we placing or stripping?
	var/stripping = target_slot
	var/obj/item/held = user.get_active_hand()
	if(!stripping && !held)
		return FALSE

	if(stripping)
		if(!target_slot.canremove)
			to_chat(user, SPAN_WARNING("You cannot remove \the [src]'s [target_slot.name]."))
			return 0
		else
			visible_message(SPAN_DANGER("\The [user] is trying to remove \the [src]'s [target_slot.name]!"))
	else
		visible_message(SPAN_DANGER("\The [user] is trying to put \a [held] on \the [src]!"))
	if(!do_mob(user,src,HUMAN_STRIP_DELAY))
		return 0
	if(!can_strip(user) || is_strip_slot_obscured(text2num(slot_to_strip)) || get_strip_item(text2num(slot_to_strip)) != target_slot || (stripping && (QDELETED(target_slot) || !target_slot.canremove)))
		return FALSE
	if(!get_strip_slots(strip_menu?.pockets_revealed(user))[slot_to_strip])
		return FALSE
	if(!stripping && held != user.get_active_hand())
		return 0

	if(stripping)
		admin_attack_log(user, src, "Attempted to remove \a [target_slot]", "Target of an attempt to remove \a [target_slot].", "attempted to remove \a [target_slot] from")
		if((l_ear == target_slot || r_ear == target_slot) && (target_slot.slot_flags & SLOT_TWOEARS))
			var/obj/item/clothing/ears/OE = (l_ear == target_slot ? r_ear : l_ear)
			qdel(OE)
		if(unEquip(target_slot))
			user.put_in_hands(target_slot)
	else if(user.unEquip(held))
		if(!equip_to_slot_if_possible(held, text2num(slot_to_strip), FALSE, TRUE, TRUE, FALSE, TRUE))
			user.put_in_hands(held)
	return 1

// Empty out everything in the target's pockets.
/mob/living/carbon/human/proc/empty_pockets(var/mob/living/user)
	if(!r_store && !l_store)
		to_chat(user, SPAN_WARNING("\The [src] has nothing in their pockets."))
		return
	if(r_store)
		unEquip(r_store)
	if(l_store)
		unEquip(l_store)
	visible_message(SPAN_DANGER("\The [user] empties \the [src]'s pockets!"))

// Modify the current target sensor level.
/mob/living/carbon/human/proc/toggle_sensors(var/mob/living/user)
	var/obj/item/clothing/under/suit = w_uniform
	if(!suit)
		to_chat(user, SPAN_WARNING("\The [src] is not wearing a suit with sensors."))
		return
	if (suit.has_sensor >= 2)
		to_chat(user, SPAN_WARNING("\The [src]'s suit sensor controls are locked."))
		return
	attack_log += "\[[time_stamp()]\] <font color='orange'>Has had their sensors toggled by [user.name] ([user.ckey])</font>"
	user.attack_log += "\[[time_stamp()]\] <span class='warning'>Attempted to toggle [name]'s ([ckey]) sensors</span>"
	suit.set_sensors(user, src)

// Remove all splints.
/mob/living/carbon/human/proc/remove_splints(var/mob/living/user)

	var/can_reach_splints = 1
	if(istype(wear_suit,/obj/item/clothing/suit/space))
		var/obj/item/clothing/suit/space/suit = wear_suit
		if(suit.supporting_limbs && suit.supporting_limbs.len)
			to_chat(user, SPAN_WARNING("You cannot remove the splints - [src]'s [suit] is supporting some of the breaks."))
			can_reach_splints = 0

	if(can_reach_splints)
		var/removed_splint
		for(var/organ in list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_R_FOOT,BP_L_FOOT))
			var/obj/item/organ/external/o = get_organ(organ)
			if (o && o.status & ORGAN_SPLINTED)
				var/obj/item/W = new /obj/item/stack/medical/splint(get_turf(src), 1)
				o.status &= ~ORGAN_SPLINTED
				W.add_fingerprint(user)
				removed_splint = 1
		if(removed_splint)
			visible_message(SPAN_DANGER("\The [user] removes \the [src]'s splints!"))
		else
			to_chat(user, SPAN_WARNING("\The [src] has no splints to remove."))

// Set internals on or off.
/mob/living/carbon/human/proc/toggle_internals(var/mob/living/user)
	if(!can_toggle_strip_internals())
		return
	if(internal)
		internal.add_fingerprint(user)
		internal = null
		if(internals)
			internals.icon_state = "internal0"
	else
		// Find an internal source.
		if(istype(back, /obj/item/tank))
			internal = back
		else if(istype(s_store, /obj/item/tank))
			internal = s_store
		else if(istype(belt, /obj/item/tank))
			internal = belt

	if(internal)
		visible_message(SPAN_WARNING("\The [src] is now running on internals!"))
		internal.add_fingerprint(user)
		if (internals)
			internals.icon_state = "internal1"
	else
		visible_message(SPAN_DANGER("\The [user] disables \the [src]'s internals!"))
