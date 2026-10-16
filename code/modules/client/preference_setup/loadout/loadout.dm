GLOBAL_LIST_INIT(gear_datums, list())

/// Assoc list of tag group -> assoc list of tag -> amount of gear with that tag. Built by [/proc/build_loadout_tag_index].
GLOBAL_LIST_INIT(loadout_tag_groups, list())
GLOBAL_VAR_INIT(loadout_tags_ready, FALSE)
/// Helper tags that mean "no restriction", these are never irrelevant for a character
GLOBAL_LIST_INIT(loadout_unrestricted_tags, list(LOADOUT_TAG_NO_FACTION, LOADOUT_TAG_NO_ORIGIN, LOADOUT_TAG_NO_CULTURE, LOADOUT_TAG_NO_ROLE, LOADOUT_TAG_NO_DEPARTMENT, LOADOUT_TAG_NO_SPECIES))

/hook/startup/proc/populate_gear_list()
	// Setup custom loadout.
	//create a list of gear datums to sort
	for(var/geartype in subtypesof(/datum/gear))
		var/datum/gear/G = geartype

		//We do not want placeholders
		if(G.type == G.abstract_type)
			continue

		var/use_name = initial(G.display_name)
		GLOB.gear_datums[use_name] = new geartype

	sortTim(GLOB.gear_datums, GLOBAL_PROC_REF(cmp_text_asc), FALSE)

	return TRUE

/proc/add_tag_to_gear(var/datum/gear/gear, var/group, var/tag)
	if(!group || !tag)
		return
	if(!gear.tags)
		gear.tags = list()
	if(!gear.tags[group])
		gear.tags[group] = list()
	gear.tags[group] |= tag

/proc/get_loadout_slot_tag(var/datum/gear/gear)
	if(gear.augment)
		return "Augment"
	if(ispath(gear.path, /obj/item/clothing/accessory))
		return "Accessory"
	switch(gear.slot)
		if(slot_w_uniform)
			return "Uniform"
		if(slot_wear_suit)
			return "Suit"
		if(slot_head)
			return "Head"
		if(slot_wear_mask)
			return "Mask"
		if(slot_glasses)
			return "Glasses"
		if(slot_gloves)
			return "Gloves"
		if(slot_shoes)
			return "Shoes"
		if(slot_belt, slot_in_belt)
			return "Belt"
		if(slot_back)
			return "Back"
		if(slot_l_ear, slot_r_ear)
			return "Ears"
		if(slot_wear_id)
			return "ID"
		if(slot_wrists)
			return "Wrists"
		if(slot_pants)
			return "Pants"
		if(slot_l_store, slot_r_store)
			return "Pocket"
		if(slot_s_store)
			return "Suit Storage"
		if(slot_l_hand, slot_r_hand)
			return "Hand"
		if(slot_tie)
			return "Accessory"
	// No slot set, the item is sent to the storage (eg. backpack)
	return "Storage"

/// Fills `gear.tags` with the tags that can be derived from the gear's own vars. Department tags need jobs to exist, see [/proc/fill_department_tags_on_item].
/proc/fill_automatic_tags_on_item(var/datum/gear/gear)
	add_tag_to_gear(gear, LOADOUT_TAG_GROUP_CATEGORY, gear.sort_category)
	add_tag_to_gear(gear, LOADOUT_TAG_GROUP_SLOT, get_loadout_slot_tag(gear))
	add_tag_to_gear(gear, LOADOUT_TAG_GROUP_FACTION, gear.faction || LOADOUT_TAG_NO_FACTION)
	if(!length(gear.origin_restriction))
		add_tag_to_gear(gear, LOADOUT_TAG_GROUP_ORIGIN, LOADOUT_TAG_NO_ORIGIN)
	if(!length(gear.culture_restriction))
		add_tag_to_gear(gear, LOADOUT_TAG_GROUP_CULTURE, LOADOUT_TAG_NO_CULTURE)
	if(!length(gear.allowed_roles))
		add_tag_to_gear(gear, LOADOUT_TAG_GROUP_ROLE, LOADOUT_TAG_NO_ROLE)
		add_tag_to_gear(gear, LOADOUT_TAG_GROUP_DEPARTMENT, LOADOUT_TAG_NO_DEPARTMENT)
	for(var/role in gear.allowed_roles)
		add_tag_to_gear(gear, LOADOUT_TAG_GROUP_ROLE, role)
	if(!length(gear.whitelisted))
		add_tag_to_gear(gear, LOADOUT_TAG_GROUP_SPECIES, LOADOUT_TAG_NO_SPECIES)
	for(var/species in gear.whitelisted)
		add_tag_to_gear(gear, LOADOUT_TAG_GROUP_SPECIES, species)

