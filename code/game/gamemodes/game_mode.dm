var/global/antag_add_failed // Used in antag type voting.
var/global/list/additional_antag_types = list()

/datum/game_mode
	var/name = "invalid"
	var/round_description = "How did you even vote this in?"
	var/extended_round_description = "This roundtype should not be spawned, let alone votable. Someone contact a developer and tell them the game's broken again."
	var/config_tag = null
	var/votable = 1
	var/probability = 0

	var/required_players = 0                 // Minimum players for round to start if voted in.
	var/max_players = 0			 			// Maximum players for round to start for secret voting. 0 means "doesn't matter"
	var/required_enemies = 0                 // Minimum antagonists for round to start.
	var/newscaster_announcements = null
	var/end_on_antag_death = 0               // Round will end when all antagonists are dead.
	var/ert_disabled = 0                     // ERT cannot be called.
	var/deny_respawn = 0	                 // Disable respawn during this round.

	var/list/disabled_jobs = list()           // Mostly used for Malf.  This check is performed in job_controller so it doesn't spawn a regular AI.

	var/shuttle_delay = 1                    // Shuttle transit time is multiplied by this.
	var/auto_recall_shuttle = 0              // Will the shuttle automatically be recalled?

	var/list/antag_tags = list()             // Core antag templates to spawn.
	var/list/antag_templates                 // Extra antagonist types to include.
	var/round_autoantag = 0                  // Will this round attempt to periodically spawn more antagonists?
	var/antag_scaling_coeff = 5              // Coefficient for scaling max antagonists to player count.
	var/require_all_templates = 0            // Will only start if all templates are checked and can spawn.

	var/station_was_nuked = 0                // See nuclearbomb.dm and malfunction.dm.
	var/explosion_in_progress = 0            // Sit back and relax
	var/waittime_l = 600                     // Lower bound on time before intercept arrives (in tenths of seconds)
	var/waittime_h = 1800                    // Upper bound on time before intercept arrives (in tenths of seconds)

	var/event_delay_mod_moderate             // Modifies the timing of random events.
	var/event_delay_mod_major                // As above.

/datum/game_mode/New()
	..()
	// Enforce some formatting.
	// This will probably break something.
	name = capitalize(lowertext(name))
	config_tag = lowertext(config_tag)

/datum/game_mode/Topic(href, href_list[])
	if(..())
		return
	if(href_list["toggle"])
		switch(href_list["toggle"])
			if("respawn")
				deny_respawn = !deny_respawn
			if("ert")
				ert_disabled = !ert_disabled
				announce_ert_disabled()
			if("shuttle_recall")
				auto_recall_shuttle = !auto_recall_shuttle
			if("autotraitor")
				round_autoantag = !round_autoantag
		message_admins("Admin [key_name_admin(usr)] toggled game mode option '[href_list["toggle"]]'.")
	else if(href_list["set"])
		var/choice = ""
		switch(href_list["set"])
			if("shuttle_delay")
				choice = input("Enter a new shuttle delay multiplier") as num
				if(!choice || choice < 1 || choice > 20)
					return
				shuttle_delay = choice
			if("antag_scaling")
				choice = input("Enter a new antagonist cap scaling coefficient.") as num
				if(isnull(choice) || choice < 0 || choice > 100)
					return
				antag_scaling_coeff = choice
			if("event_modifier_moderate")
				choice = input("Enter a new moderate event time modifier.") as num
				if(isnull(choice) || choice < 0 || choice > 100)
					return
				event_delay_mod_moderate = choice
				refresh_event_modifiers()
			if("event_modifier_severe")
				choice = input("Enter a new moderate event time modifier.") as num
				if(isnull(choice) || choice < 0 || choice > 100)
					return
				event_delay_mod_major = choice
				refresh_event_modifiers()
		message_admins("Admin [key_name_admin(usr)] set game mode option '[href_list["set"]]' to [choice].")
	else if(href_list["debug_antag"])
		if(href_list["debug_antag"] == "self")
			usr.client.debug_variables(src)
			return
		var/datum/antagonist/antag = all_antag_types[href_list["debug_antag"]]
		if(antag)
			usr.client.debug_variables(antag)
			message_admins("Admin [key_name_admin(usr)] is debugging the [antag.role_text] template.")
	else if(href_list["remove_antag_type"])
		if(antag_tags && (href_list["remove_antag_type"] in antag_tags))
			to_chat(usr, "Cannot remove core mode antag type.")
			return
		var/datum/antagonist/antag = all_antag_types[href_list["remove_antag_type"]]
		if(antag_templates && antag_templates.len && antag && (antag in antag_templates) && (antag.id in additional_antag_types))
			antag_templates -= antag
			additional_antag_types -= antag.id
			message_admins("Admin [key_name_admin(usr)] removed [antag.role_text] template from game mode.")
	else if(href_list["add_antag_type"])
		var/choice = input("Which type do you wish to add?") as null|anything in all_antag_types
		if(!choice)
			return
		var/datum/antagonist/antag = all_antag_types[choice]
		if(antag)
			if(!islist(SSticker.mode.antag_templates))
				SSticker.mode.antag_templates = list()
			SSticker.mode.antag_templates |= antag
			message_admins("Admin [key_name_admin(usr)] added [antag.role_text] template to game mode.")

	// I am very sure there's a better way to do this, but I'm not sure what it might be. ~Z
	// yes there is. but let me first immortalize this code.
