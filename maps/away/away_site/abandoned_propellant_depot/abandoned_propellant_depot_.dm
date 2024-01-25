/datum/map_template/ruin/away_site/abandoned_propellant_depot
	name = "Abandoned Industrial Station"//Not a visible thing ingame, but this should be unique for visibility purposes
	description = "Abandoned Industrial Station."//Not visible ingame
	unit_test_groups = list(1)

	id = "abandoned_propellant_depot"//Arbitrary tag to make things work. This should be lowercase and unique
	spawn_cost = 1
	spawn_weight = 1
	suffixes = list("away_site/abandoned_industrial/abandoned_propellant_depot.dmm")

	sectors = list(ALL_POSSIBLE_SECTORS)

/singleton/submap_archetype/abandoned_propellant_depot//Arbitrary duplicates of the above name/desc
	map = "abandoned industrial station"
	descriptor = "Abandoned Industrial Station."

/obj/effect/overmap/visitable/sector/abandoned_propellant_depot//This is the actual overmap object that spawns at roundstart
	name = "Abandoned Industrial Station"//This and desc is visible ingame when the object is scanned by any scanner
	desc = "Industrial station of unknown designation or origin. Scanners detect it to be mostly cold, likely no movement or life inside, although appears to be pressurized."
	icon_state = "outpost"

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
		"nav_abandoned_propellant_depot_north",
		"nav_abandoned_propellant_depot_north_close",
		"nav_abandoned_propellant_depot_east",
		"nav_abandoned_propellant_depot_south",
		"nav_abandoned_propellant_depot_south_close",
		"nav_abandoned_propellant_depot_west",
		"nav_abandoned_propellant_depot_hangar_other"
	)

