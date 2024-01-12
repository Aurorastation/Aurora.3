/mob/living/carbon/human
	var/singleton/origin_item/culture/culture
	var/singleton/origin_item/origin/origin

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
		pref.culture = "[CI]"
	var/singleton/origin_item/culture/our_culture = GET_SINGLETON(text2path(pref.culture))
	if(!istext(pref.origin) || !ispath(text2path(pref.origin), /singleton/origin_item/origin))
		var/singleton/origin_item/origin/OI = pick(our_culture.possible_origins)
		pref.origin = "[OI]"
	else
		var/singleton/origin_item/origin/origin_check = text2path(pref.origin)
		if(!(origin_check in our_culture.possible_origins))
			to_client_chat(SPAN_WARNING("Your origin has been reset due to it being incompatible with your culture!"))
			var/singleton/origin_item/origin/OI = pick(our_culture.possible_origins)
			pref.origin = "[OI]"
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

/datum/category_item/player_setup_item/origin/content(var/mob/user)
	if(!SSrecords.initialized)
		return "<center><large>Records controller not initialized yet. Please wait a bit and reload this section.</large></center>"
	var/list/dat = list()
	var/singleton/origin_item/culture/CL = GET_SINGLETON(text2path(pref.culture))
	var/singleton/origin_item/origin/OR = GET_SINGLETON(text2path(pref.origin))
	dat += "<b>Culture: </b><a href='?src=\ref[src];open_culture_menu=1'>[CL.name]</a><br>"
	dat += "<i>- [CL.desc]</i><br><br>"
	if(length(CL.origin_traits_descriptions))
		dat += "- Characters from this culture "
		dat += "<b>[english_list(CL.origin_traits_descriptions)]</b>."
	if(CL.important_information)
		dat += "<br><i>- <font color=red>[CL.important_information]</font></i>"
	dat += "<hr><b>Origin: </b><a href='?src=\ref[src];open_origin_menu=1'>[OR.name]</a><br>"
	dat += "<i>- [OR.desc]</i><br>"
	if(length(OR.origin_traits_descriptions))
		dat += "- Characters from this origin "
		dat += "<b>[english_list(OR.origin_traits_descriptions)]</b>."
	if(OR.important_information)
		dat += "<br><i>- <font color=red>[OR.important_information]</font></i>"
	dat += "<hr>"
	dat += "<b>Economic Status:</b> <a href='?src=\ref[src];economic_status=1'>[pref.economic_status]</a><br/>"
	dat += "<b>Citizenship:</b> <a href='?src=\ref[src];citizenship=1'>[pref.citizenship]</a><br/>"
	dat += "<b>Religion:</b> <a href='?src=\ref[src];religion=1'>[pref.religion]</a><br/>"
	dat += "<b>Accent:</b> <a href='?src=\ref[src];accent=1'>[pref.accent]</a><br/>"
	. = dat.Join()

