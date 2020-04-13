#define LOBBY_TIME 180

#define SETUP_OK 0
#define SETUP_REVOTE 1
#define SETUP_REATTEMPT 2

var/datum/controller/subsystem/ticker/SSticker

/datum/controller/subsystem/ticker
	// -- Subsystem stuff --
	name = "Ticker"

	priority = SS_PRIORITY_TICKER
	flags = SS_NO_TICK_CHECK | SS_FIRE_IN_LOBBY
	init_order = SS_INIT_LOBBY

	wait = 1 SECOND

	// -- Gameticker --
	var/const/restart_timeout = 600
	var/current_state = GAME_STATE_PREGAME

	var/hide_mode = 0
	var/datum/game_mode/mode = null
	var/post_game = 0

	var/login_music			// music played in pregame lobby

	var/list/datum/mind/minds = list()//The people in the game. Used for objective tracking.

	var/Bible_icon_state	// icon_state the chaplain has chosen for his bible
	var/Bible_item_state	// item_state the chaplain has chosen for his bible
	var/Bible_name			// name of the bible
	var/Bible_deity_name

	var/random_players = 0 	// if set to nonzero, ALL players who latejoin or declare-ready join will have random appearances/genders

	var/pregame_timeleft = 0

	var/delay_end = 0	//if set to nonzero, the round will not restart on it's own

	var/triai = 0	//Global holder for Triumvirate
	var/tipped = FALSE						//Did we broadcast the tip of the day yet?
	var/selected_tip						// What will be the tip of the day?
	var/testmerges_printed = FALSE

	var/round_end_announced = 0 // Spam Prevention. Announce round end only once.

	//station_explosion used to be a variable for every mob's hud. Which was a waste!
	//Now we have a general cinematic centrally held within the gameticker....far more efficient!
	var/obj/screen/cinematic = null

	var/list/possible_lobby_tracks = list(
		'sound/music/space.ogg',
		'sound/music/traitor.ogg',
		'sound/music/title2.ogg',
		'sound/music/clouds.s3m',
		'sound/music/space_oddity.ogg'
	)

	var/lobby_ready = FALSE
	var/is_revote = FALSE

	var/list/roundstart_callbacks

/datum/controller/subsystem/ticker/New()
	NEW_SS_GLOBAL(SSticker)

/datum/controller/subsystem/ticker/Initialize(timeofday)
	pregame()

/datum/controller/subsystem/ticker/stat_entry()
	var/state = ""
	switch (current_state)
		if (GAME_STATE_PREGAME)
			state = "PRE"
		if (GAME_STATE_SETTING_UP)
			state = "SETUP"
		if (GAME_STATE_PLAYING)
			state = "PLAY"
		if (GAME_STATE_FINISHED)
			state = "FIN"
		else
			state = "UNK"
	..("State: [state]")

/datum/controller/subsystem/ticker/Recover()
	// Copy stuff over so we don't lose any state.
	current_state = SSticker.current_state

	hide_mode = SSticker.hide_mode
	mode = SSticker.mode
	post_game = SSticker.post_game

	login_music = SSticker.login_music

	minds = SSticker.minds

	Bible_icon_state = SSticker.Bible_icon_state
	Bible_item_state = SSticker.Bible_item_state
	Bible_deity_name = SSticker.Bible_deity_name

	random_players = SSticker.random_players

	pregame_timeleft = SSticker.pregame_timeleft

	delay_end = SSticker.delay_end

	triai = SSticker.triai
	tipped = SSticker.tipped
	selected_tip = SSticker.selected_tip

	round_end_announced = SSticker.round_end_announced

	cinematic = SSticker.cinematic

/datum/controller/subsystem/ticker/fire()
	if (!lobby_ready)
		lobby_ready = TRUE
		return

	switch (current_state)
		if (GAME_STATE_PREGAME, GAME_STATE_SETTING_UP)
			pregame_tick()
		if (GAME_STATE_PLAYING)
			game_tick()

