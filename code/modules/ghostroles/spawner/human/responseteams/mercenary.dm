/datum/ghostspawner/human/ert/mercenary
	name = "Mercenary Responder"
	short_name = "mercr"
	max_count = 2
	desc = "Rank and file of a freelancer mercenary team."
	welcome_message = "You're part of a freelancing mercenary team who just picked up a distress beacon coming from the Aurora. You have no affiliation to anyone, but you sure do want a quick buck."
	outfit = /datum/outfit/admin/ert/mercenary
	possible_species = list(SPECIES_HUMAN, SPECIES_OFFWORLDER_HUMAN, SPECIES_TAJARA, SPECIES_MSAI_TJARA, SPECIES_ZHAN_KHAZAN_TAJARA
, SPECIES_SKRELL, SPECIES_DIONA, SPECIES_UNATHI, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_WORKER, SPECIES_IPC, SPECIES_HEPHAESTUS_G1_IPC, SPECIES_HEPHAESTUS_G2_IPC, SPECIES_XION_IPC, SPECIES_ZENGHU_IPC, SPECIES_BISHOP_IPC, SPECIES_SHELL_IPC)

/datum/ghostspawner/human/ert/mercenary/specialist
	name = "Mercenary Medical Specialist"
	short_name = "mercs"
	max_count = 1
	desc = "The only medic of the freelancer mercenary team."
	outfit = /datum/outfit/admin/ert/mercenary/specialist

/datum/ghostspawner/human/ert/mercenary/engineer
	name = "Mercenary Combat Engineer"
	short_name = "merce"
	max_count = 1
	desc = "The only dedicated engineer of the freelancer mercenary team."
	outfit = /datum/outfit/admin/ert/mercenary/engineer

/datum/ghostspawner/human/ert/mercenary/leader
	name = "Mercenary Leader"
	short_name = "mercl"
	max_count = 1
	desc = "The leader of the freelancer mercenary team."
	outfit = /datum/outfit/admin/ert/mercenary/leader
