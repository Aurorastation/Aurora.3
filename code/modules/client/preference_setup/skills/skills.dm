/datum/category_item/player_setup_item/skills
	name = "Skills"
	sort_order = 1

/datum/category_item/player_setup_item/skills/load_character(var/savefile/S)
	S["culture"]    		>> pref.education
	//todomatt

/datum/category_item/player_setup_item/skills/save_character(var/savefile/S)
	S["culture"]    		<< pref.skills

/datum/category_item/player_setup_item/skills/gather_load_query()
	return list(
		"ss13_characters" = list(
			"vars" = list(
				"skills"
			),
			"args" = list("id")
		)
	)

/datum/category_item/player_setup_item/skills/gather_load_parameters()
	return list("id" = pref.current_character)

/datum/category_item/player_setup_item/skills/gather_save_query()
	return list(
		"ss13_characters" = list(
			"skills",
			"id" = 1,
			"ckey" = 1
		)
	)

/datum/category_item/player_setup_item/skills/gather_save_parameters()
	return list(
		"skills" = pref.culture,
		"id" = pref.current_character,
		"ckey" = PREF_CLIENT_CKEY
	)


/datum/category_item/player_setup_item/skills/sanitize_character(var/sql_load = 0)
	//todomatt

/datum/category_item/player_setup_item/skills/content(var/mob/user)
	var/list/dat = list()
	dat += "skills n shit"
	. = dat.Join()

/datum/category_item/player_setup_item/skills/OnTopic(href, href_list, user)
	//todomatt
	return ..()
