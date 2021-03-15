/datum/ghostspawner/human/ert/med_eridani
	name = "Eridani Medical Contractor Doctor"
	short_name = "eridanidoctor"
	mob_name_prefix = "Dr. "
	max_count = 2
	desc = "A highly trained Eridani contractor doctor medical doctor. Can do most medical procedures even under severe stress."
	welcome_message = "You are part of the Eridani Medical Contractor Team, a highly trained team of medical profissional."
	outfit = /datum/outfit/admin/ert/med_eridani
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_DIONA, SPECIES_UNATHI, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_WORKER, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_GETMOREAN)

/datum/ghostspawner/human/ert/med_eridani/bodyguard
	name = "Eridani Medical Contractor Bodyguard"
	short_name = "eridanidocbodyguard"
	mob_name_prefix = "Bdg. "
	max_count = 2
	desc = "A highly trained bodyguard. Sticks close to the medics while they work."
	outfit = /datum/outfit/admin/ert/med_eridani/bodyguard
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD)


/datum/ghostspawner/human/ert/med_eridani/paramedic
	name = "Eridani Medical Contractor Paramedic"
	short_name = "eridaniparamedic"
	mob_name_prefix = "Pm. "
	max_count = 2
	desc = "A highly trained paramedic. You grab injured people and bring them to the medical doctor. You are trained in nursing duties as well."
	outfit = /datum/outfit/admin/ert/med_eridani/paramedic