/datum/category_item/player_setup_item/origin/OnTopic(href, href_list, user)
	var/datum/species/S = GLOB.all_species[pref.species]
	if(href_list["open_culture_menu"])
		var/list/options = list()
		var/list/possible_cultures = Singletons.GetMap(S.possible_cultures)
		for(var/decl_type in possible_cultures)
			var/singleton/origin_item/culture/CL = possible_cultures[decl_type]
			options[CL.name] = CL
		var/result = tgui_input_list(user, "Choose your character's culture.", "Culture", options)
		var/singleton/origin_item/culture/chosen_culture = options[result]
		if(chosen_culture)
			show_window(chosen_culture, "set_culture_data", user)
		return TOPIC_HANDLED

	if(href_list["open_origin_menu"])
		var/list/options = list()
		var/singleton/origin_item/culture/our_culture = GET_SINGLETON(text2path(pref.culture)) //plutonians be like
		var/list/singleton/origin_item/origin/origins_list = Singletons.GetMap(our_culture.possible_origins)
		for(var/decl_type in origins_list)
			var/singleton/origin_item/origin/OR = origins_list[decl_type]
			options[OR.name] = OR
		var/result = tgui_input_list(user, "Choose your character's origin.", "Origins", options)
		var/singleton/origin_item/origin/chosen_origin = options[result]
		if(chosen_origin)
			show_window(chosen_origin, "set_origin_data", user)
		return TOPIC_HANDLED

	if(href_list["set_culture_data"])
		user << browse(null, "window=set_culture_data")
		pref.culture = html_decode(href_list["set_culture_data"])
		sanitize_character()
		return TOPIC_REFRESH

	if(href_list["set_origin_data"])
		user << browse(null, "window=set_origin_data")
		pref.origin = html_decode(href_list["set_origin_data"])
		sanitize_character()
		return TOPIC_REFRESH

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
		show_citizenship_menu(user, choice)
		return TOPIC_HANDLED

	if(href_list["set_citizenship"])
		user << browse(null, "window=citizen_win")
		pref.citizenship = (html_decode(href_list["set_citizenship"]))
		sanitize_character()
		return TOPIC_REFRESH

	if(href_list["religion"])
		var/singleton/origin_item/origin/our_origin = GET_SINGLETON(text2path(pref.origin))
		var/choice = tgui_input_list(user, "Please choose a religion.", "Character Preference", our_origin.possible_religions, pref.religion)
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		show_religion_menu(user, choice)
		return TOPIC_HANDLED

	if(href_list["set_religion"])
		user << browse(null, "window=rel_win")
		pref.religion = (html_decode(href_list["set_religion"]))
		sanitize_character()
		return TOPIC_REFRESH

	if(href_list["accent"])
		var/singleton/origin_item/origin/our_origin = GET_SINGLETON(text2path(pref.origin))
		var/choice = tgui_input_list(user, "Please choose an accent.", "Character Preference", our_origin.possible_accents, pref.accent)
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		show_accent_menu(user, choice)
		return TOPIC_HANDLED

	if(href_list["set_accent"])
		user << browse(null, "window=acc_win")
		pref.accent = (html_decode(href_list["set_accent"]))
		sanitize_character()
		return TOPIC_REFRESH

/datum/category_item/player_setup_item/origin/proc/show_window(var/singleton/origin_item/OI, var/topic_data, var/mob/user)
	var/datum/browser/origin_win = new(user, topic_data, "Origins Selection")
	var/dat = "<html><center><b>[OI.name]</center></b>"
	dat += "<hr>[OI.desc]<br>"
	if(OI.important_information)
		dat += "<font color=red><i>[OI.important_information]</i></font>"
	dat += "<br><center>\[<a href='?src=\ref[src];[topic_data]=[html_encode(OI.type)]'>Select</a>\]</center>"
	dat += "</html>"
	origin_win.set_content(dat)
	origin_win.open()

/datum/category_item/player_setup_item/origin/proc/show_citizenship_menu(mob/user, selected_citizenship)
	var/datum/citizenship/citizenship = SSrecords.citizenships[selected_citizenship]
	if(citizenship)
		var/datum/browser/citizen_win = new(user, "citizen_win", "Citizenship")
		var/dat = "<html><center><b>[citizenship.name]</center></b>"
		dat += "<br><br><center><a href='?src=\ref[user.client];JSlink=wiki;wiki_page=[replacetext(citizenship.name, " ", "_")]'>Read the Wiki</a></center>"
		dat += "<br>[citizenship.description]"
		dat += "<br><center>\[<a href='?src=\ref[src];set_citizenship=[html_encode(citizenship.name)]'>Select</a>\]</center>"
		dat += "</html>"
		citizen_win.set_content(dat)
		citizen_win.open()

/datum/category_item/player_setup_item/origin/proc/show_religion_menu(mob/user, selected_religion)
	var/datum/religion/religion = SSrecords.religions[selected_religion]
	if(religion)
		var/datum/browser/rel_win = new(user, "rel_win", "Religion")
		var/dat = "<center><b>[religion.name]</center></b>"
		dat += "<br>[religion.description]"
		dat += "<br><center>\[<a href='?src=\ref[src];set_religion=[html_encode(religion.name)]'>Select</a>\]</center>"
		dat += "</html>"
		rel_win.set_content(dat)
		rel_win.open()

/datum/category_item/player_setup_item/origin/proc/show_accent_menu(mob/user, selected_accent)
	var/datum/accent/accent = SSrecords.accents[selected_accent]
	if(accent)
		var/datum/browser/acc_win = new(user, "acc_win", "Accent")
		var/dat = "<html><center><b>[accent.name]</center></b>"
		dat += "<br>[accent.description]"
		dat += "<br><center>\[<a href='?src=\ref[src];set_accent=[html_encode(accent.name)]'>Select</a>\]</center>"
		dat += "</html>"
		acc_win.set_content(dat)
		acc_win.open()
