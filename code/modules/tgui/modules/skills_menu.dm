/datum/tgui_module/skills_menu
	var/datum/weakref/target_human
	/// Assoc list of skill type -> initial skill level when the menu was created.
	var/list/initial_skills = list()
	/// Assoc list of skill type -> currently selected skill level.
	var/list/selected_skills = list()
	/// Assoc list of skill category name -> bonus skill points.
	var/list/bonus_skill_points = list()

/datum/tgui_module/skills_menu/New(mob/living/carbon/human/target, list/bonus_points = null)
	..()
	target_human = WEAKREF(target)
	if(islist(bonus_points))
		bonus_skill_points = bonus_points.Copy()

	for(var/singleton/skill/skill as anything in SSskills.all_skills)
		var/level = target?.skills?[skill.type]
		if(!level && skill.component_type)
			var/datum/component/skill/comp = target?.GetComponent(skill.component_type)
			if(comp)
				level = comp.skill_level
		if(!level)
			level = SKILL_LEVEL_UNFAMILIAR
		initial_skills[skill.type] = level
		selected_skills[skill.type] = level

/datum/tgui_module/skills_menu/Destroy(force)
	var/mob/living/carbon/human/owner = target_human?.resolve()
	if(istype(owner) && owner.pending_skills_menu == src)
		owner.pending_skills_menu = null
	target_human = null
	return ..()

/datum/tgui_module/skills_menu/ui_state(mob/user)
	return GLOB.always_state

/datum/tgui_module/skills_menu/ui_interact(mob/user, datum/tgui/ui)
	var/mob/living/carbon/human/owner = target_human?.resolve()
	if(!istype(owner) || user != owner)
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SkillsMenu", "Skills Configuration", 850, 700)
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/tgui_module/skills_menu/ui_data(mob/user)
	if(!SSskills.initialized)
		return list("initialized" = FALSE)

	var/mob/living/carbon/human/owner = target_human?.resolve()
	if(!istype(owner))
		return list("initialized" = FALSE)

	var/list/categories = list()
	for(var/singleton/skill_category/skill_category as anything in SSskills.skill_tree)
		var/list/subcategories = list()
		for(var/subcategory in SSskills.skill_tree[skill_category])
			var/list/skills = list()
			for(var/singleton/skill/skill as anything in SSskills.skill_tree[skill_category][subcategory])
				skills += list(get_skill_ui_data(skill, owner))
			subcategories += list(list(
				"name" = subcategory,
				"skills" = skills
			))
		categories += list(list(
			"name" = skill_category.name,
			"remaining" = calculate_remaining_skill_points(skill_category, owner),
			"bonus" = bonus_skill_points[skill_category.name] || 0,
			"subcategories" = subcategories
		))

	return list(
		"initialized" = TRUE,
		"categories" = categories
	)

/datum/tgui_module/skills_menu/proc/get_skill_ui_data(singleton/skill/skill, mob/living/carbon/human/owner)
	var/current_level = selected_skills[skill.type] || SKILL_LEVEL_UNFAMILIAR
	var/initial_level = initial_skills[skill.type] || SKILL_LEVEL_UNFAMILIAR
	var/maximum_skill_level = get_maximum_skill_level(skill, owner)
	var/alist/level_descriptions = skill.get_skill_level_descriptions(null, owner.species)
	var/current_description = replacetext(level_descriptions[current_level], "<br>", "\n")
	current_description = html_decode(strip_html_properly(current_description))

	var/list/levels = list()
	for(var/i = SKILL_LEVEL_UNFAMILIAR, i <= skill.maximum_level, i++)
		if(i <= 0)
			continue
		levels += list(get_skill_level_ui_data(skill, initial_level, current_level, i, maximum_skill_level))

	return list(
		"name" = skill.get_name(null, owner.species),
		"type" = "[skill.type]",
		"description" = skill.get_description(null, owner.species),
		"current_description" = current_description,
		"levels" = levels
	)

/datum/tgui_module/skills_menu/proc/get_skill_level_ui_data(singleton/skill/skill, initial_level, current_level, selection_level, maximum_skill_level)
	var/level_name = skill.skill_level_map[selection_level]
	var/cost = skill.get_cost(selection_level)
	var/state = "unavailable"
	var/selectable = FALSE

	if(selection_level < initial_level)
		state = "forced"
	else if(selection_level == current_level)
		state = "current"
	else if(selection_level <= maximum_skill_level)
		state = "selectable"
		selectable = TRUE

	return list(
		"label" = level_name,
		"cost" = cost,
		"value" = selection_level,
		"state" = state,
		"selectable" = selectable
	)

