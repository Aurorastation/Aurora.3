#define LOBBY_TIME 180

#define SETUP_OK 0
#define SETUP_REVOTE 1
#define SETUP_REATTEMPT 2

var/datum/controller/subsystem/ticker/SSticker

/datum/controller/subsystem/ticker
	// -- Subsystem stuff --
	name = "Ticker"

	priority = SS_PRIORITY_TICKER
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY
	init_order = SS_INIT_LOBBY

	wait = 1 SECOND

	// -- Gameticker --
	var/restart_timeout = 1200
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
	var/tipped = FALSE	//Did we broadcast the tip of the day yet?
	var/testmerges_printed = FALSE

	var/round_end_announced = 0 // Spam Prevention. Announce round end only once.

	//station_explosion used to be a variable for every mob's hud. Which was a waste!
	//Now we have a general cinematic centrally held within the gameticker....far more efficient!
	var/obj/screen/cinematic = null

	var/list/possible_lobby_tracks = list(
		'sound/music/space.ogg',
		'sound/music/traitor.ogg',
		'sound/music/title2.ogg',
		'sound/music/clouds.s3m'
	)

	var/lobby_ready = FALSE
	var/is_revote = FALSE

	var/list/roundstart_callbacks

	// Pre-game ready menu handling
	var/total_players = 0
	var/total_players_ready = 0
	var/list/ready_player_jobs

/datum/controller/subsystem/ticker/New()
	NEW_SS_GLOBAL(SSticker)

/datum/controller/subsystem/ticker/Initialize(timeofday)
	pregame()
	restart_timeout = GLOB.config.restart_timeout

	return SS_INIT_SUCCESS

/datum/controller/subsystem/ticker/stat_entry(msg)
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
	msg = "State: [state]"
	return ..()

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
	if (GLOB.round_progressing)
		pregame_timeleft--

	total_players = length(GLOB.player_list)

	if (current_state == GAME_STATE_PREGAME && pregame_timeleft == GLOB.config.vote_autogamemode_timeleft)
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
		Master.SetRunLevel(RUNLEVEL_SETUP)
		wait = 2 SECONDS
		switch (setup())
			if (SETUP_REVOTE)
				wait = 1 SECOND
				is_revote = TRUE
				Master.SetRunLevel(RUNLEVEL_LOBBY)
				pregame()
			if (SETUP_REATTEMPT)
				pregame_timeleft = 1 SECOND
				to_world("Reattempting gamemode selection.")

/datum/controller/subsystem/ticker/proc/game_tick(var/force_end = FALSE)
	if(current_state != GAME_STATE_PLAYING)
		return 0

	mode.process()

	var/game_finished = 0
	var/mode_finished = 0
	if(force_end)
		game_finished = TRUE
		mode_finished = TRUE
	else
		game_finished = (evacuation_controller.round_over() || mode.station_was_nuked)
		mode_finished = (!post_game && mode.check_finished())

	if(!mode.explosion_in_progress && game_finished && (mode_finished || post_game))
		current_state = GAME_STATE_FINISHED
		Master.SetRunLevel(RUNLEVEL_POSTGAME)

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
				for(var/datum/ticket/ticket in GLOB.tickets)
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
	return 1