/datum/controller/subsystem/ticker/proc/pregame_tick()
	if (round_progressing)
		pregame_timeleft--

	if (current_state == GAME_STATE_PREGAME && pregame_timeleft == config.vote_autogamemode_timeleft)
		if (!SSvote.time_remaining)
			SSvote.autogamemode()
			pregame_timeleft--
			return

	if (pregame_timeleft <= 20 && !testmerges_printed)
		print_testmerges()
		testmerges_printed = TRUE

	if (pregame_timeleft <= 10 && !tipped)
		send_tip_of_the_round()
		tipped = TRUE

	if (pregame_timeleft <= 0 || current_state == GAME_STATE_SETTING_UP)
		current_state = GAME_STATE_SETTING_UP
		wait = 2 SECONDS
		switch (setup())
			if (SETUP_REVOTE)
				wait = 1 SECOND
				is_revote = TRUE
				pregame()
			if (SETUP_REATTEMPT)
				pregame_timeleft = 1 SECOND
				to_world("Reattempting gamemode selection.")

/datum/controller/subsystem/ticker/proc/game_tick()
	if(current_state != GAME_STATE_PLAYING)
		return 0

	mode.process()

	var/game_finished = 0
	var/mode_finished = 0
	if (config.continous_rounds)
		game_finished = (emergency_shuttle.returned() || mode.station_was_nuked)
		mode_finished = (!post_game && mode.check_finished())
	else
		game_finished = (mode.check_finished() || (emergency_shuttle.returned() && emergency_shuttle.evac == 1)) || universe_has_ended
		mode_finished = game_finished

	if(!mode.explosion_in_progress && game_finished && (mode_finished || post_game))
		current_state = GAME_STATE_FINISHED

		declare_completion()

		spawn(50)
			callHook("roundend")

			if (universe_has_ended)
				if(mode.station_was_nuked)
					feedback_set_details("end_proper","nuke")
				else
					feedback_set_details("end_proper","universe destroyed")
				if(!delay_end)
					to_world("<span class='notice'><b>Rebooting due to destruction of station in [restart_timeout/10] seconds</b></span>")
			else
				feedback_set_details("end_proper","proper completion")
				if(!delay_end)
					to_world("<span class='notice'><b>Restarting in [restart_timeout/10] seconds</b></span>")

			var/wait_for_tickets
			var/delay_notified = 0
			do
				wait_for_tickets = 0
				for(var/datum/ticket/ticket in tickets)
					if(ticket.is_active())
						wait_for_tickets = 1
						break
				if(wait_for_tickets)
					if(!delay_notified)
						delay_notified = 1
						message_admins("<span class='warning'><b>Automatically delaying restart due to active tickets.</b></span>")
						to_world("<span class='notice'><b>An admin has delayed the round end</b></span>")
					sleep(15 SECONDS)
				else if(delay_notified)
					message_admins("<span class='warning'><b>No active tickets remaining, restarting in [restart_timeout/10] seconds if an admin has not delayed the round end.</b></span>")
			while(wait_for_tickets)

			if(!delay_end)
				sleep(restart_timeout)
				if(!delay_end)
					world.Reboot()
				else if(!delay_notified)
					to_world("<span class='notice'><b>An admin has delayed the round end</b></span>")
			else if(!delay_notified)
				to_world("<span class='notice'><b>An admin has delayed the round end</b></span>")

	else if (mode_finished)
		post_game = 1

		mode.cleanup()

		//call a transfer shuttle vote
		spawn(50)
			if(!round_end_announced && !config.continous_rounds) // Spam Prevention. Now it should announce only once.
				to_world("<span class='danger'>The round has ended!</span>")
				round_end_announced = 1
				SSvote.autotransfer()

	return 1

