//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/mob/abstract/new_player
	var/ready = 0
	var/spawning = 0 //Referenced when you want to delete the new_player later on in the code
	var/datum/late_choices/late_choices_ui = null
	universal_speak = 1

	invisibility = 101

	density = 0
	stat = DEAD
	canmove = 0

	anchored = 1	//  don't get pushed around
	simulated = FALSE

	var/last_ready_name // This has to be saved because the client is nulled prior to Logout()

INITIALIZE_IMMEDIATE(/mob/abstract/new_player)

/mob/abstract/new_player/Initialize(mapload)
	. = ..()
	GLOB.dead_mob_list -= src
	attempt_moving_new_player_on_marker_turf()

/mob/abstract/new_player/proc/attempt_moving_new_player_on_marker_turf()
	//If it's set, move the new_player mob to it, otherwise reschedule to check in a bit
	if(istype(GLOB.lobby_mobs_location))
		src.forceMove(GLOB.lobby_mobs_location)

	else
		//Atoms loading have finished supposedly, there should be a marker down for this, if not found throw a stack trace
		if(SSATOMS_IS_PROBABLY_DONE)
			stack_trace("The map is supposedly loaded, but GLOB.lobby_mobs_location is not set, unable to move the lobby mob!")
			return

		addtimer(CALLBACK(src, PROC_REF(attempt_moving_new_player_on_marker_turf)), 5 SECONDS)

/mob/abstract/new_player/Destroy()
	QDEL_NULL(late_choices_ui)
	return ..()

/mob/abstract/new_player/get_status_tab_items()
	. = ..()

	if(!istype(SSticker))
		return

	if(SSticker.hide_mode == ROUNDTYPE_SECRET)
		. += "Game Mode: Secret"
	else if (SSticker.hide_mode == ROUNDTYPE_MIXED_SECRET)
		. += "Game Mode: Mixed Secret"
	else
		. += "Game Mode: [GLOB.master_mode]" // Old setting for showing the game mode

	if(SSticker.current_state == GAME_STATE_PREGAME)
		. += "Time To Start: [SSticker.pregame_timeleft][GLOB.round_progressing ? "" : " (DELAYED)"]"
		. += "Players: [length(GLOB.player_list)] Players Ready: [SSticker.total_players_ready]"
		if(LAZYLEN(SSticker.ready_player_jobs))
			. += ""
			. += ""
			. += "Group antagonists ready:"

			var/list/ready_special_roles = list()

			//Get the list of all the players, if they are ready, get their special roles (aka antagonists) preferences and count them up in a list
			for(var/mob/abstract/new_player/player in GLOB.player_list)
				if(!player.ready)
					continue
				for(var/special_role in player?.client?.prefs?.be_special_role)
					ready_special_roles[special_role] += 1

			//Get the list of all antagonist types, if they require more than one person to spawn, check that there's at least one candidate and if so list the number of candidates for it
			for(var/antag_type in GLOB.all_antag_types)
				var/datum/antagonist/possible_antag_type = GLOB.all_antag_types[antag_type]

				if(possible_antag_type.initial_spawn_req > 1)
					if(ready_special_roles[possible_antag_type.role_type])
						. += "[possible_antag_type.role_text_plural]: [ready_special_roles[possible_antag_type.role_type]]"


			. += ""
			. += ""
			. += "Characters ready:"
			for(var/dept in SSticker.ready_player_jobs)
				if(LAZYLEN(SSticker.ready_player_jobs[dept]))
					. += "[uppertext(dept)]"
				for(var/char in SSticker.ready_player_jobs[dept])
					. += "[copytext_char(char, 1, 18)]: [SSticker.ready_player_jobs[dept][char]]"


