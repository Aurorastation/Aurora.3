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
		var/skill_val = pref.skills[S]
		if(skill_val <= SKILL_LEVEL_UNFAMILIAR)
			continue
		sanitized_skills["[skill.type]"] = skill_val

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
		if(istext(pref.skills))
			loaded_skills = json_decode(pref.skills)
		else
			loaded_skills = pref.skills
	catch (var/exception/e)
		log_debug("SKILLS: Caught [e]. Initial value: [before]")
		loaded_skills = list()

	pref.skills = list()
	for(var/key,value in loaded_skills)
		if (!key)
			continue
		var/path = istext(key) ? text2path(key) : key
		var/singleton/skill/skill = GET_SINGLETON(path)
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

/datum/category_item/player_setup_item/skills/ui_data(var/mob/user)
	if(!SSskills.initialized)
		return list(
			"kind" = "notice",
			"name" = name,
			"ref" = REF(src),
			"message" = "Skills not initialized yet. Please wait a bit and reload this section."
		)
	var/singleton/education/ED = GET_SINGLETON(text2path(pref.education))
	var/singleton/education/education = GET_SINGLETON(text2path(pref.education))
	var/list/categories = list()
	for(var/category in SSskills.skill_tree)
		var/singleton/skill_category/skill_category = category
		var/list/subcategories = list()
		for(var/subcategory in SSskills.skill_tree[skill_category])
			var/list/skills = list()
			for(var/singleton/skill/skill in SSskills.skill_tree[skill_category][subcategory])
				skills += list(get_skill_ui_data(skill, education))
			subcategories += list(list("name" = subcategory, "skills" = skills))
		categories += list(list(
			"name" = skill_category.name,
			"remaining" = calculate_remaining_skill_points(skill_category),
			"subcategories" = subcategories
		))
	return list(
		"kind" = "skills",
		"name" = name,
		"ref" = REF(src),
		"education" = ED.name,
		"education_description" = ED.description,
		"categories" = categories
	)

/datum/category_item/player_setup_item/skills/proc/get_skill_ui_data(singleton/skill/skill, singleton/education/education)
	var/level_from_pref = pref.skills[skill.type]
	var/current_level = level_from_pref ? level_from_pref : SKILL_LEVEL_UNFAMILIAR
	var/maximum_skill_level = get_maximum_skill_level(skill, education)
	var/current_description = replacetext(skill.skill_level_descriptions[current_level], "<br>", "\n")
	current_description = html_decode(strip_html_properly(current_description))
	var/list/levels = list()
	for(var/i = SKILL_LEVEL_UNFAMILIAR, i <= skill.maximum_level, i++)
		if(i <= 0)
			continue
		levels += list(get_skill_level_ui_data(skill, education, current_level, i, maximum_skill_level))
	return list(
		"name" = skill.name,
		"type" = "[skill.type]",
		"description" = skill.description,
		"current_description" = current_description,
		"uneducated_cap" = skill.uneducated_skill_cap ? skill.skill_level_map[skill.uneducated_skill_cap] : null,
		"levels" = levels
	)

/datum/category_item/player_setup_item/skills/proc/get_maximum_skill_level(singleton/skill/skill, singleton/education/education)
	var/base_maximum_level = skill.get_maximum_level(education)
	var/remaining_skill_points = calculate_remaining_skill_points(GET_SINGLETON(skill.category))

	var/current_level = SKILL_LEVEL_UNFAMILIAR
	if(skill.type in pref.skills)
		current_level = pref.skills[skill.type]

	var/current_cost = get_paid_skill_cost(skill, current_level, education)
	var/available_points = remaining_skill_points + current_cost

	for(var/skill_level = base_maximum_level; skill_level >= SKILL_LEVEL_UNFAMILIAR; skill_level--)
		if(get_paid_skill_cost(skill, skill_level, education) <= available_points)
			return skill_level

	return SKILL_LEVEL_UNFAMILIAR

/datum/category_item/player_setup_item/skills/proc/get_skill_level_ui_data(singleton/skill/skill, singleton/education/education, current_level, selection_level, maximum_skill_level)
	var/effective_level = selection_level
	var/level_name = skill.skill_level_map[effective_level]
	var/cost = skill.get_cost(effective_level)
	var/given_skill = FALSE
	var/education_skill = 0
	if(skill.type in education.skills)
		given_skill = TRUE
		education_skill = education.skills[skill.type]
	var/state = "unavailable"
	var/selectable = FALSE
	if((effective_level < education_skill) && given_skill)
		state = "forced"
	else if((effective_level < current_level) && !given_skill)
		state = "selectable"
		selectable = skill.get_maximum_level(education) >= effective_level
	else if(effective_level == current_level)
		state = "current"
	else if(effective_level <= maximum_skill_level)
		state = "selectable"
		selectable = skill.get_maximum_level(education) >= effective_level
	return list(
		"label" = level_name,
		"cost" = cost,
		"value" = effective_level,
		"state" = state,
		"selectable" = selectable
	)

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
 * Returns the amount of used skill points in a certain skill category.
 * Skills granted by education only cost points for levels above the granted level.
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

		. += get_paid_skill_cost(skill, pref.skills[skill.type], education)

/**
 * Returns how many points the player actually has to pay for a skill level.
 * Education granted levels are considered free.
 */
/datum/category_item/player_setup_item/skills/proc/get_paid_skill_cost(singleton/skill/skill, level, singleton/education/education)
	if(!istype(skill))
		crash_with("Invalid skill [skill] fed to get_paid_skill_cost!")

	if(!istype(education))
		crash_with("Invalid education [education] fed to get_paid_skill_cost!")

	var/cost = skill.get_cost(level)

	if(skill.type in education.skills)
		var/education_level = education.skills[skill.type]
		cost -= skill.get_cost(education_level)

	return max(0, cost)

/datum/category_item/player_setup_item/skills/OnTopic(href, href_list, user)
	if(href_list["setskill"])
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
			var/list/granted_skills = list()
			for(var/granted_skill in chosen_education.skills)
				var/singleton/skill/granted_skill_data = GET_SINGLETON(granted_skill)
				granted_skills += "[granted_skill_data.name] ([granted_skill_data.skill_level_map[chosen_education.skills[granted_skill_data.type]]])"
			var/education_summary = html_decode(strip_html(chosen_education.description))
			if(length(granted_skills))
				education_summary += "\n\nGranted skills: [english_list(granted_skills)]"
			if(tgui_alert(user, education_summary, chosen_education.name, list("Select", "Cancel")) != "Select")
				return TOPIC_NOACTION
			pref.education = "[chosen_education.type]"
			pref.skills = list()
			to_chat(user, SPAN_WARNING("Your skills have been reset as you changed your education."))
			for(var/skill in chosen_education.skills)
				var/singleton/skill/new_skill = GET_SINGLETON(skill)
				pref.skills[new_skill.type] = chosen_education.skills[new_skill.type]
				to_chat(user, SPAN_NOTICE("Added the [new_skill.name] skill at level [new_skill.skill_level_map[chosen_education.skills[new_skill.type]]]."))
			sanitize_character()
			return TOPIC_REFRESH
		return TOPIC_NOACTION

	return ..()

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
