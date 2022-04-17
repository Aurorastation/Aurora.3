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

/datum/category_item/player_setup_item/general/background/content(var/mob/user)
	var/list/dat = list("<br/><b>Records</b>:<br/>")

	if(jobban_isbanned(user, "Records"))
		dat += "<span class='danger'>You are banned from using character records.</span><br>"
	else
		dat += "Medical Records:<br>"
		dat += "<a href='?src=\ref[src];set_medical_records=1'>[TextPreview(pref.med_record,40)]</a><a href='?src=\ref[src];clear=medical'>Clear</a><br><br>"
		dat += "Employment Records:<br>"
		dat += "<a href='?src=\ref[src];set_general_records=1'>[TextPreview(pref.gen_record,40)]</a><a href='?src=\ref[src];clear=general'>Clear</a><br><br>"
		dat += "Security Records:<br>"
		dat += "<a href='?src=\ref[src];set_security_records=1'>[TextPreview(pref.sec_record,40)]</a><a href='?src=\ref[src];clear=security'>Clear</a><br>"

	. = dat.Join()

/datum/category_item/player_setup_item/general/background/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["set_medical_records"])
		var/new_medical = sanitize(input(user,"Enter medical information here.","Character Preference", html_decode(pref.med_record)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0)
		if(!isnull(new_medical) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.med_record = new_medical
		return TOPIC_REFRESH

	else if(href_list["set_general_records"])
		var/new_general = sanitize(input(user,"Enter employment information here.","Character Preference", html_decode(pref.gen_record)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0)
		if(!isnull(new_general) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.gen_record = new_general
		return TOPIC_REFRESH

	else if(href_list["set_security_records"])
		var/sec_medical = sanitize(input(user,"Enter security information here.","Character Preference", html_decode(pref.sec_record)) as message|null, MAX_PAPER_MESSAGE_LEN, extra = 0)
		if(!isnull(sec_medical) && !jobban_isbanned(user, "Records") && CanUseTopic(user))
			pref.sec_record = sec_medical
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