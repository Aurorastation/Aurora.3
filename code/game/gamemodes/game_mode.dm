var/global/antag_add_failed // Used in antag type voting.
GLOBAL_LIST_EMPTY(additional_antag_types)

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
	var/waittime_l = 60 SECONDS                     // Lower bound on time before intercept arrives (in tenths of seconds)
	var/waittime_h = 180 SECONDS                    // Upper bound on time before intercept arrives (in tenths of seconds)

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
		var/datum/antagonist/antag = GLOB.all_antag_types[href_list["debug_antag"]]
		if(antag)
			usr.client.debug_variables(antag)
			message_admins("Admin [key_name_admin(usr)] is debugging the [antag.role_text] template.")
	else if(href_list["remove_antag_type"])
		if(antag_tags && (href_list["remove_antag_type"] in antag_tags))
			to_chat(usr, "Cannot remove core mode antag type.")
			return
		var/datum/antagonist/antag = GLOB.all_antag_types[href_list["remove_antag_type"]]
		if(antag_templates && antag_templates.len && antag && (antag in antag_templates) && (antag.id in GLOB.additional_antag_types))
			antag_templates -= antag
			GLOB.additional_antag_types -= antag.id
			message_admins("Admin [key_name_admin(usr)] removed [antag.role_text] template from game mode.")
	else if(href_list["add_antag_type"])
		var/choice = input("Which type do you wish to add?") as null|anything in GLOB.all_antag_types
		if(!choice)
			return
		var/datum/antagonist/antag = GLOB.all_antag_types[choice]
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

	log_game_mode("Checking gamemode possibility selection for: [name]...")

	var/returning = GAME_FAILURE_NONE

	var/playerC = 0
	for(var/mob/abstract/new_player/player in GLOB.player_list)
		if(player.client && player.ready)
			playerC++

	log_traitor("[playerC] players checked and readied.")

	if(required_players && playerC < required_players)
		log_game_mode("There aren't enough players ([playerC]/[required_players]) to start [name]!")
		returning |= GAME_FAILURE_NO_PLAYERS

	if(max_players && playerC > max_players)
		log_game_mode("There are too many players ([playerC]/[max_players]) to start [name]!")
		returning |= GAME_FAILURE_TOO_MANY_PLAYERS

	if(antag_templates && antag_templates.len)
		log_game_mode("Checking antag templates...")
		if(antag_tags && antag_tags.len)
			log_game_mode("Checking antag tags...")
			for(var/antag_tag in antag_tags)
				var/datum/antagonist/antag = GLOB.all_antag_types[antag_tag]
				if(!antag)
					continue
				log_game_mode("Checking antag tag: [antag.role_text]...")
				var/list/potential = list() //List of potential players to spawn as antagonists
				if(antag.flags & ANTAG_OVERRIDE_JOB)
					potential = antag.pending_antagonists
				else
					potential = antag.candidates
				if(islist(potential))
					for(var/potential_antag in potential)
						var/datum/mind/player = potential_antag
						if(!(antag.flags & ANTAG_OVERRIDE_JOB) && (player.assigned_role in antag.restricted_jobs))
							potential -= potential_antag
							antag.candidates -= player
							log_traitor("GAMEMODE: Player [player.name] ([player.key]) was removed from the potential antags list due to being given the role [player.assigned_role] which is a restricted job!")

			// Split the for loop here so that we can have a complete set of potential lists for each antag_tag before continuing
			var/list/total_enemies = list()
			for(var/antag_tag in antag_tags)
				var/datum/antagonist/antag = GLOB.all_antag_types[antag_tag]
				if(!antag)
					continue
				var/list/potential = list()
				if(antag.flags & ANTAG_OVERRIDE_JOB)
					potential = antag.pending_antagonists
				else
					potential = antag.candidates
				if(potential.len)
					log_traitor("GAMEMODE: Found [potential.len] potential antagonists for [antag.role_text].")
					total_enemies |= potential //Only count candidates once for our total enemy pool
					if(antag.initial_spawn_req && require_all_templates && potential.len < antag.initial_spawn_req)
						log_game_mode("There are not enough antagonists ([potential.len]/[antag.initial_spawn_req]) for the role [antag.role_text]!")
						returning |= GAME_FAILURE_NO_ANTAGS

			log_traitor("GAMEMODE: Found [total_enemies.len] total enemies for [name].")

			if(required_enemies && total_enemies.len < required_enemies)
				log_traitor("GAMEMODE: There are not enough total antagonists ([total_enemies.len]/[required_enemies]) to start [name]!")
				returning |= GAME_FAILURE_NO_ANTAGS

	log_game_mode("Finished gamemode checking. [name] returned [returning].")

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
	SHOULD_CALL_PARENT(TRUE)
	for(var/datum/antagonist/antag in antag_templates)
		antag.update_current_antag_max()
		antag.update_initial_spawn_target()
		antag.build_candidate_list() //compile a list of all eligible candidates

	if(length(antag_templates) > 1) // If we have multiple templates to satisfy, we must pick candidates who satisfy fewer templates first, and fill the template with fewest candidates first
		var/list/template_candidates = list()
		var/list/all_candidates = list() // All candidates for every template, may contain duplicates
		var/list/antag_templates_by_initial_spawn_req = list()

		for(var/datum/antagonist/antag in antag_templates)
			template_candidates[antag.id] = length(antag.candidates)
			all_candidates += antag.candidates
			antag_templates_by_initial_spawn_req[antag] = antag.initial_spawn_req

		sortTim(antag_templates_by_initial_spawn_req, GLOBAL_PROC_REF(cmp_numeric_asc), TRUE)
		antag_templates = list_keys(antag_templates_by_initial_spawn_req)

		var/list/valid_templates_per_candidate = list() // number of roles each candidate can satisfy
		for(var/candidate in all_candidates)
			valid_templates_per_candidate[candidate]++

		valid_templates_per_candidate = shuffle(valid_templates_per_candidate) // shuffle before sorting so that candidates with the same number of templates will be in random order
		sortTim(valid_templates_per_candidate, GLOBAL_PROC_REF(cmp_numeric_asc), TRUE)

		for(var/datum/antagonist/antag in antag_templates)
			antag.candidates = list_keys(valid_templates_per_candidate) & antag.candidates // orders antag.candidates by valid_templates_per_candidate

		var/datum/antagonist/last_template = antag_templates[antag_templates.len]
		last_template.candidates = shuffle(last_template.candidates)

	for(var/datum/antagonist/antag in antag_templates)
		//antag roles that replace jobs need to be assigned before the job controller hands out jobs.
		if(antag.flags & ANTAG_OVERRIDE_JOB)
			antag.attempt_spawn() //select antags to be spawned
		antag.candidates = shuffle(antag.candidates) // makes selection past initial_spawn_req fairer

