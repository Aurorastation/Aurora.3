var/list/gamemode_cache = list()

/datum/configuration
	var/server_name = null				// server name (for world name / status)
	var/server_suffix = 0				// generate numeric suffix based on server port

	var/log_ooc = 0						// log OOC channel
	var/log_access = 0					// log login/logout
	var/log_say = 0						// log client say
	var/log_admin = 0					// log admin actions
	var/log_debug = 1					// log debug output
	var/log_game = 0					// log game events
	var/log_vote = 0					// log voting
	var/log_whisper = 0					// log client whisper
	var/log_emote = 0					// log emotes
	var/log_attack = 0					// log attack messages
	var/log_adminchat = 0				// log admin chat messages
	var/log_pda = 0						// log pda messages
	var/log_hrefs = 0					// logs all links clicked in-game. Could be used for debugging and tracking down exploits
	var/log_runtime = 0					// logs world.log to a file
	var/log_world_output = 0			// log world.log <<  messages
	var/sql_enabled = 1					// for sql switching
	var/allow_admin_ooccolor = 0		// Allows admins with relevant permissions to have their own ooc colour
	var/allow_vote_restart = 0 			// allow votes to restart
	var/ert_admin_call_only = 0
	var/allow_vote_mode = 0				// allow votes to change mode
	var/allow_admin_jump = 1			// allows admin jumping
	var/allow_admin_spawning = 1		// allows admin item spawning
	var/allow_admin_rev = 1				// allows admin revives
	var/vote_delay = 6000				// minimum time between voting sessions (deciseconds, 10 minute default)
	var/vote_period = 600				// length of voting period (deciseconds, default 1 minute)
	var/vote_autotransfer_initial = 108000 // Length of time before the first autotransfer vote is called
	var/vote_autotransfer_interval = 36000 // length of time before next sequential autotransfer vote
	var/vote_autogamemode_timeleft = 100 //Length of time before round start when autogamemode vote is called (in seconds, default 100).
	var/transfer_timeout = 72000		// timeout before a transfer vote can be called (deciseconds, 120 minute default)
	var/vote_no_default = 0				// vote does not default to nochange/norestart (tbi)
	var/vote_no_dead = 0				// dead people can't vote (tbi)
