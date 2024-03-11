/datum/ghostspawner/human/ert/coalition
	name = "Coalition Ranger"
	short_name = "cocr"
	max_count = 3
	desc = "Rank and file of the Frontier Ranger response team."
	welcome_message = "You are a Ranger with the Frontier Protection Bureau. Your vessel has recieved a distress signal, and you were sent to investigate. Obey the orders of your commander."
	outfit = /obj/outfit/admin/ert/coalition
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD)

/datum/ghostspawner/human/ert/coalition/medic
	name = "Coalition Ranger Medic"
	short_name = "cocm"
	max_count = 1
	desc = "Medical specialist of the Frontier Ranger response team."
	outfit = /obj/outfit/admin/ert/coalition/medic

/datum/ghostspawner/human/ert/coalition/engineer
	name = "Coalition Ranger Sapper"
	short_name = "coce"
	max_count = 1
	desc = "Sapper and engineering specialist of the Frontier Ranger response team."
	outfit = /obj/outfit/admin/ert/coalition/sapper

/datum/ghostspawner/human/ert/coalition/leader
	name = "Coalition Ranger Squad Leader"
	short_name = "cocl"
	max_count = 1
	desc = "Commander of the Frontier Ranger response team."
	welcome_message = "You are the commander of a Frontier Ranger patrol vessel. While on patrol, your ship received a distress signal and you were sent to investigate. Lead your team."
	outfit = /obj/outfit/admin/ert/coalition/leader

/datum/ghostspawner/human/ert/konyang
	name = "Konyang Aerospace Force Crewman"
	short_name = "konc"
	desc = "Rank and file of the Konyang Aerospace Force"
	welcome_message = "You are a crewman with the Konyang Aerospace Force. You have recieved a distress signal and been dispatched to investigate. Obey your commander."
	outfit = /obj/outfit/admin/ert/konyang
	max_count = 3
	mob_name_prefix = "PO3. "
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)

/datum/ghostspawner/human/ert/konyang/medic
	name = "Konyang Aerospace Force Medic"
	short_name = "konm"
	desc = "Medical specialist of the Konyang Aerospace Force."
	mob_name_prefix = "PO2. "
	outfit = /obj/outfit/admin/ert/konyang/medic
	max_count = 1

/datum/ghostspawner/human/ert/konyang/sapper
	name = "Konyang Aerospace Force Sapper"
	short_name = "kons"
	desc = "Sapper and engineering specialist of the Konyang Aerospace Force."
	mob_name_prefix = "PO1. "
	outfit = /obj/outfit/admin/ert/konyang/sapper
	max_count = 1

/datum/ghostspawner/human/ert/konyang/leader
	name = "Konyang Aerospace Force Squad Leader"
	short_name = "konl"
	desc = "Commander of the Konyang Aerospace Force response team."
	welcome_message = "You are an officer of the Konyang Aerospace Force. While on patrol, your ship received a distress signal and you were sent to investigate. Lead your team."
	mob_name_prefix = "LT. "
	outfit = /obj/outfit/admin/ert/konyang/leader
	max_count = 1