///post_setup()
/datum/game_mode/proc/post_setup()

	next_spawn = world.time + rand(min_autotraitor_delay, max_autotraitor_delay)

	refresh_event_modifiers()

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(display_logout_report)), ROUNDSTART_LOGOUT_REPORT_TIME)

	var/welcome_delay = rand(waittime_l, waittime_h)
	addtimer(CALLBACK(current_map, TYPE_PROC_REF(/datum/map, send_welcome)), welcome_delay)

	addtimer(CALLBACK(current_map, TYPE_PROC_REF(/datum/map, load_holodeck_programs)), 5 MINUTES)

	//Assign all antag types for this game mode. Any players spawned as antags earlier should have been removed from the pending list, so no need to worry about those.
	for(var/datum/antagonist/antag in antag_templates)
		if(!(antag.flags & ANTAG_OVERRIDE_JOB))
			antag.attempt_spawn() //select antags to be spawned
		if(!(antag.flags & ANTAG_NO_ROUNDSTART_SPAWN))
			antag.finalize_spawn() //actually spawn antags

	if(evacuation_controller && auto_recall_shuttle)
		evacuation_controller.auto_recall(1)

	feedback_set_details("round_start","[time2text(world.realtime)]")
	if(SSticker.mode)
		feedback_set_details("GLOB.master_mode","[GLOB.master_mode]")
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
		"a stranded Vaurcan hiveship",
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
	return evacuation_controller.round_over() || station_was_nuked

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
			if (SSdiscord.active)
				antag_text += antag.print_player_summary_discord()

		sleep(10)
		print_ownerless_uplinks()

	discord_text += antag_text
	SSdiscord.send_to_announce(discord_text, 1)
	discord_text = ""

	var/clients = 0
	var/surviving_total = 0
	var/escaped_total = 0
	var/ghosts = 0

	for(var/mob/M in GLOB.player_list)
		if(M.client)
			clients++
			if(M.stat != DEAD && isipc(M))
				var/mob/living/carbon/human/H = M
				var/datum/species/machine/machine = H.species
				machine.update_tag(H, H.client)
			if(M.stat != DEAD)
				var/turf/playerTurf = get_turf(M)
				var/area/playerArea = get_area(playerTurf)
				surviving_total++
				if(isStationLevel(playerTurf.z) && is_station_area(playerArea))
					escaped_total++
			if(isobserver(M))
				ghosts++

	var/text = ""
	var/escape_text
	if(evacuation_controller.evacuation_type == TRANSFER_EMERGENCY)
		escape_text = "escaped"
	else
		escape_text = "transfered"
	if(surviving_total > 0)
		text += "<br>There [surviving_total>1 ? "were <b>[surviving_total] survivors</b>" : "was <b>one survivor</b>"]"
		text += " (<b>[escaped_total>0 ? escaped_total : "none"] [escape_text]</b>) and <b>[ghosts] ghosts</b>.<br>"

		discord_text += "There [surviving_total>1 ? "were **[surviving_total] survivors**" : "was **one survivor**"]"
		discord_text += " ([escaped_total>0 ? escaped_total : "none"] [escape_text]) and **[ghosts] ghosts**."
	else
		text += "There were <b>no survivors</b> (<b>[ghosts] ghosts</b>)."

		discord_text += "There were **no survivors** ([ghosts] ghosts)."
	to_world(text)

	SSdiscord.send_to_announce(discord_text)
	SSdiscord.post_webhook_event(WEBHOOK_ROUNDEND, list("survivours"=surviving_total, "escaped"=escaped_total, "ghosts"=ghosts, "gamemode"=name, "gameid"=game_id, "antags"=antag_text))

	if(clients > 0)
		feedback_set("round_end_clients", clients)
	if(ghosts > 0)
		feedback_set("round_end_ghosts", ghosts)
	if(surviving_total > 0)
		feedback_set("survived_total", surviving_total)
	if(escaped_total > 0)
		feedback_set("escaped_total", escaped_total)

	return 0

