/datum/ghostspawner/human/ert/qukala
	name = "Qukala Responder"
	short_name = "ertkala"
	desc = "A soldier of the Qukala response team."
	max_count = 2
	outfit = /obj/outfit/admin/ert/qukala
	uses_species_whitelist = FALSE
	possible_species = list(SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_VAURCA_WARRIOR, SPECIES_DIONA)
	welcome_message = "You are a soldier of the Nralakk Federation Qukala, assigned to respond to a distress call from the SCCV Horizon."
	assigned_role = "Qukala Responder"

/datum/ghostspawner/human/ert/qukala/medic
	name = "Qukala Medic"
	short_name = "ertkalam"
	desc = "A medical specialist of the Qukala response team."
	max_count = 1
	outfit = /obj/outfit/admin/ert/qukala/medic
	welcome_message = "You are a medical specialist of the Nralakk Federation Qukala, assigned to respond to a distress call from the SCCV Horizon."
	assigned_role = "Qukala Medic"

/datum/ghostspawner/human/ert/qukala/engineer
	name = "Qukala Engineer"
	short_name = "ertkalae"
	desc = "An engineering specialist of the Qukala response team."
	max_count = 1
	outfit = /obj/outfit/admin/ert/qukala/engi
	welcome_message = "You are an engineering specialist of the Nralakk Federation Qukala, assigned to respond to a distress call from the SCCV Horizon."
	assigned_role = "Qukala Engineer"

/datum/ghostspawner/human/ert/qukala/heavy
	name = "Qukala Heavy Trooper"
	short_name = "ertkalah"
	desc = "A heavy weapons specialist of the Qukala response team."
	max_count = 1
	outfit = /obj/outfit/admin/ert/qukala/heavy
	possible_species = list(SPECIES_SKRELL, SPECIES_SKRELL_AXIORI) //hardsuit only has skrell sprites
	welcome_message = "You are a heavy weapons specialist of the Nralakk Federation Qukala, assigned to respond to a distress call from the SCCV Horizon."
	assigned_role = "Qukala Heavy Trooper"

/datum/ghostspawner/human/ert/qukala/officer
	name = "Qukala Commander"
	short_name = "ertkalalead"
	desc = "The commanding officer of the Qukala response team."
	max_count = 1
	outfit = /obj/outfit/admin/ert/qukala/officer
	possible_species = list(SPECIES_SKRELL, SPECIES_SKRELL_AXIORI) //only the warblers get to give orders around here
	welcome_message = "You are an officer of the Nralakk Federation Qukala, assigned to respond to a distress call from the SCCV Horizon."
	assigned_role = "Qukala Commander"
