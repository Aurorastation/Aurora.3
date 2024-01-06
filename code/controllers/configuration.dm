GLOBAL_LIST_EMPTY(gamemode_cache)

/datum/configuration
	var/server_name = null				// server name (for world name / status)
	var/server_suffix = 0				// generate numeric suffix based on server port

	/*#############################################
				START LOGGING SETTINGS
	#############################################*/


	/**
	 * This is the nuclear option, this will make Hadii proud of you, and the players/other staff VERY VERY
	 * ANGRY at you if you flip this on in production, also, everyone connected will be able to see the logs
	 * so once again:
	 *
	 *		 NUCLEAR OPTION, TEST ENVIRONMENT/LOCAL INSTANCE/EVERYTHING IS FUCKED ONLY
	 *
	 * don't come cry to me if you fuck this up, but at least you can unfuck it just as easily. If the server survives.
	*/
	var/all_logs_to_chat = FALSE

	var/condense_all_logs = TRUE

	// Enable/Disable Logging
	var/list/logsettings = list(
	"log_access" = FALSE,	// log login/logout
	"log_say" = FALSE,	// log client say
	"log_signaler" = FALSE,	// log signaler actions
	"log_debug" = TRUE,	// log debug output
	"log_whisper" = FALSE,	// log client whisper
	"log_attack" = FALSE,	// log attack messages
	"log_hrefs" = FALSE,	// logs all links clicked in-game. Could be used for debugging and tracking down exploits
	"log_runtime" = FALSE,	// logs world.log to a file
	"log_asset" = FALSE,	// Asset loadings and changes
	"log_job_debug" = FALSE,	// Jobs debugging
	"log_signals" = FALSE,	// Signals
	"log_admin" = TRUE,	// Admin actions
	"log_adminchat" = TRUE,	// Admin chat
	"log_suspicious_login" = TRUE,
	"log_traitor" = TRUE,	// Antags
	"log_uplink" = TRUE,	// Antag uplink
	"log_game" = TRUE,	// General game events
	"log_emote" = TRUE,	// Audible emotes (like ME/F4)
	"log_ooc" = TRUE,	// OOC Chat
	"log_prayer" = TRUE,	// Prays
	"log_vote" = FALSE,	// OOC Votes, like transfer
	"log_pda" = TRUE,	// PDA messages
	"log_telecomms" = FALSE,	// Radiochat / telecommunications
	"log_speech_indicators" = FALSE,	// Speech indicator
	"log_tools" = FALSE,	// Tools
	"log_manifest" = TRUE,	// Manifest
	"log_asset" = FALSE,	// log asset caching

	/*#### SUBSYSTEMS ####*/

	"log_subsystems" = TRUE,	// General Subsystems
	"log_subsystems_chemistry" = TRUE,	// SSChemistry
	"log_subsystems_atlas" = TRUE,	// ATLAS
	"log_subsystems_ghostroles" = TRUE,	// Ghost Roles
	"log_subsystems_law" = TRUE,	// Law
	"log_subsystems_cargo" = TRUE, // Cargo
	"log_subsystems_documents" = TRUE, // Documents
	"log_subsystems_fail2topic" = TRUE, // Fail2Topic
	"log_subsystems_mapfinalization" = TRUE, // Map Finalization
	"log_subsystems_tgui" = TRUE, // TGUI
	"log_subsystems_zas" = FALSE, // ZAS
	"log_subsystems_zas_debug" = FALSE, // ZAS debug

	/*#### MODULES ####*/

	"log_modules_ghostroles" = TRUE,	// Ghost Roles
	"log_modules_customitems" = TRUE,	// Custom Items
	"log_modules_exoplanets" = TRUE,	// Exoplanets
	"log_modules_sectors" = TRUE,	// Overmap Sectors
	"world_modules_ruins_log" = TRUE,	// Ruins

	)

	// Files to send the logs to
	var/list/logfiles = list(
	"world_asset_log" = "world_asset.log",
	"config_error_log" = "config_error.log",
	"filter_log" = "filter.log",
	"lua_log" = "lua.log",
	"world_map_error_log" = "world_map_error.log",
	"perf_log" = "perf.log",
	"world_qdel_log" = "world_qdel.log",
	"query_debug_log" = "query_debug.log",
	"world_runtime_log" = "world_runtime.log",
	"sql_error_log" = "sql_error.log",
	"world_game_log" = "world_game.log",
	"world_job_debug_log" = "world_job_debug.log",
	"signals_log" = "signals.log",
	"world_suspicious_login_log" = "world_suspicious_login.log",
	"world_uplink_log" = "world_uplink.log",
	"world_attack_log" = "world_attack.log",
	"combat_log" = "combat.log",
	"world_pda_log" = "world_pda.log",
	"world_telecomms_log" = "world_telecomms.log",
	"world_speech_indicators_log" = "world_speech_indicators.log",
	"world_tool_log" = "world_tool.log",
	"world_href_log" = "href.log",
	"garbage_collector_log" = "garbage_collector.log",
	"harddel_log" = "harddel.log",
	"world_paper_log" = "world_paper.log",
	"world_manifest_log" = "world_manifest.log",

	/*#### SUBSYSTEMS ####*/

	"world_subsystems_log" = "subsystems/world_subsystems.log",
	"world_subsystems_chemistry_log" = "subsystems/chemistry.log",
	"world_subsystems_atlas_log" = "subsystems/atlas.log",
	"world_subsystems_ghostroles_log" = "subsystems/ghostroles.log",
	"world_subsystems_law_log" = "subsystems/law.log",
	"world_subsystems_cargo_log" = "subsystems/cargo.log",
	"world_subsystems_documents_log" = "subsystems/documents.log",
	"world_subsystems_fail2topic_log" = "subsystems/fail2topic.log",
	"world_subsystems_mapfinalization_log" = "subsystems/mapfinalization.log",
	"world_subsystems_tgui" = "subsystems/tgui.log",
	"world_subsystems_zas" = "subsystems/zas.log",
	"world_subsystems_zas_debug" = "subsystems/zas.log",

	/*#### MODULES ####*/

	"world_modules_ghostroles_log" = "modules/ghostroles.log",
	"world_modules_customitems_log" = "modules/customitems.log",
	"world_modules_exoplanets_log" = "modules/exoplanets.log",
	"world_modules_sectors_log" = "modules/sectors.log",
	"world_modules_ruins_log" = "modules/ruins.log",
	)


	/*#############################################
				END LOGGING SETTINGS
	#############################################*/

	/*#############################################
				START AWAY SITES SETTINGS
	#############################################*/

	var/list/awaysites = list(
		"enable_loading" = TRUE, //If the away sites should be loaded or not
		"guaranteed_sites" = list(), //Config-specified guaranteed away sites
		"away_site_budget" = null, //The budget for away sites, overrides the map-defined one if set to a number
		"away_ship_budget" = null, //The budget for ships, overrides the map-defined one if set to a number
	)

	/*#############################################
				END AWAY SITES SETTINGS
	#############################################*/

	/*#############################################
				START EXOPLANET SETTINGS
	#############################################*/

	var/list/exoplanets = list(
		"enable_loading" = TRUE, //If the exoplanets should be generated or not
		"exoplanets_budget" = null, //The budget for exoplanets, overrides the map-defined one if set to a number
	)

	/*#############################################
				END AWAY SITES SETTINGS
	#############################################*/

	var/log_world_output = 0			// log world.log <<  messages
	var/sql_enabled = 0					// for sql switching
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
	var/restart_timeout = 1200			// time after round end & admin tickets are resolved until server restarts (deciseconds, 2 minute default)
	var/vote_no_default = 0				// vote does not default to nochange/norestart (tbi)
	var/vote_no_dead = 0				// dead people can't vote (tbi)
