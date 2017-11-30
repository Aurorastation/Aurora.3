//lavaland mining colony.

/datum/map/lavaland
	name = "Arcturus"
	full_name = "Arcturus Mining Colony"
	path = "lavaland"
	station_levels = list(2, 3, 4, 5, 6, 7, 8)
	admin_levels = list(1)
	contact_levels = list(2, 3, 4, 5, 6, 7, 8)
	player_levels = list(2, 3, 4, 5, 6, 7, 8)
	sealed_levels = list(1, 2, 3, 4, 5, 6, 7, 8)
	base_turf_by_z = list(
		"1" = /turf/simulated/lava,
		"2" = /turf/simulated/lava,
		"3" = /turf/simulated/open/chasm,
		"4" = /turf/simulated/open/chasm,
		"5" = /turf/simulated/open/chasm,
		"6" = /turf/simulated/open/chasm,
		"7" = /turf/simulated/open/chasm,
		"8" = /turf/simulated/open/chasm,
	)

	station_name = "Arcturus Mining Colony"
	station_short = "Arcturus"
	dock_name = "Ploutos Station"
	dock_short = "Ploutos"
	boss_name = "Spartan Colonial Authority"
	boss_short = "Colonial Command"
	company_name = "Dagon Commerce Guild"
	company_short = "The Guild"
	system_name = "X'yr Vharn'p"

	command_spawn_enabled = TRUE
	command_spawn_message = "Welcome to Ploutos Station. Please take platform two to depart for Arcturus."

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

	shuttle_docked_message = "The scheduled outbound train to %dock% has pulled into the station. It will depart in approximately %ETA% minutes."
	shuttle_leaving_dock = "The outbound train has left the station. Estimate %ETA% minutes until the train arrives at %dock%."
	shuttle_called_message = "Outbound train to Baal is en route. It will arrive in approximately %ETA% minutes. All individuals interested in departure please purchase a ticket at the station."
	shuttle_recall_message = "The scheduled outbound train has been delayed indefinitely due to a track obstruction."
	emergency_shuttle_docked_message = "The emergency train has docked with the station. You have approximately %ETD% minutes to board the train."
	emergency_shuttle_leaving_dock = "The emergency train has left the station. Estimate %ETA% minutes until the train arrives at %dock%."
	emergency_shuttle_recall_message = "The emergency evacuation signal has been cancelled, and the train recalled to station."
	emergency_shuttle_called_message = "An emergency evacuation has been declared and an emergency train has been deployed. It will arrive in approximately %ETA% minutes."

	allowed_species = list(
    	/datum/species/human,
    	/datum/species/skrell,
    	/datum/species/unathi,
    	/datum/species/tajaran,
    	/datum/species/tajaran/zhan_khazan,
    	/datum/species/tajaran/m_sai,
    	/datum/species/diona,
	)

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