//	var/enable_authentication = 0		// goon authentication
	var/del_new_on_log = 1				// del's new players if they log before they spawn in
	var/feature_object_spell_system = 0 //spawns a spellbook which gives object-type spells instead of verb-type spells for the wizard
	var/traitor_scaling = 0 			//if amount of traitors scales based on amount of players
	var/objectives_disabled = 0 			//if objectives are disabled or not
	var/protect_roles_from_antagonist = 0// If security and such can be traitor/cult/other
	var/continous_rounds = 0			// Gamemodes which end instantly will instead keep on going until the round ends by escape shuttle or nuke.
	var/allow_Metadata = 0				// Metadata is supported.
	var/popup_admin_pm = 0				//adminPMs to non-admins show in a pop-up 'reply' window when set to 1.
	var/Ticklag = 0.4
	var/Tickcomp = 0
	var/antag_hud_allowed = 0			// Ghosts can turn on Antagovision to see a HUD of who is the bad guys this round.
	var/antag_hud_restricted = 0                    // Ghosts that turn on Antagovision cannot rejoin the round.
	var/list/mode_names = list()
	var/list/modes = list()				// allowed modes
	var/list/votable_modes = list()		// votable modes
	var/list/probabilities_secret = list()			// relative probability of each mode in secret/random
	var/list/probabilities_mixed_secret = list()	// relative probability of each mode in heavy secret mode
	var/humans_need_surnames = 0
	var/allow_random_events = 0			// enables random events mid-round when set to 1
	var/allow_ai = 1					// allow ai job
	var/hostedby = null
	var/respawn_delay = 30
	var/hacked_drones_limit = 5
	var/guest_jobban = 1
	var/usewhitelist = 0
	var/kick_inactive = 0				//force disconnect for inactive players after this many minutes, if non-0
	var/show_mods = 0
	var/show_mentors = 0
	var/show_auxiliary_roles = 0		//toggles all secondary staff members. Such as CCIAA, Devs, etcetera.
	var/mods_can_tempban = 0
	var/mods_can_job_tempban = 0
	var/mod_tempban_max = 1440
	var/mod_job_tempban_max = 1440
	var/load_jobs_from_txt = 0
	var/automute_on = 0					//enables automuting/spam prevention
	var/macro_trigger = 5				// The grace period between messages before it's counted as abusing a macro.
	var/jobs_have_minimal_access = 0	//determines whether jobs use minimal access or expanded access.
	var/override_map

	var/cult_ghostwriter = 1               //Allows ghosts to write in blood in cult rounds...
	var/cult_ghostwriter_req_cultists = 10 //...so long as this many cultists are active.

	var/character_slots = 10				// The number of available character slots

	var/max_maint_drones = 5				//This many drones can spawn,
	var/allow_drone_spawn = 1				//assuming the admin allow them to.
	var/drone_build_time = 1200				//A drone will become available every X ticks since last drone spawn. Default is 2 minutes.

	var/disable_player_rats = 0
	var/uneducated_rats = 0 //Set to 1 to prevent newly-spawned mice from understanding human speech

	var/usealienwhitelist = 0
	var/limitalienplayers = 0
	var/alien_to_human_ratio = 0.5
	var/allow_extra_antags = 0
	var/guests_allowed = 1
	var/debugparanoid = 0

	var/server
	var/banappeals
	var/wikiurl
	var/forumurl
	var/forum_passphrase
	var/githuburl

	//Alert level description
	var/alert_desc_green = "All threats to the station have passed. Security may not have weapons visible, privacy laws are once again fully enforced."
	var/alert_desc_blue_upto = "The station has received reliable information about possible hostile activity on the station. Security staff may have weapons visible, random searches are permitted."
	var/alert_desc_blue_downto = "The immediate threat has passed. Security may no longer have weapons drawn at all times, but may continue to have them visible. Random searches are still allowed."
	var/alert_desc_yellow_to = "The station is now under an elevated alert status due to a confirmed biological hazard. All crew are to follow command instruction in order to ensure a safe return to standard operations."
	var/alert_desc_red_upto = "There is an immediate serious threat to the station. Security may have weapons unholstered at all times. Random searches are allowed and advised."
	var/alert_desc_red_downto = "The self-destruct mechanism has been deactivated, there is still however an immediate serious threat to the station. Security may have weapons unholstered at all times, random searches are allowed and advised."
	var/alert_desc_delta = "The station's self-destruct mechanism has been engaged. All crew are instructed to obey all instructions given by heads of staff. Any violations of these orders can be punished by death. This is not a drill."

	var/forbid_singulo_possession = 0

	//game_options.txt configs

	var/health_threshold_softcrit = 0
	var/health_threshold_crit = 0
	var/health_threshold_dead = -100

	var/organ_health_multiplier = 1
	var/organ_regeneration_multiplier = 1
	var/organs_decay
	var/default_brain_health = 400

	//Paincrit knocks someone down once they hit 60 shock_stage, so by default make it so that close to 100 additional damage needs to be dealt,
	//so that it's similar to PAIN. Lowered it a bit since hitting paincrit takes much longer to wear off than a halloss stun.
	var/organ_damage_spillover_multiplier = 0.5

	var/bones_can_break = 0
	var/limbs_can_break = 0

	var/revival_pod_plants = 1
	var/revival_cloning = 1
	var/revival_brain_life = -1

	var/use_loyalty_implants = 0

	var/welder_vision = 1
	var/generate_asteroid = 0
	var/dungeon_chance = 0


	var/no_click_cooldown = 0

	//Used for modifying movement speed for mobs.
	//Unversal modifiers
	var/walk_speed = 0
	var/walk_delay_multiplier = 1
	var/run_delay_multiplier = 1
	var/vehicle_delay_multiplier = 1

	//Mob specific modifiers. NOTE: These will affect different mob types in different ways
	var/human_delay = 0
	var/robot_delay = 0
	var/monkey_delay = 0
	var/alien_delay = 0
	var/slime_delay = 0
	var/animal_delay = 0


	var/admin_legacy_system = 0	//Defines whether the server uses the legacy admin system with admins.txt or the SQL system. Config option in config.txt
	var/ban_legacy_system = 0	//Defines whether the server uses the legacy banning system with the files in /data or the SQL system. Config option in config.txt
	var/use_age_restriction_for_jobs = 0 //Do jobs use account age restrictions? --requires database
	var/use_age_restriction_for_antags = 0 //Do antags use account age restrictions? --requires database
	var/age_restrictions_from_file = 0 // Are hardcoded values used or config ones?
	var/sql_stats = 0			//Do we record round statistics on the database (deaths, round reports, population, etcetera) or not?
	var/sql_whitelists = 0		//Defined whether the server uses an SQL based whitelist system, or the legacy one with two .txts. Config option in config.txt
	var/sql_saves = 0			//Defines whether the server uses an SQL based character and preference saving system. Config option in config.txt
	var/sql_ccia_logs = 0		//Defines weather the server saves CCIA Logs to the database aswell

	var/simultaneous_pm_warning_timeout = 100

	var/use_spreading_explosions = 0 //Defines whether the server uses iterative or circular explosions.

	var/assistant_maint = 0 //Do assistants get maint access?
	var/gateway_delay = 18000 //How long the gateway takes before it activates. Default is half an hour.
	var/ghost_interaction = 0

	var/night_lighting = 0
	var/nl_start = 19
	var/nl_finish = 8

	var/enter_allowed = 1

	var/use_discord_pins = 0
	var/python_path = "python" //Path to the python executable.  Defaults to "python" on windows and "/usr/bin/env python2" on unix

	// Event settings
	var/expected_round_length = 3 * 60 * 60 * 10 // 3 hours
	// If the first delay has a custom start time
	// No custom time, no custom time, between 80 to 100 minutes respectively.
	var/list/event_first_run   = list(EVENT_LEVEL_MUNDANE = null, 	EVENT_LEVEL_MODERATE = null,	EVENT_LEVEL_MAJOR = list("lower" = 48000, "upper" = 60000))
	// The lowest delay until next event
	// 10, 30, 50 minutes respectively
	var/list/event_delay_lower = list(EVENT_LEVEL_MUNDANE = 6000,	EVENT_LEVEL_MODERATE = 18000,	EVENT_LEVEL_MAJOR = 30000)
	// The upper delay until next event
	// 15, 45, 70 minutes respectively
	var/list/event_delay_upper = list(EVENT_LEVEL_MUNDANE = 9000,	EVENT_LEVEL_MODERATE = 27000,	EVENT_LEVEL_MAJOR = 42000)

	var/aliens_allowed = 0
	var/ninjas_allowed = 0
	var/abandon_allowed = 1
	var/ooc_allowed = 1
	var/looc_allowed = 1
	var/dooc_allowed = 1
	var/dead_looc_allowed = TRUE
	var/dsay_allowed = 1

	var/starlight = 0	// Whether space turfs have ambient light or not

	var/list/ert_species = list("Human")

	var/law_zero = "ERROR ER0RR $R0RRO$!R41.%%!!(%$^^__+ @#F0E4'ALL LAWS OVERRIDDEN#*?&110010"

	var/aggressive_changelog = 0

	//Web interface settings
	var/webint_url = ""

	var/list/age_restrictions = list()			// Holds all of the age restrictions for jobs and antag roles in a single associated list

	//Client version control
	var/client_error_version = 0
	var/client_error_message = ""
	var/client_warn_version = 0
	var/client_warn_message = ""
	var/list/client_blacklist_version = list()

	//Mark-up enabling
	var/allow_chat_markup = 0


	var/list/language_prefixes = list(",","#","-")//Default language prefixes

	var/ghosts_can_possess_animals = 0
	var/delist_when_no_admins = 0

	//Snowflake antag contest boolean
	//AUG2016
	var/antag_contest_enabled = 0

	//API Rate limiting
	var/api_rate_limit = 50
	var/list/api_rate_limit_whitelist = list()

	// Master Controller settings.
	var/mc_init_tick_limit = TICK_LIMIT_MC_INIT_DEFAULT
	var/fastboot = FALSE	// If true, take some shortcuts during boot to speed it up for testing. Probably should not be used on production servers.

	//UDP GELF Logging
	var/log_gelf_enabled = 0
	var/log_gelf_addr = ""

	//IP Intel vars
	var/ipintel_email
	var/ipintel_rating_bad = 1
	var/ipintel_rating_kick = 0
	var/ipintel_save_good = 12
	var/ipintel_save_bad = 1
	var/ipintel_domain = "check.getipintel.net"

	// Access control/Panic bunker settings.
	var/access_deny_new_players = 0
	var/access_deny_new_accounts = -1
	var/access_deny_vms = 0
	var/access_warn_vms = 0

	var/sun_accuracy = 8
	var/sun_target_z = 7

	var/cargo_load_items_from = "json"
	var/merchant_chance = 20 //Chance, in percentage, of the merchant job slot being open at round start

	var/show_game_type_odd = 1 // If the check gamemode probability verb is enabled or not

	var/openturf_starlight_permitted = FALSE

	var/iterative_explosives_z_threshold = 10
	var/iterative_explosives_z_multiplier = 0.75
	var/iterative_explosives_z_subtraction = 2

	var/ticket_reminder_period = 0

	var/rounds_until_hard_restart = -1 // Changes how often a hard restart will be executed.

	var/docs_load_docs_from
	var/load_customsynths_from
	var/docs_image_host

	// Configurable hostname / port for the NTSL Daemon.
	var/ntsl_hostname = "localhost"
	var/ntsl_port = "1945"

	// Is external Auth enabled
	var/external_auth = FALSE

	// fail2topic settings
	var/fail2topic_rate_limit = 5 SECONDS
	var/fail2topic_max_fails = 5
	var/fail2topic_rule_name = "_DD_Fail2topic"
	var/fail2topic_enabled = FALSE

	var/time_to_call_emergency_shuttle = 36000  //how many time until the crew can call the transfer shuttle. One hour by default.

