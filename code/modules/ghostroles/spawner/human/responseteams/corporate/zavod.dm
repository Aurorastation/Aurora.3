/datum/ghostspawner/human/ert/zavodskoi
	name = "Zavodskoi Interstellar Asset Protection"
	short_name = "zavodert"
	desc = "A responder from a Zavodskoi Interstellar asset protection squad."
	max_count = 2
	welcome_message = "You are a member of a Zavodskoi heavy asset protection squad. You have recieved a distress call, and been dispatched to investigate. Obey your commander's orders."
	outfit = /obj/outfit/admin/ert/zavodskoi
	possible_species = list(SPECIES_HUMAN) //Only humans have Zavod voidsuit sprites currently
	assigned_role = "Asset Protection (Zavod)"

/datum/ghostspawner/human/ert/zavodskoi/medical
	name = "Zavodskoi Interstellar Medical Specialist"
	short_name = "zavmed"
	desc = "A medical specialist from a Zavodskoi Interstellar asset protection squad."
	max_count = 1
	outfit = /obj/outfit/admin/ert/zavodskoi/medic

/datum/ghostspawner/human/ert/zavodskoi/engineer
	name = "Zavodskoi Interstellar Engineering Specialist"
	short_name = "zaveng"
	desc = "An engineering specialist from a Zavodskoi Interstellar asset protection squad."
	max_count = 1
	outfit = /obj/outfit/admin/ert/zavodskoi/engi

/datum/ghostspawner/human/ert/zavodskoi/leader
	name = "Zavodskoi Interstellar Squad Leader"
	short_name = "zavlead"
	desc = "The commander of a Zavodskoi Interstellar asset protection squad."
	max_count = 1
	outfit = /obj/outfit/admin/ert/zavodskoi/lead
	welcome_message = "You are the commander of a Zavodskoi heavy asset protection squad. You have recieved a distress call, and been dispatched to investigate. Lead your team."
	assigned_role = "Asset Protection Commander (Zavod)"
