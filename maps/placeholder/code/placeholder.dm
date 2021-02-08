/datum/map/placeholder
	name = "Placeholder"
	full_name = "NSS Placeholder"
	path = "placeholder"
	lobby_icons = list('icons/misc/titlescreens/placeholder/placeholder.dmi')
	lobby_transitions = FALSE

	station_levels = list(1, 2, 3)
	admin_levels = list(4)
	contact_levels = list(1, 2, 3)
	player_levels = list(1, 2, 3, 5, 6)
	restricted_levels = list()
	accessible_z_levels = list(1, 2, 3)
	base_turf_by_z = list(
		"1" = /turf/space,
		"2" = /turf/space,
		"3" = /turf/space,
		"4" = /turf/space,
		"5" = /turf/space,
		"6" = /turf/space
	)

	station_name = "NSS Placeholder"
	station_short = "Placeholder"
	dock_name = "The Shipyard"
	dock_short = "Shipyard"
	boss_name = "Placeholder"
	boss_short = "Placeholder Shortened"
	company_name = "Placeholder Inc"
	company_short = "PI"
	system_name = "Virtual Reality"

	command_spawn_enabled = TRUE
	command_spawn_message = "Welcome to the Shipyard!"

//These too are placeholders
	station_networks = list(
		NETWORK_DECK_ONE_AFT,
		NETWORK_DECK_ONE_FORE,
		NETWORK_DECK_TWO_AFT,
		NETWORK_DECK_TWO_FORE,
		NETWORK_DECK_THREE_AFT,
		NETWORK_DECK_THREE_FORE
	)

	shuttle_docked_message = "The scheduled crew transfer shuttle to %dock% has docked with the station. It will depart in approximately %ETA% minutes."
	shuttle_leaving_dock = "The crew transfer shuttle has left the station. Estimate %ETA% minutes until the shuttle docks at %dock%."
	shuttle_called_message = "A crew transfer to %dock% has been scheduled. The shuttle has been called. It will arrive in approximately %ETA% minutes."
	shuttle_recall_message = "The scheduled crew transfer has been cancelled."
	emergency_shuttle_docked_message = "The emergency shuttle has docked with the station. You have approximately %ETD% minutes to board the emergency shuttle."
	emergency_shuttle_leaving_dock = "The emergency shuttle has left the station. Estimate %ETA% minutes until the shuttle docks at %dock%."
	emergency_shuttle_recall_message = "The emergency shuttle has been recalled."
	emergency_shuttle_called_message = "An emergency evacuation shuttle has been called. It will arrive in approximately %ETA% minutes."

//datum/map/aurora/generate_asteroid()
//	// Create the chasms.
//	new /datum/random_map/automata/cave_system/chasms(null,0,0,3,255,255)
//	new /datum/random_map/automata/cave_system(null,0,0,3,255,255)
//	new /datum/random_map/automata/cave_system/chasms(null,0,0,4,255,255)
//	new /datum/random_map/automata/cave_system(null,0,0,4,255,255)
//	new /datum/random_map/automata/cave_system/chasms(null,0,0,5,255,255)
//	new /datum/random_map/automata/cave_system/high_yield(null,0,0,5,255,255)
//	new /datum/random_map/automata/cave_system/chasms/surface(null,0,0,6,255,255)

//	// Create the deep mining ore distribution map.
//	new /datum/random_map/noise/ore(null, 0, 0, 5, 64, 64)
//	new /datum/random_map/noise/ore(null, 0, 0, 4, 64, 64)
//	new /datum/random_map/noise/ore(null, 0, 0, 3, 64, 64)

/datum/map/placeholder/finalize_load()
	// generate an empty space Z
	world.maxz++
