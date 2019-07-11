/datum/ghostspawner/human/ert_commander
	short_name = "ertcommander"
	name = "ERT Commander"
	desc = "Command the Response team from Central Command"

	landmark_name = "ERTCommander"

	//Vars related to human mobs
	outfit = /datum/outfit/admin/nt/ert_commander
	possible_species = list("Human")
	possible_genders = list(MALE,FEMALE)
	allow_appearance_change = TRUE

	assigned_role = "Emergency Response Team Commander"
	special_role = "ERT Commander"
	respawn_flag = null

	mob_name = null
	mob_name_prefix = "Cmdr. "

/datum/ghostspawner/human/cciaagent
	short_name = "cciaagent"
	name = "CCIA Agent"
	desc = "Board the Aurora, annoy crew with your interviews and get squashed by your own shuttle."

	landmark_name = "CCIAAgent"

	//Vars related to human mobs
	outfit = /datum/outfit/admin/nt/cciaa
	possible_species = list("Human")
	possible_genders = list(MALE,FEMALE)
	allow_appearance_change = TRUE

	assigned_role = "Emergency Response Team Commander"
	special_role = "ERT Commander"
	respawn_flag = null

	mob_name = null
	mob_name_prefix = "CCIAA "