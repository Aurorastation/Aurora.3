/datum/map_template/ruin/away_site/voidtamer_trader
	name = "Voidtamer Trade Ship"
	id = "voidtamer_trade_ship"
	description = "A trade ship of the Voidtamer Conflux."

	prefix = "ships/voidtamer/trader/"
	suffix = "voidtamer_trader.dmm"

	ship_cost = 1
	spawn_weight = 1
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/voidtamer_trade_ship_shuttle)
	sectors = list(ALL_TAU_CETI_SECTORS, SECTOR_VALLEY_HALE, SECTOR_BADLANDS, SECTOR_TABITI, SECTOR_AEMAQ, SECTOR_SRANDMARR, SECTOR_NRRAHRAHUL, SECTOR_GAKAL, SECTOR_UUEOAESA, ALL_COALITION_SECTORS)
	unit_test_groups = list(1)
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

/singleton/submap_archetype/voidtamer_trade_ship
	map = "Voidtamer Trade Ship"
	descriptor = "A trade ship of the Voidtamer Conflux. While far from being built for combat, the vessel is outfited for self-defense against space fauna and potentialy hostile ships. The vessel is loaded for trade, looking for various ports and ships to trade at."

/obj/effect/overmap/visitable/ship/voidtamer_trade_ship
	name = "Voidtamer Trade Ship"
	desc = "A trade ship of the Voidtamer Conflux. While far from being built for combat, the vessel is outfited for self-defense against space fauna and potentialy hostile ships. The vessel is loaded for trade, looking for various ports and ships to trade at."
	class = "VCV" //Pending
	icon_state = "asteroid_cluster"
	moving_state = "asteroid_cluster_moving"
	colors = list("#9900FF")
	scanimage = "hno_data.png"
	designer = "Obfuscated, hull origin uncertain"
	volume = "37 meters length, 24 meters beam/width, 11 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "Dual bow-mounted extruding low-caliber rotary ballistic armament, port obscured flight craft bay"
	sizeclass = "Hailstorm-type Retrofitted Skipjack"
	shiptype = "Short-distance military tasking, low-level naval interdiction"
	vessel_mass = 10000
	max_speed = 1/(2 SECONDS)
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	initial_generic_waypoints = list(
		"nav_voidtamer_trade_ship_1",
		"nav_voidtamer_trade_ship_2",
		"nav_voidtamer_trade_ship_3",
		"nav_voidtamer_trade_ship_4"
	)
	initial_restricted_waypoints = list(
		"Voidtamer Shuttle" = list("nav_voidtamer_trade_ship_shuttle")
	)
	//invisible_until_ghostrole_spawn = TRUE

/obj/effect/overmap/visitable/ship/voidtamer_trade_ship/New()
	designation = "[pick("Test", "Embrace of the Void")]"
	..()

/obj/effect/overmap/visitable/ship/voidtamer_trade_ship/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/subcapital_ships.dmi', "diona")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	return skybox_image

/obj/effect/shuttle_landmark/voidtamer_trade_ship
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/nav_voidtamer_trade_ship/nav1
	name = "Voidtamer Trade Navpoint #1"
	landmark_tag = "nav_voidtamer_trade_ship_1"

/obj/effect/shuttle_landmark/nav_voidtamer_trade_ship/nav2
	name = "Voidtamer Trade Ship Navpoint #2"
	landmark_tag = "nav_voidtamer_trade_ship_2"

/obj/effect/shuttle_landmark/nav_voidtamer_trade_ship/nav3
	name = "Voidtamer Trade Navpoint #3"
	landmark_tag = "nav_voidtamer_trade_ship_3"

/obj/effect/shuttle_landmark/nav_voidtamer_trade_ship/nav4
	name = "Voidtamer Trade Navpoint #4"
	landmark_tag = "nav_voidtamer_trade_ship_4"

//shuttle
/obj/effect/overmap/visitable/ship/landable/voidtamer_trade_ship_shuttle
	name = "Voidtamer Shuttle"
	desc = "A small transport shuttle outfited for use by the Voidtamers."
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	colors = list("#B9BDC4")
	class = "Void Shuttle"
	designation = "Starflight"
	shuttle = "Voidtamer Shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY

/obj/effect/overmap/visitable/ship/landable/voidtamer_trade_ship_shuttle/New()
	designation = "Starflight"
	..()

/obj/machinery/computer/shuttle_control/explore/terminal/voidtamer_trade_ship_shuttle
	name = "shuttle control console"
	shuttle_tag = "Voidtamer Shuttle"

/datum/shuttle/autodock/overmap/voidtamer_trade_ship_shuttle
	name = "Voidtamer Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/voidtamer_trade_ship_shuttle)
	current_location = "nav_voidtamer_shuttle_dock"
	landmark_transition = "nav_transit_voidtamer_trade_ship_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_voidtamer_shuttle_dock"
	defer_initialisation = TRUE
	dock_target = "nav_voidtamer_shuttle_dock"

/obj/effect/map_effect/marker/airlock/shuttle/voidtamer_trade_ship_shuttle
	name = "Voidtamer Shuttle"
	shuttle_tag = "Voidtamer Shuttle"
	master_tag = "voidtamer_trade_ship_shuttle"