/// Adds the origins and cultures of the gear restrictions. Needs the origin singletons to exist, which happens after gear is created.
/proc/fill_origin_tags_on_item(var/datum/gear/gear)
	for(var/culture_path in gear.culture_restriction)
		var/singleton/origin_item/culture = GET_SINGLETON(culture_path)
		if(culture)
			add_tag_to_gear(gear, LOADOUT_TAG_GROUP_CULTURE, culture.name)
	for(var/origin_path in gear.origin_restriction)
		var/singleton/origin_item/origin = GET_SINGLETON(origin_path)
		if(origin)
			add_tag_to_gear(gear, LOADOUT_TAG_GROUP_ORIGIN, origin.name)

/// Adds the departments of `gear.allowed_roles`. Needs SSjobs to be initialized, which happens after gear is created.
/proc/fill_department_tags_on_item(var/datum/gear/gear)
	for(var/role in gear.allowed_roles)
		var/datum/job/job = SSjobs.GetJob(role)
		if(job)
			for(var/department in job.departments)
				add_tag_to_gear(gear, LOADOUT_TAG_GROUP_DEPARTMENT, department)
		// Generic roles like "Engineering Personnel"
		else if(length(role) > 10 && copytext(role, length(role) - 9) == " Personnel")
			add_tag_to_gear(gear, LOADOUT_TAG_GROUP_DEPARTMENT, copytext(role, 1, length(role) - 9))

/// Completes the tags that depend on jobs and builds `GLOB.loadout_tag_groups`. Safe to call repeatedly, does nothing once it succeeded.
/proc/build_loadout_tag_index()
	if(GLOB.loadout_tags_ready || !length(SSjobs.name_occupations))
		return

	var/list/groups = list()
	for(var/group in list(LOADOUT_TAG_GROUP_CATEGORY, LOADOUT_TAG_GROUP_SLOT, LOADOUT_TAG_GROUP_FACTION, LOADOUT_TAG_GROUP_ROLE, LOADOUT_TAG_GROUP_DEPARTMENT, LOADOUT_TAG_GROUP_SPECIES, LOADOUT_TAG_GROUP_ORIGIN, LOADOUT_TAG_GROUP_CULTURE))
		groups[group] = list()

	for(var/gear_name in GLOB.gear_datums)
		var/datum/gear/G = GLOB.gear_datums[gear_name]
		fill_department_tags_on_item(G)
		fill_origin_tags_on_item(G)
		for(var/group in G.tags)
			if(!groups[group])
				groups[group] = list()
			for(var/tag in G.tags[group])
				groups[group][tag]++

	for(var/group in groups)
		if(!length(groups[group]))
			groups -= group
			continue
		sortTim(groups[group], GLOBAL_PROC_REF(cmp_text_asc), FALSE)
		// The "No ... Restriction" helper tags go first
		var/list/ordered_tags = list()
		for(var/helper_tag in GLOB.loadout_unrestricted_tags)
			if(helper_tag in groups[group])
				ordered_tags[helper_tag] = groups[group][helper_tag]
		for(var/tag in groups[group])
			if(!(tag in ordered_tags))
				ordered_tags[tag] = groups[group][tag]
		groups[group] = ordered_tags

	GLOB.loadout_tag_groups = groups
	GLOB.loadout_tags_ready = TRUE

/datum/category_item/player_setup_item/loadout
	name = "Loadout"
	sort_order = 1
	/// Assoc list of tag group -> list with the one selected tag of that group, if any. Gear is shown if it has the selected tag of every group. If nothing is selected, the gear selected by the player is shown.
	var/list/selected_tags = list()
	/// Whether to show the tags that make no sense for the current character (other factions, roles, etc.)
	var/show_hidden_tags = FALSE
	/// Whether to show gear that the current character cannot take (other factions, roles, etc.)
	var/show_all_items = FALSE
	/// Whether to show the additional info in the gear cards, like restrictions and tags
	var/show_item_info = FALSE
	var/gear_reset = FALSE
	var/search_input_value = ""

/datum/category_item/player_setup_item/loadout/load_character(var/savefile/S)
	S["gear"] >> pref.gear
	S["gear_list"] >> pref.gear_list

/datum/category_item/player_setup_item/loadout/load_character_special(var/savefile/S)
	pref.gear_modified = FALSE
	//Query the ss13_characters_gear table
	if(GLOB.config.sql_saves && establish_db_connection(GLOB.dbcon))
		var/fetched_gear = list()

		var/DBQuery/character_gear_query = GLOB.dbcon.NewQuery("SELECT slot, name, tweaks FROM ss13_characters_gear WHERE char_id = :char_id:")
		character_gear_query.Execute(list("char_id"=pref.current_character))
		while(character_gear_query.NextRow())
			CHECK_TICK
			var/slot = character_gear_query.item[1]
			var/name = character_gear_query.item[2]

			if(!fetched_gear[slot])
				fetched_gear[slot] = list()

			var/tweaks = list()
			if(character_gear_query.item[3])
				tweaks = json_decode(character_gear_query.item[3])

			fetched_gear[slot][name]=tweaks

		pref.gear_list = fetched_gear
	return

