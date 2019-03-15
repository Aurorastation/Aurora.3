// This file is not included because this map does not work at the moment.

/datum/map/exodus
	name = "Exodus"
	full_name = "NSS Exodus"
	path = "exodus"

	lobby_screens = list("exodus_art")

	station_name = "NSS Exodus"
	station_short = "Exodus"
	dock_name = "NTCC Odin"
	dock_short = "Odin"
	boss_name = "Central Command"
	boss_short = "CentCom"
	company_name = "NanoTrasen"
	company_short = "NT"
	system_name = "Tau Ceti"

	station_networks = list(
		NETWORK_CIVILIAN_EAST,
		NETWORK_CIVILIAN_WEST,
		NETWORK_COMMAND,
		NETWORK_ENGINE,
		NETWORK_ENGINEERING,
		NETWORK_ENGINEERING_OUTPOST,
		NETWORK_STATION,
		NETWORK_MEDICAL,
		NETWORK_MINE,
		NETWORK_RESEARCH,
		NETWORK_RESEARCH_OUTPOST,
		NETWORK_ROBOTS,
		NETWORK_PRISON,
		NETWORK_SECURITY
	)

	shuttle_docked_message = "The scheduled Crew Transfer Shuttle to %dock% has docked with the station. It will depart in approximately %ETA% minutes."
	shuttle_leaving_dock = "The Crew Transfer Shuttle has left the station. Estimate %ETA% minutes until the shuttle docks at %dock%."
	shuttle_called_message = "A crew transfer to %dock% has been scheduled. The shuttle has been called. It will arrive in approximately %ETA% minutes."
	shuttle_recall_message = "The scheduled crew transfer has been cancelled."
	emergency_shuttle_docked_message = "The Emergency Shuttle has docked with the station. You have approximately %ETD% minutes to board the Emergency Shuttle."
	emergency_shuttle_leaving_dock = "The Emergency Shuttle has left the station. Estimate %ETA% minutes until the shuttle docks at %dock%."
	emergency_shuttle_recall_message = "The emergency shuttle has been recalled."
	emergency_shuttle_called_message = "An emergency evacuation shuttle has been called. It will arrive in approximately %ETA% minutes."

	station_levels = list(1)
	admin_levels = list(2)
	contact_levels = list(1, 5)
	player_levels = list(1, 3, 4, 5, 6)
	accessible_z_levels = list("1" = 5, "3" = 10, "4" = 15, "5" = 10, "6" = 60)

	allowed_jobs = list(/datum/job/captain, /datum/job/hop, /datum/job/assistant, /datum/job/bartender, /datum/job/chef, /datum/job/hydro, /datum/job/qm, /datum/job/cargo_tech,
						/datum/job/mining, /datum/job/janitor, /datum/job/journalist, /datum/job/librarian, /datum/job/lawyer, /datum/job/chaplain, /datum/job/chief_engineer,
						/datum/job/engineer, /datum/job/atmos, /datum/job/intern_eng, /datum/job/cmo, /datum/job/doctor, /datum/job/chemist, /datum/job/psychiatrist, /datum/job/paramedic,
						/datum/job/intern_med, /datum/job/rd, /datum/job/scientist, /datum/job/xenobiologist, /datum/job/roboticist, /datum/job/intern_sci, /datum/job/hos,
						/datum/job/warden, /datum/job/detective, /datum/job/forensics, /datum/job/officer, /datum/job/intern_sec, /datum/job/ai, /datum/job/cyborg)

/datum/map/exodus/generate_asteroid()
	new /datum/random_map/automata/cave_system(null, 13, 32, 5, 217, 223)
	new /datum/random_map/noise/ore(null, 13, 32, 5, 217, 223)

/datum/map/exodus/finalize_load()
	world.maxz++
