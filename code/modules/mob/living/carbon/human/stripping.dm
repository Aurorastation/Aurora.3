/mob/living/carbon/human/proc/handle_strip(var/slot_to_strip, var/mob/living/user)
	if(!slot_to_strip || !istype(user) || ispAI(user) || (isanimal(user) && !istype(user, /mob/living/simple_animal/hostile) ) )
		return FALSE

	if(user.incapacitated() || !user.Adjacent(src))
		user << browse(null, text("window=mob[src.name]"))
		return FALSE

	var/obj/item/target_slot = get_equipped_item(text2num(slot_to_strip))

	switch(slot_to_strip)
		// Handle things that are part of this interface but not removing/replacing a given item.
		if("mask")
			visible_message(span("warning", "\The [user] is trying to adjust \the [src]'s mask!"))
			if(do_after(user,HUMAN_STRIP_DELAY, act_target = src))
				var/obj/item/clothing/mask/M = wear_mask
				M.adjust_mask(user, FALSE)
			return TRUE
		if("tank")
			visible_message(span("warning", "\The [user] is taking a look at \the [src]'s air tank."))
			if(do_after(user,HUMAN_STRIP_DELAY, act_target = src))
				var/obj/item/tank/T = internal
				to_chat(user, span("notice", "\The [T] has [T.air_contents.return_pressure()] kPA left."))
				to_chat(user, span("notice", "The [T] is set to release [T.distribute_pressure] kPA."))
			return TRUE
		if("pockets")
			visible_message("<span class='danger'>\The [user] is trying to empty \the [src]'s pockets!</span>")
			if(do_after(user,HUMAN_STRIP_DELAY, act_target = src))
				empty_pockets(user)
			return 1
		if("splints")
			visible_message("<span class='danger'>\The [user] is trying to remove \the [src]'s splints!</span>")
			if(do_after(user,HUMAN_STRIP_DELAY, act_target = src))
				remove_splints(user)
			return 1
		if("sensors")
			visible_message("<span class='danger'>\The [user] is trying to set \the [src]'s sensors!</span>")
			if(do_after(user,HUMAN_STRIP_DELAY, act_target = src))
				toggle_sensors(user)
			return 1
		if("internals")
			visible_message("<span class='danger'>\The [usr] is trying to set \the [src]'s internals!</span>")
			if(do_after(user,HUMAN_STRIP_DELAY, act_target = src))
				toggle_internals(user)
			return 1
		if("tie")
			var/obj/item/clothing/under/suit = w_uniform
			if(!istype(suit) || !LAZYLEN(suit.accessories))
				return 0
			var/obj/item/clothing/accessory/A = suit.accessories[1]
			if(!istype(A))
				return 0
			visible_message("<span class='danger'>\The [usr] is trying to remove \the [src]'s [A.name]!</span>")

			if(!do_after(user,HUMAN_STRIP_DELAY, act_target = src))
				return 0

			if(!A || suit.loc != src || !(A in suit.accessories))
				return 0

			if(istype(A, /obj/item/clothing/accessory/badge) || istype(A, /obj/item/clothing/accessory/medal))
				user.visible_message("<span class='danger'>\The [user] tears off \the [A] from [src]'s [suit.name]!</span>")
			attack_log += "\[[time_stamp()]\] <font color='orange'>Has had \the [A] removed by [user.name] ([user.ckey])</font>"
			user.attack_log += "\[[time_stamp()]\] <font color='red'>Attempted to remove [name]'s ([ckey]) [A.name]</font>"
			suit.remove_accessory(user, A)
			return 1

	// Are we placing or stripping?
	var/stripping
	var/obj/item/held = user.get_active_hand()

	if(!istype(held) || is_robot_module(held))
		if(!istype(target_slot))  // They aren't holding anything valid and there's nothing to remove, why are we even here?
			return 0
		if(!target_slot.canremove)
			to_chat(user, "<span class='warning'>You cannot remove \the [src]'s [target_slot.name].</span>")
			return 0
		stripping = 1

	if(stripping)
		visible_message("<span class='danger'>\The [user] is trying to remove \the [src]'s [target_slot.name]!</span>")
	else
		visible_message("<span class='danger'>\The [user] is trying to put \a [held] on \the [src]!</span>")
	if(!do_mob(user,src,HUMAN_STRIP_DELAY))
		return 0
	if(!stripping && user.get_active_hand() != held)
		return 0

	if(stripping)
		admin_attack_log(user, src, "Attempted to remove \a [target_slot]", "Target of an attempt to remove \a [target_slot].", "attempted to remove \a [target_slot] from")
		unEquip(target_slot)
	else if(user.unEquip(held))
		equip_to_slot_if_possible(held, text2num(slot_to_strip), 0, 1, 1)
		if(held.loc != src)
			user.put_in_hands(held)
	return 1

// Empty out everything in the target's pockets.
/mob/living/carbon/human/proc/empty_pockets(var/mob/living/user)
	if(!r_store && !l_store)
		to_chat(user, "<span class='warning'>\The [src] has nothing in their pockets.</span>")
		return
	if(r_store)
		unEquip(r_store)
	if(l_store)
		unEquip(l_store)
	visible_message("<span class='danger'>\The [user] empties \the [src]'s pockets!</span>")

// Modify the current target sensor level.
/mob/living/carbon/human/proc/toggle_sensors(var/mob/living/user)
	var/obj/item/clothing/under/suit = w_uniform
	if(!suit)
		to_chat(user, "<span class='warning'>\The [src] is not wearing a suit with sensors.</span>")
		return
	if (suit.has_sensor >= 2)
		to_chat(user, "<span class='warning'>\The [src]'s suit sensor controls are locked.</span>")
		return
	attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had their sensors toggled by [user.name] ([user.ckey])</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to toggle [name]'s ([ckey]) sensors</font>")
	suit.set_sensors(user)

// Remove all splints.
/mob/living/carbon/human/proc/remove_splints(var/mob/living/user)

	var/can_reach_splints = 1
	if(istype(wear_suit,/obj/item/clothing/suit/space))
		var/obj/item/clothing/suit/space/suit = wear_suit
		if(suit.supporting_limbs && suit.supporting_limbs.len)
			to_chat(user, "<span class='warning'>You cannot remove the splints - [src]'s [suit] is supporting some of the breaks.</span>")
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
			visible_message("<span class='danger'>\The [user] removes \the [src]'s splints!</span>")
		else
			to_chat(user, "<span class='warning'>\The [src] has no splints to remove.</span>")

// Set internals on or off.
/mob/living/carbon/human/proc/toggle_internals(var/mob/living/user)
	if(internal)
		internal.add_fingerprint(user)
		internal = null
		if(internals)
			internals.icon_state = "internal0"
	else
		// Check for airtight mask/helmet.
		if(!(istype(wear_mask, /obj/item/clothing/mask) || istype(head, /obj/item/clothing/head/helmet/space)))
			return
		// Find an internal source.
		if(istype(back, /obj/item/tank))
			internal = back
		else if(istype(s_store, /obj/item/tank))
			internal = s_store
		else if(istype(belt, /obj/item/tank))
			internal = belt

	if(internal)
		visible_message("<span class='warning'>\The [src] is now running on internals!</span>")
		internal.add_fingerprint(user)
		if (internals)
			internals.icon_state = "internal1"
	else
		visible_message("<span class='danger'>\The [user] disables \the [src]'s internals!</span>")
