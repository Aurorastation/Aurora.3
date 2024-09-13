/datum/ghostspawner/human/ert/ap_eridani
	name = "Eridani Asset Protection Specialist"
	short_name = "eridaniprotection"
	mob_name_prefix = "Spc. "
	max_count = 2
	desc = "A specialist suited for close asset protection and policing duties. Ensure your colleagues ledgers remain in the black."
	welcome_message = "You are part of an Eridani Private Military Company Asset Protection Team, a highly trained group of security specialists and medical professionals \
	contracted by the Stellar Corporate Conglomerate to protect its investments."
	outfit = /datum/outfit/admin/ert/ap_eridani
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD)

/datum/ghostspawner/human/ert/ap_eridani/lead
	name = "Eridani Section Leader"
	short_name = "eridanileader"
	mob_name_prefix = "Ldr. "
	max_count = 1
	desc = "The leader of the EPMC Asset Protection Team. Ensure your employers bottom line remains protected and don't sign blindly."
	outfit = /datum/outfit/admin/ert/ap_eridani/lead
	possible_species = list(SPECIES_HUMAN)

/datum/ghostspawner/human/ert/ap_eridani/doctor
	name = "Eridani Medical Officer"
	short_name = "eridanidoctor"
	mob_name_prefix = "Dr. "
	max_count = 1
	desc = "A highly trained Eridani medical officer and the second in command of the EPMC Asset Protection Team. Well versed in surgical procedures and expected to work in a hot zone. Not a stranger to a bank run."
	outfit = /datum/outfit/admin/ert/ap_eridani/doctor
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_IPC_SHELL)

/datum/ghostspawner/human/ert/ap_eridani/corpsman
	name = "Eridani Corpsman"
	short_name = "eridanicorpsman"
	mob_name_prefix = "Cm. "
	max_count = 2
	desc = "An Eridani corpsman that can handle nursing duties as well. Trained to operate in combat environments if needed. Make sure to check your quarterlies."
	outfit = /datum/outfit/admin/ert/ap_eridani/corpsman
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_WORKER, SPECIES_IPC, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)
