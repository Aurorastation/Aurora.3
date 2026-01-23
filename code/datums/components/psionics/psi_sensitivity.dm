/**
 * When attached to any datum, this component subscribes to COMSIG_PSI_CHECK_SENSITIVITY on behalf of its owner.
 * It provides a +1 modifier to Psi Sensitivity Checks.
 */
#define HighPsiSensitivityComponent /datum/component/psi_sensitivity/high

/**
 * When attached to any datum, this component subscribes to COMSIG_PSI_CHECK_SENSITIVITY on behalf of its owner.
 * It provides a -1 modifier to Psi Sensitivity Checks.
 */
#define LowPsiSensitivityComponent /datum/component/psi_sensitivity/low

/**
 * Component that gets temporarily attached to someone who consumes excessive amounts of Wulumunusha.
 * When the Wulumunusha high wears off, the component deletes itself.
 */
#define WuluOverdoseComponent /datum/component/psi_sensitivity/wulu_overdose

/**
 * When attached to any datum, this component subscribes to COMSIG_PSI_CHECK_SENSITIVITY and COMSIG_PSI_MIND_POWER on behalf of its owner.
 * It provides a +2 modifier to Psi Sensitivity Checks.
 * It also cancels telepathy attempts, while spiking both owner and caster with painful interference.
 */
#define PsionicEchoesComponent /datum/component/psi_sensitivity/echoes

/datum/component/psi_sensitivity

	/**
	 * The amount this component will modify its owner psi_sensitivity by when they are called by psychic phenomena to check.
	 * See /proc/check_psi_sensitivity() for more information.
	 */
	var/sensitivity_modifier = 0

/datum/component/psi_sensitivity/Initialize()
	. = ..()
	if (!parent)
		return

	RegisterSignal(parent, COMSIG_PSI_CHECK_SENSITIVITY, PROC_REF(modify_sensitivity), override = TRUE)

/datum/component/psi_sensitivity/Destroy()
	. = ..()
	if (!parent)
		return

	UnregisterSignal(parent, COMSIG_PSI_CHECK_SENSITIVITY)

/datum/component/psi_sensitivity/proc/modify_sensitivity(var/parent, var/effective_sensitivity)
	SIGNAL_HANDLER
	*effective_sensitivity += sensitivity_modifier

/datum/component/psi_sensitivity/high
	sensitivity_modifier = 1

/datum/component/psi_sensitivity/low
	sensitivity_modifier = -1

/datum/component/psi_sensitivity/wulu_overdose
	sensitivity_modifier = 1

/// Variant of high-sensitivity that has a two-way brain damage spike.
/datum/component/psi_sensitivity/echoes
	sensitivity_modifier = 2

	/// The amount of pain both caster and recipient take when the owner receives a telepathic message.
	var/pain_from_telepathy = 20

	/// The amount of confusion time both caster and recipient take when the owner receives a telepathic message.
	var/confusion_from_telepathy = 1 MINUTE

/datum/component/psi_sensitivity/echoes/Initialize()
	. = ..()
	if (!parent)
		return

	RegisterSignal(parent, COMSIG_PSI_MIND_POWER, PROC_REF(cancel_power_echoes), override = TRUE)

/datum/component/psi_sensitivity/echoes/Destroy()
	. = ..()
	if (!parent)
		return

	UnregisterSignal(parent, COMSIG_PSI_MIND_POWER)

/datum/component/psi_sensitivity/echoes/proc/cancel_power_echoes(var/parent, var/caster, var/cancelled, var/cancel_return, var/wide_field)
	SIGNAL_HANDLER
	if(wide_field || parent == caster)
		return

	// Block the telepathic message.
	// This is intentionally done after the wide field check, because including them in psi-search adds uncertainty to Skrell trying to validhunt.
	*cancelled = TRUE

	// SLAP THE PARENT!
	to_chat(parent, SPAN_DANGER("Your thought-field explodes into a storm of incoherent noise!"))
	if(ishuman(parent))
		var/mob/living/carbon/human/victim_parent = parent
		victim_parent.custom_pain(SPAN_DANGER("Agony lances through your mind as the torrent of thoughts overwhelms it!"), pain_from_telepathy)
		victim_parent.confused += confusion_from_telepathy

	// THEN SLAP THE CASTER!
	*cancel_return = SPAN_DANGER("Your thought-field explodes into a storm of incoherent noise!")
	if(ishuman(caster))
		var/mob/living/carbon/human/victim_caster = caster
		victim_caster.custom_pain(SPAN_DANGER("Agony lances through your mind as the torrent of thoughts overwhelms it!"), pain_from_telepathy)
		victim_caster.confused += confusion_from_telepathy
