/**
 * Component used for the Surgery Skill. A character's rank in this component is used to determine which surgical procedures they can perform.
 * This skill only governs "Organic" surgery. IPC surgery is instead handled by the Robotics skill.
 */
/datum/component/skill/surgery
	/// Bonus surgery speed (as a percent increase) per skill level, applied to ANY surgery.
	var/surgery_speed_mod_per_level = 0.1

/datum/component/skill/surgery/Initialize(level)
	. = ..()
	if (!parent)
		return

	RegisterSignal(parent, COMSIG_GET_SURGERY_SUCCESS_MODIFIERS, PROC_REF(handle_surgery_modifiers))

/datum/component/skill/surgery/Destroy(force)
	if (!parent)
		return ..()

	UnregisterSignal(parent, COMSIG_GET_SURGERY_SUCCESS_MODIFIERS)
	return ..()

/datum/component/skill/surgery/proc/handle_surgery_modifiers(mob/living/user, mob/living/carbon/target, success_rate, duration)
	SIGNAL_HANDLER
	*duration = *duration * (1 - surgery_speed_mod_per_level * (skill_level - 1))
