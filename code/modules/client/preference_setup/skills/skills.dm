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
	return list(
		"skills" = pref.skills,
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

/datum/category_item/player_setup_item/skills/content(var/mob/user)
	var/list/dat = list()
	var/singleton/education/education = GET_SINGLETON(text2path(pref.education))
	for(var/category in SSskills.skill_tree)
		var/singleton/skill_category/skill_category = category
		dat += "<b><font size=5>[skill_category.name]</font></b><br>"
		for(var/subcategory in SSskills.skill_tree[skill_category])
			dat += "<font size=4>[subcategory]</font><br><table><tr style='text-align:left;'>"
			for(var/singleton/skill/skill in SSskills.skill_tree[skill_category][subcategory])
				dat += "<tr><a href='?src=\ref[src];skillinfo=[skill.type]'>[skill.name]</a>: "
				var/current_skill_level = 0
				if(skill.type in pref.skills)
					current_skill_level = pref.skills[skill.type]
				for(var/skill_level in SKILL_LEVEL_UNFAMILIAR to skill.get_maximum_level(education))
					if(current_skill_level == skill_level)
						dat += "<b><a href='?src=\ref[src];setskill=[skill.type];newvalue=[skill_level]'><font color='green'>\[[SSskills.skill_level_map[skill_level]]\]</font></a></b>"
					if(current_skill_level > skill_level)
						dat += "<b><a href='?src=\ref[src];setskill=[skill.type];newvalue=[skill_level]'><font color='green'>[SSskills.skill_level_map[skill_level]]</font></a></b>"
					if(current_skill_level < skill_level)
						dat += "<a href='?src=\ref[src];setskill=[skill.type];newvalue=[skill_level]'><font color='red'>[SSskills.skill_level_map[skill_level]]</font></a>"
				dat += "</tr><br><br>"
		dat += "</table><hr>"
	. = dat.Join()

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
