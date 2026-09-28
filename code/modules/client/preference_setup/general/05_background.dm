/datum/category_item/player_setup_item/general/background
	name = "Background"
	sort_order = 5

/datum/category_item/player_setup_item/general/background/load_character(var/savefile/S)
	S["med_record"]          >> pref.med_record
	S["sec_record"]          >> pref.sec_record
	S["gen_record"]          >> pref.gen_record

/datum/category_item/player_setup_item/general/background/save_character(var/savefile/S)
	S["med_record"]          << pref.med_record
	S["sec_record"]          << pref.sec_record
	S["gen_record"]          << pref.gen_record

/datum/category_item/player_setup_item/general/background/gather_load_query()
	return list(
		"ss13_characters_flavour" = list(
			"vars" = list(
				"records_employment" = "gen_record",
				"records_medical" = "med_record",
				"records_security" = "sec_record",
				"records_ccia" = "ccia_record"
			),
			"args" = list("char_id")
		)
	)

/datum/category_item/player_setup_item/general/background/gather_load_parameters()
	return list(
		"char_id" = pref.current_character
	)

/datum/category_item/player_setup_item/general/background/gather_save_query()
	return list(
		"ss13_characters_flavour" = list(
			"records_employment",
			"records_medical",
			"records_security",
			"char_id" = 1
		)
	)

/datum/category_item/player_setup_item/general/background/gather_save_parameters()
	return list(
		"records_employment" = pref.gen_record,
		"records_medical" = pref.med_record,
		"records_security" = pref.sec_record,
		"char_id" = pref.current_character,
		"ckey" = PREF_CLIENT_CKEY
	)

/datum/category_item/player_setup_item/general/background/ui_data(var/mob/user)
	var/list/records = list()
	if(!jobban_isbanned(user, "Records"))
		records += list(list("name" = "Medical", "preview" = html_decode(TextPreview(pref.med_record, 40)), "type" = "medical"))
		records += list(list("name" = "Employment", "preview" = html_decode(TextPreview(pref.gen_record, 40)), "type" = "general"))
		records += list(list("name" = "Security", "preview" = html_decode(TextPreview(pref.sec_record, 40)), "type" = "security"))
	return list(
		"kind" = "background",
		"name" = name,
		"ref" = REF(src),
		"banned" = jobban_isbanned(user, "Records"),
		"records" = records
	)

/datum/category_item/player_setup_item/general/background/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["edit_record"])
		if(jobban_isbanned(user, "Records") || !CanUseTopic(user))
			return TOPIC_NOACTION
		var/record_type = href_list["edit_record"]
		var/record_name
		var/current_value
		switch(record_type)
			if("medical")
				record_name = "Medical"
				current_value = pref.med_record
			if("general")
				record_name = "Employment"
				current_value = pref.gen_record
			if("security")
				record_name = "Security"
				current_value = pref.sec_record
			else
				return TOPIC_NOACTION

		var/new_value = tgui_input_text(user, "Write the character's [lowertext(record_name)] record.", "[record_name] Records", html_decode(current_value), max_length = MAX_PAPER_MESSAGE_LEN - 1, multiline = TRUE, encode = FALSE, preview_context = get_pencode_preview_context(FALSE, TRUE, TRUE, TRUE, MAX_PAPER_MESSAGE_LEN), preview_width = 864, preview_height = 720)
		if(isnull(new_value) || jobban_isbanned(user, "Records") || !CanUseTopic(user))
			return TOPIC_NOACTION
		new_value = sanitize(new_value, MAX_PAPER_MESSAGE_LEN, extra = FALSE) || ""
		switch(record_type)
			if("medical")
				pref.med_record = new_value
			if("general")
				pref.gen_record = new_value
			if("security")
				pref.sec_record = new_value
		return TOPIC_REFRESH

	else if(href_list["clear"])
		if(!jobban_isbanned(user, "Records") && CanUseTopic(user))
			if(alert(user, "Are you sure you wish to clear the [capitalize(href_list["clear"])] record?", "Clear Record Confirmation","Yes","No") == "No")
				return TOPIC_NOACTION
			switch(href_list["clear"])
				if("medical")
					pref.med_record = ""
				if("general")
					pref.gen_record = ""
				if("security")
					pref.sec_record = ""
			return TOPIC_REFRESH


	return ..()
