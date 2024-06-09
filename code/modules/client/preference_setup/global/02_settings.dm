/datum/category_item/player_setup_item/player_global/settings
	name = "Settings"
	sort_order = 2

/datum/category_item/player_setup_item/player_global/settings/load_preferences(var/savefile/S)
	S["lastchangelog"]    >> pref.lastchangelog
	S["default_slot"]     >> pref.default_slot
	S["toggles"]          >> pref.toggles
	S["sfx_toggles"]        >> pref.sfx_toggles
	S["toggles_secondary"] >> pref.toggles_secondary

/datum/category_item/player_setup_item/player_global/settings/save_preferences(var/savefile/S)
	S["lastchangelog"]    << pref.lastchangelog
	S["default_slot"]     << pref.default_slot
	S["toggles"]          << pref.toggles
	S["sfx_toggles"]        << pref.sfx_toggles
	S["toggles_secondary"] << pref.toggles_secondary

/datum/category_item/player_setup_item/player_global/settings/gather_load_query()
	return list(
		"ss13_player_preferences" = list(
			"vars" = list(
				"lastchangelog",
				"current_character",
				"toggles",
				"sfx_toggles",
				"toggles_secondary"
			),
			"args" = list("ckey")
		)
	)

/datum/category_item/player_setup_item/player_global/settings/gather_load_parameters()
	return list("ckey" = PREF_CLIENT_CKEY)

/datum/category_item/player_setup_item/player_global/settings/gather_save_query()
	return list(
		"ss13_player_preferences" = list(
			"lastchangelog",
			"current_character",
			"toggles",
			"sfx_toggles",
			"ckey" = 1,
			"toggles_secondary",
		)
	)

/datum/category_item/player_setup_item/player_global/settings/gather_save_parameters()
	return list(
		"ckey" = PREF_CLIENT_CKEY,
		"lastchangelog" = pref.lastchangelog,
		"current_character" = pref.current_character,
		"toggles" = pref.toggles,
		"sfx_toggles" = pref.sfx_toggles,
		"toggles_secondary" = pref.toggles_secondary
	)

/datum/category_item/player_setup_item/player_global/settings/sanitize_preferences(var/sql_load = 0)
	if (sql_load)
		pref.current_character = text2num(pref.current_character)
		pref.current_character = validate_current_character()

	pref.lastchangelog  = sanitize_text(pref.lastchangelog, initial(pref.lastchangelog))
	pref.default_slot   = sanitize_integer(text2num(pref.default_slot), 1, GLOB.config.character_slots, initial(pref.default_slot))
	pref.toggles        = sanitize_integer(text2num(pref.toggles), 0, BITFIELDMAX, initial(pref.toggles))
	pref.sfx_toggles      = sanitize_integer(text2num(pref.sfx_toggles), 0, BITFIELDMAX, initial(pref.toggles))
	pref.toggles_secondary  = sanitize_integer(text2num(pref.toggles_secondary), 0, BITFIELDMAX, initial(pref.toggles_secondary))

