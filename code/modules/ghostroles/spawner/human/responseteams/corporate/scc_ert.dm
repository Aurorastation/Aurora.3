/datum/ghostspawner/human/ert/scc
	name = "SCC Responder"
	short_name = "sccert"
	desc = "A Stellar Corporate Conglomerate emergency responder."
	welcome_message = "You are part of an SCC asset protection squad, sent in response to a distress call. Obey your commander and safeguard SCC assets."
	max_count = 2
	outfit = /obj/outfit/admin/ert/scc
	mob_name_prefix = "Tpr. "
	possible_species = list(SPECIES_HUMAN) //no one made an scc skrellmet
	spawnpoints = list("NTERTSpawn")

/datum/ghostspawner/human/ert/scc/engineer
	name = "SCC Engineering Specialist"
	short_name = "scceng"
	desc = "An engineering specialist of the Stellar Corporate Conglomerate ERT."
	max_count = 1
	mob_name_prefix = "S/Tpr. "
	outfit = /obj/outfit/admin/ert/scc/engineer

/datum/ghostspawner/human/ert/scc/medic
	name = "SCC Medical Specialist"
	short_name = "sccmed"
	desc = "A medical specialist of the Stellar Corporate Conglomerate ERT."
	max_count = 1
	outfit = /obj/outfit/admin/ert/scc/medic

/datum/ghostspawner/human/ert/scc/commander
	name = "SCC ERT Commander"
	short_name = "scclead"
	desc = "The commander of the Stellar Corporate Conglomerate ERT."
	max_count = 1
	mob_name_prefix = "L/Tpr. "
	outfit = /obj/outfit/admin/ert/scc/commander
