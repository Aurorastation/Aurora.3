/datum/ghostspawner/human/ert/dominia
	short_name = "ertdom"
	name = "Imperial Fleet Armsman"
	desc = "You are an enlisted voidsman of the Dominian Imperial Fleet, responding to a distress call in the sector."
	outfit = /obj/outfit/admin/ert/dominia
	mob_name_prefix = "ARMSN. " //Armsman
	max_count = 2
	possible_species = list(SPECIES_HUMAN)
	assigned_role = "Imperial Fleet Voidsman"
	respawn_flag = null

/datum/ghostspawner/human/ert/dominia/medic
	short_name = "ertdomm"
	name = "Imperial Fleet Medic"
	desc = "You are a medical specialist voidsman of the Dominian Imperial Fleet, responding to a distress call in the sector."
	outfit = /obj/outfit/admin/ert/dominia/medic
	mob_name_prefix = "VDSMN. " //Voidsman
	max_count = 1
	assigned_role = "Imperial Fleet Medic"

/datum/ghostspawner/human/ert/dominia/engi
	short_name = "ertdome"
	name = "Imperial Fleet Sapper"
	desc = "You are an engineering specialist voidsman of the Dominian Imperial Fleet, responding to a distress call in the sector."
	outfit = /obj/outfit/admin/ert/dominia/engi
	mob_name_prefix = "VDSMN. " //Voidsman
	max_count = 1
	assigned_role = "Imperial Fleet Sapper"

/datum/ghostspawner/human/ert/dominia/lead
	short_name = "ertdomlead"
	name = "Imperial Fleet Offcer"
	desc = "You are an ensign of the Dominian Imperial Fleet, leading the response to a distress call in the sector."
	outfit = /obj/outfit/admin/ert/dominia/officer
	mob_name_prefix = "ENS. " //Voidsman
	max_count = 1
	assigned_role = "Imperial Fleet Officer"
