/datum/category_item/player_setup_item/origin
	name = "Origin"
	sort_order = 1

/datum/category_item/player_setup_item/origin/load_character(var/savefile/S)
	S["culture"]    		>> pref.culture
	S["origin"]     		>> pref.origin
	S["citizenship"]		>> pref.citizenship
	S["religion"]			>> pref.religion
	S["accent"]				>> pref.accent
	S["economic_status"] 	>> pref.economic_status

/datum/category_item/player_setup_item/origin/save_character(var/savefile/S)
	S["culture"]			<< pref.culture
	S["origin"]				<< pref.origin
	S["citizenship"]		<< pref.citizenship
	S["religion"]			<< pref.religion
	S["accent"]				<< pref.accent
	S["economic_status"]	<< pref.economic_status

/datum/category_item/player_setup_item/origin/gather_load_query()
	return list(
		"ss13_characters" = list(
			"vars" = list(
				"culture",
				"origin",
				"economic_status",
				"citizenship",
				"religion",
				"accent"
			),
			"args" = list("id")
		)
	)

/datum/category_item/player_setup_item/origin/gather_load_parameters()
	return list("id" = pref.current_character)

/datum/category_item/player_setup_item/origin/gather_save_query()
	return list(
		"ss13_characters" = list(
			"culture",
			"origin",
			"economic_status",
			"citizenship",
			"religion",
			"accent",
			"id" = 1,
			"ckey" = 1
		)
	)

/datum/category_item/player_setup_item/origin/gather_save_parameters()
	return list(
		"culture" = pref.culture,
		"origin" = pref.origin,
		"economic_status" = pref.economic_status,
		"citizenship" = pref.citizenship,
		"religion" = pref.religion,
		"accent" = pref.accent,
		"id" = pref.current_character,
		"ckey" = PREF_CLIENT_CKEY
	)

/datum/category_item/player_setup_item/origin/sanitize_character(var/sql_load = 0)
	var/datum/species/S = GLOB.all_species[pref.species]
	if(!istext(pref.culture) || !ispath(text2path(pref.culture), /singleton/origin_item/culture))
		var/singleton/origin_item/culture/CI = S.possible_cultures[1]
		pref.culture = "[CI.type]"

	var/singleton/origin_item/culture/our_culture = GET_SINGLETON(text2path(pref.culture))
	if(!istext(pref.origin) || !ispath(text2path(pref.origin), /singleton/origin_item/origin))
		var/singleton/origin_item/origin/OI = pick(our_culture.possible_origins)
		pref.origin = "[OI.type]"
	else
		var/singleton/origin_item/origin/origin_check = text2path(pref.origin)
		if(!(origin_check in our_culture.possible_origins))
			to_client_chat(SPAN_WARNING("Your origin has been reset due to it being incompatible with your culture!"))
			var/singleton/origin_item/origin/OI = pick(our_culture.possible_origins)
			pref.origin = "[OI.type]"

	var/singleton/origin_item/origin/our_origin = GET_SINGLETON(text2path(pref.origin))
	if(!(pref.citizenship in our_origin.possible_citizenships))
		to_client_chat(SPAN_WARNING("Your previous citizenship is invalid for this origin! Resetting."))
		pref.citizenship = our_origin.possible_citizenships[1]

	if(!(pref.religion in our_origin.possible_religions))
		to_client_chat(SPAN_WARNING("Your previous religion is invalid for this origin! Resetting."))
		pref.religion = our_origin.possible_religions[1]

	if(!(pref.accent in our_origin.possible_accents))
		to_client_chat(SPAN_WARNING("Your previous accent is invalid for this origin! Resetting."))
		pref.accent	= our_origin.possible_accents[1]

	pref.economic_status = sanitize_inlist(pref.economic_status, ECONOMIC_POSITIONS, initial(pref.economic_status))

/datum/category_item/player_setup_item/origin/ui_data(var/mob/user)
	if(!SSrecords.initialized)
		return list(
			"kind" = "notice",
			"name" = name,
			"ref" = REF(src),
			"message" = "Records controller not initialized yet. Please wait a bit and reload this section."
		)
	var/singleton/origin_item/culture/CL = GET_SINGLETON(text2path(pref.culture))
	var/singleton/origin_item/origin/OR = GET_SINGLETON(text2path(pref.origin))
	var/culture_description = CL.desc
	if(length(CL.origin_traits_descriptions))
		culture_description += " Characters from this culture [english_list(CL.origin_traits_descriptions)]."
	var/origin_description = OR.desc
	if(length(OR.origin_traits_descriptions))
		origin_description += " Characters from this origin [english_list(OR.origin_traits_descriptions)]."
	return list(
		"kind" = "form",
		"name" = name,
		"ref" = REF(src),
		"sections" = list(
			list(
				"title" = "Culture",
				"description" = culture_description,
				"description_html" = TRUE,
				"warning" = CL.important_information,
				"warning_html" = TRUE,
				"fields" = list(list("label" = "Selected Culture", "value" = CL.name, "action" = "open_culture_menu"))
			),
			list(
				"title" = "Origin",
				"description" = origin_description,
				"description_html" = TRUE,
				"warning" = OR.important_information,
				"warning_html" = TRUE,
				"fields" = list(list("label" = "Selected Origin", "value" = OR.name, "action" = "open_origin_menu"))
			),
			list(
				"title" = "Identity",
				"fields" = list(
					list("label" = "Economic Status", "value" = pref.economic_status, "action" = "economic_status"),
					list("label" = "Citizenship", "value" = pref.citizenship, "action" = "citizenship"),
					list("label" = "Religion", "value" = pref.religion, "action" = "religion"),
					list("label" = "Accent", "value" = pref.accent, "action" = "accent")
				)
			)
		)
	)

