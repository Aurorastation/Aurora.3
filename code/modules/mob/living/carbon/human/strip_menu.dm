/mob/living/carbon/human
	var/datum/strip_menu/strip_menu

/// Shared by the UI and delayed actions. Viewing a mob does not grant permission to strip it.
/mob/living/carbon/human/proc/can_strip(mob/living/user)
	if(QDELETED(src) || !istype(user) || QDELETED(user) || ispAI(user) || isrobot(user))
		return FALSE
	if(isanimal(user) && !istype(user, /mob/living/simple_animal/hostile))
		return FALSE
	if(user.incapacitated() || !user.Adjacent(src))
		return FALSE
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/left = H.get_organ(BP_L_HAND)
		var/obj/item/organ/external/right = H.get_organ(BP_R_HAND)
		if(!(left && left.is_usable()) && !(right && right.is_usable()))
			return FALSE
	return TRUE

/// String keys are also the server-side allowlist. Pockets require a completed search.
/mob/living/carbon/human/proc/get_strip_slots(include_pockets = FALSE)
	var/list/slots = list()
	for(var/entry in species.hud.gear)
		var/list/slot_ref = species.hud.gear[entry]
		var/slot = slot_ref["slot"]
		if(!include_pockets && (slot in list(slot_l_store, slot_r_store)))
			continue
		slots["[slot]"] = slot_ref["name"]
	if(species.hud.has_hands)
		slots["[slot_l_hand]"] = "Left hand"
		slots["[slot_r_hand]"] = "Right hand"
	if(handcuffed)
		slots["[slot_handcuffed]"] = "Handcuffs"
	if(legcuffed)
		slots["[slot_legcuffed]"] = "Leg cuffs"
	return slots

/mob/living/carbon/human/proc/get_strip_item(slot)
	var/obj/item/item = get_equipped_item(slot)
	if(istype(item, /obj/item/clothing/ears/offear))
		return l_ear == item ? r_ear : l_ear
	return item

/mob/living/carbon/human/proc/can_toggle_strip_internals()
	if(internal)
		return TRUE
	var/obj/item/clothing/mask/M = wear_mask
	if(!((istype(M) && !M.hanging && (M.item_flags & ITEM_FLAG_AIRTIGHT)) || (head && (head.item_flags & ITEM_FLAG_AIRTIGHT))))
		return FALSE
	return istype(back, /obj/item/tank) || istype(belt, /obj/item/tank) || istype(s_store, /obj/item/tank)

/mob/living/carbon/human/proc/can_remove_strip_splints()
	if(istype(wear_suit, /obj/item/clothing/suit/space))
		var/obj/item/clothing/suit/space/suit = wear_suit
		if(length(suit.supporting_limbs))
			return FALSE
	for(var/limb in list(BP_L_LEG, BP_R_LEG, BP_L_ARM, BP_R_ARM, BP_L_HAND, BP_R_HAND, BP_L_FOOT, BP_R_FOOT))
		var/obj/item/organ/external/organ = get_organ(limb)
		if(organ && (organ.status & ORGAN_SPLINTED))
			return TRUE
	return FALSE

/// Separate UI owner so opening inventory does not replace other human interfaces.
/datum/strip_menu
	var/mob/living/carbon/human/target
	var/list/busy_users = list()
	var/list/icon_appearances = list()
	var/list/icon_images = list()
	/// Each viewer must search for themselves; closing the menu discards the search.
	var/list/pocket_sessions = list()

/datum/strip_menu/New(mob/living/carbon/human/target)
	..()
	src.target = target

/datum/strip_menu/Destroy()
	SStgui.close_uis(src)
	target = null
	busy_users = null
	icon_appearances = null
	icon_images = null
	pocket_sessions = null
	return ..()

/datum/strip_menu/ui_host(mob/user)
	return target

/datum/strip_menu/ui_status(mob/user, datum/ui_state/state)
	return !QDELETED(target) && target.can_strip(user) ? UI_INTERACTIVE : UI_CLOSE

/datum/strip_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		pocket_sessions[user] = list("revealed" = FALSE)
		ui = new(user, src, "StripMenu", "Stripping [target.name]", 380, 420)
		ui.open()