/datum/game_mode/proc/check_win() //universal trigger to be called at mob death, nuke explosion, etc. To be called from everywhere.
	return 0

/datum/game_mode/proc/get_players_for_role(var/role, var/antag_id)
	var/list/players = list()
	var/list/candidates = list()

	var/datum/antagonist/antag_template = GLOB.all_antag_types[antag_id]
	if(!antag_template)
		return candidates

	// If this is being called post-roundstart then it doesn't care about ready status.
	if(SSticker.current_state == GAME_STATE_PLAYING)
		for(var/mob/player in GLOB.player_list)
			if(!player.client)
				continue
			if(istype(player, /mob/abstract/new_player))
				continue
			if(!role || (role in player.client.prefs.be_special_role))
				log_traitor("[player.key] had [antag_id] enabled, so we are drafting them.")
				candidates |= player.mind
	else
		// Assemble a list of active players without jobbans.
		for(var/mob/abstract/new_player/player in GLOB.player_list)
			if( player.client && player.ready )
				players += player

		// Get a list of all the people who want to be the antagonist for this round
		for(var/mob/abstract/new_player/player in players)
			if(!role || (role in player.client.prefs.be_special_role))
				log_traitor("[player.key] had [antag_id] enabled, so we are drafting them.")
				candidates += player.mind
				players -= player

	return candidates		// Returns: The number of people who had the antagonist role set to yes, regardless of recomended_enemies, if that number is greater than required_enemies
							//			required_enemies if the number of people with that role set to yes is less than recomended_enemies,
							//			Less if there are not enough valid players in the game entirely to make required_enemies.

/datum/game_mode/proc/num_players()
	. = 0
	for(var/mob/abstract/new_player/P in GLOB.player_list)
		if(P.client && P.ready)
			. ++

/datum/game_mode/proc/check_antagonists_topic(href, href_list[])
	return 0

/datum/game_mode/proc/create_antagonists()

	if(!GLOB.config.traitor_scaling)
		antag_scaling_coeff = 0

	if(antag_tags && antag_tags.len)
		antag_templates = list()
		for(var/antag_tag in antag_tags)
			var/datum/antagonist/antag = GLOB.all_antag_types[antag_tag]
			if(antag)
				antag_templates |= antag

	if(GLOB.additional_antag_types && GLOB.additional_antag_types.len)
		if(!antag_templates)
			antag_templates = list()
		for(var/antag_type in GLOB.additional_antag_types)
			var/datum/antagonist/antag = GLOB.all_antag_types[antag_type]
			if(antag)
				antag_templates |= antag

	shuffle(antag_templates) //In the case of multiple antag types
	newscaster_announcements = pick(newscaster_standard_feeds)

