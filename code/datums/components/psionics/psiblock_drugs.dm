/datum/component/timed_life/psiblock_drugs

	var/removal_message_list = list("You feel more sensitive to your surroundings.", "Your thoughts feel clearer.", "You feel more aware of others around you.", "You can focus better.")

/datum/component/timed_life/psiblock_drugs/Initialize(lifetime_seconds = 5 MINUTES)
	. = ..()
	if (!parent)
		return

	RegisterSignal(parent, COMSIG_PSI_CHECK_SENSITIVITY, PROC_REF(modify_sensitivity), override = TRUE)
	RegisterSignal(parent, COMSIG_PSI_MIND_POWER, PROC_REF(cancel_power), override = TRUE)

/datum/component/timed_life/psiblock_drugs/Destroy()
	if (!parent)
		return ..()

	// This is here and not on the reagent because the reagent's duration is handled by this component rather than metabolism.
	// If the parent is being deleted, then there's no need to send a message about the drug wearing off.
	if (!QDELING(parent))
		to_chat(parent, SPAN_NOTICE(pick(removal_message_list)))

	UnregisterSignal(parent, COMSIG_PSI_CHECK_SENSITIVITY)
	UnregisterSignal(parent, COMSIG_PSI_MIND_POWER)
	return ..()

/datum/component/timed_life/psiblock_drugs/proc/modify_sensitivity(parent, effective_sensitivity)
	SIGNAL_HANDLER

	*effective_sensitivity = *effective_sensitivity - 1

/datum/component/timed_life/psiblock_drugs/proc/cancel_power(parent, caster, cancelled, cancel_return, wide_field)
	SIGNAL_HANDLER
	*cancelled = TRUE