/datum/controller/subsystem/ticker/proc/declare_completion()
	set waitfor = FALSE

	to_world("<br><br><br><H1>A round of [mode.name] has ended!</H1>")
	for(var/mob/Player in player_list)
		if(Player.mind && !isnewplayer(Player))
			if(Player.stat != DEAD)
				var/turf/playerTurf = get_turf(Player)
				if(emergency_shuttle.departed && emergency_shuttle.evac)
					if(isNotAdminLevel(playerTurf.z))
						to_chat(Player, "<font color='blue'><b>You managed to survive, but were marooned on [station_name()] as [Player.real_name]...</b></font>")
					else
						to_chat(Player, "<font color='green'><b>You managed to survive the events on [station_name()] as [Player.real_name].</b></font>")
				else if(isAdminLevel(playerTurf.z))
					to_chat(Player, "<font color='green'><b>You successfully underwent crew transfer after events on [station_name()] as [Player.real_name].</b></font>")
				else if(issilicon(Player))
					to_chat(Player, "<font color='green'><b>You remain operational after the events on [station_name()] as [Player.real_name].</b></font>")
				else
					to_chat(Player, "<font color='blue'><b>You missed the crew transfer after the events on [station_name()] as [Player.real_name].</b></font>")
			else
				if(istype(Player,/mob/abstract/observer))
					var/mob/abstract/observer/O = Player
					if(!O.started_as_observer)
						to_chat(Player, "<font color='red'><b>You did not survive the events on [station_name()]...</b></font>")
				else
					to_chat(Player, "<font color='red'><b>You did not survive the events on [station_name()]...</b></font>")
	to_world("<br>")

	for (var/mob/living/silicon/ai/aiPlayer in mob_list)
		if (aiPlayer.stat != 2)
			to_world("<b>[aiPlayer.name]'s laws at the end of the round were:</b>")
		else
			to_world("<b>[aiPlayer.name]'s laws when it was deactivated were:</b>")
		aiPlayer.show_laws(1)

		if (aiPlayer.connected_robots.len)
			var/robolist = "<b>The AI's loyal minions were:</b> "
			for(var/mob/living/silicon/robot/robo in aiPlayer.connected_robots)
				robolist += "[robo.name][robo.stat?" (Deactivated), ":", "]"
			to_world("[robolist]")

	var/dronecount = 0

	for (var/mob/living/silicon/robot/robo in mob_list)

		if(istype(robo,/mob/living/silicon/robot/drone))
			dronecount++
			continue

		if (!robo.connected_ai)
			if (robo.stat != 2)
				to_world("<b>[robo.name] survived as an AI-less borg! Its laws were:</b>")
			else
				to_world("<b>[robo.name] was unable to survive the rigors of being a cyborg without an AI. Its laws were:</b>")

			if(robo) //How the hell do we lose robo between here and the world messages directly above this?
				robo.laws.show_laws(world)

	if(dronecount)
		to_world("<b>There [dronecount>1 ? "were" : "was"] [dronecount] industrious maintenance [dronecount>1 ? "drones" : "drone"] at the end of this round.</b>")

	mode.declare_completion()//To declare normal completion.

	//Ask the event manager to print round end information
	SSevents.RoundEnd()

	//Print a list of antagonists to the server log
	var/list/total_antagonists = list()
	//Look into all mobs in world, dead or alive
	for(var/datum/mind/Mind in minds)
		var/temprole = Mind.special_role
		if(temprole)							//if they are an antagonist of some sort.
			if(temprole in total_antagonists)	//If the role exists already, add the name to it
				total_antagonists[temprole] += ", [Mind.name]"
			else
				total_antagonists.Add(temprole) //If the role doesnt exist in the list, create it and add the mob
				total_antagonists[temprole] += ": [Mind.name]"

	//Now print them all into the log!
	log_game("Antagonists at round end were...")
	for(var/i in total_antagonists)
		log_game("[i]s[total_antagonists[i]].")

	SSfeedback.print_round_end_message()

	return 1

/datum/controller/subsystem/ticker/proc/send_tip_of_the_round()
	var/m
	if(selected_tip)
		m = selected_tip
	else
		var/list/randomtips = file2list("config/tips.txt")
		if(randomtips.len)
			m = pick(randomtips)

	if(m)
		to_world("<font color='purple'><b>Tip of the round: \
			</b>[html_encode(m)]</font>")

/datum/controller/subsystem/ticker/proc/print_testmerges()
	var/data = revdata.testmerge_overview()

	if (data)
		to_world(data)

