/datum/map_template/ruin/away_site/tajara_scrapper
	name = "adhomian scrapper outpost"
	description = "An outpost used by Tajaran scrappers. It offers repair and scrapping services."
	suffixes = list("away_site/tajara/scrapper/scrapper.dmm")
	sectors = list(SECTOR_BADLANDS, SECTOR_SRANDMARR, SECTOR_NRRAHRAHUL, SECTOR_GAKAL)
	spawn_weight = 1
	ship_cost = 1
	id = "tajara_scrapper"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/tajara_scrapper)

	unit_test_groups = list(2)

/singleton/submap_archetype/tajara_scrapper
	map = "adhomian scrapper outpost"
	descriptor = "An outpost used by Tajaran scrapper. It offers repair and scrapping services."

/obj/effect/overmap/visitable/sector/tajara_scrapper
	name = "adhomian scrapper outpost"
	desc = "An outpost used by Tajaran scrapper. It offers repair and scrapping services."
	initial_generic_waypoints = list(
		"nav_tajara_scrapper_1",
		"nav_tajara_scrapper_2",
		"nav_tajara_scrapper_3"
	)
	initial_restricted_waypoints = list(
		"Scrapper Ship" = list("nav_hangar_tajara_scrapper")
	)
	comms_support = TRUE
	comms_name = "adhomian scrapper"

	icon = 'icons/obj/overmap/overmap_stationary.dmi'
	icon_state = "outpost"
	color = "#DAA06D"

/obj/effect/shuttle_landmark/tajara_scrapper
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/tajara_scrapper/nav1
	name = "Scrapper Outpost Navpoint #1"
	landmark_tag = "nav_tajara_scrapper_1"

/obj/effect/shuttle_landmark/tajara_scrapper/nav2
	name = "Scrapper Outpost Navpoint #2"
	landmark_tag = "nav_tajara_scrapper_2"

/obj/effect/shuttle_landmark/tajara_scrapper/nav3
	name = "Scrapper Outpost Navpoint #3"
	landmark_tag = "nav_tajara_scrapper_3"


//ship stuff
/obj/effect/overmap/visitable/ship/landable/tajara_scrapper
	name = "Scrapper Ship"
	class = "ACV"
	desc = "A horseshoe-shaped ship used by Adhomian Scrappers. Frequently used in repairs and scrapping operations."
	shuttle = "Scrapper Ship"
	icon_state = "skipjack"
	moving_state = "skipjack_moving"
	colors = list("#DAA06D")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/effect/overmap/visitable/ship/landable/tajara_scrapper/New()
	designation = "[pick("Space Scavenger", "Cheap Repair", "Adhomian Handyman", "Iron Rafama", "Wreck Wrecker", "Messa's Mechanic", "Grease Farwa", "Cold Gears", "Scrap's Bane")]"
	..()

/obj/machinery/computer/shuttle_control/explore/tajara_scrapper
	name = "shuttle control console"
	shuttle_tag = "Scrapper Ship"

/datum/shuttle/autodock/overmap/tajara_scrapper
	name = "Scrapper Ship"
	move_time = 20
	shuttle_area = list(/area/shuttle/scrapper_ship/bridge, /area/shuttle/scrapper_ship/port_engines, /area/shuttle/scrapper_ship/starboard_engines,
						/area/shuttle/scrapper_ship/atmos, /area/shuttle/scrapper_ship/power_station, /area/shuttle/scrapper_ship/workshop, /area/shuttle/scrapper_ship/storage)
	dock_target = "tajara_scrapper"
	current_location = "nav_hangar_tajara_scrapper"
	landmark_transition = "nav_transit_tajara_scrapper"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_tajara_scrapper"
	defer_initialisation = TRUE




