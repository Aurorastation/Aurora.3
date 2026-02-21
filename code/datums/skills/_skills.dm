/singleton/skill
	/// The displayed name of the skill.
	var/name
	/// A description of what this skill entails.
	var/description
	/// A detailed description of what a character should expect with their current level in this skill. Assoc list of skill level to string.
	var/alist/skill_level_descriptions = alist(
		SKILL_LEVEL_UNFAMILIAR = "You are clueless.",
		SKILL_LEVEL_FAMILIAR = "You have read up on the subject or have prior real experience.",
		SKILL_LEVEL_TRAINED = "You have received some degree of official training on the subject, whether through certifications or courses.",
		SKILL_LEVEL_PROFESSIONAL = "You are an expert in this field, devoting many years of study or practice to it."
	)
	/// Map of skill names and descriptions by their index.
	var/list/skill_level_map = list(
		"Unfamiliar",
		"Familiar",
		"Trained",
		"Professional"
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
	 * Required skills are always included in the user's saved skills preference, even if it's at the lowest rank.
	 * This is needed for skills that rely on components.
	 */
	var/required = FALSE

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

/**
 * ECS hook for Skills, based on a one-shot-on-spawn pattern common to traits/disabilities/loadouts, etc.
 * Skills may optionally include this, but are not required to.
 * This is primarily useful for making skills that offload all of their functional logic to a Component.
 *
 * It will be called during the process of spawning a player character in.
 */
/singleton/skill/proc/on_spawn(var/mob/owner, var/skill_level)
	// Gentle reminder that if you use this proc for a skill, you don't need any variety of ..() in it.
	SHOULD_CALL_PARENT(FALSE)

	// Code comments below this line are provided as an example ECS hook.
	//if (!owner)
	//	return

	// Change YourSkillComponent to the pretty #define used by whatever component you make.
	//var YourSkillComponent/skill = character._LoadComponent(YourSkillComponent)
	//skill.level = skill_level
