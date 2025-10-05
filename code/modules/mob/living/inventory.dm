/datum/inventory_slot
	var/slot_id
	var/ui_loc
	var/ui_label
	var/overlay_slot
	var/obj/item/holding

/datum/inventory_slot/New(var/new_slot, var/new_ui_loc, var/new_overlay_slot, var/new_label)
	slot_id = new_slot
	ui_loc = new_ui_loc
	ui_label = new_label
	overlay_slot = new_overlay_slot || new_slot

/mob/living
	var/held_item_slot_selected
	var/list/held_item_slots

/mob/living/has_held_item_slot()
	. = LAZYLEN(held_item_slots) >= 1

/mob/living/proc/add_held_item_slot(var/slot, var/new_ui_loc, var/new_overlay_slot, var/new_label)
	LAZYSET(held_item_slots, slot, new /datum/inventory_slot(slot, new_ui_loc, new_overlay_slot, new_label))
	hud_used?.rebuild_hands(list(slot), FALSE)
	if(!get_active_hand())
		select_held_item_slot(slot)

/mob/living/proc/remove_held_item_slot(var/slot)
	var/datum/inventory_slot/inv_slot = LAZYACCESS(held_item_slots, slot)
	if(inv_slot)
		if(inv_slot.holding)
			drop_from_inventory(inv_slot.holding)
		held_item_slots -= slot
		qdel(inv_slot)
		hud_used?.rebuild_hands(FALSE, list(slot))
		if(get_active_held_item_slot() == slot)
			select_held_item_slot(held_item_slots[1])

/mob/living/proc/select_held_item_slot(var/slot)
	var/last_slot = get_active_held_item_slot()
	if(slot != last_slot && LAZYACCESS(held_item_slots, slot))
		held_item_slot_selected = slot
		for(var/atom/movable/screen/inventory/hand in hud_used?.hand_hud_objects)
			hand.update_icon()

/mob/living/get_active_hand()
	var/datum/inventory_slot/inv_slot = LAZYACCESS(held_item_slots, get_active_held_item_slot())
	. = inv_slot?.holding

/mob/living/get_active_held_item_slot()
	. = held_item_slot_selected

/mob/living/get_inactive_held_items()
	for(var/bp in (held_item_slots - get_active_held_item_slot()))
		var/datum/inventory_slot/inv_slot = held_item_slots[bp]
		if(inv_slot?.holding)
			LAZYADD(., inv_slot.holding)

/mob/living/is_holding(var/thing)
	. = (thing in get_held_items())

/mob/living/is_holding_offhand(var/thing)
	. = (thing in get_inactive_held_items())

/mob/living/get_bp_holding(var/thing)
	for(var/bp in held_item_slots)
		var/datum/inventory_slot/inv_slot = held_item_slots[bp]
		if(inv_slot && inv_slot.holding == thing)
			return bp

/mob/living/swap_hand()
	. = ..()
	select_held_item_slot(next_in_list(get_active_held_item_slot(), held_item_slots))

/mob/living/get_empty_hand_slot()
	for(var/bp in held_item_slots)
		var/datum/inventory_slot/inv_slot = held_item_slots[bp]
		if(!inv_slot?.holding)
			return bp

/mob/living/get_empty_hand_slots()
	for(var/bp in held_item_slots)
		var/datum/inventory_slot/inv_slot = held_item_slots[bp]
		if(!inv_slot?.holding)
			LAZYADD(., bp)

/mob/living/get_equipped_item(var/slot)
	. = ..()
	if(!.)
		var/datum/inventory_slot/inv_slot = LAZYACCESS(held_item_slots, slot)
		. = inv_slot?.holding

/mob/living/drop_from_hand(var/slot, var/atom/Target)
	var/datum/inventory_slot/inv_slot = LAZYACCESS(held_item_slots, slot)
	if(inv_slot?.holding)
		return drop_from_inventory(inv_slot.holding, Target)
	. = ..()

/mob/living/u_equip(obj/W)
	. = ..()
	if(!.)
		for(var/bp in held_item_slots)
			var/datum/inventory_slot/inv_slot = held_item_slots[bp]
			if(inv_slot?.holding == W)
				inv_slot.holding = null
				. = TRUE
				break
		if(.)
			update_inv_hands()