/datum/category_item/player_setup_item/loadout/save_character_special(var/savefile/S)
	//Persist the loadout to the database
	if(GLOB.config.sql_saves && establish_db_connection(GLOB.dbcon) && pref.gear_modified)
		var/gear_string = json_encode(pref.gear_list["[pref.gear_slot]"])
		var/DBQuery/character_gear_save_query = GLOB.dbcon.NewQuery("CALL `update_character_gear`(:char_id:, :slot_id:, :gear_data:)")
		character_gear_save_query.Execute(list("char_id"=pref.current_character,"slot_id"=pref.gear_slot,"gear_data"=gear_string))
		pref.gear_modified = FALSE
	return

/datum/category_item/player_setup_item/loadout/save_character(var/savefile/S)
	pref.gear_list["[pref.gear_slot]"] = pref.gear
	to_file(S["gear_list"], pref.gear_list)
	to_file(S["gear_slot"], pref.gear_slot)

/datum/category_item/player_setup_item/loadout/gather_load_query()
	return list("ss13_characters" = list("vars" = list("gear_slot"), "args" = list("id")))

/datum/category_item/player_setup_item/loadout/gather_load_parameters()
	return list("id" = pref.current_character)

/datum/category_item/player_setup_item/loadout/gather_save_query()
	return list("ss13_characters" = list("gear_slot", "id" = 1, "ckey" = 1))

/datum/category_item/player_setup_item/loadout/gather_save_parameters()
	return list("gear_slot" = pref.gear_slot, "id" = pref.current_character, "ckey" = PREF_CLIENT_CKEY)


/datum/category_item/player_setup_item/loadout/proc/valid_gear_choices(var/max_cost)
	. = list()
	var/mob/preference_mob = preference_mob()
	var/list/whitelist_cache = list()

	if(preference_mob)
		if(preference_mob.client)
			preference_mob.client.load_whitelist_status()
		for(var/species in GLOB.all_species)
			var/datum/species/S = GLOB.all_species[species]
			if(is_alien_whitelisted(preference_mob, S))
				whitelist_cache += S.name

	for(var/gear_name in GLOB.gear_datums)
		var/datum/gear/G = GLOB.gear_datums[gear_name]
		if(max_cost && G.cost > max_cost)
			continue
		else if(G.whitelisted && whitelist_cache.len)
			for(var/species in G.whitelisted)
				if(species in whitelist_cache)
					. += gear_name
					break
		else
			.+= gear_name

/datum/category_item/player_setup_item/loadout/sanitize_character(var/sql_load = 0)
	if (sql_load)
		gear_reset = FALSE

		pref.gear_slot = text2num(pref.gear_slot)

		if (istext(pref.gear_list))
			try
				pref.gear_list = json_decode(pref.gear_list)
			catch
				LOG_DEBUG("SQL CHARACTER LOAD: Unable to load custom loadout for client [pref.client ? pref.client.ckey : "UNKNOWN"].")
				gear_reset = TRUE

	var/mob/preference_mob = preference_mob()

	if(!islist(pref.gear_list))
		pref.gear_list = list()

	if(!isnull(pref.gear_slot) && islist(pref.gear_list["[pref.gear_slot]"]))
		pref.gear = pref.gear_list["[pref.gear_slot]"]
	else
	// old format, try to recover it.
		if(!islist(pref.gear_list["1"]))
			pref.gear = pref.gear_list.Copy()
			pref.gear_list = list("1" = pref.gear)
			pref.gear_slot = 1
		else
			pref.gear = list()
			pref.gear_list = list("1" = pref.gear)
			pref.gear_slot = 1

	for(var/gear_name in pref.gear)
		if(!(gear_name in GLOB.gear_datums))
			pref.gear -= gear_name
	var/total_cost = 0
	var/list/player_valid_gear_choices = valid_gear_choices()
	for(var/gear_name in pref.gear)
		if(!GLOB.gear_datums[gear_name])
			to_chat(preference_mob, SPAN_WARNING("You cannot have more than one of the \the [gear_name]"))
			pref.gear -= gear_name
		else if(!(gear_name in player_valid_gear_choices))
			to_chat(preference_mob, SPAN_WARNING("You cannot take \the [gear_name] as you are not whitelisted for the species."))
			pref.gear -= gear_name
		else
			var/datum/gear/G = GLOB.gear_datums[gear_name]
			if(total_cost + G.cost > GLOB.config.loadout_cost)
				pref.gear -= gear_name
				to_chat(preference_mob, SPAN_WARNING("You cannot afford to take \the [gear_name]"))
			else
				total_cost += G.cost

