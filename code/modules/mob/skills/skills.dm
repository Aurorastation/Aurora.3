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
	if(skill_level > skill_floor)
		modifier -= bonus * max(0, skill_level - skill_floor)
	else
		modifier += malus * max(1, skill_floor - skill_level)
	return modifier

/**
 * A do_after modified by skill proficiency.
 *
 * delay = The base delay in seconds the do_after should take if skill level is equal to `skill_floor`.
 * target = The do_after target.
 * skill_type = The skill used for this do_after. Can be a list or a path.
 * skill_floor = The base skill level at which the delay is unaffected.
 * bonus/malus = The bonus added or removed for each step of skill difference, see get_skill_multiplier.
 * do_flags = The do_flags fed to the do_after.
 */
/mob/proc/do_after_skill(base_delay, atom/target, skill_type, skill_floor = SKILL_LEVEL_TRAINED, bonus = 0.2, malus = 0.2, do_flags)
	var/skill_mult
	if(islist(skill_type))
		for(var/skill in skill_type)
			skill_mult = min(skill_mult, get_skill_multiplier(skill, skill_floor, bonus, malus))
	else
		skill_mult = get_skill_multiplier(skill_type, skill_floor, bonus, malus)
	return do_after(src, base_delay * skill_mult, target, do_flags)

/**
 * Throws a DC challenge against the difficulty class. For explanation on how criticals work, see code\__DEFINES\skills.dm.
 * Remember that you should not check `if(!result)` for a failure. You should do `if(result <= ROLL_RESULT_FAILURE)` instead, so as to also check for a crit fail.
 *
 * difficulty_class = The DC to beat.
 * skill_type = The skill used for this check. Can be a list or a path.
 */
/mob/proc/skill_challenge(difficulty_class, skill_type)
	var/roll = rand(1, 20)
