/**
 * Component used for the Psi-Suppression power.
 * Acts like a stronger Mind-shield/Mind-Blanker until toggled off.
 */
#define PsiSuppressionComponent /datum/component/psi_suppression
/datum/component/psi_suppression

	/**
	 * The amount this component will modify its owner psi_sensitivity by when they are called by psychic phenomena to check.
	 * See /proc/check_psi_sensitivity() for more information.
	 */
	var/sensitivity_modifier = -2

/datum/component/psi_suppression/Initialize()
	. = ..()
	if (!parent)
		return

	RegisterSignal(parent, COMSIG_PSI_CHECK_SENSITIVITY, PROC_REF(modify_sensitivity), override = TRUE)
	RegisterSignal(parent, COMSIG_PSI_MIND_POWER, PROC_REF(cancel_power), override = TRUE)

/datum/component/psi_suppression/Destroy()
	. = ..()
	if (!parent)
		return

	UnregisterSignal(parent, COMSIG_PSI_CHECK_SENSITIVITY)
	UnregisterSignal(parent, COMSIG_PSI_MIND_POWER)

/datum/component/psi_suppression/proc/modify_sensitivity(var/parent, var/effective_sensitivity)
	SIGNAL_HANDLER

	*effective_sensitivity += sensitivity_modifier

/datum/component/psi_suppression/proc/cancel_power(var/parent, var/caster, var/cancelled, var/cancel_return, var/wide_field)
	SIGNAL_HANDLER

	*cancelled = TRUE
	if (wide_field || parent == caster)
		return

	to_chat(parent, SPAN_DANGER("You repulse an outside thought!"))
