/singleton/skill
	/// The displayed name of the skill.
	var/name
	/// A description of what this skill entails.
	var/description
	/// A detailed description of what a character should expect with their current level in this skill. Assoc list of skill level to string.
	var/list/skill_level_descriptions = list(
		SKILL_LEVEL_UNFAMILIAR = "You are clueless.",
		SKILL_LEVEL_FAMILIAR = "You have read up on the subject or have prior real experience.",
		SKILL_LEVEL_TRAINED = "You have received some degree of official training on the subject, whether through certifications or courses.",
		SKILL_LEVEL_PROFESSIONAL = "You are an expert in this field, devoting many years of study or practice to it."
	)
	/// The maximum level someone with no education can reach in this skill. Typically, this should be FAMILIAR on occupational skills.
	/// If null, then there is no cap.
	var/uneducated_skill_cap
	/// The maximum level this skill can reach.
	var/maximum_level = SKILL_LEVEL_TRAINED
	/// The category of this skill. Used for sorting, typically.
	var/category
	/// The sub-category of this skill. Used to better sort skills.
	var/subcategory
	/// The modifier for how difficult the skill is. Each level costs this much * the level.
	var/skill_difficulty_modifier = SKILL_DIFFICULTY_MODIFIER_MEDIUM

/**
 * Returns the maximum level a character can have in this skill depending on education.
 */
/singleton/skill/proc/get_maximum_level(var/singleton/education/education)
	if(!istype(education))
		crash_with("SKILL: Invalid [education] fed to get_maximum_level!")

	// If there is no uneducated skill cap, it means we can always pick the maximum level.
	if(!uneducated_skill_cap)
		return maximum_level

	// Otherwise, we need to check the education...
	if(type in education.skills)
		return education.skills[type]


	return uneducated_skill_cap

/**
 * Returns the cost of this skill, modified by its difficulty modifier.
 */
/singleton/skill/proc/get_cost(level)
	if(level == SKILL_LEVEL_UNFAMILIAR) //thanks byond for not supporting index 0
		return 0
	return skill_difficulty_modifier * level
