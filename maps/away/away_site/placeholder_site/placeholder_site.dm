//A placeholder away site that shouldn't spawn. To be used as an example for future contributions
//The comments added to this should help newer contributors to understand the purpose of the code here
/datum/map_template/ruin/away_site/placeholder_site
	name = "Placeholder Away Site"//Not a visible thing ingame, but this should be unique for visibility purposes
	description = "A placeholder away site for new contributors to use."//Not visible ingame

	id = "placeholder_site"//Arbitrary tag to make things work. This should be lowercase and unique to the map you're making
	spawn_cost = 1//Typically set to 1. Adjusting this changes the parameters and chance of this site spawning
	spawn_weight = 1//Default set to 1. Adjusting this changes the parameters and chance of this site spawning
	suffixes = list("away_site/placeholder_site/placeholder_site.dmm")//Self explanatory. Should link to the map with root folder included!

//Uncomment this (remove the double slashes at the start) to assign the sectors it can spawn within to in a list
//	sectors = list(SECTOR_WEEPING_STARS, SECTOR_TAU_CETI)//You can find the sectors available for this in code\__defines\space_sectors.dm

//Uncomment this to forcibly spawn your away site to test it! Remove this completely once you're done testing!
//	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

//Uncomment this to place the site adjacent to the Horizon and its original spawn location. Remove this completely once you're done testing!
//	place_near_main = list(1, 1)

/singleton/submap_archetype/placeholder_site//Arbitrary duplicates of the above name/desc
	map = "placeholder away site"
	descriptor = "A placeholder away site for new contributors to use."

/obj/effect/overmap/visitable/sector/placeholder_site//This is the actual overmap object that spawns at roundstart, given your map loads
	name = "free-floating navigation beacon"//This and desc is visible ingame when the object is scanned by any scanner
	desc = "A placeholder away site for new contributors to use. This description is quite visible on scans."
	in_space = 0//Setting this to TRUE, or 1, will make people who are floating freely in EVA potentially run into this away site. Usually not a good idea to turn on
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
		"nav_placeholder_site_1",
		"nav_placeholder_site_2",
		"nav_placeholder_site_3"
	)

//Restricted waypoints let important shuttles like the Intrepid land specifically in designated zones. The first tag here (labeled Intrepid) will follow the shuttle tag itself and prevent other shuttles from landing besides it
	initial_restricted_waypoints = list(
		"Intrepid" = list("nav_placeholder_site_intrepid")
	)

/obj/effect/shuttle_landmark/placeholder_site/nav1
	name = "South Landing Beacon"//Visible ingame when landing a shuttle
	landmark_tag = "nav_placeholder_site_1"//Must match initial waypoints

/obj/effect/shuttle_landmark/placeholder_site/nav2
	name = "North Landing Beacon"
	landmark_tag = "nav_placeholder_site_2"

/obj/effect/shuttle_landmark/placeholder_site/nav3
	name = "Open Hangar Beacon"
	landmark_tag = "nav_placeholder_site_3"

/obj/effect/shuttle_landmark/placeholder_site/nav_intrepid//For the restricted Intrepid navpoint
	name = "Special Hangar Beacon"
	landmark_tag = "nav_placeholder_site_intrepid"