//	var/enable_authentication = 0		// goon authentication
	var/del_new_on_log = 1				// del's new players if they log before they spawn in
	var/feature_object_spell_system = 0 //spawns a spellbook which gives object-type spells instead of verb-type spells for the wizard
	var/traitor_scaling = 0 			//if amount of traitors scales based on amount of players
	var/objectives_disabled = 0 			//if objectives are disabled or not
	var/protect_roles_from_antagonist = 0// If security and such can be traitor/cult/other
	var/allow_Metadata = 0				// Metadata is supported.
	var/popup_admin_pm = 0				//adminPMs to non-admins show in a pop-up 'reply' window when set to 1.
	var/Ticklag = 0.33
	var/antag_hud_allowed = 0			// Ghosts can turn on Antagovision to see a HUD of who is the bad guys this round.
	var/antag_hud_restricted = 0                    // Ghosts that turn on Antagovision cannot rejoin the round.
	var/list/mode_names = list()
	var/list/modes = list()				// allowed modes
	var/list/votable_modes = list()		// votable modes
	var/list/probabilities_secret = list()			// relative probability of each mode in secret/random
	var/list/probabilities_mixed_secret = list()	// relative probability of each mode in heavy secret mode
	var/ipc_timelock_active = FALSE
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
	var/loadout_slots = 3					// The number of loadout slots per character
	var/loadout_cost = 15					// The maximum cost of the loadout per slot

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
	var/alert_desc_green = "All threats to the ship have passed. Security may not have weapons visible, privacy laws are once again fully enforced."
	var/alert_desc_blue_upto = "The ship has received reliable information about possible hostile activity onboard. Security staff may have weapons visible, random searches are permitted."
	var/alert_desc_blue_downto = "The immediate threat has passed. Security may no longer have weapons drawn at all times, but may continue to have them visible. Random searches are still allowed."
	var/alert_desc_yellow_to = "The ship is now under an elevated alert status due to a confirmed biological hazard. All crew are to follow command instruction in order to ensure a safe return to standard operations."
	var/alert_desc_red_upto = "There is an immediate serious threat to the ship. Security may have weapons unholstered at all times. Random searches are allowed and advised."
	var/alert_desc_red_downto = "The self-destruct mechanism has been deactivated, there is still, however, an immediate serious threat to the ship. Security may have weapons unholstered at all times, random searches are allowed and advised."
	var/alert_desc_delta = "The ship's self-destruct mechanism has been engaged. All crew are instructed to obey all instructions given by heads of staff. Any violations of these orders can be punished by death. This is not a drill."

	var/forbid_singulo_possession = 0

	//game_options.txt configs

	var/health_threshold_softcrit = 50
	var/health_threshold_dead = 0

	var/organ_health_multiplier = 1
	var/organ_regeneration_multiplier = 1
	var/organs_decay
	var/default_brain_health = 400

	//Paincrit knocks someone down once they hit 60 shock_stage, so by default make it so that close to 100 additional damage needs to be dealt,
	//so that it's similar to DAMAGE_PAIN. Lowered it a bit since hitting paincrit takes much longer to wear off than a halloss stun.
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
	var/lying_delay_multiplier = 4
	var/run_delay_multiplier = 1
	var/vehicle_delay_multiplier = 1

	//Mob specific modifiers. NOTE: These will affect different mob types in different ways
	var/human_delay = 0
	var/robot_delay = 0
	var/monkey_delay = 0
	var/alien_delay = 0
	var/slime_delay = 0
	var/animal_delay = 0


	var/auto_local_admin = FALSE
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

	var/time_offset = 6 //GMT to CST

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

	var/ninjas_allowed = 0
	var/abandon_allowed = 1
	var/ooc_allowed = 1
	var/looc_allowed = 1
	var/dooc_allowed = 1
	var/dead_looc_allowed = TRUE
	var/dsay_allowed = 1

	var/starlight = 0	// Whether space turfs have ambient light or not

	var/list/ert_species = list(SPECIES_HUMAN)

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
	var/observe_restriction = 1 // 0 - no restrictions; 1 - only following is permited on restricted levels; 2 - nothing is permitted on restricted levels

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

	// BYOND Tracy
	var/enable_byond_tracy = 0

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
	var/ntsl_disabled = TRUE

	// Is external Auth enabled
	var/external_auth = FALSE

	// fail2topic settings
	var/fail2topic_rate_limit = 5 SECONDS
	var/fail2topic_max_fails = 5
	var/fail2topic_rule_name = "_DD_Fail2topic"
	var/fail2topic_enabled = FALSE

	var/time_to_call_emergency_shuttle = 36000  //how many time until the crew can call the transfer shuttle. One hour by default.

	var/forum_api_path
	// global.forum_api_key - see modules/http/forum_api.dm
	var/news_use_forum_api = FALSE

	var/forumuser_api_url
	var/use_forumuser_api = FALSE
	// global.forumuser_api_key - see modules/http/forumuser_api.dm

	var/profiler_is_enabled = FALSE
	var/profiler_restart_period = 120 SECONDS
	var/profiler_timeout_threshold = 5 SECONDS

	var/list/external_rsc_urls = list()

	var/lore_summary

	var/current_space_sector

	var/cache_assets = TRUE

	var/asset_transport = "simple"

	var/asset_simple_preload
	var/asset_cdn_webroot = ""
	var/asset_cdn_url = null

