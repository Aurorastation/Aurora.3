/datum/map_template/ruin/away_site/himeo_patrol_ship
	name = "Himean Planetary Guard Vessel"
	description = "A patrol vessel fielded by the Himean Planetary Guard"

	traits = list(
		//Z1
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = TRUE, ZTRAIT_DOWN = FALSE),
		//Z2
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = FALSE, ZTRAIT_DOWN = TRUE),
	)

	prefix = "ships/himeo/"
	suffix = "himeo_patrol_ship.dmm"

	sectors = list(ALL_COALITION_SECTORS) // Change this.
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED
	spawn_weight = 1
	ship_cost = 1
	id = "Himean Planetary Guard Vessel"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/himeo_patrol_shuttle, /datum/shuttle/autodock/multi/lift/himeo_patrol_ship)
	unit_test_groups = list(1)

/obj/effect/overmap/visitable/ship/himeo_patrol_ship
	name = "Himean Planetary Guard Vessel"
	class = "USPGV" // United Syndicates Planetary Guard Vessel
	desc = "A typical Himean design, the Collier-class is designed to patrol major trade routes and discourage pirate attacks. It is not intended for fleet engagements, as it lacks heavier armament such as missiles."
	icon_state = "xansan"
	moving_state = "xansan_moving"
	colors = list("#525151", "#800a0a")
	designer = "Free Consortium of Defense and Aerospace Manufacturers"
	weapons = "Rear-mounted low-calibre autocannon, rear-mounted blaster weapon"
	drive = "Forsberg Mk. XII Warp Drive: A Himean design from the 2440s, the Forsberg is a decently cheap — and relatively fast — drive produced by FCDAM for the Himean Planetary Guard."
	sizeclass = "Collier-class patrol corvette"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 9000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	initial_restricted_waypoints = list(
		"Himean Patrol Shuttle" = list("nav_himeo_patrol_start")
	)
	initial_generic_waypoints = list(
		"himeo_patrol_nav1",
		"himeo_patrol_nav2",
		"himeo_patrol_nav3",
		"himeo_patrol_nav4",
		"himeo_patrol_dock1",
		"himeo_patrol_dock2",
		"himeo_patrol_dock3",
		"himeo_patrol_dock4"
	)
	invisible_until_ghostrole_spawn = TRUE

/obj/effect/overmap/visitable/ship/himeo_patrol_ship/New()
	designation = "[pick("Placeholder", "Placeholder")]"
	..()

/obj/effect/shuttle_landmark/himeo_patrol
	base_turf = /turf/space/dynamic
	base_area = /area/space

//Deck 1 navpoints.
/obj/effect/shuttle_landmark/himeo_patrol/nav1
	name = "Himeo Planetary Guard Vessel - Deck One Fore"
	landmark_tag = "himeo_nav1"

/obj/effect/shuttle_landmark/himeo_patrol/nav2
	name = "Himeo Planetary Guard Vessel - Deck One Aft "
	landmark_tag = "himeo_nav2"

/obj/effect/shuttle_landmark/himeo_patrol/nav3
	name = "Himeo Planetary Guard Vessel - Deck One Port "
	landmark_tag = "himeo_nav3"

/obj/effect/shuttle_landmark/himeo_patrol/nav4
	name = "Himeo Planetary Guard Vessel - Deck One Starboard"
	landmark_tag = "himeo_nav4"

//Deck 2 navpoints.
/obj/effect/shuttle_landmark/himeo_patrol/dock1
	name = "Himeo Planetary Guard Vessel - Deck Two Starboard"
	landmark_tag = "himeo_dock1"
	base_turf = /turf/simulated/floor/reinforced/airless

/obj/effect/shuttle_landmark/himeo_patrol/dock2
	name = "Himeo Planetary Guard Vessel - Deck Two Fore"
	landmark_tag = "himeo_dock2"
	base_turf = /turf/simulated/floor/reinforced/airless

/obj/effect/shuttle_landmark/himeo_patrol/dock3
	name = "Himeo Planetary Guard Vessel - Deck Two Aft"
	landmark_tag = "himeo_dock3"
	base_turf = /turf/simulated/floor/reinforced/airless

/obj/effect/shuttle_landmark/himeo_patrol/dock4
	name = "Himeo Planetary Guard Vessel - Deck Two Port"
	landmark_tag = "himeo_dock4"
	base_turf = /turf/simulated/floor/reinforced/airless

//Shuttle
/obj/effect/overmap/visitable/ship/landable/himeo_patrol_shuttle
	name = "Himean Patrol Shuttle"
	desc = "Placeholder."
	class = "USPGV"
	designation = "Kotka"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	shuttle = "Himean Patrol Shuttle"
	colors = list("#525151", "#800a0a")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 2000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY
	designer = "Free Consortium of Defense and Auerospace Manufacturers"
	volume = "15 meters length, 20 meters beam/width, 6 meters vertical height"
	sizeclass = "Hiirihaukka-class Fighter Shuttle"
	shiptype = "Troop transport and anti-ship combat operations"

/obj/machinery/computer/shuttle_control/explore/terminal/himeo_patrol_shuttle
	name = "shuttle control terminal"
	shuttle_tag = "Himean Patrol Shuttle"

/datum/shuttle/autodock/overmap/himeo_patrol_shuttle
	name = "Himean Patrol Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/himeo_patrol, /area/shuttle/himeo_patrol/central)
	dock_target = "airlock_himeo_patrol_shuttle"
	current_location = "nav_himeo_patrol_start"
	landmark_transition = "nav_himeo_patrol_transit"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_himeo_patrol_start"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/himeo_patrol_shuttle/shuttle_start
	name = "Himean Patrol Shuttle - Shuttle Dock"
	landmark_tag = "nav_himeo_patrol_start"
	docking_controller = "himeo_patrol_shuttle_dock"

/obj/effect/shuttle_landmark/himeo_patrol_shuttle/shuttle_transit
	name = "In transit"
	landmark_tag = "nav_himeo_patrol_transit"
	base_turf = /turf/space/transit/north


// Lift
/datum/shuttle/autodock/multi/lift/himeo_patrol_ship
	name = "Himean Patrol Ship Lift"
	current_location = "nav_himeo_patrol_ship_lift_first_deck"
	shuttle_area = /area/turbolift/himeo_patrol/himeo_patrol_lift
	destination_tags = list(
		"nav_himeo_patrol_ship_lift_first_deck",
		"nav_himeo_patrol_ship_lift_second_deck",
		)

/obj/effect/shuttle_landmark/lift/nav_himeo_patrol_ship_lift_first_deck
	name = "Himean Patrol Ship Lift - First Deck"
	landmark_tag = "nav_himeo_patrol_ship_lift_first_deck"
	base_area = /area/himeo_patrol_ship
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/lift/nav_himeo_patrol_ship_lift_second_deck
	name = "Himean Patrol Ship Lift - Second Deck"
	landmark_tag = "nav_himeo_patrol_ship_lift_second_deck"
	base_area = /area/himeo_patrol_ship/deck_2_interstitial
	base_turf = /turf/simulated/open

/obj/machinery/computer/shuttle_control/multi/lift/himeo_patrol_ship
	shuttle_tag = "Himean Patrol Ship Lift"
