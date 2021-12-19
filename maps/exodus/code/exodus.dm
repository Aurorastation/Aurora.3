// This file is not included because this map does not work at the moment.

/datum/map/exodus
	name = "Exodus"
	full_name = "NSS Exodus"
	path = "exodus"
	lobby_icons = list('icons/misc/titlescreens/aurora/humans.dmi', 'icons/misc/titlescreens/aurora/synthetics.dmi', 'icons/misc/titlescreens/aurora/king_of_the_world.dmi')
	lobby_transitions = 10 SECONDS

	station_name = "NSS Exodus"
	station_short = "Exodus"
	dock_name = "NTCC Odin"
	dock_short = "Odin"
	boss_name = "Central Command"
	boss_short = "CentCom"
	company_name = "NanoTrasen"
	company_short = "NT"

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

	evac_controller_type = /datum/evacuation_controller/shuttle

	station_levels = list(1)
	admin_levels = list(2)
	contact_levels = list(1, 5)
	player_levels = list(1, 3, 4, 5, 6)
	accessible_z_levels = list("1" = 5, "3" = 10, "4" = 15, "5" = 10, "6" = 60)
	meteor_levels = list(1)

	map_shuttles = list(
		/datum/shuttle/autodock/ferry/escape_pod/pod/escape_pod1,
		/datum/shuttle/autodock/ferry/escape_pod/pod/escape_pod2,
		/datum/shuttle/autodock/ferry/escape_pod/pod/escape_pod3,
		/datum/shuttle/autodock/ferry/emergency/exodus,
		/datum/shuttle/autodock/ferry/supply/exodus,
		/datum/shuttle/autodock/multi/admin,
		/datum/shuttle/autodock/ferry/autoreturn/ccia,
		/datum/shuttle/autodock/ferry/engi,
		/datum/shuttle/autodock/ferry/mining,
		/datum/shuttle/autodock/ferry/research_exodus,
		/datum/shuttle/autodock/ferry/specops/ert_exodus,
		/datum/shuttle/autodock/multi/antag/skipjack_exodus,
		/datum/shuttle/autodock/multi/antag/merc_exodus,
		/datum/shuttle/autodock/ferry/legion_exodus,
		/datum/shuttle/autodock/ferry/merchant/exodus
	)

/datum/map/exodus/generate_asteroid()
	new /datum/random_map/automata/cave_system(null, 13, 32, 5, 217, 223)
	new /datum/random_map/noise/ore(null, 13, 32, 5, 217, 223)

/datum/map/exodus/finalize_load()
	world.maxz++
