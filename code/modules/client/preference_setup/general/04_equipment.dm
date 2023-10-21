/datum/preferences
	var/list/all_underwear
	var/list/all_underwear_metadata

/datum/category_item/player_setup_item/general/equipment
	name = "Equipment"
	sort_order = 4

/datum/category_item/player_setup_item/general/equipment/load_character(var/savefile/S)
	S["all_underwear"] >> pref.all_underwear
	S["all_underwear_metadata"] >> pref.all_underwear_metadata
	S["backbag"]       >> pref.backbag
	S["backbag_style"] >> pref.backbag_style
	S["backbag_color"] >> pref.backbag_color
	S["backbag_strap"] >> pref.backbag_strap
	S["pda_choice"] >> pref.pda_choice
	S["headset_choice"] >> pref.headset_choice
	S["primary_radio_slot"] >> pref.primary_radio_slot
	S["sensor_setting"] >> pref.sensor_setting

/datum/category_item/player_setup_item/general/equipment/save_character(var/savefile/S)
	S["all_underwear"] << pref.all_underwear
	S["all_underwear_metadata"] << pref.all_underwear_metadata
	S["backbag"]       << pref.backbag
	S["backbag_style"] << pref.backbag_style
	S["backbag_color"] << pref.backbag_color
	S["backbag_strap"] << pref.backbag_strap
	S["pda_choice"] << pref.pda_choice
	S["headset_choice"] << pref.headset_choice
	S["primary_radio_slot"] << pref.primary_radio_slot
	S["sensor_setting"] << pref.sensor_setting

/datum/category_item/player_setup_item/general/equipment/gather_load_query()
	return list(
		"ss13_characters" = list(
			"vars" = list(
				"all_underwear",
				"all_underwear_metadata",
				"backbag",
				"backbag_style",
				"backbag_color",
				"backbag_strap",
				"pda_choice",
				"headset_choice",
				"primary_radio_slot",
				"sensor_setting"
			),
			"args" = list("id")
		)
	)

/datum/category_item/player_setup_item/general/equipment/gather_load_parameters()
	return list("id" = pref.current_character)

/datum/category_item/player_setup_item/general/equipment/gather_save_query()
	return list(
		"ss13_characters" = list(
			"all_underwear",
			"all_underwear_metadata",
			"backbag",
			"backbag_style",
			"backbag_color",
			"backbag_strap",
			"pda_choice",
			"headset_choice",
			"primary_radio_slot",
			"sensor_setting",
			"id" = 1,
			"ckey" = 1
		)
	)

/datum/category_item/player_setup_item/general/equipment/gather_save_parameters()
	return list(
		"all_underwear" = json_encode(pref.all_underwear),
		"all_underwear_metadata" = json_encode(pref.all_underwear_metadata),
		"backbag" = pref.backbag,
		"backbag_style" = pref.backbag_style,
		"backbag_color" = pref.backbag_color,
		"backbag_strap" = pref.backbag_strap,
		"pda_choice" = pref.pda_choice,
		"headset_choice" = pref.headset_choice,
		"primary_radio_slot" = pref.primary_radio_slot,
		"sensor_setting" = pref.sensor_setting,
		"id" = pref.current_character,
		"ckey" = PREF_CLIENT_CKEY
	)

