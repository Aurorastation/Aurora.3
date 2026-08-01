/singleton/skill_category
	/// The name of the skill category.
	var/name
	/// The description and purpose of the skill category, displayed in the info tab.
	var/desc
	/// The hex colour of the skill category. Shows as background on the skills tab.
	var/color
	/// The number of base points a character gets in this category.
	var/base_skill_points

/singleton/skill_category/proc/calculate_skill_points(datum/species/species, age, singleton/origin_item/culture, singleton/origin_item/origin)
	var/list/species_modifiers = species.modify_skill_points(src, age)
	return base_skill_points * species_modifiers[name]

/singleton/skill_category/everyday
	name = SKILL_CATEGORY_EVERYDAY
	desc = "An everyday skill is a skill that can be picked up normally. Think like mixing a drink, growing a plant, cooking, and so on."
	base_skill_points = BASE_SKILL_POINTS_EVERYDAY

/singleton/skill_category/occupational
	name = SKILL_CATEGORY_OCCUPATIONAL
	desc = "Occupational skills are the skills necessary for you to do your job. They typically lock certain aspects of your department if you aren't proficient enough."
	base_skill_points = BASE_SKILL_POINTS_OCCUPATIONAL

/singleton/skill_category/combat
	name = SKILL_CATEGORY_COMBAT
	desc = "A combat skill is a skill that has a direct effect in combat. These have an increased cost."
	base_skill_points = BASE_SKILL_POINTS_COMBAT

