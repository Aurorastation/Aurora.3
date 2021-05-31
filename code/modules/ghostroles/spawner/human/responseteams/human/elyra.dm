/datum/ghostspawner/human/ert/elyra
	short_name = "elyra_trooper"
	name = "Elyran Trooper"
	desc = "Rank and file of the Elyran Navy."
	welcome_message = "Your crew has is answering to a distress signal. Obey the orders of your commander."
	max_count = 3

	outfit = /datum/outfit/admin/ert/elyran_trooper
	possible_species = list(SPECIES_HUMAN)

	extra_languages = list(LANGUAGE_SOL_COMMON)

/datum/ghostspawner/human/ert/elyra/leader
	short_name = "elyra_leadertrooper"
	name = "Elyran Commander"
	desc = "The leader of the Elyran Navy squad."
	welcome_message = "Your crew has is answering to a distress signal. Lead your squad."
	max_count = 1
	outfit = /datum/outfit/admin/ert/elyran_trooper/leader

/datum/ghostspawner/human/ert/elyra/engineer
	short_name = "elyra_engtrooper"
	name = "Elyran Engineering Trooper"
	desc = "The engineering trooper of the Elyran Navy squad."
	max_count = 1
	outfit = /datum/outfit/admin/ert/elyran_trooper/engineer

/datum/ghostspawner/human/ert/elyra/heavy
	short_name = "elyra_heavy"
	name = "Elyran Heavy Trooper"
	desc = "The heavy trooper of the Elyran Navy squad."
	max_count = 1
	outfit = /datum/outfit/admin/ert/elyran_trooper/heavy

/datum/ghostspawner/human/ert/elyra/medical
	short_name = "elyra_medtrooper"
	name = "Elyran Medical Trooper"
	desc = "The medical trooper of the Elyran Navy squad."
	max_count = 1
	outfit = /datum/outfit/admin/ert/elyran_trooper/medical