/*	spawn(1)
		for(var/datum/admins/admin in world)
			if(usr.client == admin.owner)
				admin.show_game_mode(usr)
				return */

	if (usr.client && usr.client.holder)
		usr.client.holder.show_game_mode(usr)

/datum/game_mode/proc/announce() //to be called when round starts
	to_world("<B>The current game mode is [capitalize(name)]!</B>")
	if(round_description)
		to_world("[round_description]")
	if(round_autoantag)
		to_world("Antagonists will be added to the round automagically as needed.")
	if(antag_templates && antag_templates.len)
		var/antag_summary = "<b>Possible antagonist types:</b> "
		var/i = 1
		for(var/datum/antagonist/antag in antag_templates)
			if(i > 1)
				if(i == antag_templates.len)
					antag_summary += " and "
				else
					antag_summary += ", "
			antag_summary += "[antag.role_text_plural]"
			i++
		antag_summary += "."
		if(antag_templates.len > 1 && !SSticker.hide_mode)
			to_world("[antag_summary]")
		else
			message_admins("[antag_summary]")

///can_start()
///Checks to see if the game can be setup and ran with the current number of players or whatnot.
/datum/game_mode/proc/can_start()

	log_debug("GAMEMODE: Checking gamemode possibility selection for: [name]...")

	var/returning = GAME_FAILURE_NONE

	var/playerC = 0
	for(var/mob/abstract/new_player/player in player_list)
		if(player.client && player.ready)
			playerC++

	log_debug("GAMEMODE: [playerC] players checked and readied.")

	if(required_players && playerC < required_players)
		log_debug("GAMEMODE: There aren't enough players ([playerC]/[required_players]) to start [name]!")
		returning |= GAME_FAILURE_NO_PLAYERS

	if(max_players && playerC > max_players)
		log_debug("GAMEMODE: There are too many players ([playerC]/[max_players]) to start [name]!")
		returning |= GAME_FAILURE_TOO_MANY_PLAYERS

	if(antag_templates && antag_templates.len)
		log_debug("GAMEMODE: Checking antag templates...")
		if(antag_tags && antag_tags.len)
			log_debug("GAMEMODE: Checking antag tags...")
			var/total_enemy_count = 0
			for(var/antag_tag in antag_tags)
				var/datum/antagonist/antag = all_antag_types[antag_tag]
				if(!antag)
					continue
				log_debug("GAMEMODE: Checking antag tag: [antag.role_text]...")
				var/list/potential = list() //List of potential players to spawn as antagonists
				if(antag.flags & ANTAG_OVERRIDE_JOB)
					potential = antag.pending_antagonists
				else
					potential = antag.candidates
				if(islist(potential))
					if(potential.len)
						log_debug("GAMEMODE: Found [potential.len] potential antagonists for [antag.role_text].")
						total_enemy_count += potential.len
						if(antag.initial_spawn_req && require_all_templates && potential.len < antag.initial_spawn_req)
							log_debug("GAMEMODE: There are not enough antagonists ([potential.len]/[antag.initial_spawn_req]) for the role [antag.role_text]!")
							returning |= GAME_FAILURE_NO_ANTAGS

			log_debug("GAMEMODE: Found [total_enemy_count] total enemies for [name].")

			if(required_enemies && total_enemy_count < required_enemies)
				log_debug("GAMEMODE: There are not enough total antagonists ([total_enemy_count]/[required_enemies]) to start [name]!")
				returning |= GAME_FAILURE_NO_ANTAGS

	log_debug("GAMEMODE: Finished gamemode checking. [name] returned [returning].")

	return returning

