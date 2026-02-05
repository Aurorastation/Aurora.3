/datum/map_template/ruin/away_site/ruined_propellant_depot
	name = "Ruined Propellant Depot"
	description = "Ruined Propellant Depot."
	id = "ruined_propellant_depot"

	prefix = "scenarios/ruined_propellant_depot/"
	suffix = "ruined_propellant_depot.dmm"

	spawn_cost = 1
	spawn_weight = 0 // so it does not spawn as ordinary away site
	sectors = list(ALL_POSSIBLE_SECTORS)
	template_flags = TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	unit_test_groups = list(1)

/singleton/submap_archetype/ruined_propellant_depot
	map = "Ruined Propellant Depot"
	descriptor = "Ruined Propellant Depot."

/obj/effect/overmap/visitable/sector/ruined_propellant_depot
	name = "Propellant Depot AG5"
	desc = "\
		Industrial propellant depot designated as independent. Scanners detect it to be pressurized, with some signs of life inside. \
		Records indicate it to be a refuel point, advertised as able to serve propellant to anyone, but with discounts for corporate vessels. \
		"
	static_vessel = TRUE
	generic_object = FALSE
	comms_support = TRUE
	icon = 'icons/obj/overmap/overmap_stationary.dmi'
	icon_state = "outpost"
	color = "#bbb186"
	designer = "Unknown"
	volume = "92 meters length, 99 meters beam/width, 27 meters vertical height"
	weapons = "Not apparent"
	sizeclass = "Industrial Station"

	initial_generic_waypoints = list(
		// docks
		"nav_ruined_propellant_depot_dock_north_east",
		"nav_ruined_propellant_depot_dock_north_west",
		"nav_ruined_propellant_depot_dock_west",
		"nav_ruined_propellant_depot_dock_east_north",
		"nav_ruined_propellant_depot_dock_east_south",
		"nav_ruined_propellant_depot_dock_south_east",
		"nav_ruined_propellant_depot_dock_south_mid",
		"nav_ruined_propellant_depot_dock_south_west",
		// catwalks
		"nav_ruined_propellant_depot_catwalk_north",
		"nav_ruined_propellant_depot_catwalk_west",
		"nav_ruined_propellant_depot_catwalk_south_1",
		"nav_ruined_propellant_depot_catwalk_south_2",
		"nav_ruined_propellant_depot_catwalk_south_3",
		"nav_ruined_propellant_depot_catwalk_south_4",
		// space
		"nav_ruined_propellant_depot_space_south_west",
		"nav_ruined_propellant_depot_space_south_east",
		"nav_ruined_propellant_depot_space_north_west",
		"nav_ruined_propellant_depot_space_north_east",
	)

