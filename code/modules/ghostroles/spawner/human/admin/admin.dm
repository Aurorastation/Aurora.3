/datum/ghostspawner/human/admin
	tags = list("Admin")

//Add the ability to despawn
/datum/ghostspawner/human/admin/post_spawn(mob/user)
	user.client.verbs += /client/proc/despawn
	return ..()

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
	possible_species = list(SPECIES_HUMAN,SPECIES_SKRELL, SPECIES_SKRELL_AXIORI,SPECIES_IPC)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Odin Security Officer"
	special_role = "Odin Security Officer"
	respawn_flag = null

	mob_name = null
	mob_name_prefix = "Spec. "
	mob_name_pick_message = "Pick a callsign or last-name."

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
	possible_species = list(SPECIES_HUMAN,SPECIES_SKRELL, SPECIES_SKRELL_AXIORI,SPECIES_TAJARA,SPECIES_UNATHI,SPECIES_IPC)
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
	possible_species = list(SPECIES_HUMAN,SPECIES_SKRELL, SPECIES_SKRELL_AXIORI,SPECIES_TAJARA,SPECIES_UNATHI,SPECIES_IPC)
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
	possible_species = list(SPECIES_HUMAN,SPECIES_SKRELL, SPECIES_SKRELL_AXIORI,SPECIES_TAJARA,SPECIES_UNATHI,SPECIES_IPC)
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
	possible_species = list(SPECIES_HUMAN,SPECIES_SKRELL, SPECIES_SKRELL_AXIORI,SPECIES_TAJARA,SPECIES_UNATHI,SPECIES_IPC)
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
	possible_species = list(SPECIES_HUMAN,SPECIES_SKRELL, SPECIES_SKRELL_AXIORI,SPECIES_TAJARA,SPECIES_UNATHI,SPECIES_IPC)
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
	possible_species = list(SPECIES_HUMAN, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_WORKER, SPECIES_IPC, SPECIES_DIONA)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "TCFL Sentinel"
	special_role = "TCFL Sentinel"
	respawn_flag = null

	mob_name = null
	mob_name_prefix = "Sent. "
	mob_name_pick_message = "Pick a callsign or last-name."

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

	if(evacuation_controller.emergency_evacuation)
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
	
/datum/ghostspawner/human/admin/peacekeeper
	name = "SCC Oversight Agent"
	short_name = "SCCPeacekeeper"
	desc = "Following the events of the 18th of September, you have been deployed to the SCCV Horizon to oversee the ship for any lingering signs of mutiny, silence any sort of seditious behaviour and keep up crew morale."

	enabled = TRUE
	spawnpoints = list("SCCPeacekeeper")
	req_perms = null
	req_perms_edit = R_ADMIN
	max_count = 2

	outfit = /datum/outfit/admin/scc/peacekeeper
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_SKRELL)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "SCC Oversight Agent"
	special_role = "SCC Oversight Agent"
	respawn_flag = null

	mob_name = null
	mob_name_prefix = "AGT. "
	mob_name_pick_message = "Set your full name. You already have a prefix."