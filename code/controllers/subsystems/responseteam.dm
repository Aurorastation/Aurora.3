SUBSYSTEM_DEF(distress)
	name = "Distress"
	flags = SS_NO_FIRE

	var/ert_count = 0
	var/send_emergency_team = FALSE
	var/can_call_ert = TRUE

	var/list/datum/responseteam/all_ert_teams = list()
	var/list/datum/responseteam/available_teams = list()
	var/datum/responseteam/picked_team
	var/list/datum/ghostspawner/human/ert/sent_teams = list()

	var/list/active_distress_beacons = list()

/datum/controller/subsystem/distress/Recover()
	send_emergency_team = SSdistress.send_emergency_team

/datum/controller/subsystem/distress/PreInit()
	feedback_set("responseteam_count", 0)

/datum/controller/subsystem/distress/Initialize(start_timeofday)
	var/list/all_teams = subtypesof(/datum/responseteam)
	for(var/team in all_teams)
		CHECK_TICK
		var/datum/responseteam/ert = new team
		if(SSatlas.current_sector.name in ert.possible_space_sector)
			available_teams += ert
		all_ert_teams += ert

	return SS_INIT_SUCCESS

/datum/controller/subsystem/distress/stat_entry(msg)
	msg = "CC:[can_call_ert]"
	return ..()

/datum/controller/subsystem/distress/proc/pick_random_team()
	var/list/datum/responseteam/possible_teams = list()
	for(var/datum/responseteam/ert in available_teams)
		possible_teams[ert] = ert.chance

	return pickweight(possible_teams)


/datum/controller/subsystem/distress/proc/trigger_armed_response_team(var/forced_choice = null)
	if(!can_call_ert && !forced_choice)
		return
	if(send_emergency_team)
		return

	ert_count++
	feedback_inc("responseteam_count")

	command_announcement.Announce("An emergency response team has picked up the distress signal. A specialized relief team will arrive shortly.", "[current_map.station_name] Distress Suite", 'sound/misc/announcements/security_level_old.ogg')

	if(forced_choice && forced_choice != "Random")
		for(var/datum/responseteam/R in available_teams)
			if(R.name == forced_choice)
				picked_team = R
				break
	else
		picked_team = pick_random_team()

	feedback_set("responseteam[ert_count]",world.time)

	can_call_ert = FALSE // Only one call per round, gentleman.
	send_emergency_team = TRUE

	sent_teams = list() //Make sure this list is clear before we use it.

	handle_spawner()

	sleep(120 SECONDS)

	for(var/datum/ghostspawner/G in sent_teams)
		G.disable()

	send_emergency_team = FALSE //We completed the ERT handling, so let's allow admins to call another.

/datum/controller/subsystem/distress/proc/trigger_overmap_distress_beacon(var/obj/effect/overmap/visitable/caller, var/distress_message, var/mob/user)
	if(caller.has_called_distress_beacon)
		return

	ert_count++
	feedback_inc("responseteam_count")

	command_announcement.Announce("A distress beacon has been broadcasted to nearby vessels in the sector. Please remain calm and make preparations for the arrival of third parties.", "[current_map.station_name] Distress Suite", 'sound/misc/announcements/security_level_old.ogg', zlevels = caller.map_z)

	log_and_message_admins("has launched a distress beacon from the [caller.name] with message: [distress_message].", user)
	var/datum/distress_beacon/beacon = new()
	beacon.caller = caller
	beacon.distress_message = distress_message
	beacon.user = user
	beacon.user_name = user.name //It is possible that the mob's name may change after the distress beacon is launched, so we keep this var to avoid stuff like that.

	active_distress_beacons[caller.name] = beacon

	caller.toggle_distress_status()

/datum/controller/subsystem/distress/proc/handle_spawner()
	for(var/N in typesof(picked_team.spawner)) //Find all spawners that are subtypes of the team we want.
		var/datum/ghostspawner/human/ert/new_spawner = new N
		for(var/role_spawner in SSghostroles.spawners)
			if(new_spawner.short_name == role_spawner) //Create the spawner, then use its name to find the spawner in SSghostroles' spawner lists.
				var/datum/ghostspawner/human/ert/good_spawner = SSghostroles.spawners[role_spawner]
				sent_teams += good_spawner //Enable that spawner.
				good_spawner.enable()
	if(picked_team.equipment_map)
		var/landmark_position
		for(var/obj/effect/landmark/distress_team_equipment/L in GLOB.landmarks_list)
			landmark_position = L.loc
		if(landmark_position)
			var/datum/map_template/distress_map = new picked_team.equipment_map
			distress_map.load(landmark_position)

/datum/controller/subsystem/distress/proc/close_ert_blastdoors()
	var/datum/wifi/sender/door/wifi_sender = new("ert_shuttle_lockdown", src)
	wifi_sender.activate("close")

/datum/controller/subsystem/distress/proc/close_tcfl_blastdoors()
	var/datum/wifi/sender/door/wifi_sender = new("tcfl_shuttle_lockdown", src)
	wifi_sender.activate("close")

	var/datum/wifi/sender/door/wifi_sender_blast = new("tcfl_shuttle_release", src)
	wifi_sender_blast.activate("open")

/client/proc/response_team()
	set name = "Dispatch Emergency Response Team"
	set category = "Special Verbs"
	set desc = "Send an emergency response team to the ship."

	if(!holder)
		to_chat(usr, "<span class='danger'>Only administrators may use this command.</span>")
		return
	if(!ROUND_IS_STARTED)
		to_chat(usr, "<span class='danger'>The round hasn't started yet!</span>")
		return
	if(SSdistress.send_emergency_team)
		to_chat(usr, "<span class='danger'>[current_map.boss_name] has already dispatched an emergency response team!</span>")
		return
	if(alert("Do you want to dispatch an Emergency Response Team?",,"Yes","No") != "Yes")
		return
	if(get_security_level() != "red") // Allow admins to reconsider if the alert level isn't Red
		switch(alert("The ship is not on red alert. Do you still want to dispatch a response team?",,"Yes","No"))
			if("No")
				return

	var/list/plaintext_teams = list("Random")
	for(var/datum/responseteam/A in SSdistress.all_ert_teams)
		plaintext_teams += A.name

	var/choice = input(usr, "Select the response team type.","Response Team Selection", plaintext_teams)

	if(SSdistress.send_emergency_team)
		to_chat(usr, "<span class='danger'>Looks like somebody beat you to it!</span>")
		return

	message_admins("[key_name_admin(usr)] is dispatching a Response Team: [choice].", 1)
	log_admin("[key_name(usr)] used Dispatch Response Team: [choice].",admin_key=key_name(usr))
	SSdistress.trigger_armed_response_team(choice)


/hook/shuttle_moved/proc/close_response_blastdoors(var/obj/effect/shuttle_landmark/start_location, var/obj/effect/shuttle_landmark/destination)
	//Check if we are departing from the Odin
	if(start_location.landmark_tag == "nav_ert_start")
		SSdistress.close_ert_blastdoors()

	//Check if we are departing from the TCFL base
	else if(start_location.landmark_tag == "nav_legion_start")
		SSdistress.close_tcfl_blastdoors()
	return TRUE

/datum/distress_beacon
	var/distress_message
	var/obj/effect/overmap/visitable/caller
	var/mob/living/carbon/human/user
	var/user_name

/datum/distress_beacon/Destroy()
	caller = null
	user = null
	return ..()
