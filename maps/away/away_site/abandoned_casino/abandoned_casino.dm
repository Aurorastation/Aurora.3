/datum/map_template/ruin/away_site/casino
	name = "Casino"
	description = "A casino ship!"

	prefix = "away_site/abandoned_casino/"
	suffix = "abandoned_casino.dmm"

	sectors = list(ALL_TAU_CETI_SECTORS, ALL_BADLAND_SECTORS, ALL_COALITION_SECTORS)
	spawn_weight = 1
	spawn_cost = 1
	id = "awaysite_casino"

	unit_test_groups = list(2)

/singleton/submap_archetype/casino
	map = "Casino"
	descriptor = "A casino ship!"

//Ship
/obj/effect/overmap/visitable/sector/casino
	name = "Casino Station"
	desc = "\
	A mid-scale transit hub of an uncertain design, a luxury casino according to the IFF signature. \
	Sensors detect that it is undamaged and without any apparent signs of activity within."
	icon = 'icons/obj/overmap/overmap_ships.dmi'
	icon_state = "voidbreaker"

	color = "#918b73"
	designer = "Unknown"
	volume = "79 meters length, 65 meters beam/width, 16 meters vertical height"
	weapons = "Not apparent"
	sizeclass = "Commercial Station"

	static_vessel = TRUE
	generic_object = FALSE

	initial_generic_waypoints = list(
		"nav_abandoned_casino_dock_starboard_1a",
		"nav_abandoned_casino_dock_starboard_1b",
		"nav_abandoned_casino_dock_starboard_1c",
		"nav_abandoned_casino_dock_port_2a",
		"nav_abandoned_casino_dock_port_2b",
		"nav_casino_1",
		"nav_casino_2",
		"nav_casino_3",
		"nav_casino_4",
	)
