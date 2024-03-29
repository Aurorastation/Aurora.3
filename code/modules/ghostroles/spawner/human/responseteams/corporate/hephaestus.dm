/datum/ghostspawner/human/ert/hephaestus
	name = "Hephaestus Industries Asset Protection"
	short_name = "hephert"
	desc = "A responder from a Hephaestus Industries asset protection squad."
	max_count = 2
	welcome_message = "You are a member of a Hephaestus heavy asset protection squad. You have recieved a distress call, and been dispatched to investigate. Obey your commander's orders."
	outfit = /obj/outfit/admin/ert/hephaestus
	possible_species = list(SPECIES_HUMAN, SPECIES_UNATHI)
	assigned_role = "Asset Protection (Hepht)"

/datum/ghostspawner/human/ert/hephaestus/medical
	name = "Hephaestus Industries Medical Specialist"
	short_name = "hephmed"
	desc = "A medical specialist from a Hephaestus Industries asset protection squad."
	max_count = 1
	outfit = /obj/outfit/admin/ert/hephaestus/medic

/datum/ghostspawner/human/ert/hephaestus/engineer
	name = "Hephaestus Industries Engineering Specialist"
	short_name = "hepheng"
	desc = "An engineering specialist from a Hephaestus Industries asset protection squad."
	max_count = 1
	outfit = /obj/outfit/admin/ert/hephaestus/engi

/datum/ghostspawner/human/ert/hephaestus/leader
	name = "Hephaestus Industries Squad Leader"
	short_name = "hephlead"
	desc = "The commander of a Hephaestus Industries asset protection squad."
	max_count = 1
	outfit = /obj/outfit/admin/ert/hephaestus/leader
	welcome_message = "You are the commander of a Hephaestus heavy asset protection squad. You have recieved a distress call, and been dispatched to investigate. Lead your team."