/datum/strip_menu/ui_close(mob/user)
	pocket_sessions -= user
	return ..()

/datum/strip_menu/proc/pockets_revealed(mob/user)
	var/list/session = pocket_sessions[user]
	return session && session["revealed"]

/datum/strip_menu/proc/search_pockets(mob/living/user)
	var/list/session = pocket_sessions[user]
	if(!session || session["revealed"] || !target.can_strip(user) || target.is_strip_slot_obscured(slot_l_store))
		return FALSE
	target.visible_message(SPAN_DANGER("\The [user] is trying to search \the [target]'s pockets!"))
	if(!do_after(user, HUMAN_STRIP_DELAY, target, do_flags = DO_EQUIP))
		return FALSE
	if(QDELETED(src) || QDELETED(target) || pocket_sessions[user] != session || !target.can_strip(user) || target.is_strip_slot_obscured(slot_l_store))
		return FALSE
	session["revealed"] = TRUE
	return TRUE

/datum/strip_menu/ui_assets(mob/user)
	return list(get_asset_datum(/datum/asset/simple/strip_menu))

/datum/strip_menu/ui_data(mob/user)
	var/list/data = list("name" = target.name, "busy" = (user in busy_users), "internals" = !!target.internal)
	data["can_toggle_internals"] = target.can_toggle_strip_internals()
	data["can_remove_splints"] = target.can_remove_strip_splints()
	data["active_slot"] = busy_users[user]
	var/static/list/slot_keys = list(
		"[slot_back]" = "back", "[slot_wear_mask]" = "mask", "[slot_handcuffed]" = "handcuffs",
		"[slot_l_hand]" = "left_hand", "[slot_r_hand]" = "right_hand", "[slot_belt]" = "belt",
		"[slot_wear_id]" = "id", "[slot_l_ear]" = "left_ear", "[slot_r_ear]" = "right_ear",
		"[slot_glasses]" = "eyes", "[slot_gloves]" = "gloves", "[slot_head]" = "head",
		"[slot_shoes]" = "shoes", "[slot_wear_suit]" = "suit", "[slot_w_uniform]" = "uniform",
		"[slot_s_store]" = "suit_storage", "[slot_legcuffed]" = "legcuffs",
		"[slot_pants]" = "pants", "[slot_wrists]" = "wrists",
		"[slot_l_store]" = "left_pocket", "[slot_r_store]" = "right_pocket"
	)
	var/list/slots = list()
	var/list/available_slots = target.get_strip_slots(TRUE)
	for(var/slot in available_slots)
		if((text2num(slot) in list(slot_l_store, slot_r_store)) && !pockets_revealed(user))
			// Do not send even the occupancy of an unsearched pocket.
			slots += list(list(
				"id" = slot, "key" = slot_keys[slot], "label" = available_slots[slot],
				"hidden" = TRUE, "obscured" = target.is_strip_slot_obscured(text2num(slot)), "actions" = list()
			))
			continue
		var/obscured = target.is_strip_slot_obscured(text2num(slot))
		var/obj/item/item = obscured ? null : target.get_strip_item(text2num(slot))
		var/list/actions = list()
		if(item)
			var/list/item_actions = item.get_strip_actions(target, user)
			for(var/action in item_actions)
				actions += list(list("id" = action, "label" = item_actions[action]))
			// Cache by appearance, not item identity, so sprites update without re-encoding every tick.
			if(icon_appearances[slot] != item.appearance)
				icon_appearances[slot] = item.appearance
				icon_images[slot] = icon2base64(getFlatIcon(item, SOUTH, no_anim = TRUE))
		slots += list(list(
			"id" = slot,
			"key" = slot_keys[slot],
			"label" = available_slots[slot],
			"name" = item?.name,
			"ref" = item ? REF(item) : null,
			"icon" = item ? icon_images[slot] : null,
			"obscured" = obscured,
			"removable" = !obscured && (item ? !!item.canremove : TRUE),
			"actions" = actions
		))
	data["slots"] = slots
	var/obj/item/clothing/under/uniform = target.w_uniform
	if(istype(uniform) && uniform.has_sensor && !target.is_strip_slot_obscured(slot_w_uniform))
		var/list/modes = list("Off", "Binary sensors", "Vitals tracker", "Tracking beacon")
		data["sensors"] = modes[uniform.sensor_mode + 1]
	var/list/species_actions = list()
	var/list/available_actions = target.species.get_strip_actions()
	for(var/action in available_actions)
		species_actions += list(list("id" = action, "label" = available_actions[action]))
	data["species_actions"] = species_actions
	data["held"] = user.get_active_hand()?.name
	return data

