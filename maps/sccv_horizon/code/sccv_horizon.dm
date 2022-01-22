/datum/map/sccv_horizon
	name = "SCCV Horizon"
	full_name = "SCCV Horizon"
	path = "sccv_horizon"
	lobby_icons = list('icons/misc/titlescreens/sccv_horizon/sccv_horizon.dmi')
	lobby_transitions = 25 SECONDS

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

	station_name = "SCCV Horizon"
	station_short = "Horizon"
	dock_name = "The Shipyard"
	dock_short = "Shipyard"
	boss_name = "Stellar Corporate Conglomerate"
	boss_short = "SCC"
	company_name = "Stellar Corporate Conglomerate"
	company_short = "SCC"

	command_spawn_enabled = TRUE
	command_spawn_message = "Welcome to the SCCV Horizon!"

	use_overmap = TRUE
	num_exoplanets = 2
	overmap_event_areas = 15
	planet_size = list(255,255)

	station_networks = list(
		NETWORK_COMMAND,
		NETWORK_ENGINE,
		NETWORK_ENGINEERING,
		NETWORK_MEDICAL,
		NETWORK_MINE,
		NETWORK_RESEARCH,
		NETWORK_ROBOTS,
		NETWORK_PRISON,
		NETWORK_SECURITY,
		NETWORK_SERVICE,
		NETWORK_SUPPLY,
		NETWORK_FIRST_DECK,
		NETWORK_SECOND_DECK,
		NETWORK_THIRD_DECK,
		NETWORK_INTREPID
	)

	shuttle_docked_message = "Attention all hands: Jump preparation complete. The bluespace drive is now spooling up, secure all stations for departure. Time to jump: approximately %ETD%."
	shuttle_leaving_dock = "Attention all hands: Jump initiated, exiting bluespace in %ETA%."
	shuttle_called_message = "Attention all hands: Jump sequence initiated. Transit procedures are now in effect. Jump in %ETA%."
	shuttle_recall_message = "Attention all hands: Jump sequence aborted, return to normal operating conditions."
	emergency_shuttle_docked_message = "The emergency evacuation has started. You have approximately %ETD% minutes to board the emergency pods."
	emergency_shuttle_leaving_dock = "The emergency evacuatioon has been completed."
	emergency_shuttle_recall_message = "The emergency evacuation has been canceled."
	emergency_shuttle_called_message = "An emergency evacuation has been called. It will start in approximately %ETA%."

	map_shuttles = list(
		/datum/shuttle/autodock/ferry/lift/scc_ship/cargo,
		/datum/shuttle/autodock/ferry/lift/scc_ship/morgue,
		/datum/shuttle/autodock/ferry/lift/scc_ship/robotics,
		/datum/shuttle/autodock/ferry/escape_pod/pod/escape_pod1,
		/datum/shuttle/autodock/ferry/escape_pod/pod/escape_pod2,
		/datum/shuttle/autodock/ferry/escape_pod/pod/escape_pod3,
		/datum/shuttle/autodock/ferry/escape_pod/pod/escape_pod4,
		/datum/shuttle/autodock/ferry/supply/aurora,
		/datum/shuttle/autodock/ferry/specops/ert_aurora,
		/datum/shuttle/autodock/multi/antag/skipjack_ship,
		/datum/shuttle/autodock/multi/antag/burglar_ship,
		/datum/shuttle/autodock/multi/antag/merc_ship,
		/datum/shuttle/autodock/multi/legion,
		/datum/shuttle/autodock/multi/distress,
		/datum/shuttle/autodock/overmap/intrepid,
		/datum/shuttle/autodock/overmap/mining,
		/datum/shuttle/autodock/ferry/merchant_aurora,
		/datum/shuttle/autodock/ferry/autoreturn/ccia
	)

	evac_controller_type = /datum/evacuation_controller/starship

	spawn_types = list(/datum/spawnpoint/living_quarters_lift, /datum/spawnpoint/cryo)

/datum/map/sccv_horizon/finalize_load()
	// generate an empty space Z
	world.maxz++
