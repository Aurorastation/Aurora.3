/obj/item/organ/internal/augment/psi
	name = "psionic receiver"
	desc = "A cybernetic implant that allows for the carrier of a receiver to be sensitive enough to accept and interpret psionic signals " \
		+ "Essentially an implanted and carefully encased cultured zona bovinae, these receivers are regularly found within dionae and vaurca who otherwise lack this specialized portion of the brain entirely." \
		+ "It is also used by other sophonts who regularly interact with skrell to the point of necessitating it." \
		+ "Some psionically weak skrell will also implant themselves with a receiver in the same way a hearing aid is utilized."
	organ_tag = BP_AUG_PSI
	parent_organ = BP_HEAD
	var/sensitivity_modifier = 1

/obj/item/organ/internal/augment/psi/Initialize()
	. = ..()
	if(!owner)
		return

	RegisterSignal(owner, COMSIG_PSI_CHECK_SENSITIVITY, PROC_REF(modify_sensitivity), override = TRUE)

/obj/item/organ/internal/augment/psi/replaced()
	. = ..()
	if(!owner)
		return

	RegisterSignal(owner, COMSIG_PSI_CHECK_SENSITIVITY, PROC_REF(modify_sensitivity), override = TRUE)

/obj/item/organ/internal/augment/psi/removed()
	. = ..()
	if(!owner)
		return

	UnregisterSignal(owner, COMSIG_PSI_CHECK_SENSITIVITY)

/obj/item/organ/internal/augment/psi/proc/modify_sensitivity(var/implantee, var/effective_sensitivity)
	SIGNAL_HANDLER
	*effective_sensitivity += sensitivity_modifier
