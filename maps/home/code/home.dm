/datum/map/home
	name = "Home Station"
	full_name = "Home Debugging Station"
	path = "home"
	lobby_icons = list('icons/misc/titlescreens/runtime/developers.dmi')
	lobby_transitions = 10 SECONDS

	station_levels = list(1, 2, 3)
	admin_levels = list()
	contact_levels = list(1, 2, 3)
	player_levels = list(1, 2, 3)
	accessible_z_levels = list(1, 2, 3)

	station_name = "NSS Home"
	station_short = "Home"
	dock_name = "singulo"
	boss_name = "#code_dungeon"
	boss_short = "Coders"
	company_name = "BanoTarsen"
	company_short = "BT"

	station_networks = list(
		NETWORK_CIVILIAN_MAIN,
		NETWORK_COMMAND,
		NETWORK_ENGINEERING,
	)

