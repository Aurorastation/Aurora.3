/datum/map_template/ruin/away_site/cult_base
	name = "Cult Base"
	description = "Cult Base."
	id = "cult_base"
	suffixes = list("away_site/cult_base/cult_base.dmm")
	spawn_cost = 1
	spawn_weight = 1
	sectors = list(ALL_POSSIBLE_SECTORS)
	unit_test_groups = list(1)
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED // TODO: REMOVE THIS

/singleton/submap_archetype/cult_base
	map = "Cult Base"
	descriptor = "Cult Base."

/obj/effect/overmap/visitable/sector/cult_base
	name = "Cult Base"
	desc = "\
		Scans reveal a small station built into a asteroid, registered in the official and public databases as an independent research outpost. \
		It appears to be pressurized, powered, and with a functioning transponder. There is a hangar for a small shuttle. \
		Database query reveals that it was active and has seen traffic up until a few days ago, but no communications in or out since then. \
		Caution is advised.\
		"
	static_vessel = TRUE
	generic_object = FALSE
	icon = 'icons/obj/overmap/overmap_ships.dmi'
	icon_state = "asteroid_cluster"
	color = "#aa673b"

	designer = "Unknown"
	volume = "90 meters length, 90 meters beam/width, 42 meters vertical height"
	weapons = "Not apparent"
	sizeclass = "Asteroid Base"

	initial_generic_waypoints = list(
		// docks
		"nav_cult_base_dock_north_east",
		"nav_cult_base_dock_north_west",
		"nav_cult_base_dock_west",
		"nav_cult_base_dock_east_north",
		"nav_cult_base_dock_east_south",
		"nav_cult_base_dock_south_east",
		"nav_cult_base_dock_south_mid",
		"nav_cult_base_dock_south_west",
		// catwalks
		"nav_cult_base_catwalk_north",
		"nav_cult_base_catwalk_west",
		"nav_cult_base_catwalk_south_1",
		"nav_cult_base_catwalk_south_2",
		"nav_cult_base_catwalk_south_3",
		"nav_cult_base_catwalk_south_4",
		// space
		"nav_cult_base_space_south_west",
		"nav_cult_base_space_south_east",
		"nav_cult_base_space_north_west",
		"nav_cult_base_space_north_east",
	)

