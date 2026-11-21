/datum/component/skill/electrical_engineering
	/// Bonus surgery success rate, to be applied only when performing surgeries on an IPC.
	var/success_rate_bonus_per_level = 2.5

	/// Bonus surgery speed (as a percent increase) per skill level, to be applied only when performing surgeries on an IPC.
	var/surgery_speed_mod_per_level = 0.05

/datum/component/skill/electrical_engineering/Initialize(level)
	. = ..()
	if (!parent)
		return

	RegisterSignal(parent, COMSIG_GET_SURGERY_SUCCESS_MODIFIERS, PROC_REF(handle_surgery_modifiers))

/datum/component/skill/electrical_engineering/Destroy(force)
	if (!parent)
		return ..()

	UnregisterSignal(parent, COMSIG_GET_SURGERY_SUCCESS_MODIFIERS)
	return ..()

/datum/component/skill/electrical_engineering/proc/handle_surgery_modifiers(mob/living/user, mob/living/carbon/target, success_rate, duration)
	SIGNAL_HANDLER
	if (!isipc(target))
		return

	var/effective_skill = skill_level - 1
	*success_rate = *success_rate + success_rate_bonus_per_level * effective_skill
	*duration = *duration * (1 - surgery_speed_mod_per_level * effective_skill)