/datum/game_mode/proc/refresh_event_modifiers()
	if(event_delay_mod_moderate || event_delay_mod_major)
		SSevents.report_at_round_end = 1
		if(event_delay_mod_moderate)
			var/datum/event_container/EModerate = SSevents.event_containers[EVENT_LEVEL_MODERATE]
			EModerate.delay_modifier = event_delay_mod_moderate
		if(event_delay_mod_moderate)
			var/datum/event_container/EMajor = SSevents.event_containers[EVENT_LEVEL_MAJOR]
			EMajor.delay_modifier = event_delay_mod_major

/datum/game_mode/proc/pre_setup()
	for(var/datum/antagonist/antag in antag_templates)
		antag.update_current_antag_max()
		antag.update_initial_spawn_target()
		antag.build_candidate_list() //compile a list of all eligible candidates

		//antag roles that replace jobs need to be assigned before the job controller hands out jobs.
		if(antag.flags & ANTAG_OVERRIDE_JOB)
			antag.attempt_spawn() //select antags to be spawned

///post_setup()
/datum/game_mode/proc/post_setup()

	next_spawn = world.time + rand(min_autotraitor_delay, max_autotraitor_delay)

	refresh_event_modifiers()

	spawn (ROUNDSTART_LOGOUT_REPORT_TIME)
		display_logout_report()

	spawn (rand(waittime_l, waittime_h))
		send_intercept()

	//Assign all antag types for this game mode. Any players spawned as antags earlier should have been removed from the pending list, so no need to worry about those.
	for(var/datum/antagonist/antag in antag_templates)
		if(!(antag.flags & ANTAG_OVERRIDE_JOB))
			antag.attempt_spawn() //select antags to be spawned
		antag.finalize_spawn() //actually spawn antags

	if(emergency_shuttle && auto_recall_shuttle)
		emergency_shuttle.auto_recall = 1

	feedback_set_details("round_start","[time2text(world.realtime)]")
	if(SSticker.mode)
		feedback_set_details("master_mode","[master_mode]")
		feedback_set_details("game_mode","[SSticker.mode]")
	feedback_set_details("server_ip","[world.internet_address]:[world.port]")
	return 1

/datum/game_mode/proc/fail_setup()
	for(var/datum/antagonist/antag in antag_templates)
		antag.reset_antag_selection()

/datum/game_mode/proc/announce_ert_disabled()
	if(!ert_disabled)
		return

	var/list/reasons = list(
		"political instability",
		"quantum fluctuations",
		"hostile raiders",
		"derelict station debris",
		"REDACTED",
		"ancient alien artillery",
		"solar magnetic storms",
		"sentient time-travelling killbots",
		"gravitational anomalies",
		"wormholes to another dimension",
		"a telescience mishap",
		"radiation flares",
		"supermatter dust",
		"leaks into a negative reality",
		"antiparticle clouds",
		"residual bluespace energy",
		"suspected criminal operatives",
		"malfunctioning von Neumann probe swarms",
		"shadowy interlopers",
		"a stranded Vox arkship",
		"haywire IPC constructs",
		"rogue Unathi exiles",
		"artifacts of eldritch horror",
		"a brain slug infestation",
		"killer bugs that lay eggs in the husks of the living",
		"a deserted transport carrying xenomorph specimens",
		"an emissary for the gestalt requesting a security detail",
		"classified security operations"
		)
	command_announcement.Announce("The presence of [pick(reasons)] in the region is tying up all available local emergency resources; emergency response teams cannot be called at this time, and post-evacuation recovery efforts will be substantially delayed.","Emergency Transmission")

