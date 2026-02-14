/datum/category_item/player_setup_item/skills
	name = "Skills"
	sort_order = 1

/datum/category_item/player_setup_item/skills/load_character(var/savefile/S)
	S["skills"]    		>> pref.skills
	S["education"]		>> pref.education

/datum/category_item/player_setup_item/skills/save_character(var/savefile/S)
	S["skills"]    		<< pref.skills
	S["education"]		<< pref.education

/datum/category_item/player_setup_item/skills/gather_load_query()
	return list(
		"ss13_characters" = list(
			"vars" = list(
				"education",
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
			"education",
			"skills",
			"id" = 1,
			"ckey" = 1
		)
	)

/datum/category_item/player_setup_item/skills/gather_save_parameters()
	var/list/sanitized_skills = list()
	for(var/S in pref.skills)
		var/singleton/skill/skill = GET_SINGLETON(S)
		if(!istype(skill))
			continue
		sanitized_skills[skill.type] = pref.skills[S]

	return list(
		"education" = pref.education,
		"skills" = json_encode(sanitized_skills),
		"id" = pref.current_character,
		"ckey" = PREF_CLIENT_CKEY
	)

/datum/category_item/player_setup_item/skills/load_character_special(savefile/S)
	if(!pref.skills)
		pref.skills = "{}"

	var/before = pref.skills
	var/loaded_skills
	try
		loaded_skills = pref.skills
	catch (var/exception/e)
		log_debug("SKILLS: Caught [e]. Initial value: [before]")
		pref.skills = list()

	pref.skills = list()
	for(var/key in SSskills.required_skills)
		var/singleton/skill/skill = GET_SINGLETON(key)
		if (istype(skill))
			pref.skills[skill.type] = SKILL_LEVEL_UNFAMILIAR

	for(var/key,value in loaded_skills)
		var/singleton/skill/skill = GET_SINGLETON(key)
		if(istype(skill))
			pref.skills[skill.type] = value

/datum/category_item/player_setup_item/skills/sanitize_character(var/sql_load = 0)
	//todomatt
	if(!istext(pref.education) || !ispath(text2path(pref.education), /singleton/education))
		var/singleton/education/ED = find_suitable_education()
		if(ED)
			pref.education = "[ED.type]"
	else
		var/singleton/education/our_education = GET_SINGLETON(text2path(pref.education))
		if(length(our_education.species_restriction))
			if(pref.species in our_education.species_restriction)
				var/singleton/education/ED = find_suitable_education()
				if(ED)
					pref.education = "[ED.type]"
		if(length(our_education.minimum_character_age))
			if(pref.species in our_education.minimum_character_age)
				if(pref.age < our_education.minimum_character_age[pref.species])
					var/singleton/education/ED = find_suitable_education()
					if(ED)
						pref.education = "[ED.type]"

// Skills HTML UI, along with a lot of other components here, lifted from Baystation 12. Credit goes to Afterthought12. Thank you for saving me from HTML hell!
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
	var/singleton/education/ED = GET_SINGLETON(text2path(pref.education))
	dat += "<center><b>Education:</b> <a href='?src=[REF(src)];open_education_menu=1'>[ED.name]</a></center><br/><hr>"
	dat += "<table>"
	var/singleton/education/education = GET_SINGLETON(text2path(pref.education))
	for(var/category in SSskills.skill_tree)
		var/singleton/skill_category/skill_category = category
		dat += "<tr><th colspan = 4><b>[skill_category.name] ([calculate_remaining_skill_points(skill_category)] points remaining)</b>"
		dat += "</th></tr>"
		for(var/subcategory in SSskills.skill_tree[skill_category])
			dat += "<tr><th colspan = 3><b>[subcategory]</b></th></tr>"
			for(var/singleton/skill/skill in SSskills.skill_tree[skill_category][subcategory])
				dat += get_skill_row(skill, education)
	dat += "</table>"

	. = JOINTEXT(dat)

/**
 * Returns an HTML skill row.
 */
/datum/category_item/player_setup_item/skills/proc/get_skill_row(singleton/skill/skill, singleton/education/education)
	var/list/dat = list()
	dat += "<tr style='text-align:left;'>"
	dat += "<th><a href='?src=[REF(src)];skillinfo=[skill.type]'>[skill.name]</a></th>"

	var/level_from_pref = pref.skills[skill.type]
	var/current_level = level_from_pref ? level_from_pref : SKILL_LEVEL_UNFAMILIAR
	var/maximum_skill_level = get_maximum_skill_level(skill, education)

	for(var/i = SKILL_LEVEL_UNFAMILIAR, i <= skill.maximum_level, i++)
		dat += skill_to_button(skill, education, current_level, i, maximum_skill_level)

	return JOINTEXT(dat)

/datum/category_item/player_setup_item/skills/proc/get_maximum_skill_level(singleton/skill/skill, singleton/education/education)
	var/base_maximum_level = skill.get_maximum_level(education)
	var/remaining_skill_points = calculate_remaining_skill_points(GET_SINGLETON(skill.category))

	for(var/skill_level = 0 to base_maximum_level)
		. = skill_level

		var/skill_cost = skill.get_cost(skill_level + 1)
		if(skill_cost > remaining_skill_points)
			break

		skill_level++
		remaining_skill_points -= skill_cost

/**
 * Turns a skill into a dynamic button.
 */
/datum/category_item/player_setup_item/skills/proc/skill_to_button(singleton/skill/skill, singleton/education/education, current_level, selection_level, maximum_skill_level)
	var/effective_level = selection_level
	if(effective_level <= 0)
		return "<th></th>"

	var/level_name = skill.skill_level_map[effective_level]
	var/cost = skill.get_cost(effective_level)
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

/**
 * Returns a button to set a skill in the skill UI.
 */
/datum/category_item/player_setup_item/skills/proc/add_link(singleton/skill/skill, singleton/education/education, text, style, value)
	if(skill.get_maximum_level(education) >= value)
		return "<a class=[style] href='?src=[REF(src)];setskill=[skill.type];newvalue=[value]'>[text]</a>"
	return text

/**
 * Returns the currently remaining skill points in a given category.
 */
/datum/category_item/player_setup_item/skills/proc/calculate_remaining_skill_points(singleton/skill_category/skill_category)
	if(!istype(skill_category))
		crash_with("Invalid skill category [skill_category] fed to calculate_remaining_skill_points!")

	var/skill_points_remaining = skill_category.calculate_skill_points(GLOB.all_species[pref.species], pref.age, GET_SINGLETON(text2path(pref.culture)), GET_SINGLETON(text2path(pref.origin)))
	var/current_points_used = get_used_skill_points_per_category(skill_category, GET_SINGLETON(text2path(pref.education)))
	return skill_points_remaining - current_points_used

/**
 * Returns the amount of used skill points in a certain skill category, ignoring skills given by education.
 */
/datum/category_item/player_setup_item/skills/proc/get_used_skill_points_per_category(singleton/skill_category/skill_category, singleton/education/education)
	if(!istype(skill_category))
		crash_with("Invalid skill category [skill_category] fed to get_used_skill_points_per_category!")

	if(!istype(education))
		crash_with("Invalid education [education] fed to get_used_skill_points_per_category!")

	. = 0
	for(var/skill_type in pref.skills)
		var/singleton/skill/skill = GET_SINGLETON(skill_type)
		if(skill.category != skill_category.type)
			continue

		if(skill.type in education.skills)
			continue

		. += skill.get_cost(pref.skills[skill.type])

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
			dat += "Without the relevant education, you may only reach the <b>[skill_to_show.skill_level_map[skill_to_show.uneducated_skill_cap]]</b> level.<br>"
		dat += "<hr>"
		var/skill_level = (skill_to_show.type in pref.skills) ? pref.skills[skill_to_show.type] : SKILL_LEVEL_UNFAMILIAR
		dat += "Your current level in this skill is [SPAN_BOLD(skill_to_show.skill_level_map[skill_level])].<br>"
		dat += SPAN_NOTICE("[skill_to_show.skill_level_descriptions[skill_level]]")
		dat += "</html>"
		skill_window.set_content(dat)
		skill_window.open()

	else if(href_list["setskill"])
		var/singleton/skill/new_skill = GET_SINGLETON(text2path(href_list["setskill"]))
		if(!new_skill)
			log_debug("SKILLS: Invalid skill selected for [user]: [new_skill]")
			return

		var/new_skill_value = text2num(href_list["newvalue"])
		pref.skills[new_skill.type] = text2num(new_skill_value)
		return TOPIC_REFRESH

	else if(href_list["open_education_menu"])
		var/list/options = list()
		var/list/singleton/education/education_list = GET_SINGLETON_SUBTYPE_MAP(/singleton/education)
		for(var/singleton_type in education_list)
			var/singleton/education/ED = education_list[singleton_type]
			if(length(ED.species_restriction))
				if(pref.species in ED.species_restriction)
					continue
			if(length(ED.minimum_character_age))
				if(pref.species in ED.minimum_character_age)
					if(pref.age < ED.minimum_character_age[pref.species])
						continue
			options[ED.name] = ED
		var/result = tgui_input_list(user, "Choose your character's education.", "Education", options)
		var/singleton/education/chosen_education = options[result]
		if(chosen_education)
			show_education_window(chosen_education, "set_education_data", user)

	else if(href_list["set_education_data"])
		user << browse(null, "window=set_education_data")
		var/new_education = html_decode(href_list["set_education_data"])
		pref.education = new_education

		pref.skills = list() // reset skills because we have to give them new minimums
		to_chat(user, SPAN_WARNING("Your skills have been reset as you changed your education."))
		var/singleton/education/education = GET_SINGLETON(text2path(new_education))
		if(istype(education))
			for(var/skill in education.skills)
				var/singleton/skill/new_skill = GET_SINGLETON(skill)
				pref.skills[new_skill.type] = education.skills[new_skill.type]
				to_chat(user, SPAN_NOTICE("Added the [new_skill.name] skill at level [new_skill.skill_level_map[education.skills[new_skill.type]]]."))

		sanitize_character()
		return TOPIC_REFRESH

	return ..()

/**
 * Opens a window showing details of an education.
 */
/datum/category_item/player_setup_item/skills/proc/show_education_window(var/singleton/education/ED, var/topic_data, var/mob/user)
	var/datum/browser/education_win = new(user, topic_data, "Education Selection")
	var/dat = "<html><center><b>[ED.name]</center></b>"
	dat += "<hr>[ED.description]<hr>"
	dat += "This education gives you the following skills: "
	var/list/skills_to_show = list()
	for(var/skill in ED.skills)
		var/singleton/skill/S = GET_SINGLETON(skill)
		skills_to_show += "[S.name] ([SPAN_DANGER(S.skill_level_map[ED.skills[S.type]])])"
	dat +=  "<b>[english_list(skills_to_show)]</b>.<br>"
	dat += "<br><center>\[<a href='?src=[REF(src)];[topic_data]=[html_encode(ED.type)]'>Select</a>\]</center>"
	dat += "</html>"
	education_win.set_content(dat)
	education_win.open()

/**
 * Finds and returns the first suitable education for the pref datum.
 */
/datum/category_item/player_setup_item/skills/proc/find_suitable_education()
	var/list/singleton/education/education_list = GET_SINGLETON_SUBTYPE_MAP(/singleton/education)
	for(var/singleton_type in education_list)
		var/singleton/education/ED = education_list[singleton_type]
		if(length(ED.species_restriction))
			if(pref.species in ED.species_restriction)
				continue
		if(length(ED.minimum_character_age))
			if(pref.species in ED.minimum_character_age)
				if(pref.age < ED.minimum_character_age[pref.species])
					continue
		return ED
