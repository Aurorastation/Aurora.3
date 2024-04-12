/datum/map_template/ruin/away_site/abandoned_industrial_station
	name = "Abandoned Industrial Station"//Not a visible thing ingame, but this should be unique for visibility purposes
	description = "Abandoned Industrial Station."//Not visible ingame
	unit_test_groups = list(1)

	id = "abandoned_industrial_station"//Arbitrary tag to make things work. This should be lowercase and unique
	spawn_cost = 1
	spawn_weight = 1
	suffixes = list("away_site/abandoned_industrial/abandoned_industrial_station.dmm")

	sectors = list(ALL_POSSIBLE_SECTORS)
	sectors_blacklist = list(SECTOR_TAU_CETI, SECTOR_HANEUNIM)

/singleton/submap_archetype/abandoned_industrial_station//Arbitrary duplicates of the above name/desc
	map = "abandoned industrial station"
	descriptor = "Abandoned Industrial Station."

/obj/effect/overmap/visitable/sector/abandoned_industrial_station//This is the actual overmap object that spawns at roundstart
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
		"nav_abandoned_industrial_station_north",
		"nav_abandoned_industrial_station_north_close",
		"nav_abandoned_industrial_station_east",
		"nav_abandoned_industrial_station_south",
		"nav_abandoned_industrial_station_south_close",
		"nav_abandoned_industrial_station_west",
		"nav_abandoned_industrial_station_hangar_other"
	)

	initial_restricted_waypoints = list(
		"Intrepid" = list("nav_abandoned_industrial_station_intrepid"),
		"Canary" = list("nav_abandoned_industrial_station_hangar_canary"),
		"Spark" = list("nav_abandoned_industrial_station_spark")
	)

/obj/effect/shuttle_landmark/abandoned_industrial_station/nav_intrepid
	name = "Docks A1 (Intrepid)"
	landmark_tag = "nav_abandoned_industrial_station_intrepid"

/obj/effect/shuttle_landmark/abandoned_industrial_station/nav_spark
	name = "Docks A1 (Spark)"
	landmark_tag = "nav_abandoned_industrial_station_spark"

/obj/effect/shuttle_landmark/abandoned_industrial_station/nav_hangar_canary
	name = "Hangar (Canary)"
	landmark_tag = "nav_abandoned_industrial_station_hangar_canary"
	base_area = /area/abandoned_industrial_station/hangar
	base_turf = /turf/simulated/floor

/obj/effect/shuttle_landmark/abandoned_industrial_station/nav_hangar_other
	name = "Hangar"
	landmark_tag = "nav_abandoned_industrial_station_hangar_other"
	base_area = /area/abandoned_industrial_station/hangar
	base_turf = /turf/simulated/floor

/obj/effect/shuttle_landmark/abandoned_industrial_station/nav_north
	name = "North Beacon"
	landmark_tag = "nav_abandoned_industrial_station_north"

/obj/effect/shuttle_landmark/abandoned_industrial_station/nav_north_close
	name = "North Beacon (Close)"
	landmark_tag = "nav_abandoned_industrial_station_north_close"

/obj/effect/shuttle_landmark/abandoned_industrial_station/nav_east
	name = "East Beacon"
	landmark_tag = "nav_abandoned_industrial_station_east"

/obj/effect/shuttle_landmark/abandoned_industrial_station/nav_south
	name = "South Beacon"
	landmark_tag = "nav_abandoned_industrial_station_south"

/obj/effect/shuttle_landmark/abandoned_industrial_station/nav_south_close
	name = "South Beacon (Close)"
	landmark_tag = "nav_abandoned_industrial_station_south_close"

/obj/effect/shuttle_landmark/abandoned_industrial_station/nav_west
	name = "West Beacon"
	landmark_tag = "nav_abandoned_industrial_station_west"

