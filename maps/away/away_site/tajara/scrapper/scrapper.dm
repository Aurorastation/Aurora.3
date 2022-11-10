/datum/map_template/ruin/away_site/tajara_scrapper
	name = "adhomian scrapper outpost"
	description = "An outpost used by Tajaran scrapper. It offers repair and scrapping services."
	suffix = "away_site/tajara/scrapper/scrapper.dmm"
	sectors = list(SECTOR_BADLANDS, SECTOR_SRANDMARR, SECTOR_NRRAHRAHUL, SECTOR_GAKAL)
	spawn_weight = 1
	spawn_cost = 2
	id = "tajara_scrapper"
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/tajara_scrapper)

/decl/submap_archetype/tajara_scrapper
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
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
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

/obj/effect/shuttle_landmark/tajara_scrapper/hangar
	name = "Scrapper Ship Hangar"
	landmark_tag = "nav_hangar_tajara_scrapper"
	docking_controller = "tajaran_scrapper_shuttle_dock"
	base_area = /area/space
	base_turf = /turf/space
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/tajara_scrapper/transit
	name = "In transit"
	landmark_tag = "nav_transit_tajara_safehouse"
	base_turf = /turf/space/transit/north