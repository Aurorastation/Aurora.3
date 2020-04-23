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

/datum/category_item/player_setup_item/loadout/load_character(var/savefile/S)
	S["gear"] >> pref.gear

/datum/category_item/player_setup_item/loadout/save_character(var/savefile/S)
	S["gear"] << pref.gear

/datum/category_item/player_setup_item/loadout/gather_load_parameters()
	return list("id" = pref.current_character)

/datum/category_item/player_setup_item/loadout/gather_load_query()
	return list("ss13_characters" = list("vars" = list("gear"), "args" = list("id")))

/datum/category_item/player_setup_item/loadout/gather_save_query()
	return list("ss13_characters" = list("gear", "id" = 1, "ckey" = 1))

/datum/category_item/player_setup_item/loadout/gather_save_parameters()
	return list("gear" = json_encode(pref.gear), "id" = pref.current_character, "ckey" = PREF_CLIENT_CKEY)

/datum/category_item/player_setup_item/loadout/proc/valid_gear_choices(var/max_cost)
	. = list()
	var/mob/preference_mob = preference_mob()
	for(var/gear_name in gear_datums)
		var/datum/gear/G = gear_datums[gear_name]
		if(max_cost && G.cost > max_cost)
			continue
		if(G.whitelisted && preference_mob)
			for(var/species in G.whitelisted)
				if(is_alien_whitelisted(preference_mob, global.all_species[species]))
					. += gear_name
					break
		else
			.+= gear_name

/datum/category_item/player_setup_item/loadout/sanitize_character(var/sql_load = 0)
	if (sql_load)
		gear_reset = FALSE
		if (istext(pref.gear))
			try
				pref.gear = json_decode(pref.gear)
			catch
				log_debug("SQL CHARACTER LOAD: Unable to load custom loadout for client [pref.client ? pref.client.ckey : "UNKNOWN"].")

				pref.gear = list()
				gear_reset = TRUE

	var/mob/preference_mob = preference_mob()
	if(!islist(pref.gear))
		pref.gear = list()

	for(var/gear_name in pref.gear)
		if(!(gear_name in gear_datums))
			pref.gear -= gear_name
	var/total_cost = 0
	for(var/gear_name in pref.gear)
		if(!gear_datums[gear_name])
			to_chat(preference_mob, "<span class='warning'>You cannot have more than one of the \the [gear_name]</span>")
			pref.gear -= gear_name
		else if(!(gear_name in valid_gear_choices()))
			to_chat(preference_mob, "<span class='warning'>You cannot take \the [gear_name] as you are not whitelisted for the species.</span>")
			pref.gear -= gear_name
		else
			var/datum/gear/G = gear_datums[gear_name]
			if(total_cost + G.cost > MAX_GEAR_COST)
				pref.gear -= gear_name
				to_chat(preference_mob, "<span class='warning'>You cannot afford to take \the [gear_name]</span>")
			else
				total_cost += G.cost

/datum/category_item/player_setup_item/loadout/content()
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
	. += "<tr><td colspan=3><center><b><font color = '[fcolor]'>[total_cost]/[MAX_GEAR_COST]</font> loadout points spent.</b> \[<a href='?src=\ref[src];clear_loadout=1'>Clear Loadout</a>\]</center></td></tr>"

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
	. += "<tr><td colspan=3><b><center>[LC.category]</center></b></td></tr>"
	. += "<tr><td colspan=3><hr></td></tr>"
	for(var/gear_name in LC.gear)
		if(!(gear_name in valid_gear_choices()))
			continue
		var/datum/gear/G = LC.gear[gear_name]
		var/ticked = (G.display_name in pref.gear)
		var/style = ""
		if(ticked)
			style = "style='color: #FF8000;'"
		. += "<tr style='vertical-align:top'><td width=25%><a href='?src=\ref[src];toggle_gear=[G.display_name]'><font [style]>[G.display_name]</font></a></td>"
		. += "<td width = 10% style='vertical-align:top'>[G.cost]</td>"
		. += "<td><font size=2><i>[G.description]</i><br>"
		if(G.allowed_roles)
			. += "</font><font size = 1>("
			var/role_count = 0
			for(var/role in G.allowed_roles)
				. += "[role]"
				role_count++
				if(role_count == G.allowed_roles.len)
					. += ")"
					break
				else
					. += ", "
		. += "</font></td></tr>"
		if(ticked)
			. += "<tr><td colspan=3>"
			for(var/datum/gear_tweak/tweak in G.gear_tweaks)
				. += " <a href='?src=\ref[src];gear=[G.display_name];tweak=\ref[tweak]'>[tweak.get_contents(get_tweak_metadata(G, tweak))]</a>"
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
		return TOPIC_REFRESH
	if(href_list["gear"] && href_list["tweak"])
		var/datum/gear/gear = gear_datums[href_list["gear"]]
		var/datum/gear_tweak/tweak = locate(href_list["tweak"])
		if(!tweak || !istype(gear) || !(tweak in gear.gear_tweaks))
			return TOPIC_NOACTION
		var/metadata = tweak.get_metadata(user, get_tweak_metadata(gear, tweak))
		if(!metadata || !CanUseTopic(user))
			return TOPIC_NOACTION
		set_tweak_metadata(gear, tweak, metadata)
		return TOPIC_REFRESH
	else if(href_list["select_category"])
		current_tab = href_list["select_category"]
		return TOPIC_REFRESH
	else if(href_list["clear_loadout"])
		pref.gear.Cut()
		return TOPIC_REFRESH
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
	if(flags & GEAR_HAS_NAME_SELECTION)
		gear_tweaks += list(gear_tweak_free_name)
	if(flags & GEAR_HAS_DESC_SELECTION)
		gear_tweaks += list(gear_tweak_free_desc)

/datum/gear_data
	var/path
	var/location

/datum/gear_data/New(var/path, var/location)
	src.path = path
	src.location = location

/datum/gear/proc/spawn_item(var/location, var/metadata)
	var/datum/gear_data/gd = new(path, location)
	for(var/datum/gear_tweak/gt in gear_tweaks)
		if(metadata["[gt]"])
			gt.tweak_gear_data(metadata["[gt]"], gd)
		else
			gt.tweak_gear_data(gt.get_default(), gd)
	var/item = new gd.path(gd.location)
	for(var/datum/gear_tweak/gt in gear_tweaks)
		if(metadata["[gt]"])
			gt.tweak_item(item, metadata["[gt]"])
		else
			gt.tweak_item(item, gt.get_default())
	return item

/datum/gear/proc/spawn_random(var/location)
	var/datum/gear_data/gd = new(path, location)
	for(var/datum/gear_tweak/gt in gear_tweaks)
		gt.tweak_gear_data(gt.get_random(), gd)
	var/item = new gd.path(gd.location)
	for(var/datum/gear_tweak/gt in gear_tweaks)
		gt.tweak_item(item, gt.get_random())
	return item