/datum/category_item/player_setup_item/general/equipment/sanitize_character(var/sql_load = 0)
	if (sql_load)
		pref.backbag = text2num(pref.backbag)
		pref.backbag_style = text2num(pref.backbag_style)
		pref.backbag_color = text2num(pref.backbag_color)
		pref.backbag_strap = text2num(pref.backbag_strap)
		pref.pda_choice = text2num(pref.pda_choice)
		pref.headset_choice = text2num(pref.headset_choice)
		if(istext(pref.all_underwear))
			var/before = pref.all_underwear
			try
				pref.all_underwear = json_decode(pref.all_underwear)
			catch(var/exception/e)
				LOG_DEBUG("UNDERWEAR: Caught [e]. Initial value: [before]")
				pref.all_underwear = list()
		if(istext(pref.all_underwear_metadata))
			var/before = pref.all_underwear_metadata
			try
				pref.all_underwear_metadata = json_decode(pref.all_underwear_metadata)
			catch(var/exception/e)
				LOG_DEBUG("UNDERWEAR METADATA: Caught [e]. Initial value: [before]")
				pref.all_underwear_metadata = list()

	if(!istype(pref.all_underwear))
		pref.all_underwear = list()

		for(var/datum/category_group/underwear/WRC in global_underwear.categories)
			for(var/datum/category_item/underwear/WRI in WRC.items)
				if(WRI.is_default(pref.gender ? pref.gender : MALE))
					pref.all_underwear[WRC.name] = WRI.name
					break

	if(!istype(pref.all_underwear_metadata))
		pref.all_underwear_metadata = list()

	for(var/underwear_category in pref.all_underwear)
		var/datum/category_group/underwear/UWC = global_underwear.categories_by_name[underwear_category]
		if(!UWC)
			pref.all_underwear -= underwear_category
		else
			var/datum/category_item/underwear/UWI = UWC.items_by_name[pref.all_underwear[underwear_category]]
			if(!UWI)
				pref.all_underwear -= underwear_category

	for(var/underwear_metadata in pref.all_underwear_metadata)
		if(!(underwear_metadata in pref.all_underwear))
			pref.all_underwear_metadata -= underwear_metadata

	pref.backbag	= sanitize_integer(pref.backbag, 1, backbaglist.len, initial(pref.backbag))
	pref.backbag_style = sanitize_integer(pref.backbag_style, 1, backbagstyles.len, initial(pref.backbag_style))
	pref.backbag_color = sanitize_integer(pref.backbag_color, 1, backbagcolors.len, initial(pref.backbag_color))
	pref.backbag_strap = sanitize_integer(pref.backbag_strap, 1, backbagstrap.len, initial(pref.backbag_strap))
	pref.pda_choice = sanitize_integer(pref.pda_choice, 1, pdalist.len, initial(pref.pda_choice))
	pref.headset_choice	= sanitize_integer(pref.headset_choice, 1, headsetlist.len, initial(pref.headset_choice))
	if(!(pref.primary_radio_slot in primary_radio_slot_choice))
		pref.primary_radio_slot = primary_radio_slot_choice[1]
	pref.sensor_setting = sanitize_inlist(pref.sensor_setting, SUIT_SENSOR_MODES, get_key_by_index(SUIT_SENSOR_MODES, 0))

/datum/category_item/player_setup_item/general/equipment/content(var/mob/user)
	. = list()
	. += "<b>Equipment:</b><br>"
	for(var/datum/category_group/underwear/UWC in global_underwear.categories)
		var/item_name = pref.all_underwear[UWC.name] ? pref.all_underwear[UWC.name] : "None"
		. += "[UWC.name]: <a href='?src=\ref[src];change_underwear=[UWC.name]'><b>[item_name]</b></a>"

		var/datum/category_item/underwear/UWI = UWC.items_by_name[item_name]
		if(UWI)
			for(var/datum/gear_tweak/gt in UWI.tweaks)
				. += " <a href='?src=\ref[src];underwear=[UWC.name];tweak=\ref[gt]'>[gt.get_contents(get_metadata(UWC.name, gt))]</a>"

		. += "<br>"

	. += "Backpack Type: <a href='?src=\ref[src];change_backpack=1'><b>[backbaglist[pref.backbag]]</b></a><br>"
	. += "Backpack Style: <a href='?src=\ref[src];change_backpack_style=1'><b>[backbagstyles[pref.backbag_style]]</b></a><br>"
	if(pref.backbag == OUTFIT_SATCHEL_ALT || pref.backbag == OUTFIT_RUCKSACK || pref.backbag == OUTFIT_POCKETBOOK) // Hardcoded. Sucks, I know.
		. += "Backpack Color: <a href='?src=\ref[src];change_backpack_color=1'><b>[backbagcolors[pref.backbag_color]]</b></a><br>"
	. += "Backpack Strap: <a href='?src=\ref[src];change_backbag_strap=1'><b>[backbagstrap[pref.backbag_strap]]</b></a><br>"
	. += "PDA Type: <a href='?src=\ref[src];change_pda=1'><b>[pdalist[pref.pda_choice]]</b></a><br>"
	. += "Headset Type: <a href='?src=\ref[src];change_headset=1'><b>[headsetlist[pref.headset_choice]]</b></a><br>"
	. += "Primary Radio Slot: <a href='?src=\ref[src];change_radio_slot=1'><b>[pref.primary_radio_slot]</b></a><br>"
	. += "Suit Sensor Setting: <a href='?src=\ref[src];change_sensor_setting=1'><b>[pref.sensor_setting]</b></a><br/>"

	return jointext(., null)

