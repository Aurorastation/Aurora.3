var/global/list/psychic_ranks_to_strings = list("Psionically Deaf", "Psionically Sensitive", "Psionically Harmonious", "Psionic Apex")

/var/datum/controller/subsystem/processing/psi/SSpsi

/datum/controller/subsystem/processing/psi
	name = "Psychics"
	priority = SS_PRIORITY_PSYCHICS
	flags = SS_POST_FIRE_TIMING | SS_BACKGROUND

	var/last_nlom_awareness_check = 0
	var/list/all_aura_images = list()
	var/list/all_psi_complexes = list()

/datum/controller/subsystem/processing/psi/New()
	NEW_SS_GLOBAL(SSpsi)

/datum/controller/subsystem/processing/psi/Initialize()
	. = ..()

/datum/controller/subsystem/processing/psi/process()
	/// nlom awareness check here