/datum/game_mode/proc/check_finished()
	if(emergency_shuttle.returned() || station_was_nuked)
		return 1
	if(end_on_antag_death && antag_templates && antag_templates.len)
		for(var/datum/antagonist/antag in antag_templates)
			if(!antag.antags_are_dead())
				return 0
		if(config.continous_rounds)
			emergency_shuttle.auto_recall = 0
			return 0
		return 1
	return 0

/datum/game_mode/proc/cleanup()	//This is called when the round has ended but not the game, if any cleanup would be necessary in that case.
	return

/datum/game_mode/proc/declare_completion()

	var/is_antag_mode = (antag_templates && antag_templates.len)
	var/discord_text = "A round of **[name]** has ended! \[Game ID: [game_id]\]\n\n"
	var/antag_text = ""
	check_victory()
	if(is_antag_mode)
		sleep(10)
		for (var/datum/antagonist/antag in antag_templates)
			sleep(10)
			antag.check_victory()
			antag.print_player_summary()
			// Avoid the longest loop if we aren't actively using the bot.
			if (discord_bot.active)
				antag_text += antag.print_player_summary_discord()

		sleep(10)
		print_ownerless_uplinks()

	discord_text += antag_text
	discord_bot.send_to_announce(discord_text, 1)
	discord_text = ""

	var/clients = 0
	var/surviving_humans = 0
	var/surviving_total = 0
	var/ghosts = 0
	var/escaped_humans = 0
	var/escaped_total = 0
	var/escaped_on_pod_1 = 0
	var/escaped_on_pod_2 = 0
	var/escaped_on_pod_3 = 0
	var/escaped_on_pod_5 = 0
	var/escaped_on_shuttle = 0

	var/list/area/escape_locations = list(/area/shuttle/escape/centcom, /area/shuttle/escape_pod1/centcom, /area/shuttle/escape_pod2/centcom, /area/shuttle/escape_pod3/centcom, /area/shuttle/escape_pod5/centcom)

	for(var/mob/M in player_list)
		if(M.client)
			clients++
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				if(M.stat != DEAD)
					surviving_humans++
					if(M.loc && M.loc.loc && M.loc.loc.type in escape_locations)
						escaped_humans++
					if (isipc(H))
						var/datum/species/machine/machine = H.species
						machine.update_tag(H, H.client)
			if(M.stat != DEAD)
				surviving_total++
				if(M.loc && M.loc.loc && M.loc.loc.type in escape_locations)
					escaped_total++

				if(M.loc && M.loc.loc && M.loc.loc.type == /area/shuttle/escape/centcom)
					escaped_on_shuttle++

				if(M.loc && M.loc.loc && M.loc.loc.type == /area/shuttle/escape_pod1/centcom)
					escaped_on_pod_1++
				if(M.loc && M.loc.loc && M.loc.loc.type == /area/shuttle/escape_pod2/centcom)
					escaped_on_pod_2++
				if(M.loc && M.loc.loc && M.loc.loc.type == /area/shuttle/escape_pod3/centcom)
					escaped_on_pod_3++
				if(M.loc && M.loc.loc && M.loc.loc.type == /area/shuttle/escape_pod5/centcom)
					escaped_on_pod_5++

			if(isobserver(M))
				ghosts++

	var/text = ""
	if(surviving_total > 0)
		text += "<br>There [surviving_total>1 ? "were <b>[surviving_total] survivors</b>" : "was <b>one survivor</b>"]"
		text += " (<b>[escaped_total>0 ? escaped_total : "none"] [emergency_shuttle.evac ? "escaped" : "transferred"]</b>) and <b>[ghosts] ghosts</b>.<br>"

		discord_text += "There [surviving_total>1 ? "were **[surviving_total] survivors**" : "was **one survivor**"]"
		discord_text += " ([escaped_total>0 ? escaped_total : "none"] [emergency_shuttle.evac ? "escaped" : "transferred"]) and **[ghosts] ghosts**."
	else
		text += "There were <b>no survivors</b> (<b>[ghosts] ghosts</b>)."

		discord_text += "There were **no survivors** ([ghosts] ghosts)."
	to_world(text)

	discord_bot.send_to_announce(discord_text)
	post_webhook_event(WEBHOOK_ROUNDEND, list("survivours"=surviving_total, "escaped"=escaped_total, "ghosts"=ghosts, "gamemode"=name, "gameid"=game_id, "antags"=antag_text))

	if(clients > 0)
		feedback_set("round_end_clients",clients)
	if(ghosts > 0)
		feedback_set("round_end_ghosts",ghosts)
	if(surviving_humans > 0)
		feedback_set("survived_human",surviving_humans)
	if(surviving_total > 0)
		feedback_set("survived_total",surviving_total)
	if(escaped_humans > 0)
		feedback_set("escaped_human",escaped_humans)
	if(escaped_total > 0)
		feedback_set("escaped_total",escaped_total)
	if(escaped_on_shuttle > 0)
		feedback_set("escaped_on_shuttle",escaped_on_shuttle)
	if(escaped_on_pod_1 > 0)
		feedback_set("escaped_on_pod_1",escaped_on_pod_1)
	if(escaped_on_pod_2 > 0)
		feedback_set("escaped_on_pod_2",escaped_on_pod_2)
	if(escaped_on_pod_3 > 0)
		feedback_set("escaped_on_pod_3",escaped_on_pod_3)
	if(escaped_on_pod_5 > 0)
		feedback_set("escaped_on_pod_5",escaped_on_pod_5)

	return 0

