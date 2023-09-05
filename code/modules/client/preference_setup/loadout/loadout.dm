/// Map of gear datums.
/// Index is initial(gear.display_name), value is actual /datum/gear object.
var/list/gear_datums = list()

/// Map of all gear names that have a tag.
/// Index is tag name, value is a list of initial(gear.display_name).
var/list/tag_gear_names = list()

/// List of all gear names (initial(gear.display_name)).
var/list/all_gear_names = list()

/// Map of related tags.
/// Index is tag name, value is any tags of items that also have this tag.
/// --
/// This is a way to show which tags are "related".
/// "Uniform" and "Zavodskoi Interstellar" are related, as there are zavod uniforms that have both these tags.
/// "Uniform" and "Glasses" are not related, as there are no items that are at the same time uniform and glasses.
var/list/tag_related_tags = list()

/datum/loadout_category
	var/category = ""
	var/list/gear = list()

/datum/loadout_category/New(var/cat)
	category = cat
	..()

/hook/startup/proc/populate_gear_list()
	// create a list of gear datums
	for(var/geartype in subtypesof(/datum/gear))
		var/datum/gear/G = geartype
		var/use_name = initial(G.display_name)
		gear_datums[use_name] = new geartype

	// sort that list
	sortTim(gear_datums, GLOBAL_PROC_REF(cmp_text_asc), FALSE)

	// fill tag_gear_names and all_gear_names
	for(var/gear_name in gear_datums)
		var/datum/gear/gear = gear_datums[gear_name]
		all_gear_names += gear_name
		for(var/tag in gear.tags)
			if(!tag_gear_names[tag])
				tag_gear_names[tag] = list()
			tag_gear_names[tag] += gear_name

	// fill tag_related_tags
	for(var/tag in tag_gear_names)
		if(!tag_related_tags[tag])
			tag_related_tags[tag] = list()
		var/list/gear_names = tag_gear_names[tag]
		for(var/gear_name in gear_names)
			var/datum/gear/gear = gear_datums[gear_name]
			for(var/related_tag in gear.tags)
				tag_related_tags[tag] |= related_tag

	// sort tag_group_slot
	sortTim(tag_group_slot, GLOBAL_PROC_REF(cmp_text_asc), FALSE)

	return TRUE

/datum/category_item/player_setup_item/loadout
	name = "Loadout"
	sort_order = 1
	var/gear_reset = FALSE
	/// Currently selected tags.
	var/list/selected_tags = list()
	///
	var/show_all_selected_items = TRUE

/datum/category_item/player_setup_item/loadout/load_character(var/savefile/S)
	S["gear"] >> pref.gear
	S["gear_list"] >> pref.gear_list
	if(pref.gear_list!=null && pref.gear_slot!=null)
		pref.gear = pref.gear_list["[pref.gear_slot]"]
	else
		S["gear"] >> pref.gear

/datum/category_item/player_setup_item/loadout/save_character(var/savefile/S)
	pref.gear_list["[pref.gear_slot]"] = pref.gear
	to_file(S["gear_list"], pref.gear_list)
	to_file(S["gear_slot"], pref.gear_slot)

/datum/category_item/player_setup_item/loadout/gather_load_parameters()
	return list("id" = pref.current_character)

/datum/category_item/player_setup_item/loadout/gather_load_query()
	return list("ss13_characters" = list("vars" = list("gear" = "gear_list", "gear_slot"), "args" = list("id")))

/datum/category_item/player_setup_item/loadout/gather_save_query()
	return list("ss13_characters" = list("gear", "gear_slot", "id" = 1, "ckey" = 1))

/datum/category_item/player_setup_item/loadout/gather_save_parameters()
	return list("gear" = json_encode(pref.gear_list), "gear_slot" = pref.gear_slot, "id" = pref.current_character, "ckey" = PREF_CLIENT_CKEY)

/datum/category_item/player_setup_item/loadout/proc/valid_gear_choices(var/max_cost)
	. = list()
	var/mob/preference_mob = preference_mob()
	var/list/whitelist_cache = list()

	if(preference_mob)
		for(var/species in global.all_species)
			var/datum/species/S = global.all_species[species]
			if(is_alien_whitelisted(preference_mob, S))
				whitelist_cache += S.name

	for(var/gear_name in gear_datums)
		var/datum/gear/G = gear_datums[gear_name]
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
		if(!(gear_name in gear_datums))
			pref.gear -= gear_name
	var/total_cost = 0
	var/list/player_valid_gear_choices = valid_gear_choices()
	for(var/gear_name in pref.gear)
		if(!gear_datums[gear_name])
			to_chat(preference_mob, "<span class='warning'>You cannot have more than one of the \the [gear_name]</span>")
			pref.gear -= gear_name
		else if(!(gear_name in player_valid_gear_choices))
			to_chat(preference_mob, "<span class='warning'>You cannot take \the [gear_name] as you are not whitelisted for the species.</span>")
			pref.gear -= gear_name
		else
			var/datum/gear/G = gear_datums[gear_name]
			if(total_cost + G.cost > MAX_GEAR_COST)
				pref.gear -= gear_name
				to_chat(preference_mob, "<span class='warning'>You cannot afford to take \the [gear_name]</span>")
			else
				total_cost += G.cost

