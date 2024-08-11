/datum/ghostspawner/human/ert/klax
	name = "K'lax Warrior"
	short_name = "ertklax"
	desc = "You are a warrior of the K'lax Hive, deployed to respond to an incident in the sector."
	outfit = /obj/outfit/admin/ert/klax
	mob_name_suffix = " K'lax"
	mob_name_pick_message = "Choose a Vaurca first name."
	possible_species = list(SPECIES_VAURCA_WARRIOR)
	uses_species_whitelist = FALSE
	max_count = 2
	assigned_role = "K'lax Warrior"

/datum/ghostspawner/human/ert/klax/medic
	name = "K'lax Field Biotechnician"
	short_name = "ertklaxm"
	desc = "You are a medical specialist of the K'lax Hive, deployed to respond to an incident in the sector."
	outfit = /obj/outfit/admin/ert/klax/medic
	max_count = 1
	assigned_role = "K'lax Field Biotechnician"

/datum/ghostspawner/human/ert/klax/engi
	name = "K'lax Sapper"
	short_name = "ertklaxe"
	desc = "You are an engineering specialist of the K'lax Hive, deployed to respond to an incident in the sector."
	outfit = /obj/outfit/admin/ert/klax/engi
	max_count = 1
	assigned_role = "K'lax Sapper"

/datum/ghostspawner/human/ert/klax/heavy
	name = "K'lax Heavy"
	short_name = "ertklaxh"
	desc = "You are a heavy weapons specialist of the K'lax Hive, deployed to respond to an incident in the sector."
	outfit = /obj/outfit/admin/ert/klax/heavy
	max_count = 1
	assigned_role = "K'lax Heavy"