/datum/game_mode/proc/check_victory()
	return

//////////////////////////
//Reports player logouts//
//////////////////////////
/proc/get_logout_report()
	var/msg = "<span class='notice'><b>Logout report</b>\n\n"
	for(var/mob/living/L in GLOB.mob_list)

		if(L.ckey)
			var/found = 0
			for(var/client/C in GLOB.clients)
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
					msg += "<b>[L.name]</b> ([L.ckey]), the [L.job] (Unconscious)\n"
					continue //Unconscious
				if(L.stat == DEAD)
					msg += "<b>[L.name]</b> ([L.ckey]), the [L.job] (Dead)\n"
					continue //Dead

			continue //Happy connected client
		for(var/mob/abstract/observer/D in GLOB.mob_list)
			if(D.mind && (D.mind.original == L || D.mind.current == L))
				if(L.stat == DEAD)
					msg += "<b>[L.name]</b> ([ckey(D.mind.key)]), the [L.job] (Dead)\n"
					continue //Dead mob, ghost abandoned
				else
					if(D.can_reenter_corpse)
						msg += "<b>[L.name]</b> ([ckey(D.mind.key)]), the [L.job] (<span class='warning'><b>Adminghosted</b></span>)\n"
						continue //Lolwhat
					else
						msg += "<b>[L.name]</b> ([ckey(D.mind.key)]), the [L.job] (<span class='warning'><b>Ghosted</b></span>)\n"
						continue //Ghosted while alive

	msg += "</span>" // close the span from right at the top
	return msg

/proc/display_logout_report()
	var/logout_report = get_logout_report()
	for(var/s in GLOB.staff)
		var/client/C = s
		if(check_rights(R_MOD|R_ADMIN,0,C.mob))
			to_chat(C.mob, logout_report)

/client/proc/print_logout_report()
	set category = "Admin"
	set name = "Print Logout Report"

	if(!check_rights(R_ADMIN|R_MOD))
		return
	to_chat(src,get_logout_report())

/proc/get_poor()
	var/list/characters = list()

	for(var/mob/living/carbon/human/character in GLOB.player_list)
		if(character.client)
			if((character.client.prefs.economic_status == ECONOMICALLY_DESTITUTE) || (character.client.prefs.economic_status == ECONOMICALLY_RUINED)) // Discrimination.
				characters += character
			else if(character.client.prefs.economic_status == ECONOMICALLY_POOR && prob(50)) // 50% discrimination.
				characters += character

	if(!length(characters))
		return

	return pick(characters)

//Announces objectives/generic antag text.
/proc/show_generic_antag_text(var/datum/mind/player)
	if(player.current)
		to_chat(player.current, "You are an antagonist! <span class='notice'><b>Within the rules</b></span>, try to act as an opposing force to the crew. Further RP and try to make sure other players have <i>fun</i>! If you are confused or at a loss, always adminhelp, and before taking extreme actions, please try to also contact the administration! Think through your actions and make the roleplay immersive! <b>Please remember all rules aside from those without explicit exceptions apply to antagonists.</b>")

/proc/show_objectives(var/datum/mind/player)

	if(!player || !player.current) return

	if(GLOB.config.objectives_disabled)
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

	if(GLOB.config.show_game_type_odd)
		to_chat(src, "<b>Secret Mode Odds:</b>")
		var/sum = 0
		for(var/config_tag in GLOB.config.probabilities_secret)
			sum += GLOB.config.probabilities_secret[config_tag]
		for(var/config_tag in GLOB.config.probabilities_secret)
			if(GLOB.config.probabilities_secret[config_tag] > 0)
				var/percentage = round(GLOB.config.probabilities_secret[config_tag] / sum * 100, 0.1)
				to_chat(src, "[config_tag] [percentage]%")

		to_chat(src, "<b>Mixed Secret Mode Odds:</b>")
		sum = 0
		for(var/config_tag in GLOB.config.probabilities_mixed_secret)
			sum += GLOB.config.probabilities_mixed_secret[config_tag]
		for(var/config_tag in GLOB.config.probabilities_mixed_secret)
			if(GLOB.config.probabilities_mixed_secret[config_tag] > 0)
				var/percentage = round(GLOB.config.probabilities_mixed_secret[config_tag] / sum * 100, 0.1)
				to_chat(src, "[config_tag] [percentage]%")
	else
		to_chat(src, "Displaying gamemode odds is disabled in the config.")