/datum/strip_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return
	var/mob/living/user = ui.user
	if(QDELETED(target) || !target.can_strip(user) || (user in busy_users))
		return FALSE
	busy_users += user
	busy_users[user] = params["slot"] ? params["slot"] : params["id"]
	SStgui.update_uis(src)
	perform_action(action, params, user)
	if(!QDELETED(src))
		busy_users -= user
	return TRUE

/datum/strip_menu/proc/perform_action(action, list/params, mob/living/user)
	if(action != "slot" && !istext(params["id"]))
		return
	switch(action)
		if("slot", "item_action")
			var/slot = params["slot"]
			var/list/slots = target.get_strip_slots(pockets_revealed(user))
			if(!istext(slot) || !slots[slot] || target.is_strip_slot_obscured(text2num(slot)))
				return
			var/obj/item/item = target.get_strip_item(text2num(slot))
			// A stale window must never operate on a replacement item.
			if((item ? REF(item) : null) != params["ref"])
				return
			if(action == "slot")
				target.handle_strip(slot, user)
			else if(item)
				var/list/actions = item.get_strip_actions(target, user)
				if(actions[params["id"]])
					item.perform_strip_action(params["id"], target, user)
		if("general")
			if(params["id"] == "pockets")
				search_pockets(user)
			else if(params["id"] in list("splints", "internals"))
				target.handle_strip(params["id"], user)
		if("species")
			var/list/actions = target.species.get_strip_actions()
			if(actions[params["id"]])
				target.species.handle_strip(user, target, params["id"])

/// Item types provide any number of action ID -> label entries; no frontend registry is needed.
/// Implementations must revalidate their target and action availability after yielding.
/obj/item/proc/get_strip_actions(mob/living/carbon/human/target, mob/living/user)
	. = list()
	if(length(get_strip_storages()))
		.["open_storage"] = "Open storage"

/obj/item/proc/perform_strip_action(action, mob/living/carbon/human/target, mob/living/user)
	if(action != "open_storage" || !user.client || !target.can_strip(user))
		return FALSE
	var/slot
	for(var/candidate in target.get_strip_slots(TRUE))
		if(target.get_strip_item(text2num(candidate)) == src && !target.is_strip_slot_obscured(text2num(candidate)))
			slot = text2num(candidate)
			break
	if(!slot)
		return FALSE
	var/list/storages = get_strip_storages()
	if(!length(storages))
		return FALSE
	var/obj/item/storage/storage = storages[1]
	if(length(storages) > 1)
		storage = tgui_input_list(user, "Which storage compartment?", "Open Storage", storages)
	if(QDELETED(storage) || QDELETED(src) || !target.can_strip(user) || target.get_strip_item(slot) != src || target.is_strip_slot_obscured(slot) || !(storage in get_strip_storages()))
		return FALSE
	if(!storage.can_open_from_strip(user))
		to_chat(user, SPAN_WARNING("\The [storage] is locked."))
		return FALSE
	target.visible_message(SPAN_WARNING("\The [user] is trying to open \the [target]'s [storage.name]!"))
	if(!do_after(user, HUMAN_STRIP_DELAY, target, do_flags = DO_EQUIP))
		return FALSE
	if(QDELETED(storage) || QDELETED(src) || !target.can_strip(user) || target.get_strip_item(slot) != src || target.is_strip_slot_obscured(slot) || !(storage in get_strip_storages()) || !storage.can_open_from_strip(user))
		return FALSE
	if(!target.get_strip_slots(target.strip_menu?.pockets_revealed(user))["[slot]"])
		return FALSE
	add_fingerprint(user)
	storage.add_fingerprint(user)
	// Use open(), not show_to(), to preserve subtype restrictions, sounds and access delays.
	storage.open(user)
	// Some storage types yield while opening. Do not leave their HUD open after losing access.
	if(!QDELETED(storage) && user.s_active == storage && !storage.Adjacent(user))
		storage.close(user)
	return TRUE

