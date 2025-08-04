/datum/map_template/ruin/away_site/abandoned_propellant_depot
	name = "Abandoned Propellant Depot"
	description = "Abandoned Propellant Depot."
	id = "abandoned_propellant_depot"

	prefix = "away_site/abandoned_propellant_depot/"
	suffix = "abandoned_propellant_depot.dmm"

	spawn_cost = 1
	spawn_weight = 1
	sectors = list(ALL_POSSIBLE_SECTORS)
	sectors_blacklist = list(ALL_UNCHARTED_SECTORS)
	unit_test_groups = list(1)

/singleton/submap_archetype/abandoned_propellant_depot//Arbitrary duplicates of the above name/desc
	map = "Abandoned Propellant Depot"
	descriptor = "Abandoned Propellant Depot."

/obj/effect/overmap/visitable/sector/abandoned_propellant_depot
	name = "Abandoned Propellant Depot"
	desc = "Industrial propellant depot of unknown designation or origin. Scanners detect it to be mostly cold, likely no movement or life inside, although appears to be pressurized."
	static_vessel = TRUE
	generic_object = FALSE
	icon = 'icons/obj/overmap/overmap_stationary.dmi'
	icon_state = "outpost2"
	color = "#bbb186"
	designer = "Unknown"
	volume = "92 meters length, 99 meters beam/width, 27 meters vertical height"
	weapons = "Not apparent"
	sizeclass = "Industrial Station"

	initial_generic_waypoints = list(
		// docks
		"nav_abandoned_propellant_depot_dock_north_east",
		"nav_abandoned_propellant_depot_dock_north_west",
		"nav_abandoned_propellant_depot_dock_west",
		"nav_abandoned_propellant_depot_dock_east_north",
		"nav_abandoned_propellant_depot_dock_east_south",
		"nav_abandoned_propellant_depot_dock_south_east",
		"nav_abandoned_propellant_depot_dock_south_mid",
		"nav_abandoned_propellant_depot_dock_south_west",
		// catwalks
		"nav_abandoned_propellant_depot_catwalk_north",
		"nav_abandoned_propellant_depot_catwalk_west",
		"nav_abandoned_propellant_depot_catwalk_south_1",
		"nav_abandoned_propellant_depot_catwalk_south_2",
		"nav_abandoned_propellant_depot_catwalk_south_3",
		"nav_abandoned_propellant_depot_catwalk_south_4",
		// space
		"nav_abandoned_propellant_depot_space_south_west",
		"nav_abandoned_propellant_depot_space_south_east",
		"nav_abandoned_propellant_depot_space_north_west",
		"nav_abandoned_propellant_depot_space_north_east",
	)

