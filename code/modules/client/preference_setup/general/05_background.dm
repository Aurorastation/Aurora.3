/datum/category_item/player_setup_item/general/background
	name = "Background"
	sort_order = 5
	var/record_preview_type
	var/record_preview_value
	var/record_preview_html

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
		records += list(list("name" = "Medical", "preview" = html_decode(TextPreview(pref.med_record, 40)), "type" = "medical", "value" = html_decode(pref.med_record)))
		records += list(list("name" = "Employment", "preview" = html_decode(TextPreview(pref.gen_record, 40)), "type" = "general", "value" = html_decode(pref.gen_record)))
		records += list(list("name" = "Security", "preview" = html_decode(TextPreview(pref.sec_record, 40)), "type" = "security", "value" = html_decode(pref.sec_record)))
	return list(
		"kind" = "background",
		"name" = name,
		"ref" = REF(src),
		"banned" = jobban_isbanned(user, "Records"),
		"records" = records,
		"record_max_length" = MAX_PAPER_MESSAGE_LEN - 1,
		"record_preview" = list(
			"type" = record_preview_type,
			"value" = record_preview_value,
			"html" = record_preview_html
		)
	)

/datum/category_item/player_setup_item/general/background/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["preview_record"])
		if(jobban_isbanned(user, "Records") || !CanUseTopic(user))
			return TOPIC_NOACTION
		var/preview_type = href_list["preview_record"]
		if(!(preview_type in list("medical", "general", "security")))
			return TOPIC_NOACTION
		record_preview_type = preview_type
		record_preview_value = copytext_char("[href_list["value"]]", 1, MAX_PAPER_MESSAGE_LEN)
		record_preview_html = record_notes_to_paper_html(record_preview_value)
		return TOPIC_REFRESH

	else if(href_list["save_record"])
		if(jobban_isbanned(user, "Records") || !CanUseTopic(user))
			return TOPIC_NOACTION
		var/record_type = href_list["save_record"]
		var/new_value = sanitize(href_list["value"], MAX_PAPER_MESSAGE_LEN, extra = 0) || ""
		switch(record_type)
			if("medical")
				pref.med_record = new_value
			if("general")
				pref.gen_record = new_value
			if("security")
				pref.sec_record = new_value
			else
				return TOPIC_NOACTION
		record_preview_type = null
		record_preview_value = null
		record_preview_html = null
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