GENERAL_PROTECT_DATUM(/datum/configuration)

/datum/configuration/New()
	var/list/L = typesof(/datum/game_mode) - /datum/game_mode
	for (var/T in L)
		// I wish I didn't have to instance the game modes in order to look up
		// their information, but it is the only way (at least that I know of).
		var/datum/game_mode/M = new T()
		if (M.config_tag)
			GLOB.gamemode_cache[M.config_tag] = M // So we don't instantiate them repeatedly.
			if(!(M.config_tag in modes))		// ensure each mode is added only once
				LOG_DEBUG("Adding game mode [M.name] ([M.config_tag]) to configuration.")
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
				if ("auto_local_admin")
					GLOB.config.auto_local_admin = TRUE

				if ("admin_legacy_system")
					GLOB.config.admin_legacy_system = 1

				if ("ban_legacy_system")
					GLOB.config.ban_legacy_system = 1

				if ("use_age_restriction_for_jobs")
					GLOB.config.use_age_restriction_for_jobs = 1

				if ("use_age_restriction_for_antags")
					GLOB.config.use_age_restriction_for_antags = 1

				if ("load_age_restrictions_from_file")
					GLOB.config.age_restrictions_from_file = 1

				if ("jobs_have_minimal_access")
					GLOB.config.jobs_have_minimal_access = 1

				if ("use_spreading_explosions")
					GLOB.config.use_spreading_explosions = 1

				if ("sql_enabled")
					GLOB.config.sql_enabled = 1

				if ("debug_paranoid")
					GLOB.config.debugparanoid = 1

				if ("dungeon_chance")
					GLOB.config.dungeon_chance = text2num(value)

				if ("generate_asteroid")
					GLOB.config.generate_asteroid = 1

				if ("no_click_cooldown")
					GLOB.config.no_click_cooldown = 1

				if("allow_admin_ooccolor")
					GLOB.config.allow_admin_ooccolor = 1

				if ("allow_vote_restart")
					GLOB.config.allow_vote_restart = 1

				if ("allow_vote_mode")
					GLOB.config.allow_vote_mode = 1

				if ("allow_admin_jump")
					GLOB.config.allow_admin_jump = 1

				if ("allow_admin_rev")
					GLOB.config.allow_admin_rev = 1

				if ("allow_admin_spawning")
					GLOB.config.allow_admin_spawning = 1

				if ("no_dead_vote")
					GLOB.config.vote_no_dead = 1

				if ("default_no_vote")
					GLOB.config.vote_no_default = 1

				if ("vote_delay")
					GLOB.config.vote_delay = text2num(value)

				if ("vote_period")
					GLOB.config.vote_period = text2num(value)

				if ("vote_autotransfer_initial")
					GLOB.config.vote_autotransfer_initial = text2num(value)

				if ("vote_autotransfer_interval")
					GLOB.config.vote_autotransfer_interval = text2num(value)

				if ("vote_autogamemode_timeleft")
					GLOB.config.vote_autogamemode_timeleft = text2num(value)

				if ("transfer_timeout")
					GLOB.config.transfer_timeout = text2num(value)

				if ("restart_timeout")
					GLOB.config.restart_timeout = text2num(value)

				if("ert_admin_only")
					GLOB.config.ert_admin_call_only = 1

				if ("allow_ai")
					GLOB.config.allow_ai = 1

				if ("respawn_delay")
					GLOB.config.respawn_delay = text2num(value)

				if ("hacked_drones_limit")
					GLOB.config.hacked_drones_limit = text2num(value)

				if ("servername")
					GLOB.config.server_name = value

				if ("serversuffix")
					GLOB.config.server_suffix = 1

				if ("hostedby")
					GLOB.config.hostedby = value

				if ("server")
					GLOB.config.server = value

				if ("banappeals")
					GLOB.config.banappeals = value

				if ("wikiurl")
					GLOB.config.wikiurl = value

				if ("forumurl")
					GLOB.config.forumurl = value

				if ("forum_passphrase")
					GLOB.config.forum_passphrase = value

				if ("githuburl")
					GLOB.config.githuburl = value

				if ("ghosts_can_possess_animals")
					GLOB.config.ghosts_can_possess_animals = value

				if ("observe_restriction")
					GLOB.config.observe_restriction = text2num(value)

				if ("guest_jobban")
					GLOB.config.guest_jobban = 1

				if ("guest_ban")
					GLOB.config.guests_allowed = 0

				if ("disable_ooc")
					GLOB.config.ooc_allowed = 0
					GLOB.config.looc_allowed = 0

				if ("disable_entry")
					GLOB.config.enter_allowed = 0

				if ("disable_dead_ooc")
					GLOB.config.dooc_allowed = 0

				if ("disable_dead_looc")
					GLOB.config.dead_looc_allowed = FALSE

				if ("disable_dsay")
					GLOB.config.dsay_allowed = 0

				if ("disable_respawn")
					GLOB.config.abandon_allowed = 0

				if ("usewhitelist")
					GLOB.config.usewhitelist = 1

				if ("feature_object_spell_system")
					GLOB.config.feature_object_spell_system = 1

				if ("allow_metadata")
					GLOB.config.allow_Metadata = 1

				if ("traitor_scaling")
					GLOB.config.traitor_scaling = 1

				if ("ninjas_allowed")
					GLOB.config.ninjas_allowed = 1

				if ("objectives_disabled")
					GLOB.config.objectives_disabled = 1

				if("protect_roles_from_antagonist")
					GLOB.config.protect_roles_from_antagonist = 1

				if ("probability")
					var/list/chunks = splittext(value, " ")
					var/prob_type
					var/prob_name
					var/prob_value

					if (chunks.len == 3)
						prob_type = lowertext(chunks[1])
						prob_name = lowertext(chunks[2])
						prob_value = text2num(chunks[3])
						if (prob_name in GLOB.config.modes)
							// S adds a mode to standard secret rotation
							// MS adds a mode to mixed secret rotation
							if (prob_type == "s")
								GLOB.config.probabilities_secret[prob_name] = prob_value
							else if (prob_type == "ms")
								GLOB.config.probabilities_mixed_secret[prob_name] = prob_value
						else
							log_config("Unknown game mode probability configuration definition: [prob_name].")
					else
						log_config("Incorrect probability configuration definition: [prob_name]  [prob_value].")

				if("allow_random_events")
					GLOB.config.allow_random_events = 1

				if("kick_inactive")
					GLOB.config.kick_inactive = text2num(value)

				if("show_mods")
					GLOB.config.show_mods = 1

				if("show_mentors")
					GLOB.config.show_mentors = 1

				if("mods_can_tempban")
					GLOB.config.mods_can_tempban = 1

				if("mods_can_job_tempban")
					GLOB.config.mods_can_job_tempban = 1

				if("mod_tempban_max")
					GLOB.config.mod_tempban_max = text2num(value)

				if("mod_job_tempban_max")
					GLOB.config.mod_job_tempban_max = text2num(value)

				if("load_jobs_from_txt")
					load_jobs_from_txt = 1

				if("alert_red_upto")
					GLOB.config.alert_desc_red_upto = value

				if("alert_red_downto")
					GLOB.config.alert_desc_red_downto = value

				if("alert_blue_downto")
					GLOB.config.alert_desc_blue_downto = value

				if("alert_blue_upto")
					GLOB.config.alert_desc_blue_upto = value

				if("alert_green")
					GLOB.config.alert_desc_green = value

				if("alert_yellow")
					GLOB.config.alert_desc_yellow_to = value

				if("alert_delta")
					GLOB.config.alert_desc_delta = value

				if("forbid_singulo_possession")
					forbid_singulo_possession = 1

				if("popup_admin_pm")
					GLOB.config.popup_admin_pm = 1

				if("allow_holidays")
					Holiday = 1

				if("ticklag")
					Ticklag = text2num(value)

				if("allow_antag_hud")
					GLOB.config.antag_hud_allowed = 1
				if("antag_hud_restricted")
					GLOB.config.antag_hud_restricted = 1

				if("ipc_timelock_active")
					ipc_timelock_active = TRUE

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
					GLOB.config.assistant_maint = 1

				if("gateway_delay")
					GLOB.config.gateway_delay = text2num(value)

				if("ghost_interaction")
					GLOB.config.ghost_interaction = 1

				if("time_offset")
					GLOB.config.time_offset = text2num(value)

				if("disable_player_rats")
					GLOB.config.disable_player_rats = 1

				if("uneducated_rats")
					GLOB.config.uneducated_rats = 1

				if("use_discord_pins")
					GLOB.config.use_discord_pins = 1

				if("python_path")
					if(value)
						GLOB.config.python_path = value

				if("allow_cult_ghostwriter")
					GLOB.config.cult_ghostwriter = 1

				if("req_cult_ghostwriter")
					GLOB.config.cult_ghostwriter_req_cultists = text2num(value)

				if("character_slots")
					GLOB.config.character_slots = text2num(value)

				if("loadout_slots")
					GLOB.config.loadout_slots = text2num(value)

				if("loadout_cost")
					GLOB.config.loadout_cost = text2num(value)

				if("allow_drone_spawn")
					GLOB.config.allow_drone_spawn = text2num(value)

				if("drone_build_time")
					GLOB.config.drone_build_time = text2num(value)

				if("max_maint_drones")
					GLOB.config.max_maint_drones = text2num(value)

				if("expected_round_length")
					GLOB.config.expected_round_length = MinutesToTicks(text2num(value))

				if("disable_welder_vision")
					GLOB.config.welder_vision = 0

				if("allow_extra_antags")
					GLOB.config.allow_extra_antags = 1

				if("event_custom_start_mundane")
					var/values = text2numlist(value, ";")
					GLOB.config.event_first_run[EVENT_LEVEL_MUNDANE] = list("lower" = MinutesToTicks(values[1]), "upper" = MinutesToTicks(values[2]))

				if("event_custom_start_moderate")
					var/values = text2numlist(value, ";")
					GLOB.config.event_first_run[EVENT_LEVEL_MODERATE] = list("lower" = MinutesToTicks(values[1]), "upper" = MinutesToTicks(values[2]))

				if("event_custom_start_major")
					var/values = text2numlist(value, ";")
					GLOB.config.event_first_run[EVENT_LEVEL_MAJOR] = list("lower" = MinutesToTicks(values[1]), "upper" = MinutesToTicks(values[2]))

				if("event_delay_lower")
					var/values = text2numlist(value, ";")
					GLOB.config.event_delay_lower[EVENT_LEVEL_MUNDANE] = MinutesToTicks(values[1])
					GLOB.config.event_delay_lower[EVENT_LEVEL_MODERATE] = MinutesToTicks(values[2])
					GLOB.config.event_delay_lower[EVENT_LEVEL_MAJOR] = MinutesToTicks(values[3])

				if("event_delay_upper")
					var/values = text2numlist(value, ";")
					GLOB.config.event_delay_upper[EVENT_LEVEL_MUNDANE] = MinutesToTicks(values[1])
					GLOB.config.event_delay_upper[EVENT_LEVEL_MODERATE] = MinutesToTicks(values[2])
					GLOB.config.event_delay_upper[EVENT_LEVEL_MAJOR] = MinutesToTicks(values[3])

				if("starlight")
					value = text2num(value)
					GLOB.config.starlight = value >= 0 ? value : 0

				if("openturf_starlight")
					openturf_starlight_permitted = TRUE

				if("ert_species")
					GLOB.config.ert_species = text2list(value, ";")
					if(!GLOB.config.ert_species.len)
						GLOB.config.ert_species += SPECIES_HUMAN

				if("law_zero")
					law_zero = value

				if("aggressive_changelog")
					GLOB.config.aggressive_changelog = 1

				if("sql_whitelists")
					GLOB.config.sql_whitelists = 1

				if("show_auxiliary_roles")
					GLOB.config.show_auxiliary_roles = 1

				if("webint_url")
					GLOB.config.webint_url = value

				if("sql_saves")
					GLOB.config.sql_saves = 1

				if("sql_ccia_logs")
					GLOB.config.sql_ccia_logs = 1

				if("client_error_version")
					GLOB.config.client_error_version = text2num(value)

				if("client_error_message")
					GLOB.config.client_error_message = value

				if("client_warn_version")
					GLOB.config.client_warn_version = text2num(value)

				if("client_warn_message")
					GLOB.config.client_warn_message = value

				if("client_blacklist_version")
					GLOB.config.client_blacklist_version = splittext(value, ";")

				if("allow_chat_markup")
					GLOB.config.allow_chat_markup = 1

				if("sql_stats")
					GLOB.config.sql_stats = 1

				if("default_language_prefixes")
					var/list/values = text2list(value, " ")
					if(values.len > 0)
						language_prefixes = values

				if("delist_when_no_admins")
					GLOB.config.delist_when_no_admins = 1

				if("antag_contest_enabled")
					GLOB.config.antag_contest_enabled = 1

				if("api_rate_limit")
					GLOB.config.api_rate_limit = text2num(value)

				if("api_rate_limit_whitelist")
					GLOB.config.api_rate_limit_whitelist = text2list(value, ";")

				if("mc_ticklimit_init")
					GLOB.config.mc_init_tick_limit = text2num(value) || TICK_LIMIT_MC_INIT_DEFAULT

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

				if("enable_byond_tracy")
					enable_byond_tracy = 1

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
					LOG_DEBUG("Fastboot is ENABLED.")

				if("merchant_chance")
					GLOB.config.merchant_chance = text2num(value)

				if("time_to_call_emergency_shuttle")
					GLOB.config.time_to_call_emergency_shuttle = text2num(value)

				if("current_space_sector")
					GLOB.config.current_space_sector = value

				if("force_map")
					override_map = value

				if ("explosion_z_threshold")
					iterative_explosives_z_threshold = text2num(value)

				if ("explosion_z_mult")
					iterative_explosives_z_multiplier = text2num(value)

				if ("explosion_z_sub")
					iterative_explosives_z_subtraction = text2num(value)

				if("show_game_type_odd")
					GLOB.config.show_game_type_odd = 1

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
				if ("ntsl_disabled")
					ntsl_disabled = text2num(value)

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


				if ("forum_api_path")
					forum_api_path = value
				if ("forum_api_key")
					global.forum_api_key = value

				if ("news_use_forum_api")
					news_use_forum_api = TRUE

				if ("profiler_enabled")
					profiler_is_enabled = TRUE
				if ("profiler_restart_period")
					profiler_restart_period = text2num(value) SECONDS
				if ("profiler_timeout_threshold")
					profiler_timeout_threshold = text2num(value)

				if ("forumuser_api_url")
					forumuser_api_url = value
				if ("use_forumuser_api")
					use_forumuser_api = TRUE
				if ("forumuser_api_key")
					global.forumuser_api_key = value

				if ("external_rsc_urls")
					external_rsc_urls = splittext(value, ",")

				if("lore_summary")
					lore_summary = value

				if("cache_assets")
					cache_assets = text2num(value)
				if("asset_transport")
					asset_transport = value
				if("asset_simple_preload")
					asset_simple_preload = TRUE
				if("asset_cdn_webroot")
					asset_cdn_webroot = (value[length(value)] != "/" ? (value + "/") : value)
				if("asset_cdn_url")
					asset_cdn_url = (value[length(value)] != "/" ? (value + "/") : value)

				else
					log_config("Unknown setting in configuration: '[name]'")

		else if(type == "game_options")
			if(!value)
				log_config("Unknown value for setting [name] in [filename].")
			value = text2num(value)

			switch(name)
				if("health_threshold_softcrit")
					GLOB.config.health_threshold_softcrit = value
				if("health_threshold_dead")
					GLOB.config.health_threshold_dead = value
				if("revival_pod_plants")
					GLOB.config.revival_pod_plants = value
				if("revival_cloning")
					GLOB.config.revival_cloning = value
				if("revival_brain_life")
					GLOB.config.revival_brain_life = value
				if("organ_health_multiplier")
					GLOB.config.organ_health_multiplier = value / 100
				if("organ_regeneration_multiplier")
					GLOB.config.organ_regeneration_multiplier = value / 100
				if("organ_damage_spillover_multiplier")
					GLOB.config.organ_damage_spillover_multiplier = value / 100
				if("organs_can_decay")
					GLOB.config.organs_decay = 1
				if("default_brain_health")
					GLOB.config.default_brain_health = text2num(value)
					if(!GLOB.config.default_brain_health || GLOB.config.default_brain_health < 1)
						GLOB.config.default_brain_health = initial(GLOB.config.default_brain_health)
				if("bones_can_break")
					GLOB.config.bones_can_break = value
				if("limbs_can_break")
					GLOB.config.limbs_can_break = value

				if("walk_speed")
					GLOB.config.walk_speed = value

				// These should never go to 0 or below. So, we clamp them.
				if("walk_delay_multiplier")
					GLOB.config.walk_delay_multiplier = max(0.1, value)
				if("run_delay_multiplier")
					GLOB.config.run_delay_multiplier = max(0.1, value)
				if("vehicle_delay_multiplier")
					GLOB.config.vehicle_delay_multiplier = max(0.1, value)

				if("human_delay")
					GLOB.config.human_delay = value
				if("robot_delay")
					GLOB.config.robot_delay = value
				if("monkey_delay")
					GLOB.config.monkey_delay = value
				if("alien_delay")
					GLOB.config.alien_delay = value
				if("slime_delay")
					GLOB.config.slime_delay = value
				if("animal_delay")
					GLOB.config.animal_delay = value


				if("use_loyalty_implants")
					GLOB.config.use_loyalty_implants = 1

				if ("sunlight_accuracy")
					GLOB.config.sun_accuracy = value

				if ("sunlight_z")
					GLOB.config.sun_target_z = value

				else
					log_config("Unknown setting in configuration: '[name]'")

		else if (type == "age_restrictions")
			name = replacetext(name, "_", " ")
			age_restrictions[name] = text2num(value)

		else if (type == "discord")
			// Ideally, this would never happen. But just in case.
			if (!SSdiscord)
				LOG_DEBUG("BOREALIS: Attempted to read config/discord.txt before initializing the bot.")
				return

			switch (name)
				if ("token")
					SSdiscord.auth_token = value
				if ("active")
					SSdiscord.active = TRUE
				if ("subscriber")
					SSdiscord.subscriber_role = value
				if ("alert_visibility")
					SSdiscord.alert_visibility = TRUE
				else
					log_config("Unknown setting in discord configuration: '[name]'")
	load_logging_config()
	load_away_sites_config()
	load_exoplanets_config()

