/singleton/skill_category
	/// The name of the skill category.
	var/name
	/// The description and purpose of the skill category, displayed in the info tab.
	var/desc

/singleton/skill_category/everyday
	name = SKILL_CATEGORY_EVERYDAY
	desc = "An everyday skill is a skill that can be picked up normally. Think like mixing a drink, growing a plant, cooking, and so on."

/singleton/skill_category/occupational
	name = SKILL_CATEGORY_OCCUPATIONAL
	desc = "Occupational skills are the skills necessary for you to do your job. They typically lock certain aspects of your department if you aren't proficient enough."

/singleton/skill_category/combat
	name = SKILL_CATEGORY_COMBAT
	desc = "A combat skill is a skill that has a direct effect in combat. These have an increased cost."

