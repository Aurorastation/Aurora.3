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

	landmark_name = "TCFLLegate"
	req_perms = R_CCIAA

	//Vars related to human mobs
	outfit = /datum/outfit/admin/tcfl
	possible_species = list(SPECIES_HUMAN,SPECIES_TAJARA_MSAI,SPECIES_SKRELL, SPECIES_UNATHI,SPECIES_IPC)
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
	possible_species = list(SPECIES_HUMAN,SPECIES_SKRELL)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "CCIA Agent"
	special_role = "CCIA Agent"
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
	possible_species = list(SPECIES_HUMAN,SPECIES_SKRELL)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Civil Protection Officer"
	special_role = "Civil Protection Officer"
	respawn_flag = null

	mob_name = null
	mob_name_prefix = "Ofc. "
	mob_name_pick_message = "Pick a callsign or last-name."

/datum/ghostspawner/human/admin/cciaagent/scc
	short_name = "sccagent"
	name = "SCC Agent"
	desc = "Board the Aurora, annoy crew with your interviews and get squashed by your own shuttle. But this time you're blue."

	outfit = /datum/outfit/admin/scc

	assigned_role = "SCC Agent"
	special_role = "SCC Agent"

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
	possible_species = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_IPC)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Odin Security Officer"
	special_role = "Odin Security Officer"
	respawn_flag = null

	mob_name = null
	mob_name_prefix = "Spec. "
	mob_name_pick_message = "Pick a callsign or last-name."

/datum/ghostspawner/human/admin/checkpointsec/prepatory
	short_name = "checkpointsec_prepatory"
	name = "Aurora Prepatory Wing Security"
	desc = "Act as an Odin security officer, guide lost newcomers onto the arrivals shuttle if the need arises."
	enabled = TRUE
	spawnpoints = list("OdinPrepatory")
	req_perms = R_CCIAA
	max_count = 3

/datum/ghostspawner/human/admin/odindoc
	short_name = "odindoc"
	name = "Odin Medical Doctor"
	desc = "Provide medical assistance for those arriving on the Odin."

	enabled = FALSE
	spawnpoints = list("OdinDoctor")
	req_perms = null
	req_perms_edit = R_CCIAA
	max_count = 4

	//Vars related to human mobs
	outfit = /datum/outfit/admin/nt/odindoc
	possible_species = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_TAJARA,SPECIES_UNATHI,SPECIES_IPC)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Odin Medical Doctor"
	special_role = "Odin Medical Doctor"
	respawn_flag = null

	mob_name = null

/datum/ghostspawner/human/admin/odinpharm
	short_name = "odinpharm"
	name = "Odin Pharmacist"
	desc = "Provide medication for the Doctors on the Odin and those in need."

	enabled = FALSE
	spawnpoints = list("OdinPharm")
	req_perms = null
	req_perms_edit = R_CCIAA
	max_count = 1

	outfit = /datum/outfit/admin/nt/odinpharm
	possible_species = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_TAJARA,SPECIES_UNATHI,SPECIES_IPC)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Odin Pharmacist"
	special_role = "Odin Pharmacist"
	respawn_flag = null

	mob_name = null

/datum/ghostspawner/human/admin/odinchef
	short_name = "odinchef"
	name = "Odin Chef"
	desc = "Feed starving crew members on the Odin."

	enabled = FALSE
	spawnpoints = list("OdinChef")
	req_perms = null
	req_perms_edit = R_CCIAA
	max_count = 2

	outfit = /datum/outfit/admin/nt/odinchef
	possible_species = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_TAJARA,SPECIES_UNATHI,SPECIES_IPC)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Odin Chef"
	special_role = "Odin Chef"
	respawn_flag = null

	mob_name = null

/datum/ghostspawner/human/admin/odinbartender
	short_name = "odinbartender"
	name = "Odin Bartender"
	desc = "Ensure enough drinks are available to the crew on the Odin."

	enabled = FALSE
	spawnpoints = list("OdinBartender")
	req_perms = null
	req_perms_edit = R_CCIAA
	max_count = 1

	outfit = /datum/outfit/admin/nt/odinbartender
	possible_species = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_TAJARA,SPECIES_UNATHI,SPECIES_IPC)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Odin Bartender"
	special_role = "Odin Bartender"
	respawn_flag = null

	mob_name = null

/datum/ghostspawner/human/admin/odinjanitor
	short_name = "odinjanitor"
	name = "Odin Sanitation Specialist"
	desc = "You are a expert in your field. A true authority. The crew looks to you when they get into a sticky situation. You are a janitor on the Odin."

	enabled = FALSE
	spawnpoints = list("OdinJanitor")
	req_perms = null
	max_count = 1

	outfit = /datum/outfit/admin/nt/odinjanitor
	possible_species = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_TAJARA,SPECIES_UNATHI,SPECIES_IPC)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Sanitation Specialist"
	special_role = "Sanitation Specialist"
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
	possible_species = list(SPECIES_HUMAN, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_UNATHI, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_WORKER, SPECIES_IPC, SPECIES_DIONA)
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
	possible_species = list(SPECIES_HUMAN)
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



/hook/shuttle_moved/proc/setup_odin_for_shuttle(var/obj/effect/shuttle_landmark/start_location, var/obj/effect/shuttle_landmark/destination)
	if(start_location.landmark_tag != "nav_emergency_start")
		return TRUE

	if(emergency_shuttle.evac)
		if(get_security_level() != "green" )
			var/datum/wifi/sender/door/wifi_sender = new("odin_arrivals_lockdown", SSghostroles)
			wifi_sender.activate("close")
			qdel(wifi_sender)

			if(prob(80))
				var/datum/ghostspawner/G = SSghostroles.get_spawner("checkpointsec")
				G.enable()
		return TRUE
	else
		if(get_security_level() == "green" && prob(70))
			var/datum/ghostspawner/G = SSghostroles.get_spawner("odinchef")
			G.enable()
			G = SSghostroles.get_spawner("odinbartender")
			G.enable()
		if(get_security_level() == "blue")
			var/datum/wifi/sender/door/wifi_sender = new("odin_arrivals_lockdown", SSghostroles)
			wifi_sender.activate("close")
			qdel(wifi_sender)

			if(prob(50))
				var/datum/ghostspawner/G = SSghostroles.get_spawner("checkpointsec")
				G.enable()
		return TRUE
