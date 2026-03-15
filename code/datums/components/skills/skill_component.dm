/**
 * The base type for Componentized skills, containing only the information extracted from Skill preferences that would be required to function.
 * Children of this component can be added to a character from skill singletons by overriding that singleton's on_spawn() proc.
 */
ABSTRACT_TYPE(/datum/component/skill)
	/**
	 * How many ranks a player has purchased in a given skill.
	 * How this is actually used is entirely up to the implementation of individual components.
	 */
	var/skill_level = SKILL_LEVEL_UNFAMILIAR

	/**
	 * Reference value used for checking "Skill Diff"
	 * "Skill Diff" is the distance from the actual skill level to the reference.
	 *
	 * This can essentially be thought of as the "baseline competence" for how a vanilla character would function prior to the introduction of Skill Components.
	 * Any datum that is *missing* a given skill component can be logically assumed to be at this skill level.
	 * Therefore, characters who both have the component, and are at a level lower than this can be assumed to be "less competent".
	 * While characters at a level above this can be assumed to be "more competent".
	 */
	var/skill_diff_reference = SKILL_LEVEL_TRAINED

/**
 * Always use . = ..() at the start of a NameSkillComponent's Initialize() proc.
 * Skills MUST have their skill_level set first during initialization.
 * Do this by setting var/level to the 2nd arg of AddComponent()
 */
/datum/component/skill/Initialize(var/level = SKILL_LEVEL_UNFAMILIAR)
	SHOULD_CALL_PARENT(TRUE)
	. = ..()
	skill_level = level
