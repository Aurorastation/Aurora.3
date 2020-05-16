/datum/ghostspawner/human/admin
	tags = list("Admin")

//Add the ability to despawn
/datum/ghostspawner/human/admin/post_spawn(mob/user)
	user.client.verbs += /client/proc/despawn
	return ..()

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
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Emergency Response Team Commander"
	special_role = "ERT Commander"
	respawn_flag = null

	mob_name = null
	mob_name_pick_message = "Pick a name."

/datum/ghostspawner/human/admin/legion_commander
	short_name = "legionlegate"
	name = "TCFL Legate"
	desc = "Command the TCFL onboard BLV The Tower, a legion patrolship from where Task Force XIII - Fortune operates from."

	landmark_name = "TCFLLegate"
	req_perms = R_CCIAA

	//Vars related to human mobs
	outfit = /datum/outfit/admin/nt/tcfl_legate
	possible_species = list("Human","M'sai Tajara","Skrell", "Unathi","Baseline Frame")
	possible_genders = list(MALE,FEMALE)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Tau Ceti Foreign Legion Legate"
	special_role = "TCFL Legate"
	respawn_flag = null

	mob_name = null
	mob_name_prefix = "Lgt. "
	mob_name_pick_message = "Pick a callsign or last-name."

/datum/ghostspawner/human/admin/cciaagent
	short_name = "cciaagent"
	name = "CCIA Agent"
	desc = "Board the Aurora, annoy crew with your interviews and get squashed by your own shuttle."

	landmark_name = "CCIAAgent"
	req_perms = R_CCIAA

	//Vars related to human mobs
	outfit = /datum/outfit/admin/nt/cciaa
	possible_species = list("Human","Skrell")
	possible_genders = list(MALE,FEMALE)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Emergency Response Team Commander"
	special_role = "ERT Commander"
	respawn_flag = null

	mob_name = null
	mob_name_pick_message = "Pick a name."


/datum/ghostspawner/human/admin/cciaescort
	short_name = "cciaescort"
	name = "CCIA Escort"
	desc = "Escort a CCIA Agent to the station, watch them annoy the crew and prevent them from throwing themselves under their own shuttle."

	enabled = FALSE
	landmark_name = "CCIAEscort"
	req_perms = null
	req_perms_edit = R_CCIAA
	max_count = 1

	//Vars related to human mobs
	outfit = /datum/outfit/admin/nt/protection_detail
	possible_species = list("Human","Skrell")
	possible_genders = list(MALE,FEMALE)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Civil Protection Officer"
	special_role = "Civil Protection Officer"
	respawn_flag = null

	mob_name = null
	mob_name_prefix = "Ofc. "
	mob_name_pick_message = "Pick a callsign or last-name."


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
	outfit = /datum/outfit/admin/nt/odinsec
	possible_species = list("Human","Skrell")
	possible_genders = list(MALE,FEMALE)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Odin Security Officer"
	special_role = "Odin Security Officer"
	respawn_flag = null

	mob_name = null
	mob_name_prefix = "Spec. "
	mob_name_pick_message = "Pick a callsign or last-name."

/datum/ghostspawner/human/admin/tcflsentinel
	short_name = "tcflsentinel"
	name = "TCFL Sentinel"
	desc = "Secure BLV The Tower from any would-be interlopers, provide assistance to returning personnel and/or evacuees."

	enabled = FALSE
	spawnpoints = list("TCFLSentinel")
	req_perms = null
	req_perms_edit = R_CCIAA
	max_count = 4

	outfit = /datum/outfit/admin/ert/legion/sentinel
	possible_species = list("Human", "Tajara", "M'sai Tajara", "Zhan-Khazan Tajara", "Skrell", "Unathi", "Vaurca Warrior", "Vaurca Worker", "Baseline Frame", "Diona")
	possible_genders = list(MALE,FEMALE)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "TCFL Sentinel"
	special_role = "TCFL Sentinel"
	respawn_flag = null

	mob_name = null
	mob_name_prefix = "Sent. "
	mob_name_pick_message = "Pick a callsign or last-name."

/datum/ghostspawner/human/admin/fib
	short_name = "fib"
	name = "FIB Agent"
	desc = "Investigate issues related to crimes under the jurisdiction of the Federal Investigations Bureau."

	landmark_name = "CCIAAgent"
	req_perms = R_CCIAA

	outfit = /datum/outfit/admin/nt/fib
	possible_species = list("Human")
	possible_genders = list(MALE,FEMALE)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "FIB Agent"
	special_role = "FIB Agent"
	respawn_flag = null

	mob_name = null
	mob_name_prefix = "S/Agt. "
	mob_name_pick_message = "Pick a name."

/datum/ghostspawner/human/admin/fib/escort
	short_name = "fibescort"
	name = "FIB Escort"
	desc = "Protect the agents of the Federal Investigations Bureau while on the field."

	landmark_name = "CCIAEscort"

	outfit = /datum/outfit/admin/nt/fib/guard

	req_perms = null
	req_perms_edit = R_CCIAA
	max_count = 1

	assigned_role = "FIB Escort"
	special_role = "FIB Escort"
	respawn_flag = null

	enabled = FALSE

	mob_name = null
	mob_name_prefix = "Agt. "
	mob_name_pick_message = "Pick a name."

/client/proc/despawn()
	set name = "Despawn"
	set desc = "Your work is done. Leave this realm."
	set category = "Special Verbs"

	var/mob/M = mob
	M.mind.special_role = null
	M.ghostize(1)
	verbs -= /client/proc/despawn
	qdel(M)
