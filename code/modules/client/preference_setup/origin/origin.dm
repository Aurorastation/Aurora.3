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

//Probably need to convert this to use text instead of types for culture stuff.
//Maybe turn accents/religion/citizenship into decls?
/datum/category_item/player_setup_item/origin/sanitize_character(var/sql_load = 0)
	var/datum/species/S = all_species[pref.species]
	pref.culture = S.get_default_culture()
	pref.origin = S.get_default_origin(pref.culture)
	if(!pref.citizenship)
		pref.citizenship = S.default_citizenship
	if(!pref.religion)
		pref.religion = RELIGION_NONE
	if(!(pref.citizenship in S.allowed_citizenships))
		pref.citizenship = S.default_citizenship
	if(!(pref.religion in S.allowed_religions))
		pref.religion = RELIGION_NONE
	if(!(pref.accent in S.allowed_accents))
		pref.accent	= S.default_accent
	pref.economic_status = sanitize_inlist(pref.economic_status, ECONOMIC_POSITIONS, initial(pref.economic_status))

/datum/category_item/player_setup_item/origin/content(var/mob/user)
	if(SSrecords.init_state != SS_INITSTATE_DONE)
		return "<center><large>Records controller not initialized yet. Please wait a bit and reload this section.</large></center>"
	var/list/dat = list()
	var/decl/origin_item/culture/CL = decls_repository.get_decl(pref.culture)
	var/decl/origin_item/origin/OR = decls_repository.get_decl(pref.origin)
	dat += "<b>Culture: </b><a href='?src=\ref[src];open_culture_menu=1'>[CL.name]</a><br>"
	dat += "<i>- [CL.desc]</i><hr>"
	dat += "<b>Origin: </b><a href='?src=\ref[src];open_origin_menu=1'>[OR.name]</a><br>"
	dat += "<i>- [OR.desc]</i><hr>"
	dat += "<b>Economic Status:</b> <a href='?src=\ref[src];economic_status=1'>[pref.economic_status]</a><br/>"
	dat += "<b>Citizenship:</b> <a href='?src=\ref[src];citizenship=1'>[pref.citizenship]</a><br/>"
	dat += "<b>Religion:</b> <a href='?src=\ref[src];religion=1'>[pref.religion]</a><br/>"
	dat += "<b>Accent:</b> <a href='?src=\ref[src];accent=1'>[pref.accent]</a><br/>"
	. = dat.Join()
	
/datum/category_item/player_setup_item/origin/OnTopic(href, href_list, user)
	var/datum/species/S = all_species[pref.species]
	if(href_list["open_culture_menu"])
		var/list/options = list()
		var/list/possible_cultures = decls_repository.get_decls(S.origins_data[TAG_CULTURE])
		for(var/decl_type in possible_cultures) //todomatt: delete this tag?
			var/decl/origin_item/culture/CL = possible_cultures[decl_type]
			options[CL.name] = CL
		var/result = input(user, "Choose your character's culture.", "Culture") as null|anything in options
		var/decl/origin_item/culture/chosen_culture = options[result]
		show_window(chosen_culture, "set_culture_data", user)
		return TOPIC_REFRESH

	if(href_list["open_origin_menu"])
		var/list/options = list()
		var/decl/origin_item/culture/our_culture = decls_repository.get_decl(pref.culture) //plutonians be like
		var/list/decl/origin_item/origin/origins_list = decls_repository.get_decls(our_culture.possible_origins)
		for(var/decl_type in origins_list)
			var/decl/origin_item/origin/OR = origins_list[decl_type]
			options[OR.name] = OR
		var/result = input(user, "Choose your character's origin.", "Origins") as null|anything in options
		var/decl/origin_item/origin/chosen_origin = options[result]
		show_window(chosen_origin, "set_origin_data", user)
		return TOPIC_REFRESH

	if(href_list["set_culture_data"])
		pref.culture = href_list["set_culture_data"]

	if(href_list["set_origin_data"])
		pref.origin = href_list["set_origin_data"]

	if(href_list["economic_status"])
		var/new_status = input(user, "Choose how wealthy your character is. Note that this applies a multiplier to a value that is also affected by your species and job.", "Character Preference", pref.economic_status)  as null|anything in ECONOMIC_POSITIONS
		if(new_status && CanUseTopic(user))
			pref.economic_status = new_status
			return TOPIC_REFRESH

	if(href_list["citizenship"])
		var/choice = input(user, "Please choose your current citizenship.", "Character Preference", pref.citizenship) as null|anything in S.allowed_citizenships
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		show_citizenship_menu(user, choice)
		return TOPIC_REFRESH

	if(href_list["set_citizenship"])
		pref.citizenship = (html_decode(href_list["set_citizenship"]))
		sanitize_character()
		return TOPIC_REFRESH

	if(href_list["religion"])
		var/choice = input(user, "Please choose a religion.", "Character Preference", pref.religion) as null|anything in S.allowed_religions
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		show_religion_menu(user, choice)
		return TOPIC_REFRESH

	if(href_list["set_religion"])
		pref.religion = (html_decode(href_list["set_religion"]))
		sanitize_character()
		return TOPIC_REFRESH

	if(href_list["accent"])
		var/choice = input(user, "Please choose an accent.", "Character Preference", pref.accent) as null|anything in S.allowed_accents
		if(!choice || !CanUseTopic(user))
			return TOPIC_NOACTION
		show_accent_menu(user, choice)
		return TOPIC_REFRESH

	if(href_list["set_accent"])
		pref.accent = (html_decode(href_list["set_accent"]))
		sanitize_character()
		return TOPIC_REFRESH

/datum/category_item/player_setup_item/origin/proc/show_window(var/decl/origin_item/OI, var/topic_data, var/mob/user)
	var/datum/browser/origin_win = new(user, topic_data, "Origins Selection")
	var/dat = "<html><center><b>[OI.name]</center></b>"
	dat += "<hr>[OI.desc]"
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