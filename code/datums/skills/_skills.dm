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
	/**
	 * Required skills are always loaded at a minimum skill level of 1 regardless of if they were saved to the preferences.
	 * This is useful for skills that provide a penalty below a certain skill level.
	 */
	var/required = FALSE

	/**
	 * For required skills on humanoid antags, they are always guaranteed a minimum of this skill level.
	 * If they have the skill previously at a lower level, their skill level is increased to this upon being promoted to antagonist.
	 * If they don't have the skill at all, they are given the skill at this level.
	 */
	var/antag_level = SKILL_LEVEL_TRAINED

	/// The component datum that this skill will add during character spawning
	var/component_type = null
	/// Map of skill levels to level costs. How many skill points it takes to purchase this rank in a skill.
	var/alist/skill_cost_map = alist(
		SKILL_LEVEL_UNFAMILIAR = 0,
		SKILL_LEVEL_FAMILIAR = 2,
		SKILL_LEVEL_TRAINED = 4,
		SKILL_LEVEL_PROFESSIONAL = 8
	)

/**
 * Returns the maximum level a character can have in this skill depending on education.
 */
/singleton/skill/proc/get_maximum_level(singleton/education/education)
	if(!istype(education))
		crash_with("SKILL: Invalid [education] fed to get_maximum_level!")

	// If there is no uneducated skill cap, it means we can always pick the maximum level.
	if(!uneducated_skill_cap)
		return maximum_level

	// Otherwise, we need to check the education...
	if(type in education.skills)
		return maximum_level


	return uneducated_skill_cap

/**
 * Returns the cost of this skill, modified by its difficulty modifier.
 */
/singleton/skill/proc/get_cost(level)
	return skill_cost_map[level]

/**
 * ECS hook for Skills, based on a one-shot-on-spawn pattern common to traits/disabilities/loadouts, etc.
 * Skills may optionally include this, but are not required to.
 * This is primarily useful for making skills that offload all of their functional logic to a Component.
 *
 * It will be called during the process of spawning a player character in.
 */
/singleton/skill/proc/on_spawn(mob/owner, skill_level)
	// Note that this can be directly overridden for skills that wish to use the ECS hook to provide an effect other than the standard "adding a component".
	if (!owner || !component_type || (!required && skill_level == SKILL_LEVEL_UNFAMILIAR))
		return

	owner.AddComponent(component_type, skill_level)
