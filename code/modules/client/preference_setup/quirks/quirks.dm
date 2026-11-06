/datum/category_item/player_setup_item/quirks
	name = "Quirks"
	sort_order = 1
	var/current_category

/datum/category_item/player_setup_item/quirks/load_character(savefile/S)
	S["quirks"] >> pref.quirks
	if(!pref.quirks)
		// Non-SQL savefile compatibility. Database characters are converted to
		// canonical quirk paths by V028__character_quirks.sql.
		S["disabilities"] >> pref.quirks

/datum/category_item/player_setup_item/quirks/save_character(savefile/S)
	S["quirks"] << pref.quirks

/datum/category_item/player_setup_item/quirks/gather_load_query()
	return list(
		"ss13_characters" = list(
			"vars" = list("quirks"),
			"args" = list("id")
		)
	)

/datum/category_item/player_setup_item/quirks/gather_load_parameters()
	return list("id" = pref.current_character)

/datum/category_item/player_setup_item/quirks/gather_save_query()
	return list(
		"ss13_characters" = list(
			"quirks",
			"id" = 1,
			"ckey" = 1
		)
	)

/datum/category_item/player_setup_item/quirks/gather_save_parameters()
	var/list/saved_quirks = list()
	for(var/quirk_type in pref.quirks)
		var/singleton/quirk/quirk = GET_SINGLETON(quirk_type)
		if(istype(quirk))
			saved_quirks["[quirk.type]"] = pref.quirks[quirk_type]
	return list(
		"quirks" = json_encode(saved_quirks),
		"id" = pref.current_character,
		"ckey" = PREF_CLIENT_CKEY
	)

/datum/category_item/player_setup_item/quirks/load_character_special(savefile/S)
	var/loaded_quirks = pref.quirks
	if(istext(loaded_quirks))
		try
			loaded_quirks = json_decode(loaded_quirks)
		catch(var/exception/e)
			log_debug("QUIRKS: Caught [e] while decoding [pref.quirks]")
			loaded_quirks = list()

	pref.quirks = list()
	if(!islist(loaded_quirks))
		return

	for(var/key, value in loaded_quirks)
		// JSON arrays and old savefile lists expose numeric keys here.
		if(isnum(key))
			key = value
			value = TRUE
		var/singleton/quirk/quirk
		var/quirk_path = istext(key) ? text2path(key) : key
		if(ispath(quirk_path, /singleton/quirk))
			quirk = GET_SINGLETON(quirk_path)
		else
			quirk = SSquirks.legacy_quirks[key]
		if(!istype(quirk))
			continue
		if(key == "High Psi-sensitivity")
			value = "High"
		else if(key == "Low Psi-sensitivity")
			value = "Low"
		pref.quirks[quirk.type] = length(quirk.selections) ? value : TRUE

/datum/category_item/player_setup_item/quirks/sanitize_character(sql_load = FALSE)
	if(!islist(pref.quirks))
		pref.quirks = list()

	var/list/candidate_quirks = list()
	for(var/quirk_type, selection in pref.quirks)
		var/path = istext(quirk_type) ? text2path(quirk_type) : quirk_type
		var/singleton/quirk/quirk = GET_SINGLETON(path)
		if(!istype(quirk) || !(quirk in SSquirks.all_quirks) || !quirk.can_select(pref))
			continue
		if(length(quirk.selections))
			if(!(selection in quirk.selections))
				selection = quirk.selections[1]
			candidate_quirks[quirk.type] = selection
		else
			candidate_quirks[quirk.type] = TRUE

	// Add point-granting quirks before point-spending quirks. This preserves as
	// much legacy data as the configured slot pool permits while remaining valid.
	pref.quirks = list()
	for(var/quirk_type in candidate_quirks)
		var/singleton/quirk/quirk = GET_SINGLETON(quirk_type)
		if(quirk.point_cost > 0)
			continue
		var/list/proposed_quirks = pref.quirks.Copy()
		proposed_quirks[quirk.type] = candidate_quirks[quirk_type]
		if(quirk_budget_valid(proposed_quirks))
			pref.quirks = proposed_quirks
	for(var/quirk_type in candidate_quirks)
		var/singleton/quirk/quirk = GET_SINGLETON(quirk_type)
		if(quirk.point_cost <= 0)
			continue
		var/list/proposed_quirks = pref.quirks.Copy()
		proposed_quirks[quirk.type] = candidate_quirks[quirk_type]
		if(quirk_budget_valid(proposed_quirks))
			pref.quirks = proposed_quirks

