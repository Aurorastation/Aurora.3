/datum/category_item/player_setup_item/general/background
	name = "Background"
	sort_order = 5

/datum/category_item/player_setup_item/general/background/load_character(var/savefile/S)
	S["med_record"]          >> pref.med_record
	S["sec_record"]          >> pref.sec_record
	S["gen_record"]          >> pref.gen_record
	S["citizenship"]         >> pref.citizenship
	S["religion"]            >> pref.religion
	S["nanotrasen_relation"] >> pref.nanotrasen_relation

/datum/category_item/player_setup_item/general/background/save_character(var/savefile/S)
	S["med_record"]          << pref.med_record
	S["sec_record"]          << pref.sec_record
	S["gen_record"]          << pref.gen_record
	S["citizenship"]         << pref.citizenship
	S["religion"]            << pref.religion
	S["nanotrasen_relation"] << pref.nanotrasen_relation

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
		),
		"ss13_characters" = list(
			"vars" = list(
				"nt_relation" = "nanotrasen_relation",
				"citizenship",
				"religion"
			),
			"args" = list("id")
		)
	)

/datum/category_item/player_setup_item/general/background/gather_load_parameters()
	return list(
		"id" = pref.current_character,
		"char_id" = pref.current_character
	)

/datum/category_item/player_setup_item/general/background/gather_save_query()
	return list(
		"ss13_characters_flavour" = list(
			"records_employment",
			"records_medical",
			"records_security",
			"char_id" = 1
		),
		"ss13_characters" = list(
			"nt_relation",
			"citizenship",
			"religion","id" = 1,
			"ckey" = 1
		)
	)

/datum/category_item/player_setup_item/general/background/gather_save_parameters()
	return list(
		"records_employment" = pref.gen_record,
		"records_medical" = pref.med_record,
		"records_security" = pref.sec_record,
		"char_id" = pref.current_character,
		"nt_relation" = pref.nanotrasen_relation,
		"citizenship" = pref.citizenship,
		"religion" = pref.religion,
		"id" = pref.current_character,
		"ckey" = PREF_CLIENT_CKEY
	)

/datum/category_item/player_setup_item/general/background/sanitize_character()
	var/datum/species/S = all_species[pref.species]
	if(!pref.citizenship)
		pref.citizenship	= S.default_citizenship
	if(!pref.religion)
		pref.religion		= RELIGION_NONE

	if(!(pref.citizenship in S.allowed_citizenships))
		pref.citizenship	= S.default_citizenship

	if(!(pref.religion in S.allowed_religions))
		pref.religion	= RELIGION_NONE

	pref.nanotrasen_relation = sanitize_inlist(pref.nanotrasen_relation, COMPANY_ALIGNMENTS, initial(pref.nanotrasen_relation))

/datum/category_item/player_setup_item/general/background/content(var/mob/user)
	var/list/dat = list(
		"<b>Background Information</b><br>",
		"[current_map.company_name] Relation: <a href='?src=\ref[src];nt_relation=1'>[pref.nanotrasen_relation]</a><br/>",
		"Citizenship: <a href='?src=\ref[src];citizenship=1'>[pref.citizenship]</a><br/>",
		"Religion: <a href='?src=\ref[src];religion=1'>[pref.religion]</a><br/>",
		"<br/><b>Records</b>:<br/>"
	)

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
	var/datum/species/S = all_species[pref.species]
	if(href_list["nt_relation"])
		var/new_relation = input(user, "Choose your relation to NT. Note that this represents what others can find out about your character by researching your background, not what your character actually thinks.", "Character Preference", pref.nanotrasen_relation)  as null|anything in COMPANY_ALIGNMENTS
		if(new_relation && CanUseTopic(user))
			pref.nanotrasen_relation = new_relation
			return TOPIC_REFRESH

	else if(href_list["citizenship"])
		var/choice = input(user, "Please choose your current citizenship.", "Character Preference", pref.citizenship) as null|anything in S.allowed_citizenships
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		show_citizenship_menu(user, choice)
		return TOPIC_REFRESH

	else if(href_list["set_citizenship"])
		pref.citizenship = (html_decode(href_list["set_citizenship"]))
		sanitize_character()
		return TOPIC_REFRESH

	else if(href_list["religion"])
		var/choice = input(user, "Please choose a religion.", "Character Preference", pref.religion) as null|anything in S.allowed_religions
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		show_religion_menu(user, choice)
		return TOPIC_REFRESH

	else if(href_list["set_religion"])
		pref.religion = (html_decode(href_list["set_religion"]))
		sanitize_character()
		return TOPIC_REFRESH

	else if(href_list["set_medical_records"])
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

/datum/category_item/player_setup_item/general/background/proc/show_citizenship_menu(mob/user, selected_citizenship)
	var/datum/citizenship/citizenship = SSrecords.citizenships[selected_citizenship]

	if(citizenship)

		var/list/dat = list("<center><b>[citizenship.name]</center></b>")
		dat += "<br><br><center><a href='?src=\ref[user.client];JSlink=wiki;wiki_page=[replacetext(citizenship.name, " ", "_")]'>Read the Wiki</a></center>"
		dat += "<br>[citizenship.description]"
		dat += "<br><center>\[<a href='?src=\ref[src];set_citizenship=[html_encode(citizenship.name)]'>Select</a>\]</center>"
		show_browser(user, dat.Join(), "window=citizenshippreview;size=400x500")

/datum/category_item/player_setup_item/general/background/proc/show_religion_menu(mob/user, selected_religion)
	var/datum/religion/religion = SSrecords.religions[selected_religion]

	if(religion)
		var/list/dat = list("<center><b>[religion.name]</center></b>")
		dat += "<br>[religion.description]"
		dat += "<br><center>\[<a href='?src=\ref[src];set_religion=[html_encode(religion.name)]'>Select</a>\]</center>"
		show_browser(user, dat.Join(), "window=religionpreview;size=400x500")