/obj/item/organ/internal/augment/bioaug/psi
	name = "psionic receiver"
	desc = "A cybernetic implant that allows for the carrier of a receiver to be sensitive enough to accept and interpret psionic signals " \
		+ "Essentially an implanted and carefully encased cultured zona bovinae, these receivers are regularly found within dionae and vaurca who otherwise lack this specialized portion of the brain entirely." \
		+ "It is also used by other sophonts who regularly interact with skrell to the point of necessitating it." \
		+ "Some psionically weak skrell will also implant themselves with a receiver in the same way a hearing aid is utilized."
	organ_tag = BP_AUG_PSI
	parent_organ = BP_HEAD
	species_restricted = list(
		SPECIES_HUMAN_OFFWORLD,
		SPECIES_HUMAN,
		SPECIES_SKRELL_AXIORI,
		SPECIES_SKRELL,
		SPECIES_TAJARA_MSAI,
		SPECIES_TAJARA_ZHAN,
		SPECIES_TAJARA,
		SPECIES_UNATHI,
	)
	var/sensitivity_modifier = 1

/obj/item/organ/internal/augment/bioaug/psi/Initialize()
	. = ..()
	if(!owner)
		return

	RegisterSignal(owner, COMSIG_PSI_CHECK_SENSITIVITY, PROC_REF(modify_sensitivity), override = TRUE)

/obj/item/organ/internal/augment/bioaug/psi/replaced()
	. = ..()
	if(!owner)
		return

	RegisterSignal(owner, COMSIG_PSI_CHECK_SENSITIVITY, PROC_REF(modify_sensitivity), override = TRUE)

/obj/item/organ/internal/augment/bioaug/psi/removed()
	. = ..()
	if(!owner)
		return

	UnregisterSignal(owner, COMSIG_PSI_CHECK_SENSITIVITY)

/obj/item/organ/internal/augment/bioaug/psi/proc/modify_sensitivity(var/implantee, var/effective_sensitivity)
	SIGNAL_HANDLER
	if(is_broken())
		return

	*effective_sensitivity += sensitivity_modifier
