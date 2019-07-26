/datum/ghostspawner/human/admin
	tags = list("Admin")

/datum/ghostspawner/human/admin/ert_commander
	short_name = "ertcommander"
	name = "ERT Commander"
	desc = "Command the response team from Central Command"

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

/datum/ghostspawner/human/admin/legion_commander
	short_name = "legioncommander"
	name = "TCFL Commander"
	desc = "Command the TCFL, a walking and talking joke, whos members regularly die before they even arrive at their target."

	landmark_name = "TCFLCommander"
	req_perms = R_CCIAA

	//Vars related to human mobs
	outfit = /datum/outfit/admin/nt/tcfl_commander
	possible_species = list("Human")
	possible_genders = list(MALE,FEMALE)
	allow_appearance_change = TRUE

	assigned_role = "Tau Ceti Foreign Legion Commander"
	special_role = "TCFL Commander"
	respawn_flag = null

	mob_name = null
	mob_name_prefix = "Cmdr. "

/datum/ghostspawner/human/admin/cciaagent
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


/datum/ghostspawner/human/admin/cciaescort
	short_name = "cciaescort"
	name = "CCIA Escort"
	desc = "Escort a CCIA Agent to the station, watch them annoy the crew and prevent them from throwing themselvs under their own shuttle."

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

	assigned_role = "Civil Protection Officer"
	special_role = "Civil Protection Officer"
	respawn_flag = null

	mob_name = null
	mob_name_prefix = "Ofc. "


/datum/ghostspawner/human/admin/checkpointsec
	short_name = "checkpointsec"
	name = "Odin Checkpoint Security"
	desc = "Secure the Odin checkpoint. Verify the identity of everyone passing through, perform random searches on \"suspicious\" crew."

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