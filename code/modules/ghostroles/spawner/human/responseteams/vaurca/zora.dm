/datum/ghostspawner/human/ert/zora
	name = "Zo'ra Warrior"
	short_name = "ertzora"
	desc = "You are a warrior of the Zo'ra Hive, deployed to respond to an incident in the sector."
	outfit = /obj/outfit/admin/ert/zora
	mob_name_suffix = " Zo'ra"
	mob_name_pick_message = "Choose a Vaurca first name."
	possible_species = list(SPECIES_VAURCA_WARRIOR)
	uses_species_whitelist = FALSE
	max_count = 2
	assigned_role = "Zo'ra Warrior"

/datum/ghostspawner/human/ert/zora/medic
	name = "Zo'ra Field Biotechnician"
	short_name = "ertzoram"
	desc = "You are a medical specialist of the Zo'ra Hive, deployed to respond to an incident in the sector."
	outfit = /obj/outfit/admin/ert/zora/medic
	max_count = 1
	assigned_role = "Zo'ra Field Biotechnician"

/datum/ghostspawner/human/ert/zora/engi
	name = "Zo'ra Sapper"
	short_name = "ertzorae"
	desc = "You are an engineering specialist of the Zo'ra Hive, deployed to respond to an incident in the sector."
	outfit = /obj/outfit/admin/ert/zora/engi
	max_count = 1
	assigned_role = "Zo'ra Sapper"

/datum/ghostspawner/human/ert/zora/heavy
	name = "Zo'ra Heavy"
	short_name = "ertzorah"
	desc = "You are a heavy weapons specialist of the Zo'ra Hive, deployed to respond to an incident in the sector."
	outfit = /obj/outfit/admin/ert/zora/heavy
	max_count = 1
	assigned_role = "Zo'ra Heavy"
