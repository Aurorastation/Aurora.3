/datum/map/colony_general
	name = "Aurora"
	full_name = "NSS Aurora"
	path = "colony_general"

	lobby_screens = list("aurora_asteroid", "aurora_postcard")

	station_levels = list(2, 3, 4, 5)
	admin_levels = list(1)
	contact_levels = list(2, 3, 4, 5)
	player_levels = list(2, 3, 4, 5)
	base_turf_by_z = list(
		"1" = /turf/space,
		"2" = /turf/space,
		"3" = /turf/space,
		"4" = /turf/simulated/floor/asteroid/ash/rocky,
		"5" = /turf/simulated/floor/asteroid/ash/rocky,
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

	command_spawn_enabled = FALSE
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

	shuttle_docked_message = "The scheduled Crew Transfer Shuttle to %dock% has docked with the station. It will depart in approximately %ETA% minutes."
	shuttle_leaving_dock = "The Crew Transfer Shuttle has left the station. Estimate %ETA% minutes until the shuttle docks at %dock%."
	shuttle_called_message = "A crew transfer to %dock% has been scheduled. The shuttle has been called. It will arrive in approximately %ETA% minutes."
	shuttle_recall_message = "The scheduled crew transfer has been cancelled."
	emergency_shuttle_docked_message = "The Emergency Shuttle has docked with the station. You have approximately %ETD% minutes to board the Emergency Shuttle."
	emergency_shuttle_leaving_dock = "The Emergency Shuttle has left the station. Estimate %ETA% minutes until the shuttle docks at %dock%."
	emergency_shuttle_recall_message = "The emergency shuttle has been recalled."
	emergency_shuttle_called_message = "An emergency evacuation shuttle has been called. It will arrive in approximately %ETA% minutes."

/datum/map/colony_general/generate_asteroid()
	///new /datum/terrain_map/mountains(//z, //xmin, xmax, ymin, ymax, seed, scale, octaves, persistence)
	new /datum/terrain_map/mountains(4, 1, 255, 1, 255, world.timeofday, 60, 10, 0.5)
	/*new /datum/terrain_map/mountains(4, 1, 5, 1, 5, world.timeofday, 15)
	new /datum/terrain_map/mountains(4, 50, 55, 25, 30, world.timeofday, 15)
	new /datum/terrain_map/mountains(4, 175, 180, 175, 180, world.timeofday, 15)
	new /datum/terrain_map/mountains(4, 250, 255, 5, 10, world.timeofday, 15)*/
	return