/datum/controller/subsystem/ticker/proc/pregame()
	set waitfor = FALSE
	sleep(1)	// Sleep so the MC has a chance to update its init time.
	if (!login_music)
		login_music = pick(possible_lobby_tracks)

	if (is_revote)
		pregame_timeleft = LOBBY_TIME
		log_debug("SSticker: lobby reset due to game setup failure, using pregame time [LOBBY_TIME]s.")
	else
		var/mc_init_time = round(Master.initialization_time_taken, 1)
		var/dynamic_time = LOBBY_TIME - mc_init_time

		if (dynamic_time <= config.vote_autogamemode_timeleft)
			pregame_timeleft = config.vote_autogamemode_timeleft + 10
			log_debug("SSticker: dynamic set pregame time [dynamic_time]s was less than or equal to configured autogamemode vote time [config.vote_autogamemode_timeleft]s, clamping.")
		else
			pregame_timeleft = dynamic_time
			log_debug("SSticker: dynamic set pregame time [dynamic_time]s was greater than configured autogamemode time, not clamping.")

	to_world("<B><FONT color='blue'>Welcome to the pre-game lobby!</FONT></B>")
	to_world("Please, setup your character and select ready. Game will start in [pregame_timeleft] seconds.")

/datum/controller/subsystem/ticker/proc/setup()
	//Create and announce mode
	if(master_mode == ROUNDTYPE_STR_SECRET)
		src.hide_mode = ROUNDTYPE_SECRET
	else if (master_mode == ROUNDTYPE_STR_MIXED_SECRET)
		src.hide_mode = ROUNDTYPE_MIXED_SECRET

	var/list/runnable_modes = config.get_runnable_modes(master_mode)
	if(master_mode in list(ROUNDTYPE_STR_RANDOM, ROUNDTYPE_STR_SECRET, ROUNDTYPE_STR_MIXED_SECRET))
		if(!runnable_modes.len)
			current_state = GAME_STATE_PREGAME
			to_world("<B>Unable to choose playable game mode.</B> Reverting to pre-game lobby.")
			return SETUP_REVOTE
		if(secret_force_mode != ROUNDTYPE_STR_SECRET && secret_force_mode != ROUNDTYPE_STR_MIXED_SECRET)
			src.mode = config.pick_mode(secret_force_mode)
		if(!src.mode)
			var/list/weighted_modes = list()
			var/list/probabilities = list()

			if (master_mode == ROUNDTYPE_STR_SECRET)
				probabilities = config.probabilities_secret
			else if (master_mode == ROUNDTYPE_STR_MIXED_SECRET)
				probabilities = config.probabilities_mixed_secret
			else
				// master_mode == ROUNDTYPE_STR_RANDOM
				probabilities = config.probabilities_secret.Copy()
				probabilities |= config.probabilities_mixed_secret

			for(var/datum/game_mode/GM in runnable_modes)
				weighted_modes[GM.config_tag] = probabilities[GM.config_tag]
			src.mode = gamemode_cache[pickweight(weighted_modes)]
	else
		src.mode = config.pick_mode(master_mode)

	if(!src.mode)
		current_state = GAME_STATE_PREGAME
		to_world("<span class='danger'>Serious error in mode setup!</span> Reverting to pre-game lobby.")
		return SETUP_REVOTE

	SSjobs.ResetOccupations()
	src.mode.create_antagonists()
	src.mode.pre_setup()
	SSjobs.DivideOccupations() // Apparently important for new antagonist system to register specific job antags properly.

	var/fail_reasons = list()

	var/can_start = src.mode.can_start()

	if(can_start & GAME_FAILURE_NO_PLAYERS)
		var/list/voted_not_ready = list()
		for(var/mob/abstract/new_player/player in SSvote.round_voters)
			if((player.client)&&(!player.ready))
				voted_not_ready += player.ckey
		message_admins("The following players voted for [mode.name], but did not ready up: [jointext(voted_not_ready, ", ")]")
		log_game("Ticker: Players voted for [mode.name], but did not ready up: [jointext(voted_not_ready, ", ")]")
		fail_reasons += "Not enough players, [mode.required_players] player(s) needed"

	if(can_start & GAME_FAILURE_NO_ANTAGS)
		fail_reasons += "Not enough antagonists, [mode.required_enemies] antagonist(s) needed"

	if(can_start & GAME_FAILURE_TOO_MANY_PLAYERS)
		fail_reasons +=  "Too many players, less than [mode.max_players] antagonist(s) needed"

	if(can_start != GAME_FAILURE_NONE)
		to_world("<B>Unable to start [mode.name].</B> [english_list(fail_reasons,"No reason specified",". ",". ")]")
		current_state = GAME_STATE_PREGAME
		mode.fail_setup()
		mode = null
		SSjobs.ResetOccupations()
		if(master_mode in list(ROUNDTYPE_STR_RANDOM, ROUNDTYPE_STR_SECRET, ROUNDTYPE_STR_MIXED_SECRET))
			to_world("<B>Reselecting gamemode...</B>")
			return SETUP_REATTEMPT
		else
			to_world("<B>Reverting to pre-game lobby.</B>")
			return SETUP_REVOTE

	var/starttime = REALTIMEOFDAY

	if(hide_mode)
		to_world("<B>The current game mode is - [hide_mode == ROUNDTYPE_SECRET ? "Secret" : "Mixed Secret"]!</B>")
		if(runnable_modes.len)
			var/list/tmpmodes = new
			for (var/datum/game_mode/M in runnable_modes)
				tmpmodes+=M.name
			tmpmodes = sortList(tmpmodes)
			if(tmpmodes.len)
				to_world("<B>Possibilities:</B> [english_list(tmpmodes)]")
	else
		src.mode.announce()

	current_state = GAME_STATE_PLAYING
	create_characters() //Create player characters and transfer them
	collect_minds()
	equip_characters()
	SSrecords.build_records()

	Master.RoundStart()
	real_round_start_time = REALTIMEOFDAY
	round_start_time = world.time

	callHook("roundstart")

	spawn(0)//Forking here so we dont have to wait for this to finish
		mode.post_setup()
		//Cleanup some stuff
		for(var/obj/effect/landmark/start/S in landmarks_list)
			//Deleting Startpoints but we need the ai point to AI-ize people later
			if (S.name != "AI")
				qdel(S)
		to_world("<FONT color='blue'><B>Enjoy the game!</B></FONT>")
		to_world(sound('sound/AI/welcome.ogg'))
		//Holiday Round-start stuff	~Carn
		Holiday_Game_Start()

	log_debug("SSticker: Running [LAZYLEN(roundstart_callbacks)] round-start callbacks.")
	run_callback_list(roundstart_callbacks)
	roundstart_callbacks = null

	log_debug("SSticker: Round-start setup took [(REALTIMEOFDAY - starttime)/10] seconds.")

	return SETUP_OK

