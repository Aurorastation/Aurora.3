//A placeholder away site that shouldn't spawn. To be used as an example for future contributions
//The comments added to this should help newer contributors to understand the purpose of the code here
/datum/map_template/ruin/away_site/abandoned_industrial_station
	name = "Abandoned Industrial Station"//Not a visible thing ingame, but this should be unique for visibility purposes
	description = "Abandoned Industrial Station."//Not visible ingame

	id = "abandoned_industrial_station"//Arbitrary tag to make things work. This should be lowercase and unique to the map you're making
	spawn_cost = 1//Typically set to 1. Adjusting this changes the parameters and chance of this site spawning
	spawn_weight = 1//Default set to 1. Adjusting this changes the parameters and chance of this site spawning
	suffixes = list("away_site/abandoned_industrial/abandoned_industrial_station.dmm")//Self explanatory. Should link to the map with root folder included!

//Uncomment this (remove the double slashes at the start) to assign the sectors it can spawn within to in a list
	sectors = list(ALL_POSSIBLE_SECTORS)//You can find the sectors available for this in code\__defines\space_sectors.dm

//Uncomment this to forcibly spawn your away site to test it! Remove this completely once you're done testing!
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

/singleton/submap_archetype/abandoned_industrial_station//Arbitrary duplicates of the above name/desc
	map = "abandoned industrial station"
	descriptor = "Abandoned Industrial Station."

/obj/effect/overmap/visitable/sector/abandoned_industrial_station//This is the actual overmap object that spawns at roundstart, given your map loads
	name = "Abandoned Industrial Station."//This and desc is visible ingame when the object is scanned by any scanner
	desc = "Abandoned Industrial Station."
	in_space = TRUE//Setting this to TRUE, or 1, will make people who are floating freely in EVA potentially run into this away site. Usually not a good idea to turn on
	icon_state = "object"//Can be anything that fits. Don't use generic objects for scannable ships and stations, instead use overmap_stationary.dmi for reference

//If you're feeling like detailing the site more as a detailed or developed station or facility for example, uncomment the below vars and mess with them as you see fit!
//These will affect how scans of your site appear on sensor readouts, printed and on computers

//	static_vessel = TRUE
//	generic_object = FALSE
//	icon = 'icons/obj/overmap/overmap_stationary.dmi'
//	icon_state = "outpost"
//	color = "#c2c0b8"
//	designer = "A sad developer"
//	volume = "51 meters length, 35 meters beam/width, 12 meters vertical height"
//	weapons = "Two obscured flight craft bays"
//	sizeclass = "Contributor support and gamer fuel depot"

//Waypoints to be used for landing areas. Any compatible overmap shuttle that fits in the landing zones can land here if they're in range.
	initial_generic_waypoints = list(
		"nav_abandoned_industrial_station_north",
		"nav_abandoned_industrial_station_east",
		"nav_abandoned_industrial_station_south",
		"nav_abandoned_industrial_station_west"
	)

//Restricted waypoints let important shuttles like the Intrepid land specifically in designated zones. The first tag here (labeled Intrepid) will follow the shuttle tag itself and prevent other shuttles from landing besides it
	initial_restricted_waypoints = list(
		"Intrepid" = list("nav_abandoned_industrial_station_intrepid"),
		"Canary" = list("nav_abandoned_industrial_station_canary"),
		"Spark" = list("nav_abandoned_industrial_station_spark")
	)

/obj/effect/shuttle_landmark/abandoned_industrial_station/nav_intrepid
	name = "Intrepid Beacon"
	landmark_tag = "nav_abandoned_industrial_station_intrepid"

/obj/effect/shuttle_landmark/abandoned_industrial_station/nav_canary
	name = "Canary Beacon"
	landmark_tag = "nav_abandoned_industrial_station_canary"

/obj/effect/shuttle_landmark/abandoned_industrial_station/nav_spark
	name = "Spark Beacon"
	landmark_tag = "nav_abandoned_industrial_station_spark"

/obj/effect/shuttle_landmark/abandoned_industrial_station/nav_north
	name = "North Beacon"//Visible ingame when landing a shuttle
	landmark_tag = "nav_abandoned_industrial_station_north"//Must match initial waypoints

/obj/effect/shuttle_landmark/abandoned_industrial_station/nav_east
	name = "East Beacon"
	landmark_tag = "nav_abandoned_industrial_station_east"

/obj/effect/shuttle_landmark/abandoned_industrial_station/nav_south
	name = "South Beacon"
	landmark_tag = "nav_abandoned_industrial_station_south"

/obj/effect/shuttle_landmark/abandoned_industrial_station/nav_west
	name = "West Beacon"
	landmark_tag = "nav_abandoned_industrial_station_west"

