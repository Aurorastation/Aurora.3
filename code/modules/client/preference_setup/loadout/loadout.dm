var/list/loadout_categories = list()
var/list/gear_datums = list()

/datum/loadout_category
	var/category = ""
	var/list/gear = list()

/datum/loadout_category/New(var/cat)
	category = cat
	..()

/hook/startup/proc/populate_gear_list()
	// Setup custom loadout.
	//create a list of gear datums to sort
	for(var/geartype in subtypesof(/datum/gear))
		var/datum/gear/G = geartype

		var/use_name = initial(G.display_name)
		var/use_category = initial(G.sort_category)

		if(!loadout_categories[use_category])
			loadout_categories[use_category] = new /datum/loadout_category(use_category)
		var/datum/loadout_category/LC = loadout_categories[use_category]
		gear_datums[use_name] = new geartype
		LC.gear[use_name] = gear_datums[use_name]

	sortTim(loadout_categories, /proc/cmp_text_asc, FALSE)
	for(var/loadout_category in loadout_categories)
		var/datum/loadout_category/LC = loadout_categories[loadout_category]
		sortTim(LC.gear, /proc/cmp_text_asc, FALSE)

	return TRUE

/datum/category_item/player_setup_item/loadout
	name = "Loadout"
	sort_order = 1
	var/current_tab = "General"
	var/gear_reset = FALSE
	var/search_input_value = ""

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
				log_debug("SQL CHARACTER LOAD: Unable to load custom loadout for client [pref.client ? pref.client.ckey : "UNKNOWN"].")
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

	. += "<tr><td colspan=3><center><b>"
	var/firstcat = 1
	for(var/category in loadout_categories)

		if(firstcat)
			firstcat = 0
		else
			. += " |"
		if(category == current_tab)
			. += " [category] "
		else
			var/datum/loadout_category/LC = loadout_categories[category]
			var/style = ""
			for(var/thing in LC.gear)
				if(thing in pref.gear)
					style = "style='color: #FF8000;'"
					break
			. += " <a href='?src=\ref[src];select_category=[category]'><font [style]>[category]</font></a> "
	. += "</b></center></td></tr>"

	var/datum/loadout_category/LC = loadout_categories[current_tab]

	. += "<tr><td colspan=3><hr></td></tr>"
	. += "<tr><td colspan=3>"
	. += "<div style='left:0;position:absolute;width:10%;margin-left:45%;'><b><center>[LC.category]</center></b></div>"
	. += "<span style='float:left;'>"
	. += "<script>function search_onchange() { \
		var val = document.getElementById('search_input').value; \
		document.getElementById('search_refresh_link').href='?src=\ref[src];search_input_refresh=' + encodeURIComponent(val) + ''; \
		document.getElementById('search_refresh_link').click(); \
		}</script>"
	. += "Search: "
	. += "<input type='text' id='search_input' name='search_input' \
			onchange='search_onchange()' value='[search_input_value]'>";
	. += "<a href='#' onclick='search_onchange()'>Refresh</a>"
	. += "<a href='?src=\ref[src];search_input_refresh=' id='search_refresh_link'>Clear</a>"
	. += "</span>"
	. += "</td></tr>"
	. += "<tr><td colspan=3><hr></td></tr>"

	var/available_items_html = "" // to be added to the top/beginning of the list
	var/unavailable_items_html = "" // to be added to the end/bottom of the list

	var/list/player_valid_gear_choices = valid_gear_choices()
	for(var/gear_name in LC.gear)
		if(!(gear_name in player_valid_gear_choices))
			continue
		var/datum/gear/G = LC.gear[gear_name]
		
		var/temp_html = ""
		var/datum/job/job = pref.return_chosen_high_job()
		var/available = (G.check_faction(pref.faction) && (job && G.check_role(job.title)) && G.check_culture(pref.culture) && G.check_origin(pref.origin))
		var/ticked = (G.display_name in pref.gear)
		var/style = ""

		var/found_searched_text = FALSE
		if(findtext(G.display_name, search_input_value))
			found_searched_text = TRUE
		for(var/datum/gear_tweak/tweak in G.gear_tweaks)
			var/datum/gear_tweak/path/path = tweak
			if(path && istype(path) && path.valid_paths)
				for(var/x in path.valid_paths)
					if(findtext(x, search_input_value))
						found_searched_text = TRUE
		available = available && found_searched_text

		if(!available)
			style = "style='color: #B1B1B1;'"
		if(ticked)
			style = "style='color: #FF8000;'"
		temp_html += "<tr style='vertical-align:top'><td width=25%><a href='?src=\ref[src];toggle_gear=[G.display_name]'><font [style]>[G.display_name]</font></a></td>"
		temp_html += "<td width = 10% style='vertical-align:top'>[G.cost]</td>"
		temp_html += "<td><font size=2><i>[G.description]</i><br>"
		
		if(G.allowed_roles)
			temp_html += "</font><font size = 1>(Role: "
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
			temp_html += "</font><font size = 1>(Culture: "
			var/culture_count = 0
			for(var/culture in G.culture_restriction)
				var/decl/origin_item/C = decls_repository.get_decl(culture)
				temp_html += "[C.name]"
				culture_count++
				if(culture_count == G.culture_restriction.len)
					temp_html += ") "
					break
				else
					temp_html += ", "
		if(G.origin_restriction)
			temp_html += "</font><font size = 1>(Origin: "
			var/origin_count = 0
			for(var/origin in G.origin_restriction)
				var/decl/origin_item/O = decls_repository.get_decl(origin)
				temp_html += "[O.name]"
				origin_count++
				if(origin_count == G.origin_restriction.len)
					temp_html += ") "
					break
				else
					temp_html += ", "
		temp_html += "</font></td></tr>"
		
		if(ticked)
			temp_html += "<tr><td colspan=3>"
			for(var/datum/gear_tweak/tweak in G.gear_tweaks)
				temp_html += " <a href='?src=\ref[src];gear=[G.display_name];tweak=\ref[tweak]'>[tweak.get_contents(get_tweak_metadata(G, tweak))]</a>"
			temp_html += "</td></tr>"
		if(!available)
			available_items_html += temp_html
		else
			unavailable_items_html += temp_html
	
	. += unavailable_items_html
	. += available_items_html
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
		var/metadata = tweak.get_metadata(user, get_tweak_metadata(gear, tweak))
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

	else if(href_list["select_category"])
		current_tab = href_list["select_category"]
		return TOPIC_REFRESH_UPDATE_PREVIEW
	else if(href_list["clear_loadout"])
		pref.gear.Cut()
		return TOPIC_REFRESH_UPDATE_PREVIEW
	else if(href_list["search_input_refresh"] != null) // empty str is false
		search_input_value = sanitize(href_list["search_input_refresh"], 100)
		return TOPIC_REFRESH_UPDATE_PREVIEW
	return ..()

