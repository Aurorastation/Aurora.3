//STRIKE TEAMS
//Thanks to Kilakk for the admin-button portion of this code.

var/global/send_emergency_team = 0 // Used for automagic response teams
                                   // 'admin_emergency_team' for admin-spawned response teams
var/ert_base_chance = 10 // Default base chance. Will be incremented by increment ERT chance.
var/can_call_ert
var/ert_type = "NanoTrasen Response Team" //what ert type will be deployed

/client/proc/response_team()
	set name = "Dispatch Emergency Response Team"
	set category = "Special Verbs"
	set desc = "Send an emergency response team to the station"

	if(!holder)
		usr << "<span class='danger'>Only administrators may use this command.</span>"
		return
	if(!ROUND_IS_STARTED)
		usr << "<span class='danger'>The round hasn't started yet!</span>"
		return
	if(send_emergency_team)
		usr << "<span class='danger'>[current_map.boss_name] has already dispatched an emergency response team!</span>"
		return
	if(alert("Do you want to dispatch an Emergency Response Team?",,"Yes","No") != "Yes")
		return
	if(get_security_level() != "red") // Allow admins to reconsider if the alert level isn't Red
		switch(alert("The station is not in red alert. Do you still want to dispatch a response team?",,"Yes","No"))
			if("No")
				return

	var/choice = input("Select the response team type","Response team selection") as null|anything in list("NanoTrasen Response Team", "Tau Ceti Foreign Legion")

	if(choice)
		ert_type = choice

	if(send_emergency_team)
		usr << "<span class='danger'>Looks like somebody beat you to it!</span>"
		return

	message_admins("[key_name_admin(usr)] is dispatching an Emergency Response Team.", 1)
	log_admin("[key_name(usr)] used Dispatch Response Team.",admin_key=key_name(usr))
	trigger_armed_response_team(1, TRUE)

client/verb/JoinResponseTeam()

	set name = "Join Response Team"
	set category = "IC"

	if(!MayRespawn(1))
		usr << "<span class='warning'>You cannot join the response team at this time.</span>"
		return

	if(istype(usr,/mob/abstract/observer) || istype(usr,/mob/abstract/new_player))

		if(!send_emergency_team)
			usr << "No emergency response team is currently being sent."
			return

		if(jobban_isbanned(usr, "Antagonist") || jobban_isbanned(usr, "Emergency Response Team") || jobban_isbanned(usr, "Security Officer"))
			usr << "<span class='danger'>You are jobbanned from the emergency reponse team!</span>"
			return

		switch(ert_type)

			if("Tau Ceti Foreign Legion")
				if(ert.current_antagonists.len >= ert.hard_cap)
					usr << "The emergency response team is already full!"
					return

				legion.create_default(usr)

			else
				if(ert.current_antagonists.len >= ert.hard_cap)
					usr << "The emergency response team is already full!"
					return

				ert.create_default(usr)
	else
		usr << "You need to be an observer or new player to use this."

// returns a number of dead players in %
proc/percentage_dead()
	var/total = 0
	var/deadcount = 0
	for(var/mob/living/carbon/human/H in mob_list)
		if(H.client) // Monkeys and mice don't have a client, amirite?
			if(H.stat == 2) deadcount++
			total++

	if(total == 0) return 0
	else return round(100 * deadcount / total)

// counts the number of antagonists in %
proc/percentage_antagonists()
	var/total = 0
	var/antagonists = 0
	for(var/mob/living/carbon/human/H in mob_list)
		if(is_special_character(H) >= 1)
			antagonists++
		total++

	if(total == 0) return 0
	else return round(100 * antagonists / total)

// Increments the ERT chance automatically, so that the later it is in the round,
// the more likely an ERT is to be able to be called.
proc/increment_ert_chance()
	while(send_emergency_team == 0) // There is no ERT at the time.
		if(get_security_level() == "green")
			ert_base_chance += 1
		if(get_security_level() == "blue")
			ert_base_chance += 2
		if(get_security_level() == "red")
			ert_base_chance += 3
		if(get_security_level() == "delta")
			ert_base_chance += 10           // Need those big guns
		sleep(600 * 3) // Minute * Number of Minutes


proc/trigger_armed_response_team(var/force = 0, forced_choice = FALSE)
	if(!can_call_ert && !force)
		return
	if(send_emergency_team)
		return

	var/send_team_chance = ert_base_chance // Is incremented by increment_ert_chance.
	send_team_chance += 2*percentage_dead() // the more people are dead, the higher the chance
	send_team_chance += percentage_antagonists() // the more antagonists, the higher the chance
	send_team_chance = min(send_team_chance, 100)

	if(force) send_team_chance = 100

	// there's only a certain chance a team will be sent
	if(!prob(send_team_chance))
		command_announcement.Announce("It would appear that an emergency response team was requested for [station_name()]. Unfortunately, we were unable to send one at this time.", "[current_map.boss_name]")
		can_call_ert = 0 // Only one call per round, ladies.
		return

	command_announcement.Announce("It would appear that an emergency response team was requested for [station_name()]. We will prepare and send one as soon as possible.", "[current_map.boss_name]")

	if(!forced_choice)
		var/random_team = pick("NanoTrasen Response Team", "Tau Ceti Foreign Legion")
		ert_type = random_team

	can_call_ert = 0 // Only one call per round, gentleman.
	send_emergency_team = 1

	sleep(600 * 5)
	send_emergency_team = 0 // Can no longer join the ERT.
	ert_type = "NanoTrasen Response Team"