/datum/category_item/player_setup_item/loadout/ui_data(var/mob/user)
	var/total_cost = 0
	if(pref.gear && pref.gear.len)
		for(var/i = 1; i <= pref.gear.len; i++)
			var/datum/gear/G = GLOB.gear_datums[pref.gear[i]]
			if(G)
				total_cost += G.cost
	build_loadout_tag_index()
	var/list/chosen_gear_tags = list()
	for(var/gear_name in pref.gear)
		var/datum/gear/chosen = GLOB.gear_datums[gear_name]
		if(!chosen)
			continue
		for(var/group in chosen.tags)
			if(!chosen_gear_tags[group])
				chosen_gear_tags[group] = list()
			chosen_gear_tags[group] |= chosen.tags[group]
	var/list/player_valid_gear_choices = valid_gear_choices()
	var/datum/job/job = pref.return_chosen_high_job()
	var/singleton/origin_item/character_origin = ispath(text2path(pref.origin)) ? GET_SINGLETON(text2path(pref.origin)) : null
	var/character_origin_name = character_origin?.name
	var/singleton/origin_item/character_culture = ispath(text2path(pref.culture)) ? GET_SINGLETON(text2path(pref.culture)) : null
	var/character_culture_name = character_culture?.name
	var/filtering = FALSE
	for(var/group in selected_tags)
		if(length(selected_tags[group]))
			filtering = TRUE
			break

	// For every tag, count the gear that would be shown if that tag was selected, given the tags selected in other groups.
	var/list/tag_counts = list()
	var/list/visible_gear = list()
	for(var/gear_name in GLOB.gear_datums)
		if(!(gear_name in player_valid_gear_choices))
			continue
		var/datum/gear/counted = GLOB.gear_datums[gear_name]
		if(!show_all_items && !can_character_take_gear(counted, job))
			continue
		var/list/failed_groups = counted.get_failed_tag_groups(selected_tags)
		if(length(failed_groups) > 1)
			continue
		if(!length(failed_groups) && (filtering || (gear_name in pref.gear)))
			visible_gear += gear_name
		for(var/group in counted.tags)
			if(length(failed_groups) && failed_groups[1] != group)
				continue
			if(!tag_counts[group])
				tag_counts[group] = list()
			for(var/tag in counted.tags[group])
				tag_counts[group][tag]++

	var/list/tag_groups = list()
	for(var/group in GLOB.loadout_tag_groups)
		var/list/group_tags = list()
		for(var/tag in GLOB.loadout_tag_groups[group])
			var/is_selected = (tag in selected_tags[group])
			var/irrelevant = is_tag_irrelevant_for_character(group, tag, job, character_origin_name, character_culture_name)
			if(irrelevant && !show_hidden_tags && !is_selected)
				continue
			var/count = (tag_counts[group] ? tag_counts[group][tag] : 0) || 0
			group_tags += list(list(
				"name" = tag,
				"count" = count,
				"selected" = is_selected,
				"has_selected" = (tag in chosen_gear_tags[group]),
				"empty" = !count && !is_selected,
				"irrelevant" = irrelevant
			))
		if(length(group_tags))
			tag_groups += list(list("name" = group, "tags" = group_tags))
	var/list/items = list()
	for(var/gear_name in visible_gear)
		var/datum/gear/G = GLOB.gear_datums[gear_name]
		var/available = job && can_character_take_gear(G, job)
		var/list/item_tags = list()
		for(var/group in G.tags)
			item_tags |= G.tags[group]
		var/ticked = (G.display_name in pref.gear)
		var/found_searched_text = FALSE
		if(findtext(G.display_name, search_input_value))
			found_searched_text = TRUE
		for(var/datum/gear_tweak/tweak in G.gear_tweaks)
			var/datum/gear_tweak/path/path = tweak
			if(path && istype(path) && path.valid_paths)
				for(var/x in path.valid_paths)
					if(findtext(x, search_input_value))
						found_searched_text = TRUE
		if(!found_searched_text)
			continue
		var/list/restrictions = list()
		if(G.allowed_roles)
			restrictions += "Role: [english_list(G.allowed_roles)]"
		if(G.culture_restriction)
			var/list/cultures = list()
			for(var/culture in G.culture_restriction)
				var/singleton/origin_item/C = GET_SINGLETON(culture)
				cultures += C.name
			restrictions += "Culture: [english_list(cultures)]"
		if(G.origin_restriction)
			var/list/origins = list()
			for(var/origin in G.origin_restriction)
				var/singleton/origin_item/O = GET_SINGLETON(origin)
				origins += O.name
			restrictions += "Origin: [english_list(origins)]"
		if(G.whitelisted)
			restrictions += "Valid species: [english_list(G.whitelisted)]"
		var/list/tweaks = list()
		if(ticked)
			for(var/datum/gear_tweak/tweak in G.gear_tweaks)
				var/tweak_metadata = get_tweak_metadata(G, tweak)
				tweaks += list(list(
					"label" = html_decode(strip_html(html_decode(tweak.get_contents(tweak_metadata)))) || "Customize",
					"preview_color" = istype(tweak, /datum/gear_tweak/color) ? tweak_metadata : null,
					"topic" = list("gear" = G.display_name, "tweak" = REF(tweak))
				))
		var/list/item_data = list(
			"name" = G.display_name,
			"cost" = G.cost,
			"description" = G.description,
			"available" = available,
			"selected" = ticked,
			"restrictions" = show_item_info ? restrictions : list(),
			"tags" = show_item_info ? item_tags : list(),
			"tweaks" = tweaks
		)
		items += list(item_data)
	return list(
		"kind" = "loadout",
		"name" = name,
		"ref" = REF(src),
		"slot" = pref.gear_slot,
		"cost" = total_cost,
		"cost_limit" = GLOB.config.loadout_cost,
		"gear_reset" = gear_reset,
		"search" = search_input_value,
		"tag_groups" = tag_groups,
		"filtering" = filtering,
		"show_hidden_tags" = show_hidden_tags,
		"show_all_items" = show_all_items,
		"show_item_info" = show_item_info,
		"items" = items
	)