/mob/abstract/new_player/Topic(href, href_list[])
	if(!client)	return 0

	if(href_list["show_preferences"])
		client.prefs.ShowChoices(src)
		return 1

	if(href_list["ready"])
		if(SSticker.current_state <= GAME_STATE_PREGAME) // Make sure we don't ready up after the round has started
			// Cannot join without a saved character, if we're on SQL saves.
			if (GLOB.config.sql_saves && !client.prefs.current_character)
				alert(src, "You have not saved your character yet. Please do so before readying up.")
				return
			if(client.unacked_warning_count > 0)
				alert(src, "You can not ready up, because you have unacknowledged warnings or notifications. Acknowledge them in OOC->Warnings and Notifications.")
				return

			ready = text2num(href_list["ready"])
		else
			ready = 0

	if(href_list["observe"])
		new_player_observe()
		return TRUE

	if(href_list["late_join"])

		if(SSticker.current_state != GAME_STATE_PLAYING)
			to_chat(usr, "<span class='warning'>The round is either not ready, or has already finished...</span>")
			return

		// Cannot join without a saved character, if we're on SQL saves.
		if (GLOB.config.sql_saves && !client.prefs.current_character)
			alert(src, "You have not saved your character yet. Please do so before attempting to join.")
			return

		if(!check_rights(R_ADMIN, 0))
			var/datum/species/S = GLOB.all_species[client.prefs.species]
			if((S.spawn_flags & IS_WHITELISTED) && !is_alien_whitelisted(src, client.prefs.species) && GLOB.config.usealienwhitelist)
				to_chat(usr, "<span class='danger'>You are currently not whitelisted to play [client.prefs.species].</span>")
				return 0

			if(!(S.spawn_flags & CAN_JOIN))
				to_chat(usr, "<span class='danger'>Your current species, [client.prefs.species], is not available for play on the station.</span>")
				return 0

		LateChoices()

	if(href_list["manifest"])
		ViewManifest()

	if(href_list["ghostspawner"])
		if(!ROUND_IS_STARTED)
			to_chat(usr, SPAN_WARNING("The round hasn't started yet!"))
			return
		SSghostroles.ui_interact(usr)

	if(href_list["SelectedJob"])

		if(!GLOB.config.enter_allowed)
			to_chat(usr, "<span class='notice'>There is an administrative lock on entering the game!</span>")
			return
		else if(SSticker.mode && SSticker.mode.explosion_in_progress)
			to_chat(usr, "<span class='danger'>The station is currently exploding. Joining would go poorly.</span>")
			return

		if(client.unacked_warning_count > 0)
			alert(usr, "You can not join the game, because you have unacknowledged warnings or notifications. Acknowledge them in OOC->Warnings and Notifications.")
			return

		var/datum/species/S = GLOB.all_species[client.prefs.species]
		if((S.spawn_flags & IS_WHITELISTED) && !is_alien_whitelisted(src, client.prefs.species) && GLOB.config.usealienwhitelist)
			to_chat(usr, "<span class='danger'>You are currently not whitelisted to play [client.prefs.species].</span>")
			return 0

		if(!(S.spawn_flags & CAN_JOIN))
			to_chat(usr, "<span class='danger'>Your current species, [client.prefs.species], is not available for play on the station.</span>")
			return 0

		AttemptLateSpawn(href_list["SelectedJob"],client.prefs.spawnpoint)
		return

	if(!ready && href_list["preference"])
		if(client)
			client.prefs.process_link(src, href_list)

	if(href_list["showpoll"])
		handle_player_polling()
		return

	if(href_list["showpolllink"])
		show_poll_link(href_list["showpolllink"])
		return

	if(href_list["pollid"])

		var/pollid = href_list["pollid"]
		if(istext(pollid))
			pollid = text2num(pollid)
		if(isnum(pollid))
			src.poll_player(pollid)
		return

	if(href_list["votepollid"] && href_list["votetype"])
		var/pollid = text2num(href_list["votepollid"])
		var/votetype = href_list["votetype"]
		switch(votetype)
			if("OPTION")
				var/optionid = text2num(href_list["voteoptionid"])
				vote_on_poll(pollid, optionid)
			if("TEXT")
				var/replytext = href_list["replytext"]
				log_text_poll_reply(pollid, replytext)
			if("NUMVAL")
				var/id_min = text2num(href_list["minid"])
				var/id_max = text2num(href_list["maxid"])

				if( (id_max - id_min) > 100 )	//Basic exploit prevention
					to_chat(usr, "The option ID difference is too big. Please contact administration or the database admin.")
					return

				for(var/optionid = id_min; optionid <= id_max; optionid++)
					if(!isnull(href_list["o[optionid]"]))	//Test if this optionid was replied to
						var/rating
						if(href_list["o[optionid]"] == "abstain")
							rating = null
						else
							rating = text2num(href_list["o[optionid]"])
							if(!isnum(rating))
								return

						vote_on_numval_poll(pollid, optionid, rating)
			if("MULTICHOICE")
				var/id_min = text2num(href_list["minoptionid"])
				var/id_max = text2num(href_list["maxoptionid"])

				if( (id_max - id_min) > 100 )	//Basic exploit prevention
					to_chat(usr, "The option ID difference is too big. Please contact administration or the database admin.")
					return

				for(var/optionid = id_min; optionid <= id_max; optionid++)
					if(!isnull(href_list["option_[optionid]"]))	//Test if this optionid was selected
						vote_on_poll(pollid, optionid, 1)