/datum/configuration/proc/save_logging_config()
	rustg_file_write(json_encode(GLOB.config.logsettings), "config/logging.json")
	rustg_file_write(json_encode(GLOB.config.logfiles), "config/logging_files.json")

/*#############################################
	JSON loading configs functions section
#############################################*/

///Load the LOGGING configuration
/datum/configuration/proc/load_logging_config()
	try
		if((rustg_file_exists("config/logging.json") == "true"))
			src.logsettings = json_decode(rustg_file_read("config/logging.json"))

		if((rustg_file_exists("config/logging_files.json") == "true"))
			src.logfiles = json_decode(rustg_file_read("config/logging_files.json"))

	catch(var/exception/e)
		WARNING("Unable to read or restore log config from the configuration files. Exception: [json_encode(e)]")

///Load the AWAY SITES configuration
/datum/configuration/proc/load_away_sites_config()
	try
		if((rustg_file_exists("config/away_sites.json") == "true"))
			src.awaysites = json_decode(rustg_file_read("config/away_sites.json"))

	catch(var/exception/e)
		WARNING("Unable to read or restore away sites config from the configuration file. Exception: [json_encode(e)]")

///Load the EXOPLANETS configuration
/datum/configuration/proc/load_exoplanets_config()
	try
		if((rustg_file_exists("config/exoplanets.json") == "true"))
			src.exoplanets = json_decode(rustg_file_read("config/exoplanets.json"))

	catch(var/exception/e)
		WARNING("Unable to read or restore exoplanets config from the configuration file. Exception: [json_encode(e)]")

