/obj/item/organ/internal/augment/bioaug/mind_blanker
	name = "mind blanker"
	desc = "A small, discrete organ attached near the base of the brainstem." \
		+ "Any attempt to read the mind of an individual with this augment installed will fail, as will attempts at psychic brainwashing."
	icon_state = "mind_blanker"
	organ_tag = BP_AUG_MIND_BLANKER
	parent_organ = BP_HEAD
	var/sensitivity_modifier = -1

/obj/item/organ/internal/augment/bioaug/mind_blanker/Initialize()
	. = ..()
	if(!owner)
		return

	RegisterSignal(owner, COMSIG_PSI_MIND_POWER, PROC_REF(cancel_power), override = TRUE)
	RegisterSignal(owner, COMSIG_PSI_CHECK_SENSITIVITY, PROC_REF(modify_sensitivity), override = TRUE)
	RegisterSignal(owner, COMSIG_GET_MINISTRY_MODIFIERS, PROC_REF(modify_ministry_empathy), override = TRUE)
	RegisterSignal(owner, COMSIG_RECEIVE_MINISTRY_MODIFIERS, PROC_REF(modify_ministry_receiving), override = TRUE)

/obj/item/organ/internal/augment/bioaug/mind_blanker/replaced()
	. = ..()
	if(!owner)
		return

	RegisterSignal(owner, COMSIG_PSI_MIND_POWER, PROC_REF(cancel_power), override = TRUE)
	RegisterSignal(owner, COMSIG_PSI_CHECK_SENSITIVITY, PROC_REF(modify_sensitivity), override = TRUE)
	RegisterSignal(owner, COMSIG_GET_MINISTRY_MODIFIERS, PROC_REF(modify_ministry_empathy), override = TRUE)
	RegisterSignal(owner, COMSIG_RECEIVE_MINISTRY_MODIFIERS, PROC_REF(modify_ministry_receiving), override = TRUE)

/obj/item/organ/internal/augment/bioaug/mind_blanker/removed()
	if(!owner)
		return ..()

	UnregisterSignal(owner, COMSIG_PSI_MIND_POWER)
	UnregisterSignal(owner, COMSIG_PSI_CHECK_SENSITIVITY)
	UnregisterSignal(owner, COMSIG_GET_MINISTRY_MODIFIERS)
	UnregisterSignal(owner, COMSIG_RECEIVE_MINISTRY_MODIFIERS)
	return ..()

/obj/item/organ/internal/augment/bioaug/mind_blanker/proc/cancel_power(implantee, caster, cancelled, cancel_return, wide_field)
	SIGNAL_HANDLER
	if(is_broken())
		return

	*cancelled = TRUE
	if(wide_field || implantee == caster)
		return

	to_chat(implantee, SPAN_DANGER("Your mind wriggles as it repulses an outside thought."))

/obj/item/organ/internal/augment/bioaug/mind_blanker/proc/modify_sensitivity(implantee, effective_sensitivity)
	SIGNAL_HANDLER
	if(is_broken())
		return

	*effective_sensitivity += sensitivity_modifier

/obj/item/organ/internal/augment/bioaug/mind_blanker/proc/modify_ministry_empathy(minister, ministree, moodlet_value)
	SIGNAL_HANDLER
	if (!(*moodlet_value))
		return

	to_chat(minister, SPAN_BAD("Why should you care how [ministree.name] feels?"))
	*moodlet_value = 0

/obj/item/organ/internal/augment/bioaug/mind_blanker/proc/modify_ministry_receiving(ministree, minister, moodlet_value)
	SIGNAL_HANDLER
	if (!(*moodlet_value))
		return

	to_chat(ministree, SPAN_BAD("You feel nothing from [minister.name]'s words."))
	*moodlet_value = 0

/obj/item/organ/internal/augment/bioaug/mind_blanker_lethal
	name = "lethal mind blanker"
	desc = "A small, discrete organ attached near the base of the brainstem." \
		+ "Available only to higher-up MfAS agents and members of the Galatean government." \
		+ "This enhanced variant of a mind blanker includes a psionic trap which inflicts severe neural damage on anyone attempting to read the user's mind."
	organ_tag = BP_AUG_MIND_BLANKER_L
	parent_organ = BP_HEAD
	var/sensitivity_modifier = -1

/obj/item/organ/internal/augment/bioaug/mind_blanker_lethal/Initialize()
	. = ..()
	if(!owner)
		return

	RegisterSignal(owner, COMSIG_PSI_MIND_POWER, PROC_REF(cancel_power_lethal), override = TRUE)
	RegisterSignal(owner, COMSIG_PSI_CHECK_SENSITIVITY, PROC_REF(modify_sensitivity), override = TRUE)

/obj/item/organ/internal/augment/bioaug/mind_blanker_lethal/replaced()
	. = ..()
	if(!owner)
		return

	RegisterSignal(owner, COMSIG_PSI_MIND_POWER, PROC_REF(cancel_power_lethal), override = TRUE)
	RegisterSignal(owner, COMSIG_PSI_CHECK_SENSITIVITY, PROC_REF(modify_sensitivity), override = TRUE)

/obj/item/organ/internal/augment/bioaug/mind_blanker_lethal/removed()
	. = ..()
	if(!owner)
		return

	UnregisterSignal(owner, COMSIG_PSI_MIND_POWER)
	UnregisterSignal(owner, COMSIG_PSI_CHECK_SENSITIVITY)

/obj/item/organ/internal/augment/bioaug/mind_blanker_lethal/proc/cancel_power_lethal(mob/living/carbon/human/implantee, caster, cancelled, cancel_return, wide_field)
	SIGNAL_HANDLER
	if(is_broken())
		return

	*cancelled = TRUE
	if(wide_field || implantee == caster)
		return

	to_chat(implantee, SPAN_DANGER("Your mind wriggles as it repulses an outside thought."))
	if(isliving(caster))
		var/mob/living/victim = caster
		victim.adjustBrainLoss(20)
		victim.confused += 20
		*cancel_return = SPAN_DANGER("Agony lances through my brain as their mind clamps down upon me!")

/obj/item/organ/internal/augment/bioaug/mind_blanker_lethal/proc/modify_sensitivity(implantee, effective_sensitivity)
	SIGNAL_HANDLER
	if(is_broken())
		return

	*effective_sensitivity += sensitivity_modifier
