/datum/map/aurora
	name = "Aurora"
	full_name = "NSS Aurora"
	path = "aurora"

	lobby_screens = list("aurora_asteroid", "aurora_postcard")

	station_levels = list(3, 4, 5, 6, 7)
	admin_levels = list(1)
	contact_levels = list(3, 4, 5, 6)
	player_levels = list(2, 3, 4, 5, 6, 7, 8)
	accessible_z_levels = list("8" = 5, "9" = 10, "7" = 15, "2" = 60)
	base_turf_by_z = list(
		"1" = /turf/space,
		"2" = /turf/space,
		"3" = /turf/space,
		"4" = /turf/simulated/floor/asteroid/ash/rocky,
		"5" = /turf/simulated/floor/asteroid/ash/rocky,
		"6" = /turf/simulated/floor/asteroid/ash,
		"7" = /turf/space,
		"8" = /turf/space,
		"9" = /turf/space
	)

	station_name = "NSS Aurora"
	station_short = "Aurora"
	dock_name = "NTCC Odin"
	dock_short = "Odin"
	boss_name = "Central Command"
	boss_short = "CentCom"
	company_name = "NanoTrasen"
	company_short = "NT"
	system_name = "Tau Ceti"

	command_spawn_enabled = TRUE
	command_spawn_message = "Welcome to the Odin! Simply proceed down and to the right to board the shuttle to your workplace!"

	station_networks = list(
		NETWORK_CIVILIAN_MAIN,
		NETWORK_CIVILIAN_SURFACE,
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
		NETWORK_SECURITY,
		NETWORK_SERVICE,
		NETWORK_SUPPLY
	)

	shuttle_docked_message = "The scheduled crew transfer shuttle to %dock% has docked with the station. It will depart in approximately %ETA% minutes."
	shuttle_leaving_dock = "The crew transfer shuttle has left the station. Estimate %ETA% minutes until the shuttle docks at %dock%."
	shuttle_called_message = "A crew transfer to %dock% has been scheduled. The shuttle has been called. It will arrive in approximately %ETA% minutes."
	shuttle_recall_message = "The scheduled crew transfer has been cancelled."
	emergency_shuttle_docked_message = "The emergency shuttle has docked with the station. You have approximately %ETD% minutes to board the emergency shuttle."
	emergency_shuttle_leaving_dock = "The emergency shuttle has left the station. Estimate %ETA% minutes until the shuttle docks at %dock%."
	emergency_shuttle_recall_message = "The emergency shuttle has been recalled."
	emergency_shuttle_called_message = "An emergency evacuation shuttle has been called. It will arrive in approximately %ETA% minutes."

	allowed_jobs = list(/datum/job/captain, /datum/job/hop, /datum/job/assistant, /datum/job/bartender, /datum/job/chef, /datum/job/hydro, /datum/job/qm, /datum/job/cargo_tech,
						/datum/job/mining, /datum/job/janitor, /datum/job/journalist, /datum/job/librarian, /datum/job/lawyer, /datum/job/chaplain, /datum/job/chief_engineer,
						/datum/job/engineer, /datum/job/atmos, /datum/job/intern_eng, /datum/job/cmo, /datum/job/doctor, /datum/job/chemist, /datum/job/psychiatrist, /datum/job/paramedic,
						/datum/job/intern_med, /datum/job/rd, /datum/job/scientist, /datum/job/xenobiologist, /datum/job/roboticist, /datum/job/intern_sci, /datum/job/hos,
						/datum/job/warden, /datum/job/detective, /datum/job/forensics, /datum/job/officer, /datum/job/intern_sec, /datum/job/ai, /datum/job/cyborg, /datum/job/merchant)

/datum/map/aurora/generate_asteroid()
	// Create the chasms.
	new /datum/random_map/automata/cave_system/chasms(null,0,0,3,255,255)
	new /datum/random_map/automata/cave_system(null,0,0,3,255,255)
	new /datum/random_map/automata/cave_system/chasms(null,0,0,4,255,255)
	new /datum/random_map/automata/cave_system(null,0,0,4,255,255)
	new /datum/random_map/automata/cave_system/chasms(null,0,0,5,255,255)
	new /datum/random_map/automata/cave_system/high_yield(null,0,0,5,255,255)
	new /datum/random_map/automata/cave_system/chasms/surface(null,0,0,6,255,255)

	// Create the deep mining ore distribution map.
	new /datum/random_map/noise/ore(null, 0, 0, 5, 64, 64)
	new /datum/random_map/noise/ore(null, 0, 0, 4, 64, 64)
	new /datum/random_map/noise/ore(null, 0, 0, 3, 64, 64)

/datum/map/aurora/finalize_load()
	// generate an empty space Z
	world.maxz++
