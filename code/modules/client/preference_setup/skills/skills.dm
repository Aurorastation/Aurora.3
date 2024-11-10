/datum/category_item/player_setup_item/skills
	name = "Skills"
	sort_order = 1

/datum/category_item/player_setup_item/skills/load_character(var/savefile/S)
	S["skills"]    		>> pref.skills

/datum/category_item/player_setup_item/skills/save_character(var/savefile/S)
	S["skills"]    		<< pref.skills

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
	var/list/sanitized_skills = list()
	for(var/S in pref.skills)
		var/singleton/skill/skill = GET_SINGLETON(text2path(S))
		if(!istype(skill))
			continue
		sanitized_skills[skill.type] = pref.skills[S]

	return list(
		"skills" = json_encode(sanitized_skills),
		"id" = pref.current_character,
		"ckey" = PREF_CLIENT_CKEY
	)

/datum/category_item/player_setup_item/skills/load_character_special(savefile/S)
	if(!pref.skills)
		pref.skills = "{}"

	var/before = pref.skills
	try
		pref.skills = json_decode(pref.skills)
	catch (var/exception/e)
		log_debug("SKILLS: Caught [e]. Initial value: [before]")
		pref.skills = list()

/datum/category_item/player_setup_item/skills/sanitize_character(var/sql_load = 0)
	//todomatt

// Skills HTML UI lifted from Baystation 12. Credit goes to Afterthought12. Thank you for saving me from HTML hell!
/datum/category_item/player_setup_item/skills/content(var/mob/user)
	if(!SSskills.initialized)
		return "<center><large>Skills not initialized yet. Please wait a bit and reload this section.</large></center>"

	var/list/dat = list()

	dat += "<body>"
	dat += "<style>.Selectable,.Current,.Unavailable,.Toohigh,.Forced{border: 1px solid #161616;padding: 1px 4px 1px 4px;margin: 0 2px 0 0}</style>"
	dat += "<style>.Forced,a.Forced{background: #FF0000}</style>"
	dat += "<style>.Selectable,a.Selectable{background: #40628a}</style>"
	dat += "<style>.Current,a.Current{background: #2f943c}</style>"
	dat += "<style>.Unavailable{background: #d09000}</style>"

	dat += "<table>"
	var/singleton/education/education = GET_SINGLETON(text2path(pref.education))
	for(var/category in SSskills.skill_tree)
		var/singleton/skill_category/skill_category = category
		dat += "<tr><th colspan = 4><b>[skill_category.name] (X points remaining)</b>"
		dat += "</th></tr>"
		for(var/subcategory in SSskills.skill_tree[skill_category])
			dat += "<tr><th colspan = 3><b>[subcategory]</b></th></tr>"
			for(var/singleton/skill/skill in SSskills.skill_tree[skill_category][subcategory])
				dat += get_skill_row(skill, education)
	dat += "</table>"

	. = JOINTEXT(dat)

/datum/category_item/player_setup_item/skills/proc/get_skill_row(singleton/skill/skill, singleton/education/education)
	var/list/dat = list()
	dat += "<tr style='text-align:left;'>"
	dat += "<th><a href='?src=\ref[src];skillinfo=[skill.type]'>[skill.name]</a></th>"

	var/current_level = pref.skills[skill.type]
	var/maximum_skill_level = skill.get_maximum_level(education)
	for(var/i = SKILL_LEVEL_UNFAMILIAR, i <= SKILL_LEVEL_PROFESSIONAL, i++)
		dat += skill_to_button(skill, education, current_level, i, maximum_skill_level)

	return JOINTEXT(dat)

/datum/category_item/player_setup_item/skills/proc/skill_to_button(singleton/skill/skill, singleton/education/education, current_level, selection_level, maximum_skill_level)
	var/effective_level = selection_level
	if(effective_level <= 0)
		return "<th></th>"

	var/level_name = SSskills.skill_level_map[effective_level]
	var/cost = "N" //skill.get_cost(effective_level)
	var/button_label = "[level_name] ([cost])"
	var/given_skill = FALSE

	// Prevent removal of skills given by education. These are meant to be minimum skills for jobs, after all.
	if(skill.type in education.skills)
		given_skill = TRUE

	if((effective_level < current_level) && given_skill)
		return "<th>[span("Forced", "[button_label]")]</th>"
	else if((effective_level < current_level) && !given_skill)
		return "<th>[add_link(skill, education, button_label, "'Current'", effective_level)]</th>"
	else if(effective_level == current_level)
		return "<th>[span("Current", "[button_label]")]</th>"
	else if(effective_level <= maximum_skill_level)
		return "<th>[add_link(skill, education, button_label, "'Selectable'", effective_level)]</th>"
	else
		return "<th>[span("Toohigh", "[button_label]")]</th>"

/datum/category_item/player_setup_item/skills/proc/add_link(singleton/skill/skill, singleton/education/education, text, style, value)
	if(skill.get_maximum_level(education) >= value)
		return "<a class=[style] href='?src=\ref[src];setskill=[skill.type];newvalue=[value]'>[text]</a>"
	return text

/datum/category_item/player_setup_item/skills/OnTopic(href, href_list, user)
	if(href_list["skillinfo"])
		var/singleton/skill/skill_to_show = GET_SINGLETON(text2path(href_list["skillinfo"]))
		if(!skill_to_show)
			log_debug("SKILLS: Invalid skill selected for [user]: [skill_to_show]")
			return
		var/datum/browser/skill_window = new(user, "skill_info", "Skill Information")
		var/dat = "<html><center><b>[skill_to_show.name]</center></b>"
		dat += "<hr>[skill_to_show.description]<br>"
		if(skill_to_show.uneducated_skill_cap)
			dat += "Without the relevant education, you may only reach the <b>[SSskills.skill_level_map[skill_to_show.uneducated_skill_cap]]</b> level.<br>"
		dat += "</html>"
		skill_window.set_content(dat)
		skill_window.open()

	else if(href_list["setskill"])
		var/singleton/skill/new_skill = GET_SINGLETON(text2path(href_list["setskill"]))
		if(!new_skill)
			log_debug("SKILLS: Invalid skill selected for [user]: [new_skill]")
			return

		var/new_skill_value = text2num(href_list["newvalue"])
		if(new_skill_value == SKILL_LEVEL_UNFAMILIAR)
			pref.skills -= new_skill.type
		else
			pref.skills[new_skill.type] = text2num(new_skill_value)
		return TOPIC_REFRESH

	return ..()