/datum/game_mode/proc/check_win() //universal trigger to be called at mob death, nuke explosion, etc. To be called from everywhere.
	return 0

/datum/game_mode/proc/send_intercept()

	var/intercepttext = "<center><img src = ntlogo.png></center><BR><FONT size = 3><BR><B>Cent. Com. Update</B><BR>FOR YOUR EYES ONLY:</FONT><HR><font face='Courier New'>"

	var/list/disregard_roles = list()
	for(var/antag_type in all_antag_types)
		var/datum/antagonist/antag = all_antag_types[antag_type]
		if(antag.flags & ANTAG_SUSPICIOUS)
			disregard_roles |= antag.role_text

	var/list/suspects = list()
	var/list/loyalists
	var/list/repeat_offenders = list()
	var/eng_suspect = 0
	var/eng = 0
	var/sec_suspect = 0
	var/sec = 0
	var/med_suspect = 0
	var/med = 0
	var/sci_suspect = 0
	var/sci = 0
	var/civ_suspect = 0
	var/civ = 0
	var/loyal_crew = 0
	var/total_crew = 0
	var/evil_department

	for(var/mob/living/carbon/human/man in player_list) if(man.client && man.mind)

		// NT relation option
		var/special_role = man.mind.special_role
		var/datum/antagonist/special_role_data = get_antag_data(special_role)

		total_crew += 1
		if (special_role in disregard_roles)
			continue
		else if(man.mind.assigned_job)
			var/datum/job/job = man.mind.assigned_job
			var/evil = 0
			if(man.client.prefs.nanotrasen_relation == COMPANY_OPPOSED || man.client.prefs.nanotrasen_relation == COMPANY_SKEPTICAL)
				evil = 1
			switch(job.department)
				if("Civilian" || "Cargo")
					civ += 1
					if(evil)
						civ_suspect += 1
				if("Engineering")
					eng += 1
					if(evil)
						eng_suspect += 1
				if("Security")
					sec += 1
					if(evil)
						sec_suspect += 1
				if("Medical")
					med +=1
					if(evil)
						med_suspect += 1
				if("Science")
					sci += 1
					if(evil)
						sci_suspect += 1

		else if(man.client.prefs.nanotrasen_relation == COMPANY_OPPOSED && prob(25))
			suspects += man
		else if(man.client.prefs.nanotrasen_relation == COMPANY_LOYAL || man.client.prefs.nanotrasen_relation == COMPANY_SUPPORTATIVE)
			loyal_crew += 1
			if(prob(25))
				loyalists += man
		// Antags
		else if(special_role_data && prob(special_role_data.suspicion_chance))
			suspects += man
		if(man.incidents.len >= 3)
			repeat_offenders += man

	var/civ_ratio = 0
	if(civ)
		civ_ratio = civ_suspect / civ
	var/eng_ratio = 0
	if(eng)
		eng_ratio = eng_suspect / eng
	var/sec_ratio = 0
	if(sec)
		sec_ratio = sec_suspect / sec
	var/med_ratio = 0
	if(med)
		med_ratio = med_suspect / med
	var/sci_ratio  = 0
	if(sci)
		sci_ratio = sci_suspect / sci

	var/most_evil = max(civ_ratio, eng_ratio, sec_ratio, med_ratio, sci_ratio)
	if(most_evil >= 0.5)
		if(most_evil == civ_ratio)
			evil_department = "Civilian & Supply"
		else if(most_evil == eng_ratio)
			evil_department = "Engineering"
		else if(most_evil == sec_ratio)
			evil_department = "Security"
		else if(most_evil == med_ratio)
			evil_department = "Medical"
		else if(most_evil == sci_ratio)
			evil_department = "Science"

	var/business_jargon = list("Collated incident reports","Assembled peer-reviews","Persistently negative staff reviews","Collected shift logs","Accumulated negative reports","Analyzed shift data")
	var/mean_words = list("has expressed consistent disapproval with the network", "is no longer working efficiently","has gone on record against NanoTrasen practices","is spreading minor dissent in response to recent NanoTrasen behavior","has expressed subversive intent","is unhappy with their employment package")

	if(suspects)
		intercepttext += "<B>The personnel listed below have been marked at-risk elements that Cent. Com. has deemed priority handling for the current shift:</B><br>"
		for(var/mob/living/carbon/human/M in suspects)
			if(player_is_antag(M.mind, only_offstation_roles = 1))
				continue
			intercepttext += "<br>     + [pick(business_jargon)] indicate that [M.mind.assigned_role] [M.name] [pick(mean_words)].<br>"
		intercepttext += "Cent. Com recommends coordinating with human resources to resolve any issues with employment.<br>"

	if(repeat_offenders)
		intercepttext += "<br><B>The personnel listed below possess three or more offenses listed on record:</B>"
		for(var/mob/living/carbon/human/M in repeat_offenders)
			if(player_is_antag(M.mind, only_offstation_roles = 1))
				continue
			intercepttext += "<br>     + [M.mind.assigned_role] [M.name], [M.incidents.len] offenses.<br>"
		intercepttext += "Cent. Com recommends coordinating with internal security to monitor and rehabilitate these personnel.<br>"

	if(loyalists)
		intercepttext += "<br><B>The personnel listed below have been indicated as particularly loyal to NanoTrasen:</B>"
		for(var/mob/living/carbon/human/M in loyalists)
			if(player_is_antag(M.mind, only_offstation_roles = 1))
				continue
			intercepttext += "<br>     + [M.mind.assigned_role] [M.name].<br>"
		intercepttext += "Cent. Com recommends coordinating with human resources to reward and further motivate these personnel for their loyalty.<br>"

	if(evil_department)
		intercepttext += "<br>[pick(business_jargon)] indicate that a majority of the [evil_department] department [pick(mean_words)]. This department has been marked at-risk and Cent. Com. recommends immediate action before the situation worsens.<br>"
	if(total_crew)
		intercepttext += "<br>Data collected and analyzed by Bubble indicate that [round((loyal_crew/total_crew)*100)]% of the current crew detail are supportive of NanoTrasen actions. Cent. Com. implores the current Head of Staff detail to increase this percentage.<br>"

	intercepttext += "<hr> </font>Respectfully,<br><i>Quix Repi'Weish</i>, Chief Personnel Director<br>"
	intercepttext += "<center><img src = barcode[rand(0, 3)].png></center>"

	//New message handling
	post_comm_message("Cent. Com. Status Summary", intercepttext)

	to_world(sound('sound/AI/commandreport.ogg'))