/datum/controller/subsystem/ticker/proc/run_callback_list(list/callbacklist)
	set waitfor = FALSE

	if (!callbacklist)
		return

	for (var/thing in callbacklist)
		var/datum/callback/callback = thing
		callback.Invoke()

		CHECK_TICK

/datum/controller/subsystem/ticker/proc/station_explosion_cinematic(station_missed = 0, override = null, list/affected_levels = current_map.station_levels)
	if (cinematic)
		return	//already a cinematic in progress!

	//initialise our cinematic screen object
	cinematic = new /obj/screen{
		icon = 'icons/effects/station_explosion.dmi';
		icon_state = "station_intact";
		layer = CINEMA_LAYER;
		mouse_opacity = 0;
		screen_loc = "1,0"
	}

	var/obj/structure/bed/temp_buckle = new
	//Incredibly hackish. It creates a bed within the gameticker (lol) to stop mobs running around
	if(station_missed)
		for(var/mob/living/M in living_mob_list)
			M.buckled = temp_buckle				//buckles the mob so it can't do anything
			if(M.client)
				M.client.screen += cinematic	//show every client the cinematic
	else	//nuke kills everyone on z-level 1 to prevent "hurr-durr I survived"
		for(var/mob/living/M in living_mob_list)
			M.buckled = temp_buckle
			if(M.client)
				M.client.screen += cinematic

			var/turf/Mloc = M.loc
			if (!Mloc)
				continue

			if (!istype(Mloc))
				Mloc = get_turf(M)

			if (Mloc.z in affected_levels)
				M.dust()

			CHECK_TICK

	//Now animate the cinematic
	switch(station_missed)
		if(1)	//nuke was nearby but (mostly) missed
			if( mode && !override )
				override = mode.name
			switch( override )
				if("mercenary") //Nuke wasn't on station when it blew up
					flick("intro_nuke",cinematic)
					sleep(35)
					to_world(sound('sound/effects/explosionfar.ogg'))
					flick("station_intact_fade_red",cinematic)
					cinematic.icon_state = "summary_nukefail"
				else
					flick("intro_nuke",cinematic)
					sleep(35)
					to_world(sound('sound/effects/explosionfar.ogg'))
					//flick("end",cinematic)

		if(2)	//nuke was nowhere nearby	//TODO: a really distant explosion animation
			sleep(50)
			to_world(sound('sound/effects/explosionfar.ogg'))

		else	//station was destroyed
			if( mode && !override )
				override = mode.name
			switch( override )
				if("mercenary") //Nuke Ops successfully bombed the station
					flick("intro_nuke",cinematic)
					sleep(35)
					flick("station_explode_fade_red",cinematic)
					to_world(sound('sound/effects/explosionfar.ogg'))
					cinematic.icon_state = "summary_nukewin"
				if("AI malfunction") //Malf (screen,explosion,summary)
					flick("intro_malf",cinematic)
					sleep(76)
					flick("station_explode_fade_red",cinematic)
					to_world(sound('sound/effects/explosionfar.ogg'))
					cinematic.icon_state = "summary_malf"
				if("blob") //Station nuked (nuke,explosion,summary)
					flick("intro_nuke",cinematic)
					sleep(35)
					flick("station_explode_fade_red",cinematic)
					to_world(sound('sound/effects/explosionfar.ogg'))
					cinematic.icon_state = "summary_selfdes"
				else //Station nuked (nuke,explosion,summary)
					flick("intro_nuke",cinematic)
					sleep(35)
					flick("station_explode_fade_red", cinematic)
					to_world(sound('sound/effects/explosionfar.ogg'))
					cinematic.icon_state = "summary_selfdes"

	//If its actually the end of the round, wait for it to end.
	//Otherwise if its a verb it will continue on afterwards.
	sleep(300)

	if(cinematic)
		QDEL_NULL(cinematic)		//end the cinematic
	if(temp_buckle)
		QDEL_NULL(temp_buckle)	//release everybody