/// Explicit storage providers avoid exposing arbitrary nested or concealed containers.
/obj/item/proc/get_strip_storages()
	return list()

/obj/item/storage/get_strip_storages()
	return list(src)

/obj/item/clothing/get_strip_storages()
	. = ..()
	for(var/obj/item/clothing/accessory/storage/accessory in accessories)
		if(!QDELETED(accessory.hold))
			. |= accessory.hold

/obj/item/clothing/suit/storage/get_strip_storages()
	. = ..()
	if(!QDELETED(pockets))
		. |= pockets

/obj/item/clothing/suit/armor/get_strip_storages()
	. = ..()
	if(!QDELETED(pockets))
		. |= pockets

/obj/item/clothing/head/helmet/get_strip_storages()
	. = ..()
	if(has_storage && !QDELETED(hold))
		. |= hold

/obj/item/clothing/accessory/storage/get_strip_storages()
	. = ..()
	if(!QDELETED(hold))
		. |= hold

/obj/item/rig/get_strip_storages()
	. = ..()
	for(var/obj/item/rig_module/storage/module in installed_modules)
		if(!QDELETED(module.pockets))
			. |= module.pockets

/obj/item/storage/proc/can_open_from_strip(mob/user)
	return TRUE

// Secure containers otherwise enforce their locks in click/drag handlers, not open().
/obj/item/storage/secure/can_open_from_strip(mob/user)
	return !locked

/obj/item/storage/lockbox/can_open_from_strip(mob/user)
	return !locked

/obj/item/radio/get_strip_actions(mob/living/carbon/human/target, mob/living/user)
	. = ..()
	if(is_on() && !istype(src, /obj/item/radio/beacon) && !istype(src, /obj/item/radio/electropack))
		.["open_radio"] = "Radio menu"

/obj/item/radio/perform_strip_action(action, mob/living/carbon/human/target, mob/living/user)
	if(action != "open_radio")
		return ..()
	var/list/actions = get_strip_actions(target, user)
	if(!actions[action] || !target.can_strip(user))
		return FALSE
	for(var/slot in target.get_strip_slots(TRUE))
		if(target.get_strip_item(text2num(slot)) != src || target.is_strip_slot_obscured(text2num(slot)))
			continue
		target.visible_message(SPAN_WARNING("\The [user] is trying to access \the [target]'s [name] controls!"))
		if(!do_after(user, HUMAN_STRIP_DELAY, target, do_flags = DO_EQUIP))
			return FALSE
		if(QDELETED(src) || !target.can_strip(user) || target.get_strip_item(text2num(slot)) != src || target.is_strip_slot_obscured(text2num(slot)))
			return FALSE
		actions = get_strip_actions(target, user)
		if(!actions[action] || !target.get_strip_slots(target.strip_menu?.pockets_revealed(user))[slot])
			return FALSE
		add_fingerprint(user)
		ui_interact(user)
		return TRUE
	return FALSE

/obj/item/clothing/mask/get_strip_actions(mob/living/carbon/human/target, mob/living/user)
	. = ..()
	if(target.wear_mask == src && adjustable)
		.["mask"] = hanging ? "Raise mask" : "Lower mask"

/obj/item/clothing/mask/perform_strip_action(action, mob/living/carbon/human/target, mob/living/user)
	if(action == "mask")
		return target.handle_strip(action, user)
	return ..()

/obj/item/clothing/under/get_strip_actions(mob/living/carbon/human/target, mob/living/user)
	. = ..()
	if(target.w_uniform == src)
		if(has_sensor == 1)
			.["sensors"] = "Set sensors"
		if(LAZYLEN(accessories))
			.["tie"] = "Remove accessory"

/obj/item/clothing/under/perform_strip_action(action, mob/living/carbon/human/target, mob/living/user)
	if(action in list("sensors", "tie"))
		return target.handle_strip(action, user)
	return ..()