/// Whether the tag can't ever be useful for the current character, eg. a tag of another faction
/// Whether the character can actually take the gear, ignoring the job restrictions if there is no job chosen yet
/datum/category_item/player_setup_item/loadout/proc/can_character_take_gear(var/datum/gear/G, var/datum/job/job)
	return G.check_faction(pref.faction) \
		&& (!job || G.check_role(job.title)) \
		&& (!length(G.whitelisted) || (pref.species in G.whitelisted)) \
		&& G.check_culture(text2path(pref.culture)) \
		&& G.check_origin(text2path(pref.origin)) \
		&& G.check_religion(pref.religion) \
		&& G.check_citizenship(pref.citizenship)

/datum/category_item/player_setup_item/loadout/proc/is_tag_irrelevant_for_character(var/group, var/tag, var/datum/job/job, var/character_origin_name, var/character_culture_name)
	if(tag in GLOB.loadout_unrestricted_tags)
		return FALSE
	switch(group)
		if(LOADOUT_TAG_GROUP_ORIGIN)
			return character_origin_name && tag != character_origin_name
		if(LOADOUT_TAG_GROUP_CULTURE)
			return character_culture_name && tag != character_culture_name
		if(LOADOUT_TAG_GROUP_FACTION)
			return pref.faction && pref.faction != "None" && pref.faction != "Stellar Corporate Conglomerate" && tag != pref.faction
		if(LOADOUT_TAG_GROUP_ROLE)
			return job && tag != job.title
		if(LOADOUT_TAG_GROUP_DEPARTMENT)
			return job && !(tag in job.departments)
		if(LOADOUT_TAG_GROUP_SPECIES)
			return tag != pref.species
	return FALSE

/datum/category_item/player_setup_item/loadout/proc/get_gear_metadata(var/datum/gear/G)
	. = pref.gear[G.display_name]
	if(!.)
		. = list()
		pref.gear[G.display_name] = .

/datum/category_item/player_setup_item/loadout/proc/get_tweak_metadata(var/datum/gear/G, var/datum/gear_tweak/tweak)
	var/list/metadata = get_gear_metadata(G)
	. = metadata["[tweak]"]
	if(!.)
		. = tweak.get_default()
		metadata["[tweak]"] = .

/datum/category_item/player_setup_item/loadout/proc/set_tweak_metadata(var/datum/gear/G, var/datum/gear_tweak/tweak, var/new_metadata)
	var/list/metadata = get_gear_metadata(G)
	metadata["[tweak]"] = new_metadata

