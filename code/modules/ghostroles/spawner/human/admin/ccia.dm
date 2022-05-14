/*
	Agents and their Escorts
*/

/datum/ghostspawner/human/admin/corporate
	short_name = null
	name = "Corporate Entity"
	desc = "A corporate entity so dull it doesn't even exist. Thrilling!"

	tags = list("CCIA")
	landmark_name = "CCIAAgent"
	req_perms = R_CCIAA

	possible_species = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	respawn_flag = null
	mob_name = null

/datum/ghostspawner/human/admin/corporate/ccia_agent
	short_name = "cciaagent"
	name = "CCIA Agent"

	outfit = /datum/outfit/admin/nt/cciaa

	assigned_role = "CCIA Agent"
	special_role = "CCIA Agent"

	mob_name_pick_message = "Pick a name."

/datum/ghostspawner/human/admin/corporate/ccia_agent/New()
	desc = "Board the [current_map.station_name], annoy crew with your interviews and get squashed by your own shuttle."
	..()

/datum/ghostspawner/human/admin/corporate/ccia_escort
	short_name = "cciaescort"
	name = "CCIA Escort"
	desc = "Escort CCIA agents, watch them annoy the crew and prevent them from throwing themselves under their own shuttle."

	enabled = FALSE
	landmark_name = "CCIAEscort"
	req_perms = null
	req_perms_edit = R_CCIAA
	max_count = 1

	//Vars related to human mobs
	outfit = /datum/outfit/admin/nt/protection_detail

	assigned_role = "Civil Protection Officer"
	special_role = "Civil Protection Officer"

	mob_name_prefix = "Ofc. "
	mob_name_pick_message = "Pick a callsign or last-name."

/datum/ghostspawner/human/admin/corporate/scc_agent
	short_name = "sccagent"
	name = "SCC Agent"

	outfit = /datum/outfit/admin/scc

	//take this block of code out once CCIA moves over to SCC proper
	enabled = FALSE
	req_perms_edit = R_ADMIN

	assigned_role = "SCC Agent"
	special_role = "SCC Agent"

/datum/ghostspawner/human/admin/corporate/scc_agent/New()
	desc = "Board the [current_map.station_name], annoy crew with your interviews and get squashed by your own shuttle. But this time you're blue."
	..()

/datum/ghostspawner/human/admin/corporate/scc_bodyguard
	short_name = "sccbodyguard"
	name = "SCC Bodyguard"
	desc = "Protect the SCC agent you're assigned to with your life. In fact, protect them if you die as well, if possible."

	landmark_name = "CCIAEscort"

	outfit = /datum/outfit/admin/scc/bodyguard

	enabled = FALSE
	req_perms = null
	req_perms_edit = R_ADMIN // change this to R_CCIAA when CCIA moves to SCC
	max_count = 1

	assigned_role = "SCC Bodyguard"
	special_role = "SCC Bodyguard"

	mob_name_prefix = "Spc. "
	mob_name_pick_message = "Pick a name."

/datum/ghostspawner/human/admin/corporate/fib
	short_name = "fib"
	name = "FIB Agent"
	desc = "Investigate issues related to crimes under the jurisdiction of the Federal Investigations Bureau."

	outfit = /datum/outfit/admin/nt/fib
	possible_species = list(SPECIES_HUMAN)

	assigned_role = "FIB Agent"
	special_role = "FIB Agent"

	mob_name_prefix = "S/Agt. "
	mob_name_pick_message = "Pick a name."

/datum/ghostspawner/human/admin/corporate/fib/escort
	short_name = "fibescort"
	name = "FIB Escort"
	desc = "Protect the agents of the Federal Investigations Bureau while on the field."

	landmark_name = "CCIAEscort"

	outfit = /datum/outfit/admin/nt/fib/guard

	enabled = FALSE

	req_perms = null
	req_perms_edit = R_CCIAA
	max_count = 1

	assigned_role = "FIB Escort"
	special_role = "FIB Escort"

	mob_name_prefix = "Agt. "
	mob_name_pick_message = "Pick a name."

/*
	ERT and Similar Commanders
*/

/datum/ghostspawner/human/admin/ert_commander
	short_name = "ertcommander"
	name = "ERT Commander"
	desc = "Command the response team from Central Command"

	tags = list("CCIA")
	landmark_name = "ERTCommander"
	req_perms = R_CCIAA

	//Vars related to human mobs
	outfit = /datum/outfit/admin/nt/ert_commander
	possible_species = list(SPECIES_HUMAN)
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

	tags = list("CCIA")
	landmark_name = "TCFLLegate"
	req_perms = R_CCIAA

	//Vars related to human mobs
	outfit = /datum/outfit/admin/tcfl
	possible_species = list(SPECIES_HUMAN,SPECIES_TAJARA_MSAI,SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI,SPECIES_IPC)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Tau Ceti Foreign Legion Legate"
	special_role = "TCFL Legate"
	respawn_flag = null

	mob_name = null
	mob_name_prefix = "Lgt. "
	mob_name_pick_message = "Pick a callsign or last-name."

/*
	Misc. Odin Roles
*/

/datum/ghostspawner/human/admin/checkpointsec/prepatory
	short_name = "checkpointsec_prepatory"
	name = "Aurora Prepatory Wing Security"
	desc = "Act as an Odin security officer, guide lost newcomers onto the arrivals shuttle if the need arises."

	enabled = TRUE
	tags = list("CCIA")
	spawnpoints = list("OdinPrepatory")
	req_perms = R_CCIAA
	max_count = 3