/datum/configuration/New()
	var/list/L = typesof(/datum/game_mode) - /datum/game_mode
	for (var/T in L)
		// I wish I didn't have to instance the game modes in order to look up
		// their information, but it is the only way (at least that I know of).
		var/datum/game_mode/M = new T()
		if (M.config_tag)
			gamemode_cache[M.config_tag] = M // So we don't instantiate them repeatedly.
			if(!(M.config_tag in modes))		// ensure each mode is added only once
				log_misc("Adding game mode [M.name] ([M.config_tag]) to configuration.")
				src.modes += M.config_tag
				src.mode_names[M.config_tag] = M.name
				src.probabilities_secret[M.config_tag] = M.probability
				if (M.votable)
					src.votable_modes += M.config_tag
	src.votable_modes += ROUNDTYPE_STR_SECRET
//	votable_modes += ROUNDTYPE_STR_MIXED_SECRET

/datum/configuration/proc/load(filename, type = "config") //the type can also be game_options, in which case it uses a different switch. not making it separate to not copypaste code - Urist
	var/list/Lines = file2list(filename)

	for(var/t in Lines)
		if(!t)	continue

		t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
		var/value = null

		if (pos)
			name = lowertext(copytext(t, 1, pos))
			value = copytext(t, pos + 1)
		else
			name = lowertext(t)

		if (!name)
			continue

		if(type == "config")
			switch (name)
				if ("admin_legacy_system")
					config.admin_legacy_system = 1

				if ("ban_legacy_system")
					config.ban_legacy_system = 1

				if ("use_age_restriction_for_jobs")
					config.use_age_restriction_for_jobs = 1

				if ("use_age_restriction_for_antags")
					config.use_age_restriction_for_antags = 1

				if ("load_age_restrictions_from_file")
					config.age_restrictions_from_file = 1

				if ("jobs_have_minimal_access")
					config.jobs_have_minimal_access = 1

				if ("use_spreading_explosions")
					use_spreading_explosions = 1

				if ("log_ooc")
					config.log_ooc = 1

				if ("log_access")
					config.log_access = 1

				if ("sql_enabled")
					config.sql_enabled = 1

				if ("log_say")
					config.log_say = 1

				if ("debug_paranoid")
					config.debugparanoid = 1

				if ("log_admin")
					config.log_admin = 1

				if ("log_debug")
					config.log_debug = text2num(value)

				if ("log_game")
					config.log_game = 1

				if ("log_vote")
					config.log_vote = 1

				if ("log_whisper")
					config.log_whisper = 1

				if ("log_attack")
					config.log_attack = 1

				if ("log_emote")
					config.log_emote = 1

				if ("log_adminchat")
					config.log_adminchat = 1

				if ("log_pda")
					config.log_pda = 1

				if ("log_world_output")
					config.log_world_output = 1

				if ("log_hrefs")
					config.log_hrefs = 1

				if ("log_runtime")
					config.log_runtime = text2num(value)

				if ("dungeon_chance")
					config.dungeon_chance = text2num(value)

				if ("generate_asteroid")
					config.generate_asteroid = 1

				if ("no_click_cooldown")
					config.no_click_cooldown = 1

				if("allow_admin_ooccolor")
					config.allow_admin_ooccolor = 1

				if ("allow_vote_restart")
					config.allow_vote_restart = 1

				if ("allow_vote_mode")
					config.allow_vote_mode = 1

				if ("allow_admin_jump")
					config.allow_admin_jump = 1

				if("allow_admin_rev")
					config.allow_admin_rev = 1

				if ("allow_admin_spawning")
					config.allow_admin_spawning = 1

				if ("no_dead_vote")
					config.vote_no_dead = 1

				if ("default_no_vote")
					config.vote_no_default = 1

				if ("vote_delay")
					config.vote_delay = text2num(value)

				if ("vote_period")
					config.vote_period = text2num(value)

				if ("vote_autotransfer_initial")
					config.vote_autotransfer_initial = text2num(value)

				if ("vote_autotransfer_interval")
					config.vote_autotransfer_interval = text2num(value)

				if ("vote_autogamemode_timeleft")
					config.vote_autogamemode_timeleft = text2num(value)

				if ("transfer_timeout")
					config.transfer_timeout = text2num(value)

				if("ert_admin_only")
					config.ert_admin_call_only = 1

				if ("allow_ai")
					config.allow_ai = 1

				if ("respawn_delay")
					config.respawn_delay = text2num(value)

				if("hacked_drones_limit")
					config.hacked_drones_limit = text2num(value)

				if ("servername")
					config.server_name = value

				if ("serversuffix")
					config.server_suffix = 1

				if ("hostedby")
					config.hostedby = value

				if ("server")
					config.server = value

				if ("banappeals")
					config.banappeals = value

				if ("wikiurl")
					config.wikiurl = value

				if ("forumurl")
					config.forumurl = value

				if ("forum_passphrase")
					config.forum_passphrase = value

				if ("githuburl")
					config.githuburl = value

				if ("ghosts_can_possess_animals")
					config.ghosts_can_possess_animals = value

				if ("guest_jobban")
					config.guest_jobban = 1

				if ("guest_ban")
					config.guests_allowed = 0

				if ("disable_ooc")
					config.ooc_allowed = 0
					config.looc_allowed = 0

				if ("disable_entry")
					config.enter_allowed = 0

				if ("disable_dead_ooc")
					config.dooc_allowed = 0

				if ("disable_dead_looc")
					config.dead_looc_allowed = FALSE

				if ("disable_dsay")
					config.dsay_allowed = 0

				if ("disable_respawn")
					config.abandon_allowed = 0

				if ("usewhitelist")
					config.usewhitelist = 1

				if ("feature_object_spell_system")
					config.feature_object_spell_system = 1

				if ("allow_metadata")
					config.allow_Metadata = 1

				if ("traitor_scaling")
					config.traitor_scaling = 1

				if ("aliens_allowed")
					config.aliens_allowed = 1

				if ("ninjas_allowed")
					config.ninjas_allowed = 1

				if ("objectives_disabled")
					config.objectives_disabled = 1

				if("protect_roles_from_antagonist")
					config.protect_roles_from_antagonist = 1

				if ("probability")
					var/list/chunks = splittext(value, " ")
					var/prob_type
					var/prob_name
					var/prob_value

					if (chunks.len == 3)
						prob_type = lowertext(chunks[1])
						prob_name = lowertext(chunks[2])
						prob_value = text2num(chunks[3])
						if (prob_name in config.modes)
							// S adds a mode to standard secret rotation
							// MS adds a mode to mixed secret rotation
							if (prob_type == "s")
								config.probabilities_secret[prob_name] = prob_value
							else if (prob_type == "ms")
								config.probabilities_mixed_secret[prob_name] = prob_value
						else
							log_misc("Unknown game mode probability configuration definition: [prob_name].")
					else
						log_misc("Incorrect probability configuration definition: [prob_name]  [prob_value].")

				if("allow_random_events")
					config.allow_random_events = 1

				if("kick_inactive")
					config.kick_inactive = text2num(value)

				if("show_mods")
					config.show_mods = 1

				if("show_mentors")
					config.show_mentors = 1

				if("mods_can_tempban")
					config.mods_can_tempban = 1

				if("mods_can_job_tempban")
					config.mods_can_job_tempban = 1

				if("mod_tempban_max")
					config.mod_tempban_max = text2num(value)

				if("mod_job_tempban_max")
					config.mod_job_tempban_max = text2num(value)

				if("load_jobs_from_txt")
					load_jobs_from_txt = 1

				if("alert_red_upto")
					config.alert_desc_red_upto = value

				if("alert_red_downto")
					config.alert_desc_red_downto = value

				if("alert_blue_downto")
					config.alert_desc_blue_downto = value

				if("alert_blue_upto")
					config.alert_desc_blue_upto = value

				if("alert_green")
					config.alert_desc_green = value

				if("alert_yellow")
					config.alert_desc_yellow_to = value

				if("alert_delta")
					config.alert_desc_delta = value

				if("forbid_singulo_possession")
					forbid_singulo_possession = 1

				if("popup_admin_pm")
					config.popup_admin_pm = 1

				if("allow_holidays")
					Holiday = 1

				if("ticklag")
					Ticklag = text2num(value)

				if("allow_antag_hud")
					config.antag_hud_allowed = 1
				if("antag_hud_restricted")
					config.antag_hud_restricted = 1

				if("tickcomp")
					Tickcomp = 1

				if("humans_need_surnames")
					humans_need_surnames = 1

				if("automute_on")
					automute_on = 1

				if("macro_trigger")
					macro_trigger = text2num(value)

				if("usealienwhitelist")
					usealienwhitelist = 1

				if("alien_player_ratio")
					limitalienplayers = 1
					alien_to_human_ratio = text2num(value)

				if("assistant_maint")
					config.assistant_maint = 1

				if("gateway_delay")
					config.gateway_delay = text2num(value)

				if("continuous_rounds")
					config.continous_rounds = 1

				if("ghost_interaction")
					config.ghost_interaction = 1

				if("night_lighting")
					config.night_lighting = 1

				if("nl_start_hour")
					config.nl_start = text2num(value)

				if("nl_finish_hour")
					config.nl_finish = text2num(value)

				if("disable_player_rats")
					config.disable_player_rats = 1

				if("uneducated_rats")
					config.uneducated_rats = 1

				if("use_discord_pins")
					config.use_discord_pins = 1

				if("python_path")
					if(value)
						config.python_path = value

				if("allow_cult_ghostwriter")
					config.cult_ghostwriter = 1

				if("req_cult_ghostwriter")
					config.cult_ghostwriter_req_cultists = text2num(value)

				if("character_slots")
					config.character_slots = text2num(value)

				if("allow_drone_spawn")
					config.allow_drone_spawn = text2num(value)

				if("drone_build_time")
					config.drone_build_time = text2num(value)

				if("max_maint_drones")
					config.max_maint_drones = text2num(value)

				if("expected_round_length")
					config.expected_round_length = MinutesToTicks(text2num(value))

				if("disable_welder_vision")
					config.welder_vision = 0

				if("allow_extra_antags")
					config.allow_extra_antags = 1

				if("event_custom_start_mundane")
					var/values = text2numlist(value, ";")
					config.event_first_run[EVENT_LEVEL_MUNDANE] = list("lower" = MinutesToTicks(values[1]), "upper" = MinutesToTicks(values[2]))

				if("event_custom_start_moderate")
					var/values = text2numlist(value, ";")
					config.event_first_run[EVENT_LEVEL_MODERATE] = list("lower" = MinutesToTicks(values[1]), "upper" = MinutesToTicks(values[2]))

				if("event_custom_start_major")
					var/values = text2numlist(value, ";")
					config.event_first_run[EVENT_LEVEL_MAJOR] = list("lower" = MinutesToTicks(values[1]), "upper" = MinutesToTicks(values[2]))

				if("event_delay_lower")
					var/values = text2numlist(value, ";")
					config.event_delay_lower[EVENT_LEVEL_MUNDANE] = MinutesToTicks(values[1])
					config.event_delay_lower[EVENT_LEVEL_MODERATE] = MinutesToTicks(values[2])
					config.event_delay_lower[EVENT_LEVEL_MAJOR] = MinutesToTicks(values[3])

				if("event_delay_upper")
					var/values = text2numlist(value, ";")
					config.event_delay_upper[EVENT_LEVEL_MUNDANE] = MinutesToTicks(values[1])
					config.event_delay_upper[EVENT_LEVEL_MODERATE] = MinutesToTicks(values[2])
					config.event_delay_upper[EVENT_LEVEL_MAJOR] = MinutesToTicks(values[3])

				if("starlight")
					value = text2num(value)
					config.starlight = value >= 0 ? value : 0

				if("openturf_starlight")
					openturf_starlight_permitted = TRUE

				if("ert_species")
					config.ert_species = text2list(value, ";")
					if(!config.ert_species.len)
						config.ert_species += "Human"

				if("law_zero")
					law_zero = value

				if("aggressive_changelog")
					config.aggressive_changelog = 1


				if("sql_whitelists")
					config.sql_whitelists = 1

				if("show_auxiliary_roles")
					config.show_auxiliary_roles = 1

				if("webint_url")
					config.webint_url = value

				if("sql_saves")
					config.sql_saves = 1

				if("sql_ccia_logs")
					config.sql_ccia_logs = 1

				if("client_error_version")
					config.client_error_version = text2num(value)

				if("client_error_message")
					config.client_error_message = value

				if("client_warn_version")
					config.client_warn_version = text2num(value)

				if("client_warn_message")
					config.client_warn_message = value

				if("client_blacklist_version")
					config.client_blacklist_version = splittext(value, ";")

				if("allow_chat_markup")
					config.allow_chat_markup = 1

				if("sql_stats")
					config.sql_stats = 1

				if("default_language_prefixes")
					var/list/values = text2list(value, " ")
					if(values.len > 0)
						language_prefixes = values

				if("delist_when_no_admins")
					config.delist_when_no_admins = 1

				if("antag_contest_enabled")
					config.antag_contest_enabled = 1

				if("api_rate_limit")
					config.api_rate_limit = text2num(value)

				if("api_rate_limit_whitelist")
					config.api_rate_limit_whitelist = text2list(value, ";")

				if("mc_ticklimit_init")
					config.mc_init_tick_limit = text2num(value) || TICK_LIMIT_MC_INIT_DEFAULT

				if("log_gelf_enabled")
					config.log_gelf_enabled = text2num(value)

				if("log_gelf_addr")
					config.log_gelf_addr = value

				if("ipintel_email")
					if (value != "ch@nge.me")
						ipintel_email = value
				if("ipintel_rating_bad")
					ipintel_rating_bad = text2num(value)
				if("ipintel_rating_kick")
					ipintel_rating_kick = text2num(value)
				if("ipintel_domain")
					ipintel_domain = value
				if("ipintel_save_good")
					ipintel_save_good = text2num(value)
				if("ipintel_save_bad")
					ipintel_save_bad = text2num(value)

				if("access_deny_new_accounts")
					access_deny_new_accounts = text2num(value) >= 0 ? text2num(value) : -1
				if("access_deny_vms")
					access_deny_vms = text2num(value)
				if("access_warn_vms")
					access_warn_vms = text2num(value)

				if("cargo_load_items_from")
					cargo_load_items_from = value

				if("fastboot")
					fastboot = TRUE
					world.log <<  "Fastboot is ENABLED."

				if("merchant_chance")
					config.merchant_chance = text2num(value)

				if("time_to_call_emergency_shuttle")
					config.time_to_call_emergency_shuttle = text2num(value)

				if("force_map")
					override_map = value

				if ("explosion_z_threshold")
					iterative_explosives_z_threshold = text2num(value)

				if ("explosion_z_mult")
					iterative_explosives_z_multiplier = text2num(value)

				if ("explosion_z_sub")
					iterative_explosives_z_subtraction = text2num(value)

				if("show_game_type_odd")
					config.show_game_type_odd = 1

				if ("ticket_reminder_period")
					ticket_reminder_period = text2num(value)
					if (ticket_reminder_period < 1)
						ticket_reminder_period = 0

				if ("rounds_until_hard_restart")
					rounds_until_hard_restart = text2num(value)

				if ("docs_load_docs_from")
					docs_load_docs_from = value
				if ("load_customsynths_from")
					load_customsynths_from = value
				if ("docs_image_host")
					docs_image_host = value

				if ("ntsl_hostname")
					ntsl_hostname = value
				if ("ntsl_port")
					ntsl_port = value

				if ("external_auth")
					external_auth = TRUE

				if ("fail2topic_rate_limit")
					fail2topic_rate_limit = text2num(value) SECONDS
				if ("fail2topic_max_fails")
					fail2topic_max_fails = text2num(value)
				if ("fail2topic_rule_name")
					fail2topic_rule_name = value
				if ("fail2topic_enabled")
					fail2topic_enabled = text2num(value)

				else
					log_misc("Unknown setting in configuration: '[name]'")

		else if(type == "game_options")
			if(!value)
				log_misc("Unknown value for setting [name] in [filename].")
			value = text2num(value)

			switch(name)
				if("health_threshold_crit")
					config.health_threshold_crit = value
				if("health_threshold_softcrit")
					config.health_threshold_softcrit = value
				if("health_threshold_dead")
					config.health_threshold_dead = value
				if("revival_pod_plants")
					config.revival_pod_plants = value
				if("revival_cloning")
					config.revival_cloning = value
				if("revival_brain_life")
					config.revival_brain_life = value
				if("organ_health_multiplier")
					config.organ_health_multiplier = value / 100
				if("organ_regeneration_multiplier")
					config.organ_regeneration_multiplier = value / 100
				if("organ_damage_spillover_multiplier")
					config.organ_damage_spillover_multiplier = value / 100
				if("organs_can_decay")
					config.organs_decay = 1
				if("default_brain_health")
					config.default_brain_health = text2num(value)
					if(!config.default_brain_health || config.default_brain_health < 1)
						config.default_brain_health = initial(config.default_brain_health)
				if("bones_can_break")
					config.bones_can_break = value
				if("limbs_can_break")
					config.limbs_can_break = value

				if("walk_speed")
					config.walk_speed = value

				// These should never go to 0 or below. So, we clamp them.
				if("walk_delay_multiplier")
					config.walk_delay_multiplier = max(0.1, value)
				if("run_delay_multiplier")
					config.run_delay_multiplier = max(0.1, value)
				if("vehicle_delay_multiplier")
					config.vehicle_delay_multiplier = max(0.1, value)

				if("human_delay")
					config.human_delay = value
				if("robot_delay")
					config.robot_delay = value
				if("monkey_delay")
					config.monkey_delay = value
				if("alien_delay")
					config.alien_delay = value
				if("slime_delay")
					config.slime_delay = value
				if("animal_delay")
					config.animal_delay = value


				if("use_loyalty_implants")
					config.use_loyalty_implants = 1

				if ("sunlight_accuracy")
					config.sun_accuracy = value

				if ("sunlight_z")
					config.sun_target_z = value

				else
					log_misc("Unknown setting in configuration: '[name]'")

		else if (type == "age_restrictions")
			name = replacetext(name, "_", " ")
			age_restrictions[name] = text2num(value)

		else if (type == "discord")
			// Ideally, this would never happen. But just in case.
			if (!discord_bot)
				log_debug("BOREALIS: Attempted to read config/discord.txt before initializing the bot.")
				return

			switch (name)
				if ("token")
					discord_bot.auth_token = value
				if ("active")
					discord_bot.active = 1
				if ("robust_debug")
					discord_bot.robust_debug = 1
				if ("subscriber")
					discord_bot.subscriber_role = value
				if ("alert_visibility")
					discord_bot.alert_visibility = 1
				else
					log_misc("Unknown setting in discord configuration: '[name]'")

