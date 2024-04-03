/datum/map_template/ruin/away_site/abandoned_diner
	name = "Abandoned Diner"//Not a visible thing ingame, but this should be unique for visibility purposes
	description = "Abandoned Diner."//Not visible ingame
	unit_test_groups = list(1)

	id = "abandoned_diner"//Arbitrary tag to make things work. This should be lowercase and unique
	spawn_cost = 1
	spawn_weight = 1
	suffixes = list("away_site/abandoned_diner/abandoned_diner.dmm")

	sectors = list(ALL_CORPORATE_SECTORS)
	sectors_blacklist = list(SECTOR_TAU_CETI, SECTOR_HANEUNIM)

/singleton/submap_archetype/abandoned_diner//Arbitrary duplicates of the above name/desc
	map = "abandoned diner"
	descriptor = "Abandoned Diner."

/obj/effect/overmap/visitable/sector/abandoned_diner//This is the actual overmap object that spawns at roundstart
	name = "Abandoned Space Diner"//This and desc is visible ingame when the object is scanned by any scanner
	desc = "A former space diner once operated by Starjack, a chain of rest stops and diners on space stations throughout the Spur, partially owned by NanoTrasen. The company went bankrupt in 2447, forcing its over 60 stations to be vacated in a hurry. \
	This one has no signs of life; however, scans do indicate power and a pressurized atmosphere."
	icon_state = "outpost"

	static_vessel = TRUE
	generic_object = FALSE
	icon = 'icons/obj/overmap/overmap_stationary.dmi'
	icon_state = "outpost2"
	color = "#bbb186"
	designer = "Starjack Inc."
	volume = "58 meters length, 66 meters beam/width, 20 meters vertical height"
	weapons = "None"
	sizeclass = "Civilian Restaurant Station"

	initial_generic_waypoints = list(
		"diner_a1",
		"diner_a2",
		"diner_b1",
		"diner_b2",
		"diner_spacewest_1",
		"diner_spacewest_2",
		"diner_spaceeast_1",
		"diner_spaceeast_2",
		"diner_spacenorth",
		"diner_spacesouth",
	)
