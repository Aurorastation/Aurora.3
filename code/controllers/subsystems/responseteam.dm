/var/datum/controller/subsystem/responseteam/SSresponseteam

/datum/controller/subsystem/responseteam
	name = "Response Team"
	wait = 1800 //Fire only every 3 minutes - Not more often needed for now

	var/ert_progression_chance = 0
	var/percentage_antagonists = 0
	var/percentage_dead = 0
	var/can_call_ert = TRUE
	var/ert_type = "NanoTrasen Response Team" //what ert type will be deployed
	var/send_emergency_team = 0 

/datum/controller/subsystem/responseteam/Recover()
	ert_progression_chance = SSresponseteam.ert_progression_chance
	can_call_ert = SSresponseteam.can_call_ert
	ert_type = SSresponseteam.ert_type
	send_emergency_team = SSresponseteam.send_emergency_team

/datum/controller/subsystem/responseteam/New()
	NEW_SS_GLOBAL(SSresponseteam)

/datum/controller/subsystem/responseteam/stat_entry()
	var/out = "PC:[ert_progression_chance] "
	out += "BC:[config.ert_base_chance] "
	out += "PA:[percentage_antagonists] "
	out += "PAF:[config.ert_scaling_factor_antag] "
	out += "PD:[percentage_dead] "
	out += "PDF:[config.ert_scaling_factor_dead] "
	out += "SF:[config.ert_scaling_factor] "
	out += "CC:[can_call_ert] "
	..(out)

/datum/controller/subsystem/responseteam/fire()
	if(send_emergency_team == 0) // There is no ERT at the time.
		var/total = 0
		var/deadcount = 0
		var/antagonists = 0
		for(var/mob/living/carbon/human/H in mob_list)
			if(!H.isMonkey() || H.client) 
				total++
				if(is_special_character(H) >= 1) antagonists++
				if(H.stat == 2) deadcount++
				
		if(total == 0)
			percentage_antagonists = 0
			percentage_dead = 0
		else
			percentage_antagonists = round(100 * antagonists / total)
			percentage_dead = round(100 * deadcount / total)
		

		switch(get_security_level())
			if("green")
				ert_progression_chance += config.ert_green_inc
			if("blue")
				ert_progression_chance += config.ert_yellow_inc
			if("red")
				ert_progression_chance += config.ert_blue_inc
			if("delta")
				ert_progression_chance += config.ert_green_inc
			else
				ert_progression_chance += 1

/datum/controller/subsystem/responseteam/proc/trigger_armed_response_team(var/forced_choice = FALSE)
	if(!can_call_ert && !forced_choice)
		return
	if(send_emergency_team)
		return

	var/ert_chance = ert_progression_chance + config.ert_base_chance // Is incremented by fire.
	ert_chance += config.ert_scaling_factor_dead*percentage_dead // the more people are dead, the higher the chance
	ert_chance += config.ert_scaling_factor_antag*percentage_antagonists // the more antagonists, the higher the chance
	ert_chance *= config.ert_scaling_factor
	ert_chance = min(ert_chance, 100)

	command_announcement.Announce("It would appear that an emergency response team was requested for [station_name()]. We will prepare and send one as soon as possible.", "[current_map.boss_name]")

	if(forced_choice)
		ert_type = forced_choice
	else if(!forced_choice && !prob(ert_chance)) 
		ert_type = "Tau Ceti Foreign Legion"

	can_call_ert = FALSE // Only one call per round, gentleman.
	send_emergency_team = 1

	sleep(600 * 5)
	send_emergency_team = 0 // Can no longer join the ERT.
	ert_type = "NanoTrasen Response Team"


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

	var/choice = input("Select the response team type","Response team selection") as null|anything in list("NanoTrasen Response Team", "Tau Ceti Foreign Legion")

	if(!choice)
		choice = FALSE

	if(SSresponseteam.send_emergency_team)
		to_chat(usr, "<span class='danger'>Looks like somebody beat you to it!</span>")
		return

	message_admins("[key_name_admin(usr)] is dispatching an Emergency Response Team.", 1)
	log_admin("[key_name(usr)] used Dispatch Response Team.",admin_key=key_name(usr))
	SSresponseteam.trigger_armed_response_team(choice)

client/verb/JoinResponseTeam()

	set name = "Join Response Team"
	set category = "IC"

	if(!MayRespawn(1))
		to_chat(usr, "<span class='warning'>You cannot join the response team at this time.</span>")
		return

	if(istype(usr,/mob/abstract/observer) || istype(usr,/mob/abstract/new_player))

		if(!SSresponseteam.send_emergency_team)
			to_chat(usr, "No emergency response team is currently being sent.")
			return

		if(jobban_isbanned(usr, "Antagonist") || jobban_isbanned(usr, "Emergency Response Team") || jobban_isbanned(usr, "Security Officer"))
			to_chat(usr, "<span class='danger'>You are jobbanned from the emergency reponse team!</span>")
			return

		switch(SSresponseteam.ert_type)

			if("Tau Ceti Foreign Legion")
				if(legion.current_antagonists.len >= legion.hard_cap)
					to_chat(usr, "The emergency response team is already full!")
					return

				legion.create_default(usr)

			else
				if(ert.current_antagonists.len >= ert.hard_cap)
					to_chat(usr, "The emergency response team is already full!")
					return

				ert.create_default(usr)
	else
		to_chat(usr, "You need to be an observer or new player to use this.")