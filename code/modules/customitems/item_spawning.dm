
// CUSTOM ITEM ICONS:
// Inventory icons must be in CUSTOM_ITEM_OBJ with state name [item_icon].
// On-mob icons must be in CUSTOM_ITEM_MOB with state name [item_icon].
// Inhands must be in CUSTOM_ITEM_MOB as [icon_state]_l and [icon_state]_r.

// Kits must have mech icons in CUSTOM_ITEM_OBJ under [kit_icon].
// Broken must be [kit_icon]-broken and open must be [kit_icon]-open.

// Kits must also have hardsuit icons in CUSTOM_ITEM_MOB as [kit_icon]_suit
// and [kit_icon]_helmet, and in CUSTOM_ITEM_OBJ as [kit_icon].


//ITEM_ICONS ARE DEPRECATED. USE CONTAINED SPRITES IN FUTURE
/var/list/custom_items = list()

/datum/custom_item
	var/id
	var/character_id

	var/item_path = /obj/item
	var/list/item_data = list()

	var/req_access = 0
	var/list/req_titles = list()

	var/additional_data


/datum/custom_item/proc/spawn_item(var/newloc)
	var/obj/item/citem = new item_path(newloc)
	apply_to_item(citem)
	return citem

/datum/custom_item/proc/apply_to_item(var/obj/item/item)
	if(!item)
		return

	//Customize the item with the item_data
	for(var/var_name in item_data["vars"])
		try
			item.vars[var_name] = item_data["vars"][var_name]
		catch(var/exception/e)
			log_debug("Custom Item: Bad variable name [var_name] in custom item with id [id]")

	// for snowflake implants
	if(istype(item, /obj/item/implanter/fluff))
		var/obj/item/implanter/fluff/L = item
		L.allowed_ckey = assoc_key
		L.implant_type = text2path(additional_data)
		L.create_implant()

	return item

//this has to mirror the way update_inv_*_hand() selects the state
/datum/custom_item/proc/get_state(var/obj/item/item, var/slot_str, var/hand_str)
	var/t_state
	if(item.item_state_slots && item.item_state_slots[slot_str])
		t_state = item.item_state_slots[slot_str]
	else if(item.item_state)
		t_state = item.item_state
	else
		t_state = item.icon_state
	if(item.icon_override)
		t_state += hand_str
	return t_state

//this has to mirror the way update_inv_*_hand() selects the icon
/datum/custom_item/proc/get_icon(var/obj/item/item, var/slot_str, var/icon/hand_icon)
	var/icon/t_icon
	if(item.icon_override)
		t_icon = item.icon_override
	else if(item.item_icons && (slot_str in item.item_icons))
		t_icon = item.item_icons[slot_str]
	else
		t_icon = hand_icon
	return t_icon


//gets the relevant list for the key from the listlist if it exists, check to make sure they are meant to have it and then calls the giving function
/proc/equip_custom_items(mob/living/carbon/human/M)
	//TODO: Load custom items for the character id from the database.
	

	var/list/key_list = custom_items[M.ckey]
	if(!key_list || key_list.len < 1)
		return

	for(var/datum/custom_item/citem in key_list)

		// Check for requisite ckey and character name.
		if((lowertext(citem.assoc_key) != lowertext(M.ckey)) || (lowertext(citem.character_name) != lowertext(M.real_name)))
			continue

		// Check for required access.
		var/obj/item/I = M.wear_id
		if(citem.req_access && citem.req_access > 0)
			if(!(istype(I) && (citem.req_access in I.GetAccess())))
				continue

		// Check for required job title.
		if(citem.req_titles && citem.req_titles.len > 0)
			var/has_title
			var/current_title = M.mind.role_alt_title ? M.mind.role_alt_title : M.mind.assigned_role
			for(var/title in citem.req_titles)
				if(title == current_title)
					has_title = 1
					break
			if(!has_title)
				continue

		// ID cards and MCs are applied directly to the existing object rather than spawned fresh.
		var/obj/item/existing_item
		if(citem.item_path == /obj/item/card/id)
			existing_item = locate(/obj/item/card/id) in M.get_contents() //TODO: Improve this ?
		else if(citem.item_path == /obj/item/modular_computer)
			existing_item = locate(/obj/item/modular_computer) in M.contents

		// Spawn and equip the item.
		if(existing_item)
			citem.apply_to_item(existing_item)
		else
			place_custom_item(M,citem)

// Places the item on the target mob.
/proc/place_custom_item(mob/living/carbon/human/M, var/datum/custom_item/citem)

	if(!citem) return
	var/obj/item/newitem = citem.spawn_item()

	if(M.equip_to_appropriate_slot(newitem))
		return newitem

	if(M.equip_to_storage(newitem))
		return newitem

	newitem.forceMove(get_turf(M.loc))
	return newitem
