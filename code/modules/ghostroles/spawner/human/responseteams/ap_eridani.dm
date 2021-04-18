/datum/ghostspawner/human/ert/ap_eridani
	name = "Eridani Security Specialist "
	short_name = "eridaniassetprotection"
	mob_name_prefix = "Spc. "
	max_count = 2
	desc = "A highly trained Eridani security specialist. Ensure your colleagues ledgers remain in the black."
	welcome_message = "You are part of an Eridani Private Military Company Asset Protection Team, a highly trained group of security specialists and medical professionals \
	contracted by the Stellar Corporate Conglomerate to protect its investments."
	outfit = /datum/outfit/admin/ert/ap_eridani
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD)

/datum/ghostspawner/human/ert/ap_eridani/commander
	name = "Eridani Section Commander"
	short_name = "eridanicommander"
	mob_name_prefix = "Cmdr. "
	max_count = 1
	desc = "The leader of the EPMC Asset Protection Team. Ensure your employers bottom line remains protected."
	outfit = /datum/outfit/admin/ert/ap_eridani/commander
	possible_species = list(SPECIES_HUMAN)

/datum/ghostspawner/human/ert/ap_eridani/doctor
	name = "Eridani Doctor"
	short_name = "eridanidoctor"
	mob_name_prefix = "Dr. "
	max_count = 1
	desc = "A highly trained Eridani medical doctor. Can do most medical procedures even under severe stress."
	outfit = /datum/outfit/admin/ert/ap_eridani/doctor
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_DIONA, SPECIES_UNATHI, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_WORKER, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)

/datum/ghostspawner/human/ert/ap_eridani/doctor
	name = "Eridani Paramedic"
	short_name = "eridaniparamedic"
	mob_name_prefix = "Pm. "
	max_count = 2
	desc = "A highly trained Eridani paramedic that can handle nursing duties as well. Expected to operate in potential hot zones."
	outfit = /datum/outfit/admin/ert/ap_eridani/paramedic