/mob/abstract/new_player/proc/IsJobAvailable(rank)
	var/datum/job/job = SSjobs.GetJob(rank)
	if (!job)
		return FALSE
	if (!job.is_position_available())
		return FALSE
	if (jobban_isbanned(src,rank))
		return FALSE

	if(job.blacklisted_species) // check for restricted species
		var/datum/species/S = GLOB.all_species[client.prefs.species]
		if(S.name in job.blacklisted_species)
			return FALSE

	if(job.blacklisted_citizenship)
		var/datum/citizenship/C = SSrecords.citizenships[client.prefs.citizenship]
		if(C.name in job.blacklisted_citizenship)
			return FALSE

	var/datum/faction/faction = SSjobs.name_factions[client.prefs.faction] || SSjobs.default_faction
	var/list/faction_allowed_roles = unpacklist(faction.allowed_role_types)
	if (!(job.type in faction_allowed_roles))
		return FALSE

	if(!faction.can_select(client.prefs,src))
		return FALSE

	if(!(client.prefs.GetPlayerAltTitle(job) in client.prefs.GetValidTitles(job))) // does age/species check for us!
		return FALSE

	return TRUE


/mob/abstract/new_player/proc/AttemptLateSpawn(rank,var/spawning_at)
	if(src != usr)
		return 0
	if(SSticker.current_state != GAME_STATE_PLAYING)
		to_chat(usr, "<span class='warning'>The round is either not ready, or has already finished...</span>")
		return 0
	if(!GLOB.config.enter_allowed)
		to_chat(usr, "<span class='notice'>There is an administrative lock on entering the game!</span>")
		return 0
	if(GLOB.config.sql_saves && !client.prefs.current_character)
		alert(usr, "You have not saved your character yet. Please do so before attempting to join.")
		return 0
	if(!IsJobAvailable(rank))
		to_chat(usr, "<span class='notice'>[rank] is not available. Please try another.</span>")
		return 0
	if(!(spawning_at in SSatlas.current_map.allowed_spawns))
		to_chat(usr, SPAN_NOTICE("Spawn location [spawning_at] invalid for [SSatlas.current_map]. Defaulting to [SSatlas.current_map.default_spawn]."))
		spawning_at = SSatlas.current_map.default_spawn

	spawning = 1
	close_spawn_windows()

	SSjobs.AssignRole(src, rank, 1)

	var/mob/living/character = create_character()	//creates the human and transfers vars and mind

	SSjobs.EquipAugments(character, character.client.prefs)
	character = SSjobs.EquipRank(character, rank, TRUE, spawning_at)					//equips the human

	// AIs don't need a spawnpoint, they must spawn at an empty core
	if(character.mind.assigned_role == "AI")

		character = character.AIize(move=0) // AIize the character, but don't move them yet

		// IsJobAvailable for AI checks that there is an empty core available in this list
		var/obj/structure/AIcore/deactivated/C = GLOB.empty_playable_ai_cores[1]
		GLOB.empty_playable_ai_cores -= C

		character.forceMove(C.loc)
		character.eyeobj.forceMove(C.loc)

		AnnounceCyborg(character, rank, "has been downloaded to the empty core in \the [character.loc.loc]")
		SSticker.mode.handle_latejoin(character)

		qdel(C)
		qdel(src)
		return

	//Find our spawning point.
	var/join_message = SSjobs.LateSpawn(character, rank)

	equip_custom_items(character)

	character.lastarea = get_area(loc)
	// Moving wheelchair if they have one
	if(character.buckled_to && istype(character.buckled_to, /obj/structure/bed/stool/chair/office/wheelchair))
		character.buckled_to.forceMove(character.loc)
		character.buckled_to.set_dir(character.dir)

	SSticker.mode.handle_latejoin(character)
	GLOB.universe.OnPlayerLatejoin(character)
	if(SSjobs.ShouldCreateRecords(character.mind))
		if(character.mind.assigned_role != "Cyborg")
			SSrecords.generate_record(character)
			SSticker.minds += character.mind//Cyborgs and AIs handle this in the transform proc.	//TODO!!!!! ~Carn

		//Grab some data from the character prefs for use in random news procs.

			AnnounceArrival(character, rank, join_message)
		else
			AnnounceCyborg(character, rank, join_message)

	qdel(src)

/mob/abstract/new_player/proc/AnnounceCyborg(var/mob/living/character, var/rank, var/join_message)
	if (SSticker.current_state == GAME_STATE_PLAYING)
		if(character.mind.role_alt_title)
			rank = character.mind.role_alt_title
		// can't use their name here, since cyborg namepicking is done post-spawn, so we'll just say "A new Cyborg has arrived"/"A new Android has arrived"/etc.
		GLOB.global_announcer.autosay("A new[rank ? " [rank]" : " visitor" ] [join_message ? join_message : "has arrived on the [SSatlas.current_map.station_type]"].", "Arrivals Announcer")

