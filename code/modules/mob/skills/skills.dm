/datum/skills
	/// The mob that owns this skill datum.
	var/mob/owner
	/// The skills that this skill datum holds. Assoc list of skill type to level.
	var/list/skills = list()
	/// The TGUI module for changing skills.
	var/tgui_module

/datum/skills/New(mob/M)
	if(!istype(M))
		crash_with("Invalid mob [M] supplied to skill datum!")
	owner = M
	..()

/**
 * Returns the proficiency with a certain skill.
 */
/datum/skills/proc/get_skill_level(skill_type)
	if(skill_type in skills)
		return skills[skill_type]
	return SKILL_LEVEL_UNFAMILIAR

/**
 *  Sets skills starting from a preferences datum.
 */
/datum/skills/proc/set_skills_from_pref(datum/preferences/pref)
	for(var/S in pref.skills)
		var/singleton/skill/skill = GET_SINGLETON(S)
		var/skill_level = pref.skills[skill.type]
		skills[skill.type] = skill_level

/**
 * Returns the mob's proficiency with a certain skill.
 */
/mob/proc/get_skill_level(skill_type)
	return skills.get_skill_level(skill_type)

/**
 * Takes a skill type and the level of skill needed.
 * Returns TRUE if the mob's skill level exceeds or equals the skill level needed.
 * Returns FALSE otherwise.
 */
/mob/proc/skill_check(skill_type, skill_level_needed)
	return get_skill_level(skill_type) >= skill_level_needed

/**
 * Gets the skill difference in a given skill between two mobs.
 */
/mob/proc/get_skill_difference(mob/opponent, skill_type)
	return get_skill_level(skill_type) - opponent.get_skill_level(skill_type)

/**
 * Returns a multiplier based on the mob's skill. Takes a skill type and a minimum skill floor at least.
 * Bonus and malus are the modifiers added or removed for each skill level of difference from the required skill floor.
 */
/mob/proc/get_skill_multiplier(skill_type, skill_floor = SKILL_LEVEL_TRAINED, bonus = 0.2, malus = 0.2)
	var/modifier = 1
	var/skill_level = get_skill_level(skill_type)
	if(skill_level >= SKILL_LEVEL_TRAINED)
		modifier -= bonus * max(1, skill_level - skill_floor)
	else
		modifier += malus * max(1, skill_floor - skill_level)
	return modifier
