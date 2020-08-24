var/global/list/uplink_locations = list("PDA", "Headset", "None")

/datum/category_item/player_setup_item/antagonism/basic
	name = "Setup"
	sort_order = 3

/datum/category_item/player_setup_item/antagonism/basic/load_character(var/savefile/S)
	S["uplinklocation"] >> pref.uplinklocation
	S["exploit_record"] >> pref.exploit_record
	S["backbag"]       >> pref.backbag

/datum/category_item/player_setup_item/antagonism/basic/save_character(var/savefile/S)
	S["uplinklocation"] << pref.uplinklocation
	S["exploit_record"] << pref.exploit_record
	S["backbag"]       << pref.backbag

/datum/category_item/player_setup_item/antagonism/basic/gather_load_query()
	return list(
		"ss13_characters_flavour" = list(
			"vars" = list(
				"records_exploit" = "exploit_record"
			),
			"args" = list("char_id")
		),
		"ss13_characters" = list(
			"vars" = list(
				"uplink_location" = "uplinklocation",
				"backbag"
			),
			"args" = list("id")
		)
	)

/datum/category_item/player_setup_item/antagonism/basic/gather_load_parameters()
	return list(
		"char_id" = pref.current_character,
		"id" = pref.current_character
	)

/datum/category_item/player_setup_item/antagonism/basic/gather_save_query()
	return list(
		"ss13_characters_flavour" = list(
			"records_exploit",
			"char_id" = 1
		),
		"ss13_characters" = list(
			"uplink_location",
			"backbag",
			"id" = 1,
			"ckey" = 1
		)
	)

/datum/category_item/player_setup_item/antagonism/basic/gather_save_parameters()
	return list("records_exploit" = pref.exploit_record, "char_id" = pref.current_character, "uplink_location" = pref.uplinklocation, "id" = pref.current_character, "ckey" = PREF_CLIENT_CKEY)

/datum/category_item/player_setup_item/antagonism/basic/sanitize_character()
	pref.uplinklocation	= sanitize_inlist(pref.uplinklocation, uplink_locations, initial(pref.uplinklocation))
	pref.backbag = text2num(pref.backbag)
	pref.backbag_style = text2num(pref.backbag_style)
	pref.backbag	= sanitize_integer(pref.backbag, 1, backbaglist.len, initial(pref.backbag))
	pref.backbag_style = sanitize_integer(pref.backbag_style, 1, backbagstyles.len, initial(pref.backbag_style))

/datum/category_item/player_setup_item/antagonism/basic/content(var/mob/user)
	var/list/dat = list(
		"<b>Antag Setup:</b><br>",
		"Uplink Type: <a href='?src=\ref[src];antagtask=1'>[pref.uplinklocation]</a><br>",
		"Backpack Type: <a href='?src=\ref[src];change_backpack=1'><b>[backbaglist[pref.backbag]]</b></a><br>",
		"Exploitable information:<br>"
	)
	if(jobban_isbanned(user, "Records"))
		dat += "<b>You are banned from using character records.</b><br>"
	else
		dat +="<a href='?src=\ref[src];exploitable_record=1'>[TextPreview(pref.exploit_record,40)]</a><br>"

	. = dat.Join()

/datum/category_item/player_setup_item/antagonism/basic/OnTopic(var/href,var/list/href_list, var/mob/user)
	if (href_list["antagtask"])
		pref.uplinklocation = next_in_list(pref.uplinklocation, uplink_locations)
		return TOPIC_REFRESH

	else if(href_list["exploitable_record"])
		var/exploitmsg = sanitize(input(user,"Set exploitable information about you here.","Exploitable Information", html_decode(pref.exploit_record)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0)
		if(!isnull(exploitmsg) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.exploit_record = exploitmsg
			return TOPIC_REFRESH

	else if(href_list["change_backpack"])
		var/new_backbag = input(user, "Choose your character's bag type:", "Character Preference", backbaglist[pref.backbag]) as null|anything in backbaglist
		if(!isnull(new_backbag) && CanUseTopic(user))
			pref.backbag = backbaglist.Find(new_backbag)
			return TOPIC_REFRESH_UPDATE_PREVIEW

	return ..()