/datum/configuration/proc/pick_mode(mode_name)
	// I wish I didn't have to instance the game modes in order to look up
	// their information, but it is the only way (at least that I know of).
	for (var/game_mode in GLOB.gamemode_cache)
		var/datum/game_mode/M = GLOB.gamemode_cache[game_mode]
		if (M.config_tag && M.config_tag == mode_name)
			return M
	return GLOB.gamemode_cache["extended"]

/datum/configuration/proc/get_runnable_modes(secret_type = ROUNDTYPE_STR_SECRET)
	log_game("GAMEMODE: Checking runnable modes with secret_type set to [secret_type]...")

	var/list/probabilities = GLOB.config.probabilities_secret

	if (secret_type == ROUNDTYPE_STR_MIXED_SECRET)
		probabilities = GLOB.config.probabilities_mixed_secret
	else if (secret_type == ROUNDTYPE_STR_RANDOM)
		// Random picks from EVERYTHING. Need to use Copy() as to not pollute the
		// original list. PBRef is /great/.
		probabilities = GLOB.config.probabilities_secret.Copy()
		probabilities |= GLOB.config.probabilities_mixed_secret

	var/list/runnable_modes = list()
	for(var/game_mode in GLOB.gamemode_cache)
		var/datum/game_mode/M = GLOB.gamemode_cache[game_mode]
		if(!M)
			log_config("GAMEMODE: ERROR: [M] does not exist!")
			continue

		var/can_start = M.can_start()
		if(can_start != GAME_FAILURE_NONE)
			#if !defined(UNIT_TEST) // Do not print this useless log during unit tests
			log_game("GAMEMODE: [M.name] cannot start! Reason: [can_start]")
			#endif

			continue

		if(!probabilities[M.config_tag])
			log_config("GAMEMODE: ERROR: [M.name] does not have a config associated with it!")
			continue

		if(probabilities[M.config_tag] <= 0)
			log_config("GAMEMODE: ERROR: [M.name] has a probability equal or less than 0!")
			continue

		runnable_modes |= M

	return runnable_modes

/datum/configuration/proc/post_load()
	// Apply a default value to config.python_path, if needed
	if (!GLOB.config.python_path)
		if(world.system_type == UNIX)
			GLOB.config.python_path = "/usr/bin/env python2"
		else //probably windows, if not this should work anyway
			GLOB.config.python_path = "python"

	// If we are running the unit tests, turn every logging to on
	#if defined(UNIT_TEST)
	for(var/k in GLOB.config.logsettings)
		GLOB.config.logsettings[k] = TRUE
	#endif