/datum/category_item/player_setup_item/general/equipment/proc/get_metadata(var/underwear_category, var/datum/gear_tweak/gt)
	var/metadata = pref.all_underwear_metadata[underwear_category]
	if(!metadata)
		metadata = list()
		pref.all_underwear_metadata[underwear_category] = metadata

	var/tweak_data = metadata["[gt]"]
	if(!tweak_data)
		tweak_data = gt.get_default()
		metadata["[gt]"] = tweak_data
	return tweak_data

/datum/category_item/player_setup_item/general/equipment/proc/set_metadata(var/underwear_category, var/datum/gear_tweak/gt, var/new_metadata)
	var/list/metadata = pref.all_underwear_metadata[underwear_category]
	metadata["[gt]"] = new_metadata

/datum/category_item/player_setup_item/general/equipment/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["change_backpack"])
		var/new_backbag = tgui_input_list(user, "Choose your character's bag type.", "Character Preference", backbaglist, backbaglist[pref.backbag])
		if(!isnull(new_backbag) && CanUseTopic(user))
			pref.backbag = backbaglist.Find(new_backbag)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["change_backpack_style"])
		var/new_backbag = tgui_input_list(user, "Choose your character's style of bag.", "Character Preference", backbagstyles, backbagstyles[pref.backbag_style])
		if(!isnull(new_backbag) && CanUseTopic(user))
			pref.backbag_style = backbagstyles.Find(new_backbag)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["change_backpack_color"])
		var/new_backbag = tgui_input_list(user, "Choose your character's color of bag.", "Character Preference", backbagcolors, backbagcolors[pref.backbag_color])
		if(!isnull(new_backbag) && CanUseTopic(user))
			pref.backbag_color = backbagcolors.Find(new_backbag)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["change_backbag_strap"])
		var/new_backbag = tgui_input_list(user, "Choose your character's style of bag strap.", "Character Preference", backbagstrap, backbagstrap[pref.backbag_strap])
		if(!isnull(new_backbag) && CanUseTopic(user))
			pref.backbag_strap = backbagstrap.Find(new_backbag)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["change_pda"])
		var/new_pda = tgui_input_list(user, "Choose your character's PDA type.", "Character Preference", pdalist, pdalist[pref.pda_choice])
		if(!isnull(new_pda) && CanUseTopic(user))
			pref.pda_choice = pdalist.Find(new_pda)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["change_headset"])
		var/new_headset = tgui_input_list(user, "Choose your character's headset type.", "Character Preference", headsetlist, headsetlist[pref.headset_choice])
		if(!isnull(new_headset) && CanUseTopic(user))
			pref.headset_choice = headsetlist.Find(new_headset)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["change_radio_slot"])
		var/new_slot = tgui_input_list(user, "Choose which radio will be spoken into first if multiple slots are occupied.", "Character Preference", primary_radio_slot_choice, pref.primary_radio_slot)
		if(!isnull(new_slot) && CanUseTopic(user))
			pref.primary_radio_slot = new_slot
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["change_sensor_setting"])
		var/new_sensor = tgui_input_list(user, "Select a sensor mode.", "Character Preference", SUIT_SENSOR_MODES, pref.sensor_setting)
		if(!isnull(new_sensor) && CanUseTopic(user))
			pref.sensor_setting = new_sensor
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["change_underwear"])
		var/datum/category_group/underwear/UWC = global_underwear.categories_by_name[href_list["change_underwear"]]
		if(!UWC)
			return TOPIC_NOACTION
		var/datum/category_item/underwear/selected_underwear = tgui_input_list(user, "Choose underwear:", "Character Preference", UWC.items, pref.all_underwear[UWC.name])
		if(selected_underwear && CanUseTopic(user))
			pref.all_underwear[UWC.name] = selected_underwear.name
		return TOPIC_REFRESH_UPDATE_PREVIEW
	else if(href_list["underwear"] && href_list["tweak"])
		var/underwear = href_list["underwear"]
		if(!(underwear in pref.all_underwear))
			return TOPIC_NOACTION
		var/datum/gear_tweak/gt = locate(href_list["tweak"])
		if(!gt)
			return TOPIC_NOACTION
		var/new_metadata = gt.get_metadata(usr, get_metadata(underwear, gt))
		if(new_metadata)
			set_metadata(underwear, gt, new_metadata)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	return ..()
