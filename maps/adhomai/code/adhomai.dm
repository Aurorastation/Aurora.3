/datum/map/adhomai
	name = "Adhomai"
	full_name = "Adhomai"
	path = "adhomai"

	lobby_screens = list("aurora_asteroid", "aurora_postcard")

	station_levels = list(2,3)
	admin_levels = list(1)
	contact_levels = list(2)
	player_levels = list(2,3)
	accessible_z_levels = list("8" = 2, "9" = 3)
	base_turf_by_z = list(
		"1" = /turf/space,
		"2" = /turf/simulated/floor/asteroid/basalt,
		"3" = /turf/simulated/floor/snow
	)

	station_name = "Adhomai"
	station_short = "Adhomai"
	dock_name = "New Kingdom of Adhomai"
	dock_short = "NKA"
	boss_name = "New Kingdom of Adhomai"
	boss_short = "NKA"
	company_name = "New Kingdom of Adhomai"
	company_short = "NKA"
	system_name = "S'rand'marr"

	command_spawn_enabled = FALSE

	allowed_jobs = list(/datum/job/commander, /datum/job/supply_officer, /datum/job/levy, /datum/job/grenadier, /datum/job/sharpshooter,/datum/job/combatengineer,
					/datum/job/commoner, /datum/job/mayor, /datum/job/barkeeper, /datum/job/hunter, /datum/job/priest, /datum/job/physician, /datum/job/nurse,
					/datum/job/prospector, /datum/job/blacksmith, /datum/job/chief_constable, /datum/job/constable)

	assistant_job = "Commoner"

	regular_turf_temperature = T0C-20

	allowed_gamemodes = list("changeling", "cult", "extended","conflux", "crossfire", "feeding", "siege", "traitorling", "uprising", "veilparty", "mercenary", "revolution",
							"autotraitor", "traitor", "vampire", "wizard")

	mudane_events	= list(
		// Severity level, event name, even type, base weight, role weights, one shot, min weight, max weight. Last two only used if set and non-zero
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Nothing",					/datum/event/nothing,				120),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Animal Migration",			/datum/event/animal_migration,		120)
	)

	moderate_events = list(
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Nothing",							/datum/event/nothing,						200),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Appendicitis", 					/datum/event/spontaneous_appendicitis, 		0,		list(ASSIGNMENT_MEDICAL = 25)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Random Antagonist",				/datum/event/random_antag,		 			0,		list(ASSIGNMENT_ANY = 1, ASSIGNMENT_SECURITY = 1),0,10,125, list("Extended")),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Meteor Chunks",			/datum/event/meteor_chunks,					800)
	)

	major_events = list(
		new /datum/event_meta(EVENT_LEVEL_MAJOR, "Nothing",						/datum/event/nothing,				135)
	)


/datum/map/adhomai/generate_asteroid()

	new /datum/random_map/noise/tundra/adhomai(null,0,0,3,255,255) //creates the wilderness before the caves
	new /datum/random_map/automata/cave_system/adhomai/under(null,0,0,2,255,255)
	new /datum/random_map/automata/cave_system/adhomai(null,0,0,3,255,255)

	new /datum/random_map/noise/ore(null, 0, 0, 2, 255, 255)
	new /datum/random_map/noise/ore(null, 0, 0, 2, 255, 255)
