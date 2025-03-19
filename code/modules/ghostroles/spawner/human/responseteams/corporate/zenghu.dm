/datum/ghostspawner/human/ert/zeng
	name = "Zeng-Hu Pharmaceuticals Asset Protection"
	short_name = "zengert"
	desc = "A responder from a Zeng-Hu Pharmaceuticals asset protection squad."
	max_count = 2
	welcome_message = "You are a member of a Zeng-Hu heavy asset protection squad. You have recieved a distress call, and been dispatched to investigate. Obey your commander's orders."
	outfit = /obj/outfit/admin/ert/zeng
	possible_species = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	assigned_role = "Asset Protection (Zeng)"

/datum/ghostspawner/human/ert/zeng/medical
	name = "Zeng-Hu Pharmaceuticals Medical Specialist"
	short_name = "zengertmed"
	desc = "A medical specialist from a Zeng-Hu Pharmaceuticals asset protection squad."
	max_count = 1
	outfit = /obj/outfit/admin/ert/zeng/medic

/datum/ghostspawner/human/ert/zeng/engineer
	name = "Zeng-Hu Pharmaceuticals Engineering Specialist"
	short_name = "zengerteng"
	desc = "An engineering specialist from a Zeng-Hu Pharmaceuticals asset protection squad."
	max_count = 1
	outfit = /obj/outfit/admin/ert/zeng/engineer

/datum/ghostspawner/human/ert/zeng/leader
	name = "Zeng-Hu Pharmaceuticals Squad Leader"
	short_name = "zengertlead"
	desc = "The commander of a Zeng-Hu Pharmaceuticals asset protection squad."
	max_count = 1
	outfit = /obj/outfit/admin/ert/zeng/leader
	welcome_message = "You are the commander of a Zeng-Hu heavy asset protection squad. You have recieved a distress call, and been dispatched to investigate. Lead your team."
	assigned_role = "Asset Protection Commander (Zavod)"