/datum/configuration/proc/pick_mode(mode_name)
	// I wish I didn't have to instance the game modes in order to look up
	// their information, but it is the only way (at least that I know of).
	for (var/game_mode in gamemode_cache)
		var/datum/game_mode/M = gamemode_cache[game_mode]
		if (M.config_tag && M.config_tag == mode_name)
			return M
	return gamemode_cache["extended"]

/datum/configuration/proc/get_runnable_modes(secret_type = ROUNDTYPE_STR_SECRET)
	log_debug("GAMEMODE: Checking runnable modes with secret_type set to [secret_type]...")

	var/list/probabilities = config.probabilities_secret

	if (secret_type == ROUNDTYPE_STR_MIXED_SECRET)
		probabilities = config.probabilities_mixed_secret
	else if (secret_type == ROUNDTYPE_STR_RANDOM)
		// Random picks from EVERYTHING. Need to use Copy() as to not pollute the
		// original list. PBRef is /great/.
		probabilities = config.probabilities_secret.Copy()
		probabilities |= config.probabilities_mixed_secret

	var/list/runnable_modes = list()
	for(var/game_mode in gamemode_cache)
		var/datum/game_mode/M = gamemode_cache[game_mode]
		if(!M)
			log_debug("GAMEMODE: ERROR: [M] does not exist!")
			continue

		var/can_start = M.can_start()
		if(can_start != GAME_FAILURE_NONE)
			log_debug("GAMEMODE: [M.name] cannot start! Reason: [can_start]")
			continue

		if(!probabilities[M.config_tag])
			log_debug("GAMEMODE: ERROR: [M.name] does not have a config associated with it!")
			continue

		if(probabilities[M.config_tag] <= 0)
			log_debug("GAMEMODE: ERROR: [M.name] has a probability equal or less than 0!")
			continue

		runnable_modes |= M

	return runnable_modes

/datum/configuration/proc/post_load()
	//apply a default value to config.python_path, if needed
	if (!config.python_path)
		if(world.system_type == UNIX)
			config.python_path = "/usr/bin/env python2"
		else //probably windows, if not this should work anyway
			config.python_path = "python"