/obj/item/tank/get_strip_actions(mob/living/carbon/human/target, mob/living/user)
	. = ..()
	if(target.internal == src)
		.["tank"] = "Check air tank"

/obj/item/tank/perform_strip_action(action, mob/living/carbon/human/target, mob/living/user)
	if(action == "tank")
		return target.handle_strip(action, user)
	return ..()

/obj/item/rig/get_strip_actions(mob/living/carbon/human/target, mob/living/user)
	. = ..()
	if(target.back == src && wearer == target && !locked && !interface_locked && !sealing)
		if(canremove)
			.["activate_rig"] = "Activate RIG"
		else
			.["deactivate_rig"] = "Deactivate RIG"

/obj/item/rig/perform_strip_action(action, mob/living/carbon/human/target, mob/living/user)
	if(!(action in list("activate_rig", "deactivate_rig")))
		return ..()
	var/list/actions = get_strip_actions(target, user)
	if(!target.can_strip(user) || !actions[action])
		return FALSE
	var/operation = action == "activate_rig" ? "activate" : "deactivate"
	target.visible_message(SPAN_WARNING("\The [user] is trying to [operation] \the [target]'s [name]!"))
	if(!do_after(user, HUMAN_STRIP_DELAY, target, do_flags = DO_EQUIP) || QDELETED(src) || !target.can_strip(user))
		return FALSE
	actions = get_strip_actions(target, user)
	if(!actions[action])
		return FALSE
	add_fingerprint(user)
	admin_attack_log(user, target, "Attempted to [operation] \a [src]", "Target of an attempt to [operation] \a [src].", "attempted to [operation] \a [src] worn by")
	toggle_seals(user)
	return TRUE

/// Covered slots cannot leak item data; only space helmets prevent access to ears.
/mob/living/carbon/human/proc/is_strip_slot_obscured(slot)
	if(slot == slot_l_ear || slot == slot_r_ear)
		// Ordinary headwear can hide ear sprites without preventing headset access.
		return istype(head, /obj/item/clothing/head/helmet/space) && (head.flags_inv & HIDEEARS)
	var/static/list/coverage = list(
		"[slot_w_uniform]" = HIDEJUMPSUIT, "[slot_gloves]" = HIDEGLOVES,
		"[slot_shoes]" = HIDESHOES, "[slot_wear_mask]" = HIDEMASK,
		"[slot_glasses]" = HIDEEYES,
		"[slot_s_store]" = HIDESUITSTORAGE, "[slot_wrists]" = HIDEWRISTS,
		"[slot_pants]" = HIDEPANTS, "[slot_l_store]" = HIDEJUMPSUIT, "[slot_r_store]" = HIDEJUMPSUIT
	)
	return !!(get_covered_clothes() & coverage["[slot]"])

/datum/asset/simple/strip_menu
	assets = list(
		"inventory-back.png" = 'icons/ui_icons/inventory/back.png',
		"inventory-belt.png" = 'icons/ui_icons/inventory/belt.png',
		"inventory-ears.png" = 'icons/ui_icons/inventory/ears.png',
		"inventory-glasses.png" = 'icons/ui_icons/inventory/glasses.png',
		"inventory-gloves.png" = 'icons/ui_icons/inventory/gloves.png',
		"inventory-hand_l.png" = 'icons/ui_icons/inventory/hand_l.png',
		"inventory-hand_r.png" = 'icons/ui_icons/inventory/hand_r.png',
		"inventory-head.png" = 'icons/ui_icons/inventory/head.png',
		"inventory-id.png" = 'icons/ui_icons/inventory/id.png',
		"inventory-mask.png" = 'icons/ui_icons/inventory/mask.png',
		"inventory-pocket.png" = 'icons/ui_icons/inventory/pocket.png',
		"inventory-shoes.png" = 'icons/ui_icons/inventory/shoes.png',
		"inventory-suit.png" = 'icons/ui_icons/inventory/suit.png',
		"inventory-suit_storage.png" = 'icons/ui_icons/inventory/suit_storage.png',
		"inventory-uniform.png" = 'icons/ui_icons/inventory/uniform.png'
	)