/datum/category_item/player_setup_item/origin/OnTopic(href, href_list, user)
	var/datum/species/S = GLOB.all_species[pref.species]
	if(href_list["open_culture_menu"])
		var/list/options = list()
		var/list/possible_cultures = GLOB.Singletons.GetMap(S.possible_cultures)
		for(var/decl_type in possible_cultures)
			var/singleton/origin_item/culture/CL = possible_cultures[decl_type]
			options[CL.name] = CL
		var/result = tgui_input_list(user, "Choose your character's culture.", "Culture", options)
		var/singleton/origin_item/culture/chosen_culture = options[result]
		if(chosen_culture)
			var/culture_summary = html_decode(strip_html(chosen_culture.desc))
			if(chosen_culture.important_information)
				culture_summary += "\n\nImportant: [html_decode(strip_html(chosen_culture.important_information))]"
			if(tgui_alert(user, culture_summary, chosen_culture.name, list("Select", "Cancel")) != "Select")
				return TOPIC_NOACTION
			pref.culture = "[chosen_culture.type]"
			sanitize_character()
			return TOPIC_REFRESH
		return TOPIC_NOACTION

	if(href_list["open_origin_menu"])
		var/list/options = list()
		var/singleton/origin_item/culture/our_culture = GET_SINGLETON(text2path(pref.culture)) //plutonians be like
		var/list/singleton/origin_item/origin/origins_list = GLOB.Singletons.GetMap(our_culture.possible_origins)
		for(var/decl_type in origins_list)
			var/singleton/origin_item/origin/OR = origins_list[decl_type]
			options[OR.name] = OR
		var/result = tgui_input_list(user, "Choose your character's origin.", "Origins", options)
		var/singleton/origin_item/origin/chosen_origin = options[result]
		if(chosen_origin)
			var/origin_summary = html_decode(strip_html(chosen_origin.desc))
			if(chosen_origin.important_information)
				origin_summary += "\n\nImportant: [html_decode(strip_html(chosen_origin.important_information))]"
			if(tgui_alert(user, origin_summary, chosen_origin.name, list("Select", "Cancel")) != "Select")
				return TOPIC_NOACTION
			pref.origin = "[chosen_origin.type]"
			sanitize_character()
			return TOPIC_REFRESH
		return TOPIC_NOACTION

	if(href_list["economic_status"])
		var/new_status = tgui_input_list(user, "Choose how wealthy your character is. Note that this applies a multiplier to a value that is also affected by your species and job.", "Character Preference", ECONOMIC_POSITIONS, pref.economic_status)
		if(new_status && CanUseTopic(user))
			pref.economic_status = new_status
			return TOPIC_REFRESH

	if(href_list["citizenship"])
		var/singleton/origin_item/origin/our_origin = GET_SINGLETON(text2path(pref.origin))
		var/choice = tgui_input_list(user, "Please choose your current citizenship.", "Character Preference", our_origin.possible_citizenships, pref.citizenship)
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		var/datum/citizenship/citizenship_data = SSrecords.citizenships[choice]
		if(citizenship_data && tgui_alert(user, html_decode(strip_html(citizenship_data.description)), citizenship_data.name, list("Select", "Cancel")) != "Select")
			return TOPIC_NOACTION
		pref.citizenship = choice
		sanitize_character()
		return TOPIC_REFRESH

	if(href_list["religion"])
		var/singleton/origin_item/origin/our_origin = GET_SINGLETON(text2path(pref.origin))
		var/choice = tgui_input_list(user, "Please choose a religion.", "Character Preference", our_origin.possible_religions, pref.religion)
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		var/datum/religion/religion_data = SSrecords.religions[choice]
		if(religion_data && tgui_alert(user, html_decode(strip_html(religion_data.description)), religion_data.name, list("Select", "Cancel")) != "Select")
			return TOPIC_NOACTION
		pref.religion = choice
		sanitize_character()
		return TOPIC_REFRESH

	if(href_list["accent"])
		var/singleton/origin_item/origin/our_origin = GET_SINGLETON(text2path(pref.origin))
		var/choice = tgui_input_list(user, "Please choose an accent.", "Character Preference", our_origin.possible_accents, pref.accent)
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		var/datum/accent/accent_data = SSrecords.accents[choice]
		if(accent_data && tgui_alert(user, html_decode(strip_html(accent_data.description)), accent_data.name, list("Select", "Cancel")) != "Select")
			return TOPIC_NOACTION
		pref.accent = choice
		sanitize_character()
		return TOPIC_REFRESH
