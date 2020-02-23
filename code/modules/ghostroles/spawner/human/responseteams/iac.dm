/datum/ghostspawner/human/ert/iac
	name = "IAC Doctor"
	short_name = "iacdoctor"
	max_count = 1
	desc = "A highly trained doctor. Can do most medical procedures even under severe stress. The de-facto lead of the IAC response team."
	welcome_message = "You are part of the Interstellar Aid Corps, an intergalactic entity set on aiding all in need."
	outfit = /datum/outfit/admin/ert/iac
	possible_species = list(SPECIES_HUMAN, SPECIES_OFFWORLDER_HUMAN, SPECIES_TAJARA, SPECIES_MSAI_TJARA, SPECIES_ZHAN_KHAZAN_TAJARA
, SPECIES_SKRELL, SPECIES_DIONA, SPECIES_UNATHI, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_WORKER, SPECIES_IPC, SPECIES_HEPHAESTUS_G1_IPC, SPECIES_HEPHAESTUS_G2_IPC, SPECIES_XION_IPC, SPECIES_ZENGHU_IPC, SPECIES_BISHOP_IPC, SPECIES_SHELL_IPC)

/datum/ghostspawner/human/ert/iac/bodyguard
	name = "IAC Bodyguard"
	short_name = "iacbodyguard"
	max_count = 1
	desc = "A highly trained bodyguard. Sticks close to the medics while they work."
	outfit = /datum/outfit/admin/ert/iac/bodyguard

/datum/ghostspawner/human/ert/iac/paramedic
	name = "IAC Paramedic"
	short_name = "iacparamedic"
	max_count = 2
	desc = "A highly trained paramedic. You grab injured people and bring them to the doctor. You are trained in nursing duties as well."
	outfit = /datum/outfit/admin/ert/iac/paramedic