// Round setup stuff.

/datum/controller/subsystem/ticker/proc/create_characters()
	for(var/mob/abstract/new_player/player in player_list)
		if(player && player.ready && player.mind)
			if(player.mind.assigned_role=="AI")
				player.close_spawn_windows()
				player.AIize()
			else if(!player.mind.assigned_role)
				continue
			else
				player.create_character()
				qdel(player)
		CHECK_TICK

/datum/controller/subsystem/ticker/proc/collect_minds()
	for(var/mob/living/player in player_list)
		if(player.mind)
			minds += player.mind

/datum/controller/subsystem/ticker/proc/equip_characters()
	var/captainless = TRUE
	for(var/mob/living/carbon/human/player in player_list)
		if(player && player.mind && player.mind.assigned_role)
			if(player.mind.assigned_role == "Captain")
				captainless = FALSE
			if(!player_is_antag(player.mind, only_offstation_roles = 1))
				SSjobs.EquipAugments(player, player.client.prefs)
				SSjobs.EquipRank(player, player.mind.assigned_role, 0)
				equip_custom_items(player)

		CHECK_TICK
	if(captainless)
		for(var/mob/M in player_list)
			if(!istype(M,/mob/abstract/new_player))
				to_chat(M, "Captainship not forced on anyone.")

// Registers a callback to run on round-start.
/datum/controller/subsystem/ticker/proc/OnRoundstart(datum/callback/callback)
	if (!istype(callback))
		return

	LAZYADD(roundstart_callbacks, callback)


#undef SETUP_OK
#undef SETUP_REVOTE
#undef SETUP_REATTEMPT
#undef LOBBY_TIME