/datum/controller/subsystem/ticker/proc/declare_completion()
	set waitfor = FALSE

	to_world("<br><br><br><H1>A round of [mode.name] has ended!</H1>")
	for(var/mob/Player in GLOB.player_list)
		if(Player.mind && !isnewplayer(Player))
			if(Player.stat != DEAD)
				var/turf/playerTurf = get_turf(Player)
				var/area/playerArea = get_area(playerTurf)
				if(evacuation_controller.round_over() && evacuation_controller.evacuation_type == TRANSFER_EMERGENCY)
					if(isStationLevel(playerTurf.z) && is_station_area(playerArea))
						to_chat(Player, SPAN_GOOD(SPAN_BOLD("You managed to survive the events on [station_name()] as [Player.real_name].")))
					else
						to_chat(Player, SPAN_NOTICE(SPAN_BOLD("You managed to survive, but were marooned as [Player.real_name]...")))
				else if(isStationLevel(playerTurf.z) && is_station_area(playerArea))
					to_chat(Player, SPAN_GOOD(SPAN_BOLD("You successfully underwent the crew transfer after the events on [station_name()] as [Player.real_name].")))
				else if(issilicon(Player))
					to_chat(Player, SPAN_GOOD(SPAN_BOLD("You remain operational after the events on [station_name()] as [Player.real_name].")))
				else
					to_chat(Player, SPAN_NOTICE(SPAN_BOLD("You missed the crew transfer after the events on [station_name()] as [Player.real_name].")))
			else
				if(istype(Player,/mob/abstract/observer))
					var/mob/abstract/observer/O = Player
					if(!O.started_as_observer)
						to_chat(Player, SPAN_WARNING(SPAN_BOLD("You did not survive the events on [station_name()]...")))
				else
					to_chat(Player, SPAN_WARNING(SPAN_BOLD("You did not survive the events on [station_name()]...")))
	to_world("<br>")

	for (var/mob/living/silicon/ai/aiPlayer in GLOB.mob_list)
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

	for (var/mob/living/silicon/robot/robo in GLOB.mob_list)

		if(istype(robo,/mob/living/silicon/robot/drone))
			dronecount++
			continue

		if (!robo.connected_ai && !istype(robo,/mob/living/silicon/robot/shell))
			if (robo.stat != 2)
				to_world("<b>[robo.name] survived as an AI-less borg! Its laws were:</b>")
			else
				to_world("<b>[robo.name] was unable to survive the rigors of being a cyborg without an AI. Its laws were:</b>")

			if(robo) //How the hell do we lose robo between here and the world messages directly above this?
				robo.laws.show_laws(world)

	if(dronecount)
		to_world("<b>There [dronecount>1 ? "were" : "was"] [dronecount] industrious maintenance drone\s at the end of this round.</b>")

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

	SSstatistics.print_round_end_message()

	return 1

/datum/controller/subsystem/ticker/proc/update_ready_list(var/mob/abstract/new_player/NP, force_rdy = FALSE, force_urdy = FALSE)
	if(current_state >= GAME_STATE_PLAYING || !SSjobs.bitflag_to_job.len)
		return FALSE // don't bother once the game has started or before SSjobs is available

	if(!LAZYLEN(ready_player_jobs))
		ready_player_jobs = DEPARTMENTS_LIST_INIT

	if(!isclient(NP.client) || force_urdy)
		// Logged out, so force unready
		return unready_player(NP.last_ready_name)
	else if(NP.ready || force_rdy)
		if(NP.last_ready_name != NP.client.prefs.real_name)
			NP.last_ready_name = NP.client.prefs.real_name
		return ready_player(NP.client.prefs)
	else
		return unready_player(NP.client.prefs)

/datum/controller/subsystem/ticker/proc/ready_player(var/datum/preferences/prefs)
	var/datum/job/ready_job = prefs.return_chosen_high_job()
	if(!istype(ready_job))
		return FALSE

	for(var/dept in ready_job.departments)
		LAZYDISTINCTADD(ready_player_jobs[dept], prefs.real_name)
		LAZYSET(ready_player_jobs[dept], prefs.real_name, ready_job.title)
		sortTim(ready_player_jobs[dept], GLOBAL_PROC_REF(cmp_text_asc))
		. = TRUE

	if(.)
		update_ready_count()

/datum/controller/subsystem/ticker/proc/unready_player(var/ident, var/force_name = FALSE)
	if(isnull(ident))
		return FALSE

	var/datum/preferences/prefs = ident
	if(!istype(prefs) || force_name)
		// trawl the whole list - we only do this on logout or job swap, aka when we can't guarantee the job datum being accurate
		for(var/dept in ready_player_jobs)
			if(!. && LAZYISIN(ready_player_jobs[dept], ident))
				. = TRUE
			ready_player_jobs[dept] -= ident
		if(.)
			update_ready_count()
		return

	var/datum/job/ready_job = prefs.return_chosen_high_job()

	if(!istype(ready_job))
		// literally how
		return FALSE

	for(var/dept in ready_job.departments)
		if(!. && ready_player_jobs[dept][prefs.real_name])
			. = TRUE
		ready_player_jobs[dept] -= prefs.real_name

	if(.)
		update_ready_count()