/datum/category_item/player_setup_item/quirks/proc/get_quirk_costs(list/selected_quirks)
	var/point_cost = 0
	var/slot_cost = 0
	for(var/quirk_type in selected_quirks)
		var/singleton/quirk/quirk = GET_SINGLETON(quirk_type)
		if(!istype(quirk))
			continue
		point_cost += quirk.point_cost
		slot_cost += quirk.slot_cost
	return list("points" = point_cost, "slots" = slot_cost)

/datum/category_item/player_setup_item/quirks/proc/quirk_budget_valid(list/selected_quirks)
	var/list/costs = get_quirk_costs(selected_quirks)
	return costs["points"] <= GLOB.config.quirk_points && costs["slots"] <= GLOB.config.quirk_slots

/datum/category_item/player_setup_item/quirks/ui_data(mob/user)
	if(!length(SSquirks.quirk_tree))
		return list("kind" = "notice", "name" = name, "ref" = REF(src), "message" = "Quirks are still initializing.")

	var/list/categories = list()
	var/singleton/quirk_category/selected_category
	for(var/singleton/quirk_category/quirk_category as anything in SSquirks.quirk_tree)
		if(!current_category)
			current_category = quirk_category.name
		if(quirk_category.name == current_category)
			selected_category = quirk_category
		categories += list(list("name" = quirk_category.name, "selected" = quirk_category.name == current_category))
	if(!selected_category)
		selected_category = SSquirks.quirk_tree[1]
		current_category = selected_category.name

	var/list/quirk_data = list()
	for(var/singleton/quirk/quirk as anything in SSquirks.quirk_tree[selected_category])
		var/selected = (quirk.type in pref.quirks)
		var/available = quirk.can_select(pref)
		quirk_data += list(list(
			"type" = "[quirk.type]",
			"name" = quirk.name,
			"description" = quirk.description,
			"point_cost" = quirk.point_cost,
			"slot_cost" = quirk.slot_cost,
			"selected" = selected,
			"available" = available,
			"unavailable_reason" = available ? null : quirk.get_unavailable_reason(pref),
			"selections" = quirk.selections,
			"selection" = selected && length(quirk.selections) ? pref.quirks[quirk.type] : null
		))

	var/list/costs = get_quirk_costs(pref.quirks)
	return list(
		"kind" = "quirks",
		"name" = name,
		"ref" = REF(src),
		"categories" = categories,
		"quirks" = quirk_data,
		"points" = GLOB.config.quirk_points - costs["points"],
		"points_limit" = GLOB.config.quirk_points,
		"slots" = GLOB.config.quirk_slots - costs["slots"],
		"slots_limit" = GLOB.config.quirk_slots
	)

/datum/category_item/player_setup_item/quirks/OnTopic(href, list/href_list, mob/user)
	if(href_list["set_category"])
		var/requested_category = href_list["set_category"]
		for(var/singleton/quirk_category/quirk_category as anything in SSquirks.quirk_tree)
			if(quirk_category.name == requested_category)
				current_category = requested_category
				return TOPIC_REFRESH
		return TOPIC_NOACTION

	var/quirk_identifier = href_list["toggle"]
	if(!quirk_identifier)
		quirk_identifier = href_list["select"]
	var/quirk_path = text2path(quirk_identifier)
	var/singleton/quirk/quirk = GET_SINGLETON(quirk_path)
	if(!istype(quirk) || !(quirk in SSquirks.all_quirks))
		return TOPIC_NOACTION

	if(href_list["select"])
		if(!(quirk.type in pref.quirks) || !length(quirk.selections))
			return TOPIC_NOACTION
		var/selection = tgui_input_list(user, "Select an option for [quirk.name].", "Quirk Selection", quirk.selections, pref.quirks[quirk.type])
		if(selection && CanUseTopic(user))
			pref.quirks[quirk.type] = selection
			return TOPIC_REFRESH
		return TOPIC_NOACTION

	var/list/proposed_quirks = pref.quirks.Copy()
	if(quirk.type in proposed_quirks)
		proposed_quirks -= quirk.type
	else
		if(!quirk.can_select(pref))
			to_chat(user, SPAN_WARNING(quirk.get_unavailable_reason(pref)))
			return TOPIC_NOACTION
		proposed_quirks[quirk.type] = length(quirk.selections) ? quirk.selections[1] : TRUE

	if(!quirk_budget_valid(proposed_quirks))
		to_chat(user, SPAN_WARNING("That change would exceed your available quirk points or slots."))
		return TOPIC_NOACTION

	pref.quirks = proposed_quirks
	return TOPIC_REFRESH_UPDATE_PREVIEW