/datum/game_mode/proc/get_players_for_role(var/role, var/antag_id)
	var/list/players = list()
	var/list/candidates = list()

	var/datum/antagonist/antag_template = all_antag_types[antag_id]
	if(!antag_template)
		return candidates

	// If this is being called post-roundstart then it doesn't care about ready status.
	if(SSticker.current_state == GAME_STATE_PLAYING)
		for(var/mob/player in player_list)
			if(!player.client)
				continue
			if(istype(player, /mob/abstract/new_player))
				continue
			if(!role || (role in player.client.prefs.be_special_role))
				log_debug("[player.key] had [antag_id] enabled, so we are drafting them.")
				candidates |= player.mind
	else
		// Assemble a list of active players without jobbans.
		for(var/mob/abstract/new_player/player in player_list)
			if( player.client && player.ready )
				players += player

		// Get a list of all the people who want to be the antagonist for this round
		for(var/mob/abstract/new_player/player in players)
			if(!role || (role in player.client.prefs.be_special_role))
				log_debug("[player.key] had [antag_id] enabled, so we are drafting them.")
				candidates += player.mind
				players -= player

		// If we don't have enough antags, draft people who voted for the round.
		if(candidates.len < required_enemies)
			var/initial_candidates = candidates.len

			for(var/mob/abstract/new_player/player in players)
				if(player.ckey in SSvote.round_voters)
					log_debug("[player.key] voted for this round, so we are drafting them.")
					candidates += player.mind
					players -= player

					if (candidates.len >= required_enemies)
						log_debug("Drafted [candidates.len - initial_candidates] new antags from voters.")
						break

	return candidates		// Returns: The number of people who had the antagonist role set to yes, regardless of recomended_enemies, if that number is greater than required_enemies
							//			required_enemies if the number of people with that role set to yes is less than recomended_enemies,
							//			Less if there are not enough valid players in the game entirely to make required_enemies.

