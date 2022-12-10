/datum/ghostspawner/human/ert/nanotrasen
	name = "NanoTrasen Responder"
	short_name = "ntert"
	desc = "A responder of the NanoTrasen Phoenix ERT."
	welcome_message = "You're part of the NanoTrasen Phoenix ERT, stationed at the Odin. Your usual powers apply here."
	max_count = 2
	outfit = /datum/outfit/admin/ert/nanotrasen
	mob_name_prefix = "Tpr. "
	possible_species = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI)
	spawnpoints = list("NTERTSpawn")

/datum/ghostspawner/human/ert/nanotrasen/specialist
	name = "NanoTrasen Engineering Specialist"
	short_name = "nteng"
	desc = "An engineering specialist of the NanoTrasen Phoenix ERT."
	max_count = 1
	outfit = /datum/outfit/admin/ert/nanotrasen/specialist
	mob_name_prefix = "S/Tpr. "

/datum/ghostspawner/human/ert/nanotrasen/specialist/med
	name = "NanoTrasen Medical Specialist"
	short_name = "ntmed"
	desc = "A medical specialist of the NanoTrasen Phoenix ERT."
	outfit = /datum/outfit/admin/ert/nanotrasen/specialist/medical

/datum/ghostspawner/human/ert/nanotrasen/leader
	name = "NanoTrasen Leader"
	short_name = "ntlead"
	desc = "The leader of the NanoTrasen Phoenix ERT."
	max_count = 1
	mob_name_prefix = "L/Tpr. "