/datum/controller/subsystem/ticker/proc/update_ready_count()
	total_players_ready = 0
	for(var/mob/abstract/new_player/NP in GLOB.player_list)
		if(NP.ready)
			total_players_ready++

/datum/controller/subsystem/ticker/proc/cycle_player(var/mob/abstract/new_player/NP, var/datum/job/job)
	// exclusively used for occupation.dm, when players swap job priority while readied
	if(current_state >= GAME_STATE_PLAYING || !SSjobs.bitflag_to_job.len || !NP.ready)
		return FALSE

	update_ready_list(NP, force_urdy = TRUE)
	update_ready_list(NP)

/datum/controller/subsystem/ticker/proc/setup_player_ready_list()
	for(var/mob/abstract/new_player/NP in GLOB.player_list)
		// initial setup to catch people who readied 0.1 seconds into init
		if(NP.ready)
			update_ready_list(NP)

/datum/controller/subsystem/ticker/proc/send_tip_of_the_round(var/tip_override)
	var/message
	if(tip_override)
		message = tip_override
	else
		var/chosen_tip_category = pick(GLOB.tips_by_category)
		var/datum/tip/tip_datum = GLOB.tips_by_category[chosen_tip_category]
		message = pick(tip_datum.messages)

	if(message)
		to_world(SPAN_VOTE(SPAN_BOLD("Tip of the round:") + " [html_encode(message)]"))

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
		LOG_DEBUG("SSticker: lobby reset due to game setup failure, using pregame time [LOBBY_TIME]s.")
	else
		var/mc_init_time = round(Master.init_timeofday, 1)
		var/dynamic_time = LOBBY_TIME - mc_init_time
		total_players = length(GLOB.player_list)
		LAZYINITLIST(ready_player_jobs)

		if (dynamic_time <= GLOB.config.vote_autogamemode_timeleft)
			pregame_timeleft = GLOB.config.vote_autogamemode_timeleft + 10
			LOG_DEBUG("SSticker: dynamic set pregame time [dynamic_time]s was less than or equal to configured autogamemode vote time [GLOB.config.vote_autogamemode_timeleft]s, clamping.")
		else
			pregame_timeleft = dynamic_time
			LOG_DEBUG("SSticker: dynamic set pregame time [dynamic_time]s was greater than configured autogamemode time, not clamping.")

		setup_player_ready_list()

	to_world("<B><span class='notice'>Welcome to the pre-game lobby!</span></B>")
	to_world("Please, setup your character and select ready. Game will start in [pregame_timeleft] seconds.")

	// Compute and, if available, print the ghost roles in the pre-round lobby. Begone, people who do not ready up to see what ghost roles will be available!
	var/list/available_ghostroles = list()

	for(var/s in SSghostroles.spawners)
		var/datum/ghostspawner/G = SSghostroles.spawners[s]
		if(G.enabled \
			&& !("Antagonist" in G.tags) \
			&& !(G.loc_type == GS_LOC_ATOM && !length(G.spawn_atoms)) \
			&& (G.req_perms == null) \
		)
			available_ghostroles |= G.name

	// Special case, to list the Merchant in case it is available at roundstart
	if(SSjobs.type_occupations[/datum/job/merchant]?.total_positions)
		available_ghostroles |= SSjobs.type_occupations[/datum/job/merchant].title

	if(length(available_ghostroles))
		to_world("<br>" \
			+ SPAN_BOLD(SPAN_NOTICE("Ghost roles available for this round: ")) \
			+ "[english_list(available_ghostroles)]. " \
			+ SPAN_INFO("Actual availability may vary.") \
			+ "<br>" \
		)

	var/datum/space_sector/current_sector = SSatlas.current_sector
	var/html = SPAN_NOTICE("Current sector: [current_sector].") + {"\
		<span> \
			<a href='?src=\ref[src];current_sector_show_sites_id=1'>Click here</a> \
			to see every possible site/ship that can potentially spawn here.\
		</span>\
	"}
	to_world(html)

	callHook("pregame_start")