/datum/category_item/player_setup_item/loadout/OnTopic(href, href_list, user)
	if(href_list["toggle_gear"])
		pref.gear_modified = TRUE
		var/datum/gear/TG = GLOB.gear_datums[href_list["toggle_gear"]]
		if(TG.display_name in pref.gear)
			pref.gear -= TG.display_name
		else
			var/total_cost = 0
			for(var/gear_name in pref.gear)
				var/datum/gear/G = GLOB.gear_datums[gear_name]
				if(istype(G)) total_cost += G.cost
			if((total_cost+TG.cost) <= GLOB.config.loadout_cost)
				pref.gear += TG.display_name
		return TOPIC_REFRESH_UPDATE_PREVIEW
	if(href_list["gear"] && href_list["tweak"])
		pref.gear_modified = TRUE
		var/datum/gear/gear = GLOB.gear_datums[href_list["gear"]]
		var/datum/gear_tweak/tweak = locate(href_list["tweak"])
		if(!tweak || !istype(gear) || !(tweak in gear.gear_tweaks))
			return TOPIC_NOACTION
		var/metadata = tweak.get_metadata(user, get_tweak_metadata(gear, tweak), null, gear.path)
		if(!metadata || !CanUseTopic(user))
			return TOPIC_NOACTION
		set_tweak_metadata(gear, tweak, metadata)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	if(href_list["next_slot"] || href_list["prev_slot"])
		if(pref.gear_modified)
			tgui_alert(user, "Gear has been Modified - Save First or Reload", "Gear Modified", list("OK"))
			return TOPIC_NOACTION
		//Set the current slot in the gear list to the currently selected gear
		pref.gear_list["[pref.gear_slot]"] = pref.gear

		//If we're moving up a slot..
		if(href_list["next_slot"])
			//change the current slot number
			pref.gear_slot = pref.gear_slot+1
			if(pref.gear_slot > GLOB.config.loadout_slots)
				pref.gear_slot = 1
		//If we're moving down a slot..
		else if(href_list["prev_slot"])
			//change current slot one down
			pref.gear_slot = pref.gear_slot-1
			if(pref.gear_slot < 1)
				pref.gear_slot = GLOB.config.loadout_slots
		// Set the currently selected gear to whatever's in the new slot
		if(pref.gear_list["[pref.gear_slot]"])
			pref.gear = pref.gear_list["[pref.gear_slot]"]
		else
			pref.gear = list()
			pref.gear_list["[pref.gear_slot]"] = list()
		// Refresh?
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["toggle_tag"] && href_list["tag_group"])
		var/group = href_list["tag_group"]
		var/tag = href_list["toggle_tag"]
		if(!(tag in GLOB.loadout_tag_groups[group]))
			return TOPIC_NOACTION
		// Tags of the same group are mutually exclusive, selecting one replaces the other, selecting it again deselects it
		if(tag in selected_tags[group])
			selected_tags -= group
		else
			selected_tags[group] = list(tag)
		return TOPIC_REFRESH

	else if(href_list["clear_tags"])
		selected_tags = list()
		return TOPIC_REFRESH

	else if(href_list["toggle_item_info"])
		show_item_info = !show_item_info
		return TOPIC_REFRESH

	else if(href_list["toggle_all_items"])
		show_all_items = !show_all_items
		return TOPIC_REFRESH

	else if(href_list["toggle_hidden_tags"])
		show_hidden_tags = !show_hidden_tags
		return TOPIC_REFRESH

	else if(href_list["clear_loadout"])
		pref.gear_modified = TRUE
		pref.gear.Cut()
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["duplicate_loadout"])
		if(pref.gear_modified)
			tgui_alert(user, "Gear has been Modified - Save First or Reload", "Gear Modified", list("OK"))
			return TOPIC_NOACTION

		var/source_slot = pref.gear_slot
		var/list/available_slots = list()
		for(var/slot = 1 to GLOB.config.loadout_slots)
			if(slot != source_slot)
				available_slots += "Slot [slot]"

		var/selected_slot = tgui_input_list(user, "Choose the loadout slot to replace with a copy of Slot [source_slot].", "Duplicate Loadout", available_slots)
		if(!selected_slot || !CanUseTopic(user))
			return TOPIC_NOACTION

		var/target_slot = text2num(copytext(selected_slot, 6))
		if(target_slot < 1 || target_slot > GLOB.config.loadout_slots || target_slot == source_slot)
			return TOPIC_NOACTION

		var/confirmation = tgui_alert(user, "Are you sure you want to replace everything in Slot [target_slot] with a copy of Slot [source_slot]?", "Duplicate Loadout", list("Yes", "No"))
		if(confirmation != "Yes" || !CanUseTopic(user) || pref.gear_slot != source_slot || pref.gear_modified)
			return TOPIC_NOACTION

		var/list/duplicated_gear = deep_copy_list(pref.gear)
		pref.gear_list["[target_slot]"] = duplicated_gear
		pref.gear_slot = target_slot
		pref.gear = duplicated_gear
		pref.gear_modified = TRUE
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["search_input_refresh"] != null) // empty str is false
		search_input_value = sanitize(href_list["search_input_refresh"], 100)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	return ..()

