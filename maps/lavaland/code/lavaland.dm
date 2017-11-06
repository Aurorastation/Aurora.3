/datum/map/lavaland
	name = "Tartarus"
	full_name = "Tartarus Labs"
	path = "lavaland"
	station_levels = list(2, 3, 4, 5, 6, 7, 8)
	admin_levels = list(1)
	contact_levels = list(2, 3, 4, 5, 6, 7, 8)
	player_levels = list(2, 3, 4, 5, 6, 7, 8)
	sealed_levels = list(1, 2, 3, 4, 5, 6, 7, 8)
	base_turf_by_z = list(
		"1" = /turf/simulated/open/airless/chasm,
		"2" = /turf/simulated/open/airless/chasm,
		"3" = /turf/simulated/open/airless/chasm,
		"4" = /turf/simulated/open/airless/chasm,
		"5" = /turf/simulated/open/airless/chasm,
		"6" = /turf/simulated/open/airless/chasm,
		"7" = /turf/simulated/open/airless/chasm,
		"8" = /turf/simulated/open/airless/chasm,
	)

	station_name = "Tartarus Robotics Laboratories
	station_short = "Tartarus Labs"
	dock_name = "HIHQ"
	dock_short = "Elysium"
	boss_name = "Elysium Command"
	boss_short = "Elysium"
	company_name = "Hephaestus Industries"
	company_short = "HI"
	system_name = "Dominia"

	command_spawn_enabled = TRUE
	command_spawn_message = "Welcom to HIHQ Elysium. Proceed towards the magtrain to your work destination."

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

	shuttle_docked_message = "The scheduled transfer train to %dock% has pulled into the station. It will depart in approximately %ETA% minutes."
	shuttle_leaving_dock = "The transfer train has left the station. Estimate %ETA% minutes until the train arrives at %dock%."
	shuttle_called_message = "A crew transfer to %dock% has been scheduled. The train has been called. It will arrive in approximately %ETA% minutes."
	shuttle_recall_message = "The scheduled crew transfer has been cancelled."
	emergency_shuttle_docked_message = "The Emergency Shuttle has docked with the station. You have approximately %ETD% minutes to board the Emergency Shuttle."
	emergency_shuttle_leaving_dock = "The Emergency Shuttle has left the station. Estimate %ETA% minutes until the shuttle docks at %dock%."
	emergency_shuttle_recall_message = "The emergency shuttle has been recalled."
	emergency_shuttle_called_message = "An emergency evacuation shuttle has been called. It will arrive in approximately %ETA% minutes."

/*/datum/map/aurora/generate_asteroid()
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
	new /datum/random_map/noise/ore(null, 0, 0, 3, 64, 64)*/
