/datum/map_template/ruin/away_site/abandoned_industrial_station
	name = "Abandoned Industrial Station"//Not a visible thing ingame, but this should be unique for visibility purposes
	description = "Abandoned Industrial Station."//Not visible ingame
	unit_test_groups = list(1)

	id = "abandoned_industrial_station"//Arbitrary tag to make things work. This should be lowercase and unique
	spawn_cost = 1
	spawn_weight = 1
	prefix = "away_site/abandoned_industrial/"
	suffix = "abandoned_industrial_station.dmm"

	sectors = list(ALL_POSSIBLE_SECTORS)
	sectors_blacklist = list(ALL_UNCHARTED_SECTORS)

/singleton/submap_archetype/abandoned_industrial_station//Arbitrary duplicates of the above name/desc
	map = "abandoned industrial station"
	descriptor = "Abandoned Industrial Station."

/obj/effect/overmap/visitable/sector/abandoned_industrial_station//This is the actual overmap object that spawns at roundstart
	name = "Abandoned Industrial Station"//This and desc is visible ingame when the object is scanned by any scanner
	desc = "Industrial station of unknown designation or origin. Scanners detect it to be mostly cold, likely no movement or life inside, although appears to be pressurized."

	static_vessel = TRUE
	generic_object = FALSE
	icon = 'icons/obj/overmap/overmap_stationary.dmi'
	icon_state = "outpost"
	color = "#bbb186"
	designer = "Unknown"
	volume = "78 meters length, 133 meters beam/width, 24 meters vertical height"
	weapons = "Not apparent"
	sizeclass = "Industrial Station"

	initial_generic_waypoints = list(
		"nav_abandoned_industrial_station_dock_0",
		"nav_abandoned_industrial_station_dock_1",
		"nav_abandoned_industrial_station_dock_2",
		"nav_abandoned_industrial_station_dock_3",
		"nav_abandoned_industrial_station_dock_4",
		"nav_abandoned_industrial_station_dock_5",
		"nav_abandoned_industrial_station_dock_6",
		"nav_abandoned_industrial_station_north",
		"nav_abandoned_industrial_station_north_close",
		"nav_abandoned_industrial_station_east",
		"nav_abandoned_industrial_station_south",
		"nav_abandoned_industrial_station_south_close",
		"nav_abandoned_industrial_station_west",
		"nav_abandoned_industrial_station_hangar_other",
	)