/datum/gear
	var/display_name       //Name/index. Must be unique.
	var/description        //Description of this gear. If left blank will default to the description of the pathed item.
	var/path               //Path to item.
	var/cost = 1           //Number of points used. Items in general cost 1 point, storage/armor/gloves/special use costs 2 points.
	var/slot               //Slot to equip to.
	var/list/allowed_roles //Roles that can spawn with this item.
	var/whitelisted        //Term to check the whitelist for..
	var/faction            //Is this item whitelisted for a faction?
	var/list/culture_restriction //Is this item restricted to certain cultures? The contents are paths.
	var/list/origin_restriction //Is this item restricted to certain origins? The contents are paths.
	var/sort_category = "General"
	var/list/gear_tweaks = list() //List of datums which will alter the item after it has been spawned.
	var/flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION
	var/augment = FALSE

/datum/gear/New()
	..()
	if(!description)
		var/obj/O = path
		description = initial(O.desc)
	if(flags & GEAR_HAS_COLOR_SELECTION)
		gear_tweaks += list(gear_tweak_free_color_choice)
	if(flags & GEAR_HAS_ADDITIONAL_COLOR_SELECTION)
		gear_tweaks += list(gear_tweak_additional_color)
	if(flags & GEAR_HAS_NAME_SELECTION)
		gear_tweaks += list(gear_tweak_free_name)
	if(flags & GEAR_HAS_DESC_SELECTION)
		gear_tweaks += list(gear_tweak_free_desc)
	if(flags & GEAR_HAS_COLOR_ROTATION_SELECTION)
		gear_tweaks += list(gear_tweak_color_rotation)

/datum/gear_data
	var/path
	var/location

/datum/gear_data/New(var/path, var/location)
	src.path = path
	src.location = location

/datum/gear/proc/spawn_item(var/location, var/metadata, var/mob/living/carbon/human/H)
	var/datum/gear_data/gd = new(path, location)
	for(var/datum/gear_tweak/gt in gear_tweaks)
		if(metadata["[gt]"])
			gt.tweak_gear_data(metadata["[gt]"], gd, H)
		else
			gt.tweak_gear_data(gt.get_default(), gd, H)
	var/item = new gd.path(gd.location)
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

/datum/gear/proc/check_faction(var/faction_)
	if((faction && faction_ && faction_ != "None" && faction_ != "Stellar Corporate Conglomerate") && (faction != faction_))
		return FALSE
	return TRUE

/datum/gear/proc/check_role(var/role)
	if(role && allowed_roles && !(role in allowed_roles))
		return FALSE
	return TRUE

/datum/gear/proc/check_culture(var/culture)
	if(culture && culture_restriction && !(culture in culture_restriction))
		return FALSE
	return TRUE

/datum/gear/proc/check_origin(var/origin)
	if(origin && origin_restriction && !(origin in origin_restriction))
		return FALSE
	return TRUE