/datum/controller/subsystem/ticker/proc/setup()
	//Create and announce mode
	if(GLOB.master_mode == ROUNDTYPE_STR_SECRET)
		src.hide_mode = ROUNDTYPE_SECRET
	else if (GLOB.master_mode == ROUNDTYPE_STR_MIXED_SECRET)
		src.hide_mode = ROUNDTYPE_MIXED_SECRET

	var/list/runnable_modes = GLOB.config.get_runnable_modes(GLOB.master_mode)
	if(GLOB.master_mode in list(ROUNDTYPE_STR_RANDOM, ROUNDTYPE_STR_SECRET, ROUNDTYPE_STR_MIXED_SECRET))
		if(!runnable_modes.len)
			current_state = GAME_STATE_PREGAME
			to_world("<B>Unable to choose playable game mode.</B> Reverting to pre-game lobby.")
			return SETUP_REVOTE
		if(GLOB.secret_force_mode != ROUNDTYPE_STR_SECRET && GLOB.secret_force_mode != ROUNDTYPE_STR_MIXED_SECRET)
			src.mode = GLOB.config.pick_mode(GLOB.secret_force_mode)
		if(!src.mode)
			var/list/weighted_modes = list()
			var/list/probabilities = list()

			if (GLOB.master_mode == ROUNDTYPE_STR_SECRET)
				probabilities = GLOB.config.probabilities_secret
			else if (GLOB.master_mode == ROUNDTYPE_STR_MIXED_SECRET)
				probabilities = GLOB.config.probabilities_mixed_secret
			else
				// GLOB.master_mode == ROUNDTYPE_STR_RANDOM
				probabilities = GLOB.config.probabilities_secret.Copy()
				probabilities |= GLOB.config.probabilities_mixed_secret

			for(var/datum/game_mode/GM in runnable_modes)
				weighted_modes[GM.config_tag] = probabilities[GM.config_tag]
			src.mode = GLOB.gamemode_cache[pickweight(weighted_modes)]
	else
		src.mode = GLOB.config.pick_mode(GLOB.master_mode)

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
		to_world("<B>Unable to start the game mode, due to lack of available antagonists.</B> [english_list(fail_reasons,"No reason specified",". ",". ")]")
		current_state = GAME_STATE_PREGAME
		mode.fail_setup()
		mode = null
		SSjobs.ResetOccupations()
		if(GLOB.master_mode in list(ROUNDTYPE_STR_RANDOM, ROUNDTYPE_STR_SECRET, ROUNDTYPE_STR_MIXED_SECRET))
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

	Master.SetRunLevel(RUNLEVEL_GAME)
	real_round_start_time = REALTIMEOFDAY
	round_start_time = world.time

	callHook("roundstart")
	INVOKE_ASYNC(src, PROC_REF(roundstart))

	LOG_DEBUG("SSticker: Running [LAZYLEN(roundstart_callbacks)] round-start callbacks.")
	run_callback_list(roundstart_callbacks)
	roundstart_callbacks = null

	LOG_DEBUG("SSticker: Round-start setup took [(REALTIMEOFDAY - starttime)/10] seconds.")

	return SETUP_OK

