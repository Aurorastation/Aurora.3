/datum/component/skill/reactor_systems
	/// Double-sized bonus surgery success rate, scoped to IPC power/reactor surgeries.
	var/power_surgery_success_bonus_per_level = 5

	/// Double-sized bonus surgery speed (as a percent reduction), scoped to IPC power/reactor surgeries.
	var/power_surgery_speed_mod_per_level = 0.10

/datum/component/skill/reactor_systems/Initialize()
	. = ..()
	if (!parent)
		return

	RegisterSignal(parent, COMSIG_USE_REACTOR_COMPUTER, PROC_REF(use_reactor_computer), override = TRUE)
	RegisterSignal(parent, COMSIG_GET_SURGERY_SUCCESS_MODIFIERS, PROC_REF(handle_surgery_modifiers))

/datum/component/skill/reactor_systems/Destroy(force)
	if (!parent)
		return ..()

	UnregisterSignal(parent, COMSIG_USE_REACTOR_COMPUTER)
	UnregisterSignal(parent, COMSIG_GET_SURGERY_SUCCESS_MODIFIERS)
	return ..()

/datum/component/skill/reactor_systems/proc/use_reactor_computer(mob/user, cancelled, required_level = SKILL_LEVEL_TRAINED)
	SIGNAL_HANDLER
	if (skill_level >= required_level)
		return

	*cancelled = TRUE
	to_chat(user, SPAN_WARNING("There's just so many buttons... You have no idea where to even begin with using this machine."))

/datum/component/skill/reactor_systems/proc/handle_surgery_modifiers(mob/living/user, mob/living/carbon/target, success_rate, duration, singleton/surgery_step/surg_step, zone)
	SIGNAL_HANDLER
	if (!isipc(target) || skill_level <= SKILL_LEVEL_UNFAMILIAR || !surg_step)
		return
	if (!istype(surg_step, /singleton/surgery_step/internal/degunk) && !(zone == BP_CHEST && istype(surg_step, /singleton/surgery_step/internal)))
		return

	var/effective_skill = skill_level - 1
	*success_rate = *success_rate + power_surgery_success_bonus_per_level * effective_skill
	*duration = *duration * (1 - power_surgery_speed_mod_per_level * effective_skill)
