/**
 * Component used for the Research skill. Mobs with this component are better at working with modular lasers, no other functionality is currently implemented.
 */
/datum/component/skill/research

/datum/component/skill/research/Initialize(var/level = SKILL_LEVEL_UNFAMILIAR)
	. = ..()
	if (!parent)
		return

/datum/component/skill/research/Destroy()
	if (!parent)
		return ..()

	return ..()