/mob/abstract/new_player/proc/LateChoices()
	if(!istype(late_choices_ui))
		late_choices_ui = new(src)
	else // if the UI exists force refresh it
		SStgui.update_uis(late_choices_ui)
	late_choices_ui.ui_interact(src)

/mob/abstract/new_player/proc/create_character()
	spawning = 1
	close_spawn_windows()

	var/mob/living/carbon/human/new_character

	var/use_species_name
	var/datum/species/chosen_species
	if(client.prefs.species)
		chosen_species = GLOB.all_species[client.prefs.species]
		use_species_name = chosen_species.get_station_variant() //Only used by pariahs atm.

	if(chosen_species && use_species_name)
		// Have to recheck admin due to no usr at roundstart. Latejoins are fine though.
		if(is_species_whitelisted(chosen_species) || has_admin_rights())
			new_character = new(GLOB.newplayer_start, use_species_name)

	if(!new_character)
		new_character = new(GLOB.newplayer_start)

	new_character.lastarea = get_area(loc)

	for(var/lang in client.prefs.alternate_languages)
		var/datum/language/chosen_language = GLOB.all_languages[lang]
		if(chosen_language)
			if(!GLOB.config.usealienwhitelist || !(chosen_language.flags & WHITELISTED) || is_alien_whitelisted(src, lang) || has_admin_rights() \
				|| (new_character.species && (chosen_language.name in new_character.species.secondary_langs)))
				new_character.add_language(lang)

	if(SSticker.random_players)
		new_character.gender = pick(MALE, FEMALE)
		client.prefs.real_name = random_name(new_character.gender)
		client.prefs.randomize_appearance_for(new_character)
	else
		client.prefs.copy_to(new_character)

	client.autohiss_mode = client.prefs.autohiss_setting

	src.stop_sound_channel(CHANNEL_LOBBYMUSIC) // MAD JAMS cant last forever yo)

	if(mind)
		mind.active = 0					//we wish to transfer the key manually
		mind.original = new_character
		mind.transfer_to(new_character)					//won't transfer key since the mind is not active

	new_character.name = real_name
	new_character.dna.ready_dna(new_character)
	new_character.dna.b_type = client.prefs.b_type
	new_character.sync_organ_dna()
	new_character.fixblood() // now that dna is set
	if(client.prefs.disabilities & NEARSIGHTED)
		// Set defer to 1 if you add more crap here so it only recalculates struc_enzymes once. - N3X
		new_character.dna.SetSEState(GLASSESBLOCK,1,0)

	// And uncomment this, too.
	//new_character.dna.UpdateSE()

	// Do the initial caching of the player's body icons.
	new_character.force_update_limbs()
	new_character.update_eyes()
	new_character.regenerate_icons()

	client.prefs.log_character(new_character)

	new_character.key = key		//Manually transfer the key to log them in

	new_character.client.init_verbs()

	return new_character

/mob/abstract/new_player/proc/ViewManifest()
	SSrecords.open_manifest_tgui(src)

/mob/abstract/new_player/Move()
	return TRUE

/mob/abstract/new_player/proc/close_spawn_windows()
	src << browse(null, "window=playersetup") //closes the player setup window

/mob/abstract/new_player/proc/has_admin_rights()
	return check_rights(R_ADMIN, 0, src)

/mob/abstract/new_player/proc/is_species_whitelisted(datum/species/S)
	if(!S) return 1
	return is_alien_whitelisted(src, S.name) || !GLOB.config.usealienwhitelist || !(S.spawn_flags & IS_WHITELISTED)

/mob/abstract/new_player/get_species(var/reference = 0)
	var/datum/species/chosen_species
	if(client.prefs.species)
		chosen_species = GLOB.all_species[client.prefs.species]

	if(!chosen_species)
		return SPECIES_HUMAN

	if(is_species_whitelisted(chosen_species) || has_admin_rights())
		if (reference)
			return chosen_species
		else
			return chosen_species.name

	return SPECIES_HUMAN

/mob/abstract/new_player/get_gender()
	if(!client || !client.prefs)
		..()
	return client.prefs.gender

/mob/abstract/new_player/is_ready()
	return ready && ..()

/mob/abstract/new_player/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "",var/italics = 0, var/mob/speaker = null)
	return

/mob/abstract/new_player/hear_radio(var/message, var/verb="says", var/datum/language/language=null, var/part_a, var/part_b, var/part_c, var/mob/speaker = null, var/hard_to_hear = 0)
	return

/mob/abstract/new_player/MayRespawn()
	return 1

/mob/abstract/new_player/show_message(msg, type, alt, alt_type)
	return