/datum/controller/subsystem/ticker/proc/roundstart()
	mode.post_setup()
	//Cleanup some stuff
	for(var/obj/effect/landmark/start/S in GLOB.landmarks_list)
		//Deleting Startpoints but we need the ai point to AI-ize people later
		if (S.name != "AI")
			qdel(S)
	// update join icon for lobbysitters
	for(var/mob/abstract/new_player/NP in GLOB.player_list)
		if(!NP.client)
			continue
		var/obj/screen/new_player/selection/join_game/JG = locate() in NP.client.screen
		JG.update_icon(NP)
	to_world(SPAN_NOTICE("<b>Enjoy the round!</b>"))
	if(SSatlas.current_sector.sector_welcome_message)
		sound_to(world, sound(SSatlas.current_sector.sector_welcome_message))
	else
		sound_to(world, sound('sound/AI/welcome.ogg'))
	//Holiday Round-start stuff	~Carn
	Holiday_Game_Start()

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
		mouse_opacity = MOUSE_OPACITY_TRANSPARENT;
		screen_loc = "1,0"
	}

	var/obj/structure/bed/temp_buckle = new
	//Incredibly hackish. It creates a bed within the gameticker (lol) to stop mobs running around
	if(station_missed)
		for(var/mob/living/M in GLOB.living_mob_list)
			M.buckled_to = temp_buckle				//buckles the mob so it can't do anything
			if(M.client)
				M.client.screen += cinematic	//show every client the cinematic
	else	//nuke kills everyone on z-level 1 to prevent "hurr-durr I survived"
		for(var/mob/living/M in GLOB.living_mob_list)
			M.buckled_to = temp_buckle
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
					sound_to(world, sound('sound/effects/explosionfar.ogg'))
					flick("station_intact_fade_red",cinematic)
					cinematic.icon_state = "summary_nukefail"
				else
					flick("intro_nuke",cinematic)
					sleep(35)
					sound_to(world, sound('sound/effects/explosionfar.ogg'))
					//flick("end",cinematic)

		if(2)	//nuke was nowhere nearby	//TODO: a really distant explosion animation
			sleep(50)
			sound_to(world, sound('sound/effects/explosionfar.ogg'))

		else	//station was destroyed
			if( mode && !override )
				override = mode.name
			switch( override )
				if("mercenary") //Nuke Ops successfully bombed the station
					flick("intro_nuke",cinematic)
					sleep(35)
					flick("station_explode_fade_red",cinematic)
					sound_to(world, sound('sound/effects/explosionfar.ogg'))
					cinematic.icon_state = "summary_nukewin"
				if("AI malfunction") //Malf (screen,explosion,summary)
					flick("intro_malf",cinematic)
					sleep(76)
					flick("station_explode_fade_red",cinematic)
					sound_to(world, sound('sound/effects/explosionfar.ogg'))
					cinematic.icon_state = "summary_malf"
				if("blob") //Station nuked (nuke,explosion,summary)
					flick("intro_nuke",cinematic)
					sleep(35)
					flick("station_explode_fade_red",cinematic)
					sound_to(world, sound('sound/effects/explosionfar.ogg'))
					cinematic.icon_state = "summary_selfdes"
				else //Station nuked (nuke,explosion,summary)
					flick("intro_nuke",cinematic)
					sleep(35)
					flick("station_explode_fade_red", cinematic)
					sound_to(world, sound('sound/effects/explosionfar.ogg'))
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
	for(var/mob/abstract/new_player/player in GLOB.player_list)
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
	for(var/mob/living/player in GLOB.player_list)
		if(player.mind)
			minds += player.mind

/datum/controller/subsystem/ticker/proc/equip_characters()
	for(var/mob/living/carbon/human/player in GLOB.player_list)
		if(player && player.mind && player.mind.assigned_role)
			if(!player_is_antag(player.mind, only_offstation_roles = 1))
				SSjobs.EquipAugments(player, player.client.prefs)
				SSjobs.EquipRank(player, player.mind.assigned_role, 0)
				equip_custom_items(player)

		CHECK_TICK

// Registers a callback to run on round-start.
/datum/controller/subsystem/ticker/proc/OnRoundstart(datum/callback/callback)
	if (!istype(callback))
		return

	LAZYADD(roundstart_callbacks, callback)

/datum/controller/subsystem/ticker/Topic(href, href_list)
	if(href_list["current_sector_show_sites_id"])
		var/datum/space_sector/current_sector = SSatlas.current_sector
		var/list/sites = SSatlas.current_sector.possible_sites_in_sector()
		var/list/site_names = list()
		var/list/ship_names = list()
		for(var/datum/map_template/ruin/site in sites)
			if(site.ship_cost)
				ship_names += site.name
			else
				site_names += site.name

		var/datum/browser/sites_win = new(
			usr,
			"Sector: " + current_sector.name,
			"Sector: " + current_sector.name,
			500, 500,
		)
		var/html = "<h1>Ships and sites that spawn in this sector:</h1>"
		html += "<h3>Ships:</h3>"
		html += english_list(ship_names)
		html += "<h3>Sites:</h3>"
		html += english_list(site_names)
		sites_win.set_content(html)
		sites_win.open()
		return TRUE
	. = ..()

#undef SETUP_OK
#undef SETUP_REVOTE
#undef SETUP_REATTEMPT
#undef LOBBY_TIME