/datum/game_mode/proc/num_players()
	. = 0
	for(var/mob/abstract/new_player/P in player_list)
		if(P.client && P.ready)
			. ++

/datum/game_mode/proc/check_antagonists_topic(href, href_list[])
	return 0

/datum/game_mode/proc/create_antagonists()

	if(!config.traitor_scaling)
		antag_scaling_coeff = 0

	if(antag_tags && antag_tags.len)
		antag_templates = list()
		for(var/antag_tag in antag_tags)
			var/datum/antagonist/antag = all_antag_types[antag_tag]
			if(antag)
				antag_templates |= antag

	if(additional_antag_types && additional_antag_types.len)
		if(!antag_templates)
			antag_templates = list()
		for(var/antag_type in additional_antag_types)
			var/datum/antagonist/antag = all_antag_types[antag_type]
			if(antag)
				antag_templates |= antag

	shuffle(antag_templates) //In the case of multiple antag types
	newscaster_announcements = pick(newscaster_standard_feeds)

/datum/game_mode/proc/check_victory()
	return

//////////////////////////
//Reports player logouts//
//////////////////////////
proc/get_logout_report()
	var/msg = "<span class='notice'><b>Logout report</b>\n\n"
	for(var/mob/living/L in mob_list)

		if(L.ckey)
			var/found = 0
			for(var/client/C in clients)
				if(C.ckey == L.ckey)
					found = 1
					break
			if(!found)
				msg += "<b>[L.name]</b> ([L.ckey]), the [L.job] (<font color='#ffcc00'><b>Disconnected</b></font>)\n"

		if(L.ckey && L.client)
			if(L.client.inactivity >= (ROUNDSTART_LOGOUT_REPORT_TIME / 2))	//Connected, but inactive (alt+tabbed or something)
				msg += "<b>[L.name]</b> ([L.ckey]), the [L.job] (<font color='#ffcc00'><b>Connected, Inactive</b></font>)\n"
				continue //AFK client
			if(L.stat)
				if(L.stat == UNCONSCIOUS)
					msg += "<b>[L.name]</b> ([L.ckey]), the [L.job] (Dying)\n"
					continue //Unconscious
				if(L.stat == DEAD)
					msg += "<b>[L.name]</b> ([L.ckey]), the [L.job] (Dead)\n"
					continue //Dead

			continue //Happy connected client
		for(var/mob/abstract/observer/D in mob_list)
			if(D.mind && (D.mind.original == L || D.mind.current == L))
				if(L.stat == DEAD)
					msg += "<b>[L.name]</b> ([ckey(D.mind.key)]), the [L.job] (Dead)\n"
					continue //Dead mob, ghost abandoned
				else
					if(D.can_reenter_corpse)
						msg += "<b>[L.name]</b> ([ckey(D.mind.key)]), the [L.job] (<font color='red'><b>Adminghosted</b></font>)\n"
						continue //Lolwhat
					else
						msg += "<b>[L.name]</b> ([ckey(D.mind.key)]), the [L.job] (<font color='red'><b>Ghosted</b></font>)\n"
						continue //Ghosted while alive

	msg += "</span>" // close the span from right at the top
	return msg

