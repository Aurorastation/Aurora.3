/datum/category_item/player_setup_item/player_global/settings
	name = "Settings"
	sort_order = 2

/datum/category_item/player_setup_item/player_global/settings/load_preferences(var/savefile/S)
	S["lastchangelog"]    >> pref.lastchangelog
	S["default_slot"]     >> pref.default_slot
	S["toggles"]          >> pref.toggles
	S["sfx_toggles"]        >> pref.sfx_toggles
	S["toggles_secondary"] >> pref.toggles_secondary
	S["lobby_music_vol"] >> pref.lobby_music_vol
	S["looping_sound_volume"] >> pref.looping_sound_volume

/datum/category_item/player_setup_item/player_global/settings/save_preferences(var/savefile/S)
	S["lastchangelog"]    << pref.lastchangelog
	S["default_slot"]     << pref.default_slot
	S["toggles"]          << pref.toggles
	S["sfx_toggles"]        << pref.sfx_toggles
	S["toggles_secondary"] << pref.toggles_secondary
	S["lobby_music_vol"] << pref.lobby_music_vol
	S["looping_sound_volume"] << pref.looping_sound_volume

/datum/category_item/player_setup_item/player_global/settings/gather_load_query()
	return list(
		"ss13_player_preferences" = list(
			"vars" = list(
				"lastchangelog",
				"current_character",
				"toggles",
				"sfx_toggles",
				"toggles_secondary",
				"lobby_music_vol",
				"looping_sound_volume"
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
			"lobby_music_vol",
			"looping_sound_volume",
		)
	)

/datum/category_item/player_setup_item/player_global/settings/gather_save_parameters()
	return list(
		"ckey" = PREF_CLIENT_CKEY,
		"lastchangelog" = pref.lastchangelog,
		"current_character" = pref.current_character,
		"toggles" = pref.toggles,
		"sfx_toggles" = pref.sfx_toggles,
		"toggles_secondary" = pref.toggles_secondary,
		"lobby_music_vol" = pref.lobby_music_vol,
		"looping_sound_volume" = pref.looping_sound_volume
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
	pref.lobby_music_vol = sanitize_integer(text2num(pref.lobby_music_vol), 0, BITFIELDMAX, initial(pref.lobby_music_vol))
	pref.looping_sound_volume = sanitize_integer(text2num(pref.looping_sound_volume), 0, 100, initial(pref.looping_sound_volume))

/datum/category_item/player_setup_item/player_global/settings/ui_data(mob/user)
	var/list/fields = list(
		list("label" = "Play Admin MIDIs", "value" = (pref.toggles & SOUND_MIDI) ? "Yes" : "No", "action" = "toggle", "action_value" = SOUND_MIDI),
		list("label" = "Lobby Music Volume", "value" = pref.lobby_music_vol, "action" = "select_volume"),
		list("label" = "Ghost Ears", "value" = (pref.toggles & CHAT_GHOSTEARS) ? "All Speech" : "Nearest Creatures", "action" = "toggle", "action_value" = CHAT_GHOSTEARS),
		list("label" = "Ghost Sight", "value" = (pref.toggles & CHAT_GHOSTSIGHT) ? "All Emotes" : "Nearest Creatures", "action" = "toggle", "action_value" = CHAT_GHOSTSIGHT),
		list("label" = "Ghost Radio", "value" = (pref.toggles & CHAT_GHOSTRADIO) ? "All Chatter" : "Nearest Speakers", "action" = "toggle", "action_value" = CHAT_GHOSTRADIO),
		list("label" = "Observer LOOC", "value" = (pref.toggles & CHAT_GHOSTLOOC) ? "Visible" : "Hidden", "action" = "toggle", "action_value" = CHAT_GHOSTLOOC),
		list("label" = "Item Outlines", "value" = (pref.toggles_secondary & SEE_ITEM_OUTLINES) ? "Visible" : "Hidden", "action" = "paratoggle", "action_value" = SEE_ITEM_OUTLINES),
		list("label" = "Hide Item Tooltips", "value" = (pref.toggles_secondary & HIDE_ITEM_TOOLTIPS) ? "Yes" : "No", "action" = "paratoggle", "action_value" = HIDE_ITEM_TOOLTIPS),
		list("label" = "Progress Bars", "value" = (pref.toggles_secondary & PROGRESS_BARS) ? "Yes" : "No", "action" = "paratoggle", "action_value" = PROGRESS_BARS),
		list("label" = "Floating Messages", "value" = (pref.toggles_secondary & FLOATING_MESSAGES) ? "Yes" : "No", "action" = "paratoggle", "action_value" = FLOATING_MESSAGES),
		list("label" = "Hotkey Mode Default", "value" = (pref.toggles_secondary & HOTKEY_DEFAULT) ? "On" : "Off", "action" = "paratoggle", "action_value" = HOTKEY_DEFAULT)
	)
	return list(
		"kind" = "form",
		"name" = name,
		"ref" = REF(src),
		"sections" = list(list("title" = "Game Settings", "fields" = fields))
	)

/datum/category_item/player_setup_item/player_global/settings/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["toggle"])
		var/toggle_flag = text2num(href_list["toggle"])
		pref.toggles ^= toggle_flag
		return TOPIC_REFRESH

	if(href_list["select_volume"])
		var/lobby_music_vol_new = tgui_input_number(src, "Choose lobby music volume, 0 to mute", "Lobby Music Volume", pref.lobby_music_vol, 100, 0, 0, TRUE)
		if(isnull(lobby_music_vol_new))
			return
		pref.lobby_music_vol = lobby_music_vol_new
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
