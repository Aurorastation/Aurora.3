/var/datum/controller/subsystem/responseteam/SSresponseteam

/datum/controller/subsystem/responseteam
	name = "Response Team"
	wait = 1800 //Fire only every 3 minutes - Not more often needed for now

	var/progression_chance = 0
	var/percentage_antagonists = 0
	var/percentage_dead = 0
	var/can_call_ert = TRUE
	var/send_emergency_team = 0
	var/ert_count = 0

	var/datum/responseteam/available_teams
	var/datum/responseteam/picked_team

	var/pg_green = 0
	var/pg_yellow = 0
	var/pg_red = 0
	var/pg_delta = 0

/datum/controller/subsystem/responseteam/Recover()
	progression_chance = SSresponseteam.progression_chance
	can_call_ert = SSresponseteam.can_call_ert
	send_emergency_team = SSresponseteam.send_emergency_team
	pg_green = SSresponseteam.pg_green
	pg_yellow = SSresponseteam.pg_yellow
	pg_red = SSresponseteam.pg_red
	pg_delta = SSresponseteam.pg_delta

/datum/controller/subsystem/responseteam/New()
	NEW_SS_GLOBAL(SSresponseteam)
	feedback_set("responseteam_count",0)

/datum/controller/subsystem/responseteam/Initialize(start_timeofday)
	. = ..()
	var/list/all_teams = subtypesof(/datum/responseteam)
	if(!all_teams)
		log_debug("No response teams found!")
		return
	else
		for(var/team in all_teams)
			CHECK_TICK
			var/datum/responseteam/ert = new team
			if(!ert) 
				continue
			available_teams += ert

/datum/controller/subsystem/responseteam/stat_entry()
	var/out = "PGC:[progression_chance] "
	out += "BC:[config.ert_base_chance]\n"
	out += "PA:[percentage_antagonists] "
	out += "PAF:[config.ert_scaling_factor_antag]\n"
	out += "PD:[percentage_dead] "
	out += "PDF:[config.ert_scaling_factor_dead]\n"
	out += "SF:[config.ert_scaling_factor] "
	out += "CC:[can_call_ert] "
	..(out)

/datum/controller/subsystem/responseteam/proc/pick_random_team()
	var/datum/responseteam/result
	var/prob = rand(1, 100)
	var/tally = 0
	for(var/datum/responseteam/ert in available_teams) //We need a loop to keep going through each candidate to be sure we find a good result.
		if((ert.chance + tally) <= prob) //Check every available ERT's chance. Keep going until we add enough to the tally so that we have a certain result.
			tally += ert.chance
			continue
		result = ert

	if(!result)
		log_debug("We didn't find an ERT pick result!")
		return null
	else
		return result


/datum/controller/subsystem/responseteam/proc/trigger_armed_response_team(var/forced_choice = FALSE)
	if(!can_call_ert && !forced_choice)
		return
	if(send_emergency_team)
		return
	
	ert_count++
	feedback_inc("responseteam_count")

	command_announcement.Announce("A distress beacon has been launched. Please remain calm.", "[current_map.boss_name]")

	if(forced_choice)
		forced_choice = text2path(forced_choice)
		if(forced_choice in available_teams)
			picked_team = forced_choice
		else 
			log_debug("Someone entered an invalid path for an ERT call!")
			picked_team = pick_random_team()
	else
		picked_team = pick_random_team()

	feedback_set("responseteam[ert_count]",world.time)
	feedback_add_details("responseteam[ert_count]","BC:[config.ert_base_chance]")
	feedback_add_details("responseteam[ert_count]","PGC:[progression_chance]")
	feedback_add_details("responseteam[ert_count]","PGG:[pg_green]")
	feedback_add_details("responseteam[ert_count]","PGY:[pg_yellow]")
	feedback_add_details("responseteam[ert_count]","PGR:[pg_red]")
	feedback_add_details("responseteam[ert_count]","PGD:[pg_delta]")
	feedback_add_details("responseteam[ert_count]","PA:[percentage_antagonists]")
	feedback_add_details("responseteam[ert_count]","PAF:[config.ert_scaling_factor_antag]")
	feedback_add_details("responseteam[ert_count]","PD:[percentage_dead]")
	feedback_add_details("responseteam[ert_count]","PDF:[config.ert_scaling_factor_dead]")
	feedback_add_details("responseteam[ert_count]","SF:[config.ert_scaling_factor]")

	can_call_ert = FALSE // Only one call per round, gentleman.
	send_emergency_team = 1

	handle_spawner()

	sleep(600 * 5)
	send_emergency_team = 0 // Can no longer join the ERT.

/datum/controller/subsystem/responseteam/proc/handle_spawner()
	spawner.chosen_team = picked_team

/datum/controller/subsystem/responseteam/proc/close_ert_blastdoors()
	var/datum/wifi/sender/door/wifi_sender = new("ert_shuttle_lockdown", src)
	wifi_sender.activate("close")

/datum/controller/subsystem/responseteam/proc/close_tcfl_blastdoors()
	var/datum/wifi/sender/door/wifi_sender = new("tcfl_shuttle_lockdown", src)
	wifi_sender.activate("close")

/client/proc/response_team()
	set name = "Dispatch Emergency Response Team"
	set category = "Special Verbs"
	set desc = "Send an emergency response team to the station"

	if(!holder)
		to_chat(usr, "<span class='danger'>Only administrators may use this command.</span>") 
		return
	if(!ROUND_IS_STARTED)
		to_chat(usr, "<span class='danger'>The round hasn't started yet!</span>")
		return
	if(SSresponseteam.send_emergency_team)
		to_chat(usr, "<span class='danger'>[current_map.boss_name] has already dispatched an emergency response team!</span>")
		return
	if(alert("Do you want to dispatch an Emergency Response Team?",,"Yes","No") != "Yes")
		return
	if(get_security_level() != "red") // Allow admins to reconsider if the alert level isn't Red
		switch(alert("The station is not in red alert. Do you still want to dispatch a response team?",,"Yes","No"))
			if("No")
				return

	var/choice = input("Select the response team type","Response team selection") as null|anything in list("NT-ERT", "TCFL")

	if(!choice)
		choice = FALSE

	if(SSresponseteam.send_emergency_team)
		to_chat(usr, "<span class='danger'>Looks like somebody beat you to it!</span>")
		return

	message_admins("[key_name_admin(usr)] is dispatching a Response Team: [choice].", 1)
	log_admin("[key_name(usr)] used Dispatch Response Team: [choice].",admin_key=key_name(usr))
	SSresponseteam.trigger_armed_response_team(choice)


/hook/shuttle_moved/proc/close_response_blastdoors(var/area/departing, var/area/destination)
	//Check if we are departing from the Odin
	if(istype(departing,/area/shuttle/specops/centcom))
		SSresponseteam.close_ert_blastdoors()

	//Check if we are departing from the TCFL base
	else if(istype(departing,/area/shuttle/legion/centcom))
		SSresponseteam.close_tcfl_blastdoors()
	return TRUE