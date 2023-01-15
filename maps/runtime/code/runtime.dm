/datum/map/runtime
	name = "Runtime Ship"
	full_name = "Runtime Debugging Ship"
	path = "runtime"

	force_spawnpoint = TRUE

	lobby_icons = list('icons/misc/titlescreens/runtime/developers.dmi', 'icons/misc/titlescreens/runtime/away.dmi')
	lobby_transitions = 10 SECONDS

	station_levels = list(1, 2, 3)
	admin_levels = list(9)
	contact_levels = list(1, 2, 3)
	player_levels = list(1, 2, 3)
	accessible_z_levels = list(1, 2, 3)
	meteor_levels = list(1, 2, 3)

	overmap_event_areas = 10

	station_name = "NSV Runtime"
	station_short = "Runtime"
	dock_name = "singulo"
	boss_name = "#code_dungeon"
	boss_short = "Coders"
	company_name = "BanoTarsen"
	company_short = "BT"
	station_type  = "dumpster"

	use_overmap = TRUE
	overmap_size = 35

	shuttle_docked_message = "Attention all hands: Jump preparation complete. The bluespace drive is now spooling up, secure all stations for departure. Time to jump: approximately %ETA%."
	shuttle_leaving_dock = "Attention all hands: Jump initiated, exiting bluespace in %ETA%."
	shuttle_called_message = "Attention all hands: Jump sequence initiated. Transit procedures are now in effect. Jump in %ETA%."
	shuttle_recall_message = "Attention all hands: Jump sequence aborted, return to normal operating conditions."

	evac_controller_type = /datum/evacuation_controller/starship

	station_networks = list(
		NETWORK_CIVILIAN_MAIN,
		NETWORK_COMMAND,
		NETWORK_ENGINEERING,
	)

	num_exoplanets = 3
	planet_size = list(65, 65)

	away_site_budget = 2
	away_ship_budget = 2

	map_shuttles = list(/datum/shuttle/autodock/overmap/runtime)