/datum/category_item/player_setup_item/loadout/content(var/mob/user)
	var/total_cost = 0
	if(pref.gear && pref.gear.len)
		for(var/i = 1; i <= pref.gear.len; i++)
			var/datum/gear/G = gear_datums[pref.gear[i]]
			if(G)
				total_cost += G.cost

	var/fcolor =  "#3366CC"
	if(total_cost < MAX_GEAR_COST)
		fcolor = "#E67300"
	. = list()
	. += "<table align = 'center' width = 100%>"
	if (gear_reset)
		. += "<tr><td colspan=3><center><i>Your loadout failed to load and will be reset if you save this slot.</i></center></td></tr>"
	. += "<tr><td colspan=3><center><a href='?src=\ref[src];prev_slot=1'>\<\<</a><b><font color = '[fcolor]'>\[[pref.gear_slot]\]</font> </b><a href='?src=\ref[src];next_slot=1'>\>\></a><b><font color = '[fcolor]'>[total_cost]/[MAX_GEAR_COST]</font> loadout points spent.</b> \[<a href='?src=\ref[src];clear_loadout=1'>Clear Loadout</a>\]</center></td></tr>"

	. += "<tr><td colspan=3><b>"
	. += "<table>"
	for(var/tag_group in tag_groups_all)
		. += "<tr><td>"
		var/list/tag_group_list = tag_groups_all[tag_group]
		. += tag_group + ":"
		. += "</td><td>"
		for(tag in tag_group_list)
			var/style = ""
			var/href_target = "?src=\ref[src];toggle_tag=[tag]"
			for(var/selected_tag in selected_tags)
				if(!(selected_tag in tag_related_tags[tag]))
					style = "style='color: #919191;'"
					href_target = "#"
					break
			if(tag in selected_tags)
				style = "style='color: #FF8000;'"
			. += " <a href='[href_target]'><font [style]>[tag]</font></a> "
		. += "</td></tr>"
	. += "</table>"
	. += "</b></td></tr>"

	. += "<tr><td colspan=3><hr></td></tr>"
	. += "<tr><td colspan=3>"
	. += "<center>"
	var/show_all_selected_items_style = show_all_selected_items ? "style='color: #FF8000;'" : ""
	. += "<a href='?src=\ref[src];show_all_selected_items=1'><font [show_all_selected_items_style]>Show all selected items</font></a> "
	. += "<a href='?src=\ref[src];clear_tags=1'>Clear tags</a> "
	. += "</center>"
	. += "</td></tr>"
	. += "<tr><td colspan=3><hr></td></tr>"

	var/ticked_items_html = "" // to be added to the top/beginning of the list
	var/available_items_html = "" // to be added to the middle of the list
	var/unavailable_items_html = "" // to be added to the end/bottom of the list
	var/max_visible_items = 100 // max of items to show in the loadout
	var/items_matching_tags = 0 // items that could potentially be shown in the loadout (but may not be if over max_visible_items)

	var/list/player_valid_gear_choices = valid_gear_choices()

	var/list/gear_names = list()
	if(show_all_selected_items == TRUE)
		gear_names = pref.gear
	else if(selected_tags.len > 0)
		gear_names = tag_gear_names[selected_tags[1]]
	else
		gear_names = all_gear_names


	for(var/gear_name in gear_names)
		if(!(gear_name in player_valid_gear_choices))
			continue

		var/datum/gear/G = gear_datums[gear_name]

		var/has_all_selected_tags = TRUE
		for(var/tag in selected_tags)
			if(!(tag in G.tags))
				has_all_selected_tags = FALSE
				break
		if(!has_all_selected_tags)
			continue

		// now this item matches all tags and could potentially be displayed in the loadout
		items_matching_tags++

		// to avoid showing too many items and lagging the loadout/server
		if(items_matching_tags >= max_visible_items)
			continue

		var/temp_html = ""
		var/datum/job/job = pref.return_chosen_high_job()
		var/available = (G.check_faction(pref.faction) \
			&& (job && G.check_role(job.title)) \
			&& G.check_culture(text2path(pref.culture)) \
			&& G.check_origin(text2path(pref.origin)))
		var/ticked = (G.display_name in pref.gear)
		var/style = ""

		if(!available)
			style = "style='color: #B1B1B1;'"
		if(ticked)
			style = "style='color: #FF8000;'"
		temp_html += "<tr style='vertical-align:top'><td width=25%><a href=\"?src=\ref[src];toggle_gear=[G.display_name]\"><font [style]>[G.display_name]</font></a></td>"
		temp_html += "<td width = 10% style='vertical-align:top'>[G.cost]</td>"
		temp_html += "<td><font size=2><i>[G.description]</i><br>"

		if(G.allowed_roles)
			temp_html += "</font><font size=1 style='color: #B1B1B1;'>(Role: "
			var/role_count = 0
			for(var/role in G.allowed_roles)
				temp_html += "[role]"
				role_count++
				if(role_count == G.allowed_roles.len)
					temp_html += ") "
					break
				else
					temp_html += ", "
		if(G.culture_restriction)
			temp_html += "</font><font size=1 style='color: #B1B1B1;'>(Culture: "
			var/culture_count = 0
			for(var/culture in G.culture_restriction)
				var/singleton/origin_item/C = GET_SINGLETON(culture)
				temp_html += "[C.name]"
				culture_count++
				if(culture_count == G.culture_restriction.len)
					temp_html += ") "
					break
				else
					temp_html += ", "
		if(G.origin_restriction)
			temp_html += "</font><font size=1 style='color: #B1B1B1;'>(Origin: "
			var/origin_count = 0
			for(var/origin in G.origin_restriction)
				var/singleton/origin_item/O = GET_SINGLETON(origin)
				temp_html += "[O.name]"
				origin_count++
				if(origin_count == G.origin_restriction.len)
					temp_html += ") "
					break
				else
					temp_html += ", "
		if(G.tags && G.tags.len != 0)
			temp_html += "</font><font size=1 style='color: #B1B1B1;'>{Tags: "
			var/tag_count = 0
			for(var/tag in G.tags)
				temp_html += "[tag]"
				tag_count++
				if(tag_count == G.tags.len)
					temp_html += "} "
					break
				else
					temp_html += ", "
		temp_html += "</font></td></tr>"

		if(ticked)
			temp_html += "<tr><td colspan=3>"
			for(var/datum/gear_tweak/tweak in G.gear_tweaks)
				temp_html += " <a href='?src=\ref[src];gear=[G.display_name];tweak=\ref[tweak]'>[tweak.get_contents(get_tweak_metadata(G, tweak))]</a>"
			temp_html += "</td></tr>"

		if(ticked)
			ticked_items_html += temp_html
		else if(!available)
			available_items_html += temp_html
		else
			unavailable_items_html += temp_html

	. += ticked_items_html
	. += unavailable_items_html
	. += available_items_html

	. += "<tr><td colspan=3>"
	. += "Items displayed: [Clamp(items_matching_tags,0,max_visible_items)]/[max_visible_items]<br>"
	if(items_matching_tags >= max_visible_items)
		. += "Items not displayed: [items_matching_tags-max_visible_items]<br>"
		. += "Select more restrictive tags to see the other items.<br>"
	. += "</td></tr>"

	. += "</table>"
	. = jointext(.,null)

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
		var/datum/gear/TG = gear_datums[href_list["toggle_gear"]]
		if(TG.display_name in pref.gear)
			pref.gear -= TG.display_name
		else
			var/total_cost = 0
			for(var/gear_name in pref.gear)
				var/datum/gear/G = gear_datums[gear_name]
				if(istype(G)) total_cost += G.cost
			if((total_cost+TG.cost) <= MAX_GEAR_COST)
				pref.gear += TG.display_name
		return TOPIC_REFRESH_UPDATE_PREVIEW
	if(href_list["gear"] && href_list["tweak"])
		var/datum/gear/gear = gear_datums[href_list["gear"]]
		var/datum/gear_tweak/tweak = locate(href_list["tweak"])
		if(!tweak || !istype(gear) || !(tweak in gear.gear_tweaks))
			return TOPIC_NOACTION
		var/metadata = tweak.get_metadata(user, get_tweak_metadata(gear, tweak), null, gear.path)
		if(!metadata || !CanUseTopic(user))
			return TOPIC_NOACTION
		set_tweak_metadata(gear, tweak, metadata)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	if(href_list["next_slot"] || href_list["prev_slot"])
		//Set the current slot in the gear list to the currently selected gear
		pref.gear_list["[pref.gear_slot]"] = pref.gear

		//If we're moving up a slot..
		if(href_list["next_slot"])
			//change the current slot number
			pref.gear_slot = pref.gear_slot+1
			if(pref.gear_slot > config.loadout_slots)
				pref.gear_slot = 1
		//If we're moving down a slot..
		else if(href_list["prev_slot"])
			//change current slot one down
			pref.gear_slot = pref.gear_slot-1
			if(pref.gear_slot < 1)
				pref.gear_slot = config.loadout_slots
		// Set the currently selected gear to whatever's in the new slot
		if(pref.gear_list["[pref.gear_slot]"])
			pref.gear = pref.gear_list["[pref.gear_slot]"]
		else
			pref.gear = list()
			pref.gear_list["[pref.gear_slot]"] = list()
		// Refresh?
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["toggle_tag"])
		show_all_selected_items = FALSE
		selected_tags ^= href_list["toggle_tag"]
		return TOPIC_REFRESH_UPDATE_PREVIEW
	else if(href_list["clear_loadout"])
		pref.gear.Cut()
		return TOPIC_REFRESH_UPDATE_PREVIEW
	else if(href_list["show_all_selected_items"])
		show_all_selected_items ^= TRUE
		selected_tags = list()
		return TOPIC_REFRESH_UPDATE_PREVIEW
	else if(href_list["clear_tags"])
		show_all_selected_items = FALSE
		selected_tags = list()
		return TOPIC_REFRESH_UPDATE_PREVIEW
	return ..()
