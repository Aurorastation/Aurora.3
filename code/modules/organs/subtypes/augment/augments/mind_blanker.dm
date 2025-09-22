/obj/item/organ/internal/augment/bioaug/mind_blanker
	name = "mind blanker"
	desc = "A small, discrete organ attached near the base of the brainstem." \
		+ "Any attempt to read the mind of an individual with this augment installed will fail, as will attempts at psychic brainwashing."
	icon_state = "mind_blanker"
	organ_tag = BP_AUG_MIND_BLANKER
	parent_organ = BP_HEAD

/obj/item/organ/internal/augment/bioaug/mind_blanker/Initialize()
	. = ..()
	if(!owner)
		return

	RegisterSignal(owner, COMSIG_PSI_MIND_POWER, PROC_REF(cancel_power))

/obj/item/organ/internal/augment/bioaug/mind_blanker/replaced()
	. = ..()
	if(!owner)
		return

	RegisterSignal(owner, COMSIG_PSI_MIND_POWER, PROC_REF(cancel_power))

/obj/item/organ/internal/augment/bioaug/mind_blanker/removed()
	. = ..()
	if(!owner)
		return

	UnregisterSignal(owner, COMSIG_PSI_MIND_POWER)

/obj/item/organ/internal/augment/bioaug/mind_blanker/proc/cancel_power(var/implantee, var/caster, var/cancelled)
	SIGNAL_HANDLER
	*cancelled = TRUE

/obj/item/organ/internal/augment/bioaug/mind_blanker_lethal
	name = "lethal mind blanker"
	desc = "A small, discrete organ attached near the base of the brainstem." \
		+ "Available only to higher-up MfAS agents and members of the Galatean government." \
		+ "This enhanced variant of a mind blanker includes a psionic trap which inflicts severe neural damage on anyone attempting to read the user's mind."
	organ_tag = BP_AUG_MIND_BLANKER_L
	parent_organ = BP_HEAD

/obj/item/organ/internal/augment/bioaug/mind_blanker_lethal/Initialize()
	. = ..()
	if(!owner)
		return

	RegisterSignal(owner, COMSIG_PSI_MIND_POWER, PROC_REF(cancel_power_lethal))

/obj/item/organ/internal/augment/bioaug/mind_blanker_lethal/replaced()
	. = ..()
	if(!owner)
		return

	RegisterSignal(owner, COMSIG_PSI_MIND_POWER, PROC_REF(cancel_power_lethal))

/obj/item/organ/internal/augment/bioaug/mind_blanker_lethal/removed()
	. = ..()
	if(!owner)
		return

	UnregisterSignal(owner, COMSIG_PSI_MIND_POWER)

/obj/item/organ/internal/augment/bioaug/mind_blanker_lethal/proc/cancel_power_lethal(var/implantee, var/caster, var/cancelled)
	SIGNAL_HANDLER
	*cancelled = TRUE
	if(isliving(caster))
		var/mob/living/victim = caster
		victim.adjustBrainLoss(20)
		victim.confused += 20
		to_chat(victim, SPAN_DANGER("Agony lances through my mind as [src]'s mind clamps down upon me!"))