proc/display_logout_report()
	var/logout_report = get_logout_report()
	for(var/s in staff)
		var/client/C = s
		if(check_rights(R_MOD|R_ADMIN,0,C.mob))
			to_chat(C.mob, logout_report)

/client/proc/print_logout_report()
	set category = "Admin"
	set name = "Print Logout Report"

	if(!check_rights(R_ADMIN|R_MOD))
		return
	to_chat(src,get_logout_report())

proc/get_nt_opposed()
	var/list/dudes = list()
	for(var/mob/living/carbon/human/man in player_list)
		if(man.client)
			if(man.client.prefs.nanotrasen_relation == COMPANY_OPPOSED)
				dudes += man
			else if(man.client.prefs.nanotrasen_relation == COMPANY_SKEPTICAL && prob(50))
				dudes += man
	if(dudes.len == 0) return null
	return pick(dudes)

//Announces objectives/generic antag text.
/proc/show_generic_antag_text(var/datum/mind/player)
	if(player.current)
		to_chat(player.current, "You are an antagonist! <font color=blue>Within the rules,</font> try to act as an opposing force to the crew. Further RP and try to make sure other players have <i>fun</i>! If you are confused or at a loss, always adminhelp, and before taking extreme actions, please try to also contact the administration! Think through your actions and make the roleplay immersive! <b>Please remember all rules aside from those without explicit exceptions apply to antagonists.</b>")

/proc/show_objectives(var/datum/mind/player)

	if(!player || !player.current) return

	if(config.objectives_disabled)
		show_generic_antag_text(player)
		return

	var/obj_count = 1
	to_chat(player.current, "<span class='notice'>Your current objectives:</span>")
	for(var/datum/objective/objective in player.objectives)
		to_chat(player.current, "<B>Objective #[obj_count]</B>: [objective.explanation_text]")
		obj_count++

/mob/verb/check_round_info()
	set name = "Check Round Info"
	set category = "OOC"

	if(!SSticker.mode)
		to_chat(usr, "Something is terribly wrong; there is no gametype.")
		return

	if(!SSticker.hide_mode)
		to_chat(usr, "<b>The roundtype is [capitalize(SSticker.mode.name)]</b>")
		if(SSticker.mode.round_description)
			to_chat(usr, "<i>[SSticker.mode.round_description]</i>")
		if(SSticker.mode.extended_round_description)
			to_chat(usr, "[SSticker.mode.extended_round_description]")
	else
		to_chat(usr, "<i>Shhhh</i>. It's a secret.")
	return

/mob/verb/check_gamemode_probability()
	set name = "Check Gamemode Probability"
	set category = "OOC"

	if(config.show_game_type_odd)
		to_chat(src, "<b>Secret Mode Odds:</b>")
		var/sum = 0
		for(var/config_tag in config.probabilities_secret)
			sum += config.probabilities_secret[config_tag]
		for(var/config_tag in config.probabilities_secret)
			if(config.probabilities_secret[config_tag] > 0)
				var/percentage = round(config.probabilities_secret[config_tag] / sum * 100, 0.1)
				to_chat(src, "[config_tag] [percentage]%")

		to_chat(src, "<b>Mixed Secret Mode Odds:</b>")
		sum = 0
		for(var/config_tag in config.probabilities_mixed_secret)
			sum += config.probabilities_mixed_secret[config_tag]
		for(var/config_tag in config.probabilities_mixed_secret)
			if(config.probabilities_mixed_secret[config_tag] > 0)
				var/percentage = round(config.probabilities_mixed_secret[config_tag] / sum * 100, 0.1)
				to_chat(src, "[config_tag] [percentage]%")
	else
		to_chat(src, "Displaying gamemode odds is disabled in the config.")
