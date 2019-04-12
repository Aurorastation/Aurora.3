/datum/map
	var/name = "Unnamed Map"
	var/full_name = "Unnamed Map"
	var/path

	var/list/station_levels = list() // Z-levels the station exists on
	var/list/admin_levels = list()   // Z-levels for admin functionality (Centcom, shuttle transit, etc)
	var/list/contact_levels = list() // Z-levels that can be contacted from the station, for eg announcements
	var/list/player_levels = list()  // Z-levels a character can typically reach
	var/list/sealed_levels = list()  // Z-levels that don't allow random transit at edge

	var/list/map_levels              // Z-levels available to various consoles, such as the crew monitor. Defaults to station_levels if unset.

	var/list/base_turf_by_z = list() // Custom base turf by Z-level. Defaults to world.turf for unlisted Z-levels

	//This list contains the z-level numbers which can be accessed via space travel and the percentile chances to get there.
	var/list/accessible_z_levels = list()

	var/list/allowed_jobs
		//Job datums to use.
		//Works a lot better so if we get to a point where three-ish maps are used
		//We don't have to C&P ones that are only common between two of them
		//That doesn't mean we have to include them with the rest of the jobs though, especially for map specific ones.
		//Also including them lets us override already created jobs, letting us keep the datums to a minimum mostly.
		//This is probably a lot longer explanation than it needs to be.

	var/station_name  = "BAD Station"
	var/station_short = "Baddy"
	var/dock_name     = "THE PirateBay"
	var/dock_short    = "Piratebay"
	var/boss_name     = "Captain Roger"
	var/boss_short    = "Cap'"
	var/company_name  = "BadMan"
	var/company_short = "BM"
	var/system_name   = "Uncharted System"

	var/command_spawn_enabled = FALSE
	var/command_spawn_message = "Someone didn't fill this in."

	var/list/spawn_types

	var/shuttle_docked_message
	var/shuttle_leaving_dock
	var/shuttle_called_message
	var/shuttle_recall_message
	var/emergency_shuttle_docked_message
	var/emergency_shuttle_leaving_dock
	var/emergency_shuttle_recall_message
	var/emergency_shuttle_called_message

	var/list/station_networks = list() 		// Camera networks that will show up on the console.

	var/list/holodeck_programs = list() // map of string ids to /datum/holodeck_program instances
	var/list/holodeck_supported_programs = list()
		// map of maps - first level maps from list-of-programs string id (e.g. "BarPrograms") to another map
		// this is in order to support multiple holodeck program listings for different holodecks
		// second level maps from program friendly display names ("Picnic Area") to program string ids ("picnicarea")
		// as defined in holodeck_programs
	var/list/holodeck_restricted_programs = list() // as above... but EVIL!

	var/allowed_spawns = list("Arrivals Shuttle","Gateway", "Cryogenic Storage", "Cyborg Storage")
	var/default_spawn = "Arrivals Shuttle"

	var/lobby_icon                         // The icon which contains the lobby image(s)
	var/list/lobby_screens = list("title") // The list of lobby screen to pick() from. If left unset the first icon state is always selected.
	var/assistant_job = "Assistant"

	var/regular_turf_temperature = T20C //The initial temperature of the turfs in the map

	var/list/allowed_gamemodes = list("changeling", "cult", "extended", "heist", "malfunction", "conflux", "crossfire", "feeding", "infiltration", "intrigue",  "paranoia", "siege",
									"traitorling", "uprising", "veilparty", "visitors", "ninja", "mercenary", "revolution", "autotraitor", "traitor", "vampire", "wizard")

	var/list/mudane_events	= list(
		// Severity level, event name, even type, base weight, role weights, one shot, min weight, max weight. Last two only used if set and non-zero
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Nothing",					/datum/event/nothing,				120),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "APC Damage",				/datum/event/apc_damage,			20, 	list(ASSIGNMENT_ENGINEER = 15)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Brand Intelligence",		/datum/event/brand_intelligence,	15, 	list(ASSIGNMENT_JANITOR = 20),	1),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Camera Damage",				/datum/event/camera_damage,			20, 	list(ASSIGNMENT_ENGINEER = 10)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Economic News",				/datum/event/economic_event,		300),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Lost Carp",					/datum/event/carp_migration, 		20, 	list(ASSIGNMENT_SECURITY = 10), 1),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Money Hacker",				/datum/event/money_hacker, 			10),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Money Lotto",				/datum/event/money_lotto, 			0, 		list(ASSIGNMENT_ANY = 1), 1, 5, 15),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Mundane News", 				/datum/event/mundane_news, 			300),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "PDA Spam",					/datum/event/pda_spam, 				0, 		list(ASSIGNMENT_ANY = 4), 0, 25, 50),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Wallrot",					/datum/event/wallrot, 				75,		list(ASSIGNMENT_ENGINEER = 5, ASSIGNMENT_GARDENER = 20)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Clogged Vents",				/datum/event/vent_clog, 			55),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "False Alarm",				/datum/event/false_alarm, 			100),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Supply Drop",				/datum/event/supply_drop, 			80),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "CCIA General Notice",		/datum/event/ccia_general_notice, 	300),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Mundane Vermin Infestation",/datum/event/infestation, 			60,		list(ASSIGNMENT_JANITOR = 15, ASSIGNMENT_SECURITY = 15, ASSIGNMENT_MEDICAL = 15))
	)

	var/list/moderate_events = list(
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Nothing",							/datum/event/nothing,						200),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Appendicitis", 					/datum/event/spontaneous_appendicitis, 		0,		list(ASSIGNMENT_MEDICAL = 25)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Carp School",						/datum/event/carp_migration,				50, 	list(ASSIGNMENT_SECURITY = 25)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Communication Blackout",			/datum/event/communications_blackout,		60),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Electrical Storm",					/datum/event/electrical_storm, 				50,		list(ASSIGNMENT_ENGINEER = 5, ASSIGNMENT_JANITOR = 20)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Gravity Failure",					/datum/event/gravity,	 					100),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Grid Check",						/datum/event/grid_check, 					80),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Ion Storm",						/datum/event/ionstorm, 						0,		list(ASSIGNMENT_AI = 45, ASSIGNMENT_CYBORG = 25, ASSIGNMENT_ENGINEER = 6, ASSIGNMENT_SCIENTIST = 6)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Meteor Shower",					/datum/event/meteor_shower,					40,		list(ASSIGNMENT_ENGINEER = 13)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Prison Break",						/datum/event/prison_break,					0,		list(ASSIGNMENT_SECURITY = 15, ASSIGNMENT_CYBORG = 20),1),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Containment Error - Virology",		/datum/event/prison_break/virology,			0,		list(ASSIGNMENT_MEDICAL = 15, ASSIGNMENT_CYBORG = 20),1),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Containment Error - Xenobiology",	/datum/event/prison_break/xenobiology,		0,		list(ASSIGNMENT_SCIENTIST = 15, ASSIGNMENT_CYBORG = 20),1),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Radiation Storm",					/datum/event/radiation_storm, 				100),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Random Antagonist",				/datum/event/random_antag,		 			0,		list(ASSIGNMENT_ANY = 1, ASSIGNMENT_SECURITY = 1),0,10,125, list("Extended")),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Rogue Drones",						/datum/event/rogue_drone, 					50,		list(ASSIGNMENT_SECURITY = 25)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Moderate Spider Infestation",		/datum/event/spider_infestation/moderate,	50,		list(ASSIGNMENT_SECURITY = 25)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Viral Infection",					/datum/event/viral_infection, 				0,		list(ASSIGNMENT_MEDICAL = 12), 1),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Moderate Vermin Infestation",		/datum/event/infestation/moderate, 			30,		list(ASSIGNMENT_JANITOR = 15, ASSIGNMENT_SECURITY = 15, ASSIGNMENT_MEDICAL = 15))
	)

	var/list/major_events = list(
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Nothing",						/datum/event/nothing,				135),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Blob",						/datum/event/blob, 					40,	list(ASSIGNMENT_ENGINEER = 5,ASSIGNMENT_SECURITY =  5), 1),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Carp Migration",				/datum/event/carp_migration,		50,	list(ASSIGNMENT_SECURITY =  10), 1),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Meteor Wave",					/datum/event/meteor_wave,			40,	list(ASSIGNMENT_ENGINEER =  10),1),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Space Vines",					/datum/event/spacevine, 			75,	list(ASSIGNMENT_ENGINEER = 10, ASSIGNMENT_GARDENER = 20), 1),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Viral Infection",				/datum/event/viral_infection,		20,	list(ASSIGNMENT_MEDICAL =  15), 1),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Spider Infestation",			/datum/event/spider_infestation,	25, list(ASSIGNMENT_SECURITY = 10, ASSIGNMENT_MEDICAL = 5), 1),
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Major Vermin Infestation",	/datum/event/infestation/major, 	15,	list(ASSIGNMENT_SECURITY = 15, ASSIGNMENT_MEDICAL = 10))
	)

	var/list/possible_lobby_tracks = list(
		'sound/music/space.ogg',
		'sound/music/traitor.ogg',
		'sound/music/title2.ogg',
		'sound/music/clouds.s3m',
		'sound/music/space_oddity.ogg',
		'sound/music/thats-my-horse.ogg'
	)

/datum/map/New()
	if(!map_levels)
		map_levels = station_levels.Copy()
	if(!allowed_jobs)
		allowed_jobs = subtypesof(/datum/job)
	if (!spawn_types)
		spawn_types = subtypesof(/datum/spawnpoint)

/datum/map/proc/generate_asteroid()
	return

// Override to set custom access requirements for camera networks.
/datum/map/proc/get_network_access(var/network)
	return 0

// By default transition randomly to another zlevel
/datum/map/proc/get_transit_zlevel(var/current_z_level)
	var/list/candidates = current_map.accessible_z_levels.Copy()
	candidates.Remove(num2text(current_z_level))

	if(!candidates.len)
		return current_z_level
	return text2num(pickweight(candidates))

/datum/map/proc/setup_shuttles()

// Called right after SSatlas finishes loading the map & multiz is setup.
/datum/map/proc/finalize_load()
