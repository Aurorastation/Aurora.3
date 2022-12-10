/datum/ghostspawner/human/ert/iac
	name = "IAC Doctor"
	short_name = "iacdoctor"
	mob_name_prefix = "Dr. "
	max_count = 3
	desc = "A highly trained doctor. Can do most medical procedures even under severe stress. The de-facto lead of the IAC response team."
	welcome_message = "You are part of the Interstellar Aid Corps, an intergalactic entity set on aiding all in need."
	outfit = /datum/outfit/admin/ert/iac
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_DIONA, SPECIES_UNATHI, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_WORKER, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)

/datum/ghostspawner/human/ert/iac/bodyguard
	name = "IAC Bodyguard"
	short_name = "iacbodyguard"
	mob_name_prefix = "Bdg. "
	max_count = 2
	desc = "A highly trained bodyguard. Sticks close to the medics while they work."
	outfit = /datum/outfit/admin/ert/iac/bodyguard

/datum/ghostspawner/human/ert/iac/paramedic
	name = "IAC Paramedic"
	short_name = "iacparamedic"
	mob_name_prefix = "Pm. "
	max_count = 2
	desc = "A highly trained paramedic. You grab injured people and bring them to the doctor. You are trained in nursing duties as well."
	outfit = /datum/outfit/admin/ert/iac/paramedic
