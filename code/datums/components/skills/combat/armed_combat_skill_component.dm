/datum/component/skill/armed_combat
	/**
	 * Reference value used for checking "Skill Diff"
	 * "Skill Diff" is the distance from the actual skill level to the reference.
	 */
	var/skill_diff_reference = SKILL_LEVEL_TRAINED

/datum/component/skill/armed_combat/Initialize(level)
	. = ..()
	if (!parent)
		return

	RegisterSignal(parent, COMSIG_APPLY_HIT_EFFECT, PROC_REF(modify_hit_effect), override = TRUE)

/datum/component/skill/armed_combat/Destroy(force)
	if (!parent)
		return ..()

	UnregisterSignal(parent, COMSIG_APPLY_HIT_EFFECT)
	return ..()

/datum/component/skill/armed_combat/proc/modify_hit_effect(var/owner, var/mob/living/target, var/obj/item/weapon, var/power, var/hit_zone)
	var/skill_diff = skill_diff_reference - skill_level
	*power *= 1 + (0.1 * skill_diff)
