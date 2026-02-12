/**
 * The base type for Componentized skills, containing only the information extracted from Skill preferences that would be required to function.
 * Children of this component can be added to a character from skill singletons by overriding that singleton's on_spawn() proc.
 */
#define SKILL_COMPONENT /datum/component/skill
ABSTRACT_TYPE(/datum/component/skill)
	/**
	 * How many ranks a player has purchased in a given skill.
	 * How this is actually used is entirely up to the implementation of individual components.
	 */
	var/skill_level = SKILL_LEVEL_UNFAMILIAR

/**
 * Always use . = ..() at the start of a NameSkillComponent's Initialize() proc.
 * Skills MUST have their skill_level set first during initialization.
 * Do this by setting var/level to the 2nd arg of AddComponent()
 */
/datum/component/skill/Initialize(var/level = SKILL_LEVEL_UNFAMILIAR)
	SHOULD_CALL_PARENT(TRUE)
	. = ..()
	skill_level = level
