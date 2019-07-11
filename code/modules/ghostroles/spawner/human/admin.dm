/datum/ghostspawner/human/ert_commander
	short_name = "ertcommander"
	name = "ERT Commander"
	desc = "Command the Response team from Central Command"

	landmark_name = "ERTCommander"
	req_perms = R_CCIAA

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
	req_perms = R_CCIAA

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


/datum/ghostspawner/human/cciaescort
	short_name = "cciaescort"
	name = "CCIA Escort"
	desc = "Escort a CCIA Agent to the station, watch them annoy the crew and prevent them from throwing themselfs under their own shuttle."

	enabled = FALSE
	landmark_name = "CCIAEscort"
	req_perms = null
	req_perms_edit = R_CCIAA
	max_count = 1

	//Vars related to human mobs
	outfit = /datum/outfit/admin/nt/protection_detail
	possible_species = list("Human")
	possible_genders = list(MALE,FEMALE)
	allow_appearance_change = TRUE

	assigned_role = "Emergency Response Team Protection Detail"
	special_role = "ERT Protection Detail"
	respawn_flag = null

	mob_name = null
	mob_name_prefix = "S/Tpr. "


/datum/ghostspawner/human/checkpointsec
	short_name = "checkpointsec"
	name = "Odin Checkpoint Security"
	desc = "Secure the odin checkpoint. Verify the identity of eveyone passing through, perform random searches on \"suspicious\" crew."

	enabled = FALSE
	spawnpoints = list("OdinCheckpoint")
	req_perms = null
	req_perms_edit = R_CCIAA
	max_count = 4

	//Vars related to human mobs
	outfit = /datum/outfit/admin/nt/protection_detail
	possible_species = list("Human","Skrell","Tajara","Unathi")
	possible_genders = list(MALE,FEMALE)
	allow_appearance_change = TRUE

	assigned_role = "Odin Security Officer"
	special_role = "Odin Security Officer"
	respawn_flag = null

	mob_name = null
	mob_name_prefix = "Spec. "