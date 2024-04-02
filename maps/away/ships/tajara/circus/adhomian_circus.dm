/datum/map_template/ruin/away_site/adhomian_circus
	name = "Adhomian Traveling Circus"
	description = "The N'hanzafu class is a bulky Adhomian freighter designed with a large crew and cargo in mind. This one is painted in bright colors."
	suffixes = list("ships/tajara/circus/adhomian_circus.dmm")
	sectors = list(ALL_TAU_CETI_SECTORS, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, SECTOR_SRANDMARR, SECTOR_NRRAHRAHUL, SECTOR_GAKAL)
	spawn_weight = 1
	ship_cost = 1
	id = "adhomian_circus_ship"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/adhomian_circus_shuttle)

	unit_test_groups = list(3)

/singleton/submap_archetype/adhomian_circus
	map = "Adhomian Traveling Circus"
	descriptor = "The N'hanzafu class is a bulky Adhomian freighter designed with a large crew and cargo in mind. This one is painted in bright colors."

//ship stuff

/obj/effect/overmap/visitable/ship/adhomian_circus
	name = "Adhomian Traveling Circus"
	class = "ACV"
	desc = "The N'hanzafu class is a bulky Adhomian freighter designed with a large crew and cargo in mind. This one is painted in bright colors."
	icon_state = "generic"
	moving_state = "generic_moving"

	scanimage = "tramp_freighter.png"
	designer = "Independent/no designation"
	volume = "60 meters length, 27 meters beam/width, 20 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "Not apparent"
	sizeclass = "Hanzafu Freighter"
	shiptype = "Long-term shipping utilities"

	colors = list(COLOR_CYAN, COLOR_WARM_YELLOW, COLOR_PALE_BTL_GREEN, COLOR_HOT_PINK)
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	initial_generic_waypoints = list(
		"nav_adhomian_circus_1",
		"nav_adhomian_circus_2",
		"nav_adhomian_circus_3",
		"nav_adhomian_circus_4"
	)
	initial_restricted_waypoints = list(
		"Adhomian Circus Shuttle" = list("nav_hangar_adhomian_circus_shuttle")
	)

	invisible_until_ghostrole_spawn = TRUE

/obj/effect/overmap/visitable/ship/adhomian_circus/New()
	designation = "[pick("Kalmykova", "Flying Rafama", "Harazhimir Brothers")]"
	..()

/obj/effect/shuttle_landmark/adhomian_circus/transit
	name = "In transit"
	landmark_tag = "nav_transit_adhomian_circus"
	base_turf = /turf/space/transit/north

/obj/effect/shuttle_landmark/adhomian_circus/nav1
	name = "Adhomian Traveling Circus Fore Navpoint #1"
	landmark_tag = "nav_adhomian_circus_1"

/obj/effect/shuttle_landmark/adhomian_circus/nav2
	name = "Adhomian Traveling Circus Starboard Navpoint #2"
	landmark_tag = "nav_adhomian_circus_ship_2"

/obj/effect/shuttle_landmark/adhomian_circus/nav3
	name = "Adhomian Traveling Circus Port Navpoint #3"
	landmark_tag = "nav_adhomian_circus_3"

/obj/effect/shuttle_landmark/adhomian_circus/nav4
	name = "Adhomian Traveling Circus Aft Navpoint"
	landmark_tag = "nav_adhomian_circus_4"

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/adhomian_circus_shuttle
	name = "Adhomian Circus Shuttle"
	desc = "An inefficient and rustic looking shuttle. This one's transponder identifies it as belonging to an independent freighter."
	shuttle = "Adhomian Circus Shuttle"
	class = "ACV"
	designation = "Rafama"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	icon_state = "pod"
	moving_state = "pod_moving"
	colors = list(COLOR_CYAN, COLOR_WARM_YELLOW, COLOR_PALE_BTL_GREEN, COLOR_HOT_PINK)
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/adhomian_circus_shuttle
	name = "shuttle control console"
	shuttle_tag = "Adhomian Circus Shuttle"

/datum/shuttle/autodock/overmap/adhomian_circus_shuttle
	name = "Adhomian Circus Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/adhomian_circus_shuttle)
	dock_target = "adhomian_circus_shuttle"
	current_location = "nav_hangar_adhomian_circus_shuttle"
	landmark_transition = "nav_transit_adhomian_circus_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_adhomian_circus_shuttle"
	defer_initialisation = TRUE

/obj/effect/map_effect/marker/airlock/shuttle/adhomian_circus_shuttle
	name = "Adhomian Circus Shuttle"
	shuttle_tag = "Adhomian Circus Shuttle"
	master_tag = "adhomian_circus_shuttle"
