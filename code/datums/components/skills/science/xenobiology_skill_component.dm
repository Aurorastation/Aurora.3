/datum/component/skill/xenobiology
	/// Bonus surgery success rate, to be applied only when performing surgeries on a creature of a different species.
	var/success_rate_bonus_per_level = 2.5

	/// Bonus surgery speed (as a percent increase) per skill level, to be applied only when performing surgeries on a creature of a different species.
	var/surgery_speed_mod_per_level = 0.05

/datum/component/skill/xenobiology/Initialize(level)
	. = ..()
	if (!parent)
		return

	RegisterSignal(parent, COMSIG_GET_SURGERY_SUCCESS_MODIFIERS, PROC_REF(handle_surgery_modifiers))

/datum/component/skill/xenobiology/Destroy(force)
	if (!parent)
		return ..()

	UnregisterSignal(parent, COMSIG_GET_SURGERY_SUCCESS_MODIFIERS)
	return ..()

/datum/component/skill/xenobiology/proc/handle_surgery_modifiers(mob/living/user, mob/living/carbon/target, success_rate, duration)
	SIGNAL_HANDLER
	// This component only applies to surgeries where our species does not match the target species.
	if (astype(user, /mob/living/carbon/human)?.species == astype(target, /mob/living/carbon/human)?.species)
		return

	var/effective_skill = skill_level - 1
	*success_rate = *success_rate + success_rate_bonus_per_level * effective_skill
	*duration = *duration * (1 - surgery_speed_mod_per_level * effective_skill)