/datum/gear
	/**
	 * Name and index, _must be unique_
	 *
	 * Otherwise, if this is just a placeholder, set the `abstract_type` variable to the path of itself
	 */
	var/display_name

	/**
	 * Description of this gear
	 *
	 * If left blank will default to the description of the pathed item.
	 */
	var/description

	///The path to item to spawn
	var/path

	///Number of points used. Items in general cost 1 point, storage/armor/gloves/special use costs 2 points.
	var/cost = 1

	/**
	 * Slot to equip to, one of the `slot_*` defines, see `code\__DEFINES\items_clothing.dm`
	 *
	 * If `null`, it will be sent to the storage (eg. backpack)
	 */
	var/slot

	/**
	 * A `/list` of roles that can spawn with this item
	 *
	 * If left `null`, any role can spawn with this item
	 */
	var/list/allowed_roles

	/**
	 * A `/list` of `SPECIES_*` that can spawn with this item
	 *
	 * If left `null`, any specie can spawn with this item
	 */
	var/list/whitelisted

	/**
	 * A string of the faction that can use this item
	 *
	 * If left `null`, any faction can spawn with this item
	 */
	var/faction

	/**
	 * A string of the religion that can use this item
	 *
	 * If left `null`, any religion can spawn with this item
	 */
	var/religion

	/**
	 * A string of the citizenship that can use this item
	 *
	 * If left `null`, any citizenship can spawn with this item
	 */
	var/citizenship

	/**
	 * A `/list` of [/singleton/origin_item/culture] paths that can use this item
	 */
	var/list/singleton/origin_item/culture/culture_restriction

	/**
	 * A `/list` of [/singleton/origin_item/origin] paths that can use this item
	 */
	var/list/singleton/origin_item/origin/origin_restriction

	///A string of the category this item will be listed in, also added as a tag of the `LOADOUT_TAG_GROUP_CATEGORY` group
	var/sort_category = "General"

	/**
	 * Assoc `/list` of tag group (`LOADOUT_TAG_GROUP_*`) -> `/list` of tag strings, used to filter the loadout UI
	 *
	 * Most tags are filled automatically, see [/proc/fill_automatic_tags_on_item]
	 */
	var/list/tags = list()

	///A `/list` of [/datum/gear_tweak] to apply
	var/list/datum/gear_tweak/gear_tweaks = list()

	///Bitflag field of `GEAR_*`, see `code\modules\client\preference_setup\loadout\_defines.dm`
	var/flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

	///Boolean, if this gear is an augment
	var/augment = FALSE

/datum/gear/New()
	..()
	if(!description)
		var/obj/O = path
		description = initial(O.desc)
	if(flags & GEAR_HAS_COLOR_SELECTION)
		gear_tweaks += list(GLOB.gear_tweak_free_color_choice)
	if(flags & GEAR_HAS_ALPHA_SELECTION)
		gear_tweaks += list(GLOB.gear_tweak_alpha_choice)
	if(flags & GEAR_HAS_ACCENT_COLOR_SELECTION)
		gear_tweaks += list(GLOB.gear_tweak_accent_color)
	if(flags & GEAR_HAS_NAME_SELECTION)
		gear_tweaks += list(GLOB.gear_tweak_free_name)
	if(flags & GEAR_HAS_DESC_SELECTION)
		gear_tweaks += list(GLOB.gear_tweak_free_desc)
	if(flags & GEAR_HAS_COLOR_ROTATION_SELECTION)
		gear_tweaks += list(GLOB.gear_tweak_color_rotation)
	if(ispath(path, /obj/item/clothing/accessory))
		gear_tweaks += list(GLOB.gear_tweak_accessory_slot)
	fill_automatic_tags_on_item(src)

/// Returns the groups in `selected` which have selected tags, but none of them is a tag of this gear
/datum/gear/proc/get_failed_tag_groups(var/list/selected)
	. = list()
	for(var/group in selected)
		var/list/wanted = selected[group]
		if(!length(wanted))
			continue
		var/found = FALSE
		for(var/tag in wanted)
			if(tag in tags[group])
				found = TRUE
				break
		if(!found)
			. += group

/datum/gear_data
	var/path
	var/location
	var/faction_requirement

/datum/gear_data/New(var/path, var/location, var/faction)
	src.path = path
	src.location = location
	src.faction_requirement = faction

/datum/gear/proc/cant_spawn_item_reason(var/location, var/metadata, var/mob/living/carbon/human/human, var/datum/job/job, var/datum/preferences/prefs)
	var/datum/gear_data/gd = new(path, location, faction)
	for(var/datum/gear_tweak/gt in gear_tweaks)
		if(metadata["[gt]"])
			gt.tweak_gear_data(metadata["[gt]"], gd, human)
		else
			gt.tweak_gear_data(gt.get_default(), gd, human)

	var/obj/spawning_item = gd.path
	if(length(allowed_roles) && !(job.title in allowed_roles))
		return "You cannot spawn with the [initial(spawning_item.name)] with your current job!"
	if(!check_species_whitelist(human))
		return "You cannot spawn with the [initial(spawning_item.name)] with your current species!"
	if(gd.faction_requirement && (human.employer_faction != "Stellar Corporate Conglomerate" && gd.faction_requirement != human.employer_faction))
		return "You cannot spawn with the [initial(spawning_item.name)] with your current faction!"
	if(!check_religion(prefs.religion))
		return "You cannot spawn with the [initial(spawning_item.name)] with your current religion!"
	if(!check_citizenship(prefs.citizenship))
		return "You cannot spawn with the [initial(spawning_item.name)] with your current citizenship!"
	if(!check_culture(text2path(prefs.culture)))
		return "You cannot spawn with the [initial(spawning_item.name)] with your current culture!"
	if(!check_origin(text2path(prefs.origin)))
		return "You cannot spawn with the [initial(spawning_item.name)] with your current origin!"
	return null

