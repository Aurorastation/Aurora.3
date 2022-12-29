/datum/map_template/ruin/away_site/nka_merchant
	name = "Her Majesty's Mercantile Flotilla Ship"
	id = "nka_merchant"
	description = "A merchant ship of the New Kingdom's Mercantile Flotilla."
	suffix = "ships/nka/nka_merchant/nka_merchant.dmm"
	ship_cost = 1
	spawn_weight = 1
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/nka_merchant_shuttle)
	sectors = list(SECTOR_BADLANDS, SECTOR_SRANDMARR, SECTOR_VALLEY_HALE, SECTOR_CORP_ZONE, SECTOR_TAU_CETI)

/decl/submap_archetype/nka_merchant
	map = "Her Majesty's Mercantile Flotilla Ship"
	descriptor = "The Hma'trra class is a modified version of the corporate freighter sold by the SCC to the New Kingdom. It is simple model adapted to the long journey between Adhomai and Tau Ceti."

/obj/effect/overmap/visitable/ship/nka_merchant
	name = "Her Majesty's Mercantile Flotilla Ship"
	desc = "The Hma'trra class is a modified version of the corporate freighter sold by the SCC to the New Kingdom. It is simple model adapted to the long journey between Adhomai and Tau Ceti."
	class = "NKAMV" //New Kingdom of Adhomai Vessel
	icon_state = "ship"
	moving_state = "ship_moving"
	vessel_mass = 10000
	max_speed = 1/(2 SECONDS)
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_SMALL
	initial_generic_waypoints = list(
		"nka_merchant_ship_1",
		"nka_merchant_ship_2",
		"nka_merchant_ship_3",
		"nka_merchant_ship_4"
	)
	initial_restricted_waypoints = list(
		"Orbital Fleet Shuttle" = list("nav_nka_merchant_shuttle")
	)

/obj/effect/overmap/visitable/ship/nka_merchant/New()
	designation = "[pick("Minharrzka's Daughter", "Her Majesty's Merchant", "Vahzirthaamro", "Azunja's Favorite", "Wealth-Beyond-Measure", "Miran'mir", "Crown Traveller", "Space Monarch")]"
	..()

/obj/effect/shuttle_landmark/nka_merchant
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/nka_merchant/nav1
	name = "Her Majesty's Mercantile Flotilla Ship Navpoint #1"
	landmark_tag = "nav_nka_merchant_ship_1"

/obj/effect/shuttle_landmark/nka_merchant/nav2
	name = "Her Majesty's Mercantile Flotilla Ship Navpoint #2"
	landmark_tag = "nav_nka_merchant_ship_2"

/obj/effect/shuttle_landmark/nka_merchant/nav3
	name = "Her Majesty's Mercantile Flotilla Ship Navpoint #3"
	landmark_tag = "nav_nka_merchant_ship_3"

/obj/effect/shuttle_landmark/nka_merchant/nav4
	name = "Her Majesty's Mercantile Flotilla Ship Navpoint #4"
	landmark_tag = "nav_nka_merchant_ship_4"

//shuttle
/obj/effect/overmap/visitable/ship/landable/nka_merchant_shuttle
	name = "Her Majesty's Mercantile Flotilla Shuttle"
	desc = "A simple corporate shuttle design used by Her Majesty's Mercantile Flotilla."
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	class = "NKAMV"
	designation = "Tajani"
	shuttle = "Her Majesty's Mercantile Flotilla Shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/nka_merchant_shuttle
	name = "shuttle control console"
	shuttle_tag = "Her Majesty's Mercantile Flotilla Shuttle"

/datum/shuttle/autodock/overmap/nka_merchant_shuttle
	name = "Her Majesty's Mercantile Flotilla Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/nka_merchant_shuttle)
	current_location = "nav_nka_merchant_shuttle"
	landmark_transition = "nav_transit_nka_merchant_shuttle"
	dock_target = "nka_merchant_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_nka_merchant_shuttle"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/nka_merchant_shuttle/hangar
	name = "Her Majesty's Mercantile Flotilla Shuttle Hangar"
	landmark_tag = "nav_nka_merchant_shuttle"
	docking_controller = "nka_merchant_shuttle_dock"
	base_area = /area/nka_merchant/hangar
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/nka_merchant_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_nka_merchant_shuttle"
	base_turf = /turf/space/transit/north