/datum/tgui_module/skills_menu/proc/get_category_cost(singleton/skill_category/skill_category, list/skill_map)
	. = 0
	for(var/skill_type in skill_map)
		var/singleton/skill/skill = GET_SINGLETON(skill_type)
		if(!istype(skill) || skill.category != skill_category.type)
			continue
		var/level = skill_map[skill_type]
		if(level > SKILL_LEVEL_UNFAMILIAR)
			. += skill.get_cost(level)

/datum/tgui_module/skills_menu/proc/calculate_remaining_skill_points(singleton/skill_category/skill_category, mob/living/carbon/human/owner)
	if(!istype(skill_category) || !istype(owner))
		return 0

	var/base_points = skill_category.calculate_skill_points(owner.species, owner.age, owner.culture, owner.origin)
	var/bonus_points = bonus_skill_points[skill_category.name] || 0
	var/initial_cost = get_category_cost(skill_category, initial_skills)
	var/selected_cost = get_category_cost(skill_category, selected_skills)
	var/total_points = max(base_points, initial_cost) + bonus_points
	return total_points - selected_cost

/datum/tgui_module/skills_menu/proc/get_maximum_skill_level(singleton/skill/skill, mob/living/carbon/human/owner)
	var/remaining = calculate_remaining_skill_points(GET_SINGLETON(skill.category), owner)
	var/current_level = selected_skills[skill.type] || SKILL_LEVEL_UNFAMILIAR
	var/current_cost = skill.get_cost(current_level)
	var/available_points = remaining + current_cost

	for(var/skill_level = skill.maximum_level; skill_level >= SKILL_LEVEL_UNFAMILIAR; skill_level--)
		if(skill.get_cost(skill_level) <= available_points)
			return skill_level

	return SKILL_LEVEL_UNFAMILIAR

/datum/tgui_module/skills_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/living/carbon/human/owner = target_human?.resolve()
	if(!istype(owner) || usr != owner)
		return FALSE

	switch(action)
		if("setskill")
			var/singleton/skill/skill = GET_SINGLETON(text2path(params["skill"]))
			if(!istype(skill))
				return FALSE
			var/new_level = text2num(params["level"])
			if(!isnum(new_level))
				return FALSE
			new_level = round(new_level)
			var/min_level = initial_skills[skill.type] || SKILL_LEVEL_UNFAMILIAR
			var/max_level = get_maximum_skill_level(skill, owner)
			if(new_level < min_level || new_level > max_level)
				return FALSE
			selected_skills[skill.type] = new_level
			return TRUE

		if("confirm")
			apply_skills(owner)
			remove_verb(owner, /mob/living/carbon/human/proc/configure_skills_verb)
			owner.pending_skills_menu = null
			to_chat(owner, SPAN_NOTICE("Your skills have been finalized."))
			ui.close()
			qdel(src)
			return TRUE

/datum/tgui_module/skills_menu/proc/apply_skills(mob/living/carbon/human/owner)
	for(var/singleton/skill/skill as anything in SSskills.all_skills)
		var/new_level = selected_skills[skill.type] || SKILL_LEVEL_UNFAMILIAR
		var/old_level = initial_skills[skill.type] || SKILL_LEVEL_UNFAMILIAR
		if(new_level <= old_level)
			continue

		LAZYSET(owner.skills, skill.type, new_level)
		if(istype(skill, /singleton/skill/resolve))
			var/singleton/skill/resolve/resolve_skill = skill
			resolve_skill.on_spawn(owner, new_level, old_level)
			continue

		if(skill.component_type)
			var/datum/component/skill/existing_comp = owner.GetComponent(skill.component_type)
			if(existing_comp)
				qdel(existing_comp)
		skill.on_spawn(owner, new_level)

/**
 * Offers a one-time, education-unrestricted skills menu to a humanoid mob.
 */
/mob/living/carbon/human/proc/offer_skills_menu(list/bonus_points = null, auto_open = TRUE)
	if(pending_skills_menu)
		return

	for(var/singleton/skill/required_skill as anything in SSskills.required_skills)
		LoadComponent(required_skill.component_type, SKILL_LEVEL_UNFAMILIAR)

	pending_skills_menu = new /datum/tgui_module/skills_menu(src, bonus_points)
	add_verb(src, /mob/living/carbon/human/proc/configure_skills_verb)
	to_chat(src, SPAN_NOTICE("You have a one-time opportunity to configure your skills using the <b>Configure Skills</b> verb in the IC tab."))
	if(auto_open && client)
		addtimer(CALLBACK(pending_skills_menu, TYPE_PROC_REF(/datum/tgui_module/skills_menu, ui_interact), src), 1)

/mob/living/carbon/human/proc/configure_skills_verb()
	set name = "Configure Skills"
	set category = "IC"
	set desc = "Configure your character's skills (one-time use)."

	if(!pending_skills_menu)
		remove_verb(src, /mob/living/carbon/human/proc/configure_skills_verb)
		return
	pending_skills_menu.ui_interact(src)