/// Returns a list of spawn item data. The first entry is the path, the second is the location
/datum/gear/proc/get_spawn_item_data(var/location, var/metadata, var/mob/living/carbon/human/H)
	var/datum/gear_data/gd = new(path, location, faction)
	for(var/datum/gear_tweak/gt in gear_tweaks)
		if(metadata["[gt]"])
			gt.tweak_gear_data(metadata["[gt]"], gd, H)
		else
			gt.tweak_gear_data(gt.get_default(), gd, H)
	return list(gd.path, gd.location)

/datum/gear/proc/spawn_item(var/location, var/metadata, var/mob/living/carbon/human/H)
	var/list/spawn_item_data = get_spawn_item_data(location, metadata, H)
	var/spawn_path = spawn_item_data[1]
	var/spawn_location = spawn_item_data[2]

	if(ispath(spawn_path, /obj/item/organ/external))
		var/obj/item/organ/external/external_aug = spawn_path
		var/obj/item/organ/external/replaced_limb = H.get_organ(initial(external_aug.limb_name))
		replaced_limb.droplimb(TRUE, DROPLIMB_EDGE, FALSE)
		qdel(replaced_limb)

	// Handling for "Organ swapping" augments. Anything that shares an organ tag with a pre-existing organ.
	if(ispath(spawn_path, /obj/item/organ/internal))
		var/obj/item/organ/internal/internal_aug = spawn_path
		var/obj/item/organ/internal/replaced_organ = H.internal_organs_by_name[internal_aug.organ_tag]
		if(replaced_organ && internal_aug.organ_tag == replaced_organ.organ_tag)
			replaced_organ.removed(H, null)
			qdel(replaced_organ)

	var/item = new spawn_path(spawn_location)
	if(istype(item, /obj/item/organ/internal) && ishuman(H))
		var/obj/item/organ/internal/I = item
		var/obj/item/organ/external/E = H.get_organ(I.parent_organ)
		if(E)
			I.replaced(H, E)

	for(var/datum/gear_tweak/gt in gear_tweaks)
		if(metadata["[gt]"])
			gt.tweak_item(item, metadata["[gt]"], H)
		else
			gt.tweak_item(item, gt.get_default(), H)

	return item

/datum/gear/proc/spawn_random(var/location)
	var/datum/gear_data/gd = new(path, location)
	for(var/datum/gear_tweak/gt in gear_tweaks)
		gt.tweak_gear_data(gt.get_random(), gd)
	var/item = new gd.path(gd.location)
	for(var/datum/gear_tweak/gt in gear_tweaks)
		gt.tweak_item(item, gt.get_random())
	return item

/datum/gear/proc/check_species_whitelist(mob/living/carbon/human/H)
	if(whitelisted && (!(H.species.name in whitelisted)))
		return FALSE
	return TRUE

// arg should be a faction name string
/datum/gear/proc/check_faction(var/faction_)
	if((faction && faction_ && faction_ != "None" && faction_ != "Stellar Corporate Conglomerate") && (faction != faction_))
		return FALSE
	return TRUE

// arg should be a religion name string
/datum/gear/proc/check_religion(var/user_religion)
	if(!religion || !user_religion)
		return TRUE
	if(religion == user_religion)
		return TRUE
	if(islist(religion) && (user_religion in religion))
		return TRUE
	return FALSE

// arg should be a citizenship name string
/datum/gear/proc/check_citizenship(var/user_citizenship)
	if(!citizenship || !user_citizenship)
		return TRUE
	if(citizenship == user_citizenship)
		return TRUE
	if(islist(citizenship) && (user_citizenship in citizenship))
		return TRUE
	return FALSE

// arg should be a role name string
/datum/gear/proc/check_role(var/role)
	if(role && allowed_roles && !(role in allowed_roles))
		return FALSE
	return TRUE

// arg should be a culture path
/datum/gear/proc/check_culture(var/culture)
	if(culture && culture_restriction && !(culture in culture_restriction))
		return FALSE
	return TRUE

// arg should be a origin path
/datum/gear/proc/check_origin(var/origin)
	if(origin && origin_restriction && !(origin in origin_restriction))
		return FALSE
	return TRUE
