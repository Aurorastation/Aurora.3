/datum/ghostspawner/human/ert/elyra
	short_name = "elyra_trooper"
	name = "Elyran Navy Crewman"
	desc = "Rank and file of the Elyran Navy."
	welcome_message = "You're a member of the Elyran Navy. While on patrol, your ship received a distress signal and you were sent to investigate. Obey the orders of your commander."
	max_count = 3
	mob_name_prefix = "Cm. "
	outfit = /datum/outfit/admin/ert/elyran_trooper
	possible_species = list(SPECIES_HUMAN)

	extra_languages = list(LANGUAGE_ELYRAN_STANDARD)

/datum/ghostspawner/human/ert/elyra/leader
	short_name = "elyra_leadertrooper"
	name = "Elyran Navy Officer"
	desc = "The leader of the Elyran Navy squad."
	welcome_message = "You're an officer of the Elyran Navy. While on patrol, your ship received a distress signal and you were sent to investigate. Lead your team."
	mob_name_prefix = "Ens. "
	max_count = 1
	outfit = /datum/outfit/admin/ert/elyran_trooper/leader

/datum/ghostspawner/human/ert/elyra/engineer
	short_name = "elyra_engtrooper"
	name = "Elyran Navy Engineer"
	desc = "The engineering trooper of the Elyran Navy team."
	mob_name_prefix = "PO3. "
	max_count = 1
	outfit = /datum/outfit/admin/ert/elyran_trooper/engineer

/datum/ghostspawner/human/ert/elyra/heavy
	short_name = "elyra_heavy"
	name = "Elyran Navy Heavy Specialist"
	desc = "The heavy trooper of the Elyran Navy team."
	mob_name_prefix = "PO3. "
	max_count = 1
	outfit = /datum/outfit/admin/ert/elyran_trooper/heavy

/datum/ghostspawner/human/ert/elyra/medical
	short_name = "elyra_medtrooper"
	name = "Elyran Navy Corpsman"
	desc = "The medical trooper of the Elyran Navy team."
	mob_name_prefix = "PO3. "
	max_count = 1
	outfit = /datum/outfit/admin/ert/elyran_trooper/medical
