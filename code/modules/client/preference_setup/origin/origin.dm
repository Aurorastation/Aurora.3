/datum/category_item/player_setup_item/origin
	name = "Origin"
	sort_order = 1

/datum/category_item/player_setup_item/origin/load_character(var/savefile/S)
	S["culture"]    >> pref.culture
	S["origin"]     >> pref.origin

/datum/category_item/player_setup_item/origin/save_character(var/savefile/S)
	S["culture"]    << pref.culture
	S["origin"]     << pref.origin

/datum/category_item/player_setup_item/origin/gather_load_query()
	return list(
		"ss13_characters" = list(
			"vars" = list(
				"culture",
				"origin"
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
			"id" = 1,
			"ckey" = 1
		)
	)

/datum/category_item/player_setup_item/origin/gather_save_parameters()
	return list(
		"culture" = pref.culture,
		"origin" = pref.origin,
		"id" = pref.current_character,
		"ckey" = PREF_CLIENT_CKEY
	)

/datum/category_item/player_setup_item/origin/sanitize_character(var/sql_load = 0)
	var/datum/species/S = all_species[pref.species]
	pref.culture = S.get_culture()
	pref.origin = S.get_origin(pref.culture)
	pref.accent = S.get_accent(pref.origin)
	pref.citizenship = S.get_citizenship(pref.origin)
	pref.religion = S.get_religion(pref.origin)

/datum/category_item/player_setup_item/origin/content(var/mob/user)
	var/list/dat = list()
	var/decl/origin_item/culture/CL = decls_repository.get_decl(pref.culture)
	var/decl/origin_item/origin/OR = decls_repository.get_decl(pref.origin)
	dat += "<b>Culture: </b><a href='?src=\ref[src];open_culture_menu=1'>[CL.name]</a><br>"
	dat += "<b>Origin: </b><a href='?src=\ref[src];open_origin_menu=1'>[OR.name]</a>"
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
		var/decl/origin_item/culture/our_culture = decls_repository.get_decl(pref.culture) //it's our culture comrade
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

/datum/category_item/player_setup_item/origin/proc/show_window(var/decl/origin_item/OI, var/topic_data, var/mob/user)
	var/list/dat = list("<center><b>[OI.name]</center></b>")
	dat += "<br>[OI.desc]"
	dat += "<br><center>\[<a href='?src=\ref[src];[topic_data]=[html_encode(OI.type)]'>Select</a>\]</center>"
	show_browser(user, dat.Join(), "window=originpreview;size=400x500")