/datum/category_item/player_setup_item/player_global/settings/content(mob/user)
	var/list/dat = list(
		"<b>Play admin midis:</b> <a href='?src=\ref[src];toggle=[SOUND_MIDI]'><b>[(pref.toggles & SOUND_MIDI) ? "Yes" : "No"]</b></a><br>",
		"<b>Play lobby music:</b> <a href='?src=\ref[src];toggle=[SOUND_LOBBY]'><b>[(pref.toggles & SOUND_LOBBY) ? "Yes" : "No"]</b></a><br>",
		"<b>Ghost ears:</b> <a href='?src=\ref[src];toggle=[CHAT_GHOSTEARS]'><b>[(pref.toggles & CHAT_GHOSTEARS) ? "All Speech" : "Nearest Creatures"]</b></a><br>",
		"<b>Ghost sight:</b> <a href='?src=\ref[src];toggle=[CHAT_GHOSTSIGHT]'><b>[(pref.toggles & CHAT_GHOSTSIGHT) ? "All Emotes" : "Nearest Creatures"]</b></a><br>",
		"<b>Ghost radio:</b> <a href='?src=\ref[src];toggle=[CHAT_GHOSTRADIO]'><b>[(pref.toggles & CHAT_GHOSTRADIO) ? "All Chatter" : "Nearest Speakers"]</b></a><br>",
		"<b>Observer LOOC:</b> <a href='?src=\ref[src];toggle=[CHAT_GHOSTLOOC]'><b>[(pref.toggles & CHAT_GHOSTLOOC) ? "Visible" : "Hidden"]</b></a><br>",
		"<b>Item Outlines:</b> <a href='?src=\ref[src];paratoggle=[SEE_ITEM_OUTLINES]'><b>[(pref.toggles_secondary & SEE_ITEM_OUTLINES) ? "Visible" : "Hidden"]</b></a><br>",
		"<b>Hide Item Tooltips:</b> <a href='?src=\ref[src];paratoggle=[HIDE_ITEM_TOOLTIPS]'><b>[(pref.toggles_secondary & HIDE_ITEM_TOOLTIPS) ? "Yes" : "No"]</b></a><br>",
		"<b>Progress Bars:</b> <a href='?src=\ref[src];paratoggle=[PROGRESS_BARS]'><b>[(pref.toggles_secondary & PROGRESS_BARS) ? "Yes" : "No"]</b></a><br>",
		"<b>Floating Messages:</b> <a href='?src=\ref[src];paratoggle=[FLOATING_MESSAGES]'><b>[(pref.toggles_secondary & FLOATING_MESSAGES) ? "Yes" : "No"]</b></a><br>",
		"<b>Hotkey Mode Default:</b> <a href='?src=\ref[src];paratoggle=[HOTKEY_DEFAULT]'><b>[(pref.toggles_secondary & HOTKEY_DEFAULT) ? "On" : "Off"]</b></a><br>"
	)

	. = dat.Join()

/datum/category_item/player_setup_item/player_global/settings/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["toggle"])
		var/toggle_flag = text2num(href_list["toggle"])
		pref.toggles ^= toggle_flag
		if(toggle_flag == SOUND_LOBBY && isnewplayer(user))
			if(pref.toggles & SOUND_LOBBY)
				user << sound(SSticker.login_music, repeat = 0, wait = 0, volume = 85, channel = 1)
			else
				user << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1)
		return TOPIC_REFRESH

	if(href_list["paratoggle"])
		var/flag = text2num(href_list["paratoggle"])
		pref.toggles_secondary ^= flag
		return TOPIC_REFRESH

	return ..()

/datum/category_item/player_setup_item/player_global/settings/proc/validate_current_character()
	if (!establish_db_connection(GLOB.dbcon))
		return pref.current_character

	var/DBQuery/is_ours = GLOB.dbcon.NewQuery("SELECT COUNT(*) as valid_id FROM ss13_characters WHERE ckey = :ckey: AND id = :curr_char: AND deleted_at IS NULL")
	is_ours.Execute(list("ckey" = pref.client.ckey, "curr_char" = pref.current_character))

	if (!is_ours.NextRow())
		return pref.current_character

	var/found = text2num(is_ours.item[1])

	if (!found)
		return select_default_character()
	else
		return pref.current_character

/datum/category_item/player_setup_item/player_global/settings/proc/select_default_character()
	if (!establish_db_connection(GLOB.dbcon))
		return 0

	var/DBQuery/first_char = GLOB.dbcon.NewQuery("SELECT id FROM ss13_characters WHERE ckey = :ckey: AND deleted_at IS NULL LIMIT 1")
	first_char.Execute(list("ckey" = pref.client.ckey))

	if (!first_char.NextRow())
		return 0

	return text2num(first_char.item[1])
