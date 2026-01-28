/**
 * The parent of all Psi-Sensitivity modifying components.
 * Mobs/Objects with any child of this component will have their Psi-sensitivity modified by the stored amount when called to check by various psionic abilities.
 * A Mob/Object is allowed to have any number of this component's children, but cannot have two of the same child.
 * The mob's psi-sensitivity gets returned as the sum of all sensitivity_modifier values.
 * If you wish to add a new source of Psi-sensitivity, simply add a new child to this component, then use AddComponent() to place it on a datum.
 */
/datum/component/psi_sensitivity

	/**
	 * The amount this component will modify its owner psi_sensitivity by when they are called by psychic phenomena to check.
	 * This var is allowed to be a floating point, as well as negative values.
	 * See /proc/check_psi_sensitivity() for more information.
	 */
	var/sensitivity_modifier = 0

/datum/component/psi_sensitivity/Initialize()
	. = ..()
	// Components have their parent set before Initialize() is triggered, so it's generally not possible for the component to be missing a parent at this stage.
	// However, we have unit tests that will fire Initialize() against every datum to check if we checked, just in case someone down the line adds a new Initialize() call.
	if (!parent)
		return

	// This is a fundamental pattern for Entity-Component-Systems (ECS).
	// When this component is given to a datum via AddComponent(), such as on a player character
	// the component tells the datum it wishes to do something when this signal happens to the datum.
	// When SendSignal() is later activated on that character, this component will react with its prepared proc.
	RegisterSignal(parent, COMSIG_PSI_CHECK_SENSITIVITY, PROC_REF(modify_sensitivity), override = TRUE)

/datum/component/psi_sensitivity/Destroy()
	. = ..()
	if (!parent)
		return

	// This is the second half of the fundamental pattern for Entity-Component-Systems (ECS)
	// When this component is taken away from a datum via RemoveComponent(), such as from a player character
	// The component tells the character it no longer wishes to do anything when a specific signal happens.
	// We MUST do this for garbage collection reasons, else we'll get hard deletes.
	UnregisterSignal(parent, COMSIG_PSI_CHECK_SENSITIVITY)

/datum/component/psi_sensitivity/proc/modify_sensitivity(var/parent, var/effective_sensitivity)
	SIGNAL_HANDLER
	// Earlier, SendSignal() sent effective_sensitivity as a pointer by marking it as &effective_sensitivity.
	// That means that for this proc, we have the memory address for the original var/effective_sensitivity located in /atom/movable/proc/check_psi_sensitivity()
	// By marking it with the asterisk (*), I'm telling the game "Actually, add directly to the original variable from /atom/movable/proc/check_psi_sensitivity()"
	// The reason we're doing this via pointer is that this allows any number of psi_sensitivity components to touch that variable.
	// If we did this by a Return statement, only the first component would have been allowed to touch it, and all others get ignored.
	*effective_sensitivity += sensitivity_modifier

/**
 * When attached to any datum, this component subscribes to COMSIG_PSI_CHECK_SENSITIVITY on behalf of its owner.
 * It provides a +1 modifier to Psi Sensitivity Checks.
 */
#define HIGH_PSI_SENSITIVITY_COMPONENT /datum/component/psi_sensitivity/high
/datum/component/psi_sensitivity/high
	sensitivity_modifier = 1

/**
 * When attached to any datum, this component subscribes to COMSIG_PSI_CHECK_SENSITIVITY on behalf of its owner.
 * It provides a -1 modifier to Psi Sensitivity Checks.
 */
#define LOW_PSI_SENSITIVITY_COMPONENT /datum/component/psi_sensitivity/low
/datum/component/psi_sensitivity/low
	sensitivity_modifier = -1

/**
 * Component that gets temporarily attached to someone who consumes excessive amounts of Wulumunusha.
 * When the Wulumunusha high wears off, the component deletes itself.
 */
#define WULU_OVERDOSE_COMPONENT /datum/component/psi_sensitivity/wulu_overdose
/datum/component/psi_sensitivity/wulu_overdose
	sensitivity_modifier = 1

// Variant of high-sensitivity that has a two-way brain damage spike.
/**
 * When attached to any datum, this component subscribes to COMSIG_PSI_CHECK_SENSITIVITY and COMSIG_PSI_MIND_POWER on behalf of its owner.
 * It provides a +2 modifier to Psi Sensitivity Checks.
 * It also cancels telepathy attempts, while spiking both owner and caster with painful interference.
 */
#define PSIONIC_ECHOES_COMPONENT /datum/component/psi_sensitivity/echoes
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
