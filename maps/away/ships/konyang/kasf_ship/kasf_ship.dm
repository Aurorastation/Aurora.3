/datum/map_template/ruin/away_site/kasf_corvette
	name = "KASF Corvette"
	description = "An older design of patrol corvette that saw its fair share of service in its golden days among the Xanu fleets, the Sai-class corvette would be considered obsolete by modern standards were it not retrofitted with newer weaponry, sensors, and other ship systems. In recent decades this class of ship has largely been mothballed by Xanu, but a large number were reactivated and donated when Konyang declared independence from Sol and joined the Coalition of Colonies. Now it serves an important role in the KASF, commonly seen combatting pirates and controlling the flow of refugees from the Wildlands."
	suffixes = list("ships/konyang/kasf_ship/kasf_ship.dmm")
	sectors = list(SECTOR_HANEUNIM)
	spawn_weight = 1
	ship_cost = 1
	id = "kasf_corvette"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/kasf_shuttle)

	unit_test_groups = list(3)

/singleton/submap_archetype/kasf_corvette
	map = "KASF Corvette"
	descriptor = "An older design of patrol corvette that saw its fair share of service in its golden days among the Xanu fleets, the Sai-class corvette would be considered obsolete by modern standards were it not retrofitted with newer weaponry, sensors, and other ship systems. In recent decades this class of ship has largely been mothballed by Xanu, but a large number were reactivated and donated when Konyang declared independence from Sol and joined the Coalition of Colonies. Now it serves an important role in the KASF, commonly seen combatting pirates and controlling the flow of refugees from the Wildlands."

/obj/effect/overmap/visitable/ship/kasf_corvette
	name = "KASF Corvette"
	class = "KASFV"
	desc = "An older design of patrol corvette that saw its fair share of service in its golden days among the Xanu fleets, the Sai-class corvette would be considered obsolete by modern standards were it not retrofitted with newer weaponry, sensors, and other ship systems. In recent decades this class of ship has largely been mothballed by Xanu, but a large number were reactivated and donated when Konyang declared independence from Sol and joined the Coalition of Colonies. Now it serves an important role in the KASF, commonly seen combatting pirates and controlling the flow of refugees from the Wildlands."
	icon_state = "xansan"
	moving_state = "xansan_moving"
	colors = list("#8492fd", "#4d61fc")
	scanimage = "ranger.png"
	designer = "Coalition of Colonies, Xanu Prime"
	volume = "54 meters length, 36 meters beam/width, 17 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "Dual extruding fore-mounted medium caliber ballistic armament, aft obscured flight craft bay"
	sizeclass = "Sai-class Corvette"
	shiptype = "Military patrol and combat utility"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	initial_restricted_waypoints = list(
		"KASF Shuttle" = list("nav_hangar_kasf")
	)

	initial_generic_waypoints = list(
		"nav_kasf_corvette_1",
		"nav_kasf_corvette_2",
		"nav_kasf_corvette_3",
		"nav_kasf_corvette_4",
		"nav_kasf_corvette_5",
		"nav_kasf_corvette_6",
		"nav_kasf_dock_starboard",
		"nav_kasf_dock_port"
	)

	invisible_until_ghostrole_spawn = TRUE

/obj/effect/overmap/visitable/ship/kasf_corvette/New()
	designation = "[pick("Jiyu", "Fuchin", "Luren", "Pyeongon", "Kikai", "Fenjin", "Arashi", "Saikuron", "Senpo", "Suwon", "Kuenoi", "Kyung-Sun", "Nageune", "Singijeon", "Hyeopdo", "Dangpa")]"
	..()

/obj/effect/overmap/visitable/ship/kasf_corvette/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/subcapital_ships.dmi', "ranger")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	return skybox_image

/obj/effect/shuttle_landmark/kasf_corvette/nav1
	name = "Port Navpoint"
	landmark_tag = "nav_kasf_corvette_1"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/kasf_corvette/nav2
	name = "Fore Navpoint"
	landmark_tag = "nav_kasf_corvette_2"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/kasf_corvette/nav3
	name = "Starboard Navpoint"
	landmark_tag = "nav_kasf_corvette_3"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/kasf_corvette/nav4
	name = "Aft Navpoint"
	landmark_tag = "nav_kasf_corvette_4"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/kasf_corvette/nav5
	name = "Far Port Navpoint"
	landmark_tag = "nav_kasf_corvette_5"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/kasf_corvette/nav6
	name = "Far Starboard Navpoint"
	landmark_tag = "nav_kasf_corvette_6"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/kasf_corvette/transit
	name = "In transit"
	landmark_tag = "nav_transit_kasf_corvette"
	base_turf = /turf/space/transit/north

/obj/effect/shuttle_landmark/kasf_corvette/starboard_dock
	name = "KASF Starboard Dock"
	landmark_tag = "nav_kasf_dock_starboard"
	docking_controller = "airlock_kasf_dock_starboard"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/kasf_corvette/port_dock
	name = "KASF Port Dock"
	landmark_tag = "nav_kasf_dock_port"
	docking_controller = "airlock_kasf_dock_port"
	base_turf = /turf/space
	base_area = /area/space


//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/kasf_shuttle
	name = "KASF Shuttle"
	class = "KASFV"
	designation = "Kuoyu"
	desc = "Somewhat bulky by modern standards, the aging Stalwart-class transport is a vessel being phased out of service in Xanu fleets to make way for newer, more efficient transports. Though considered obsolete compared to its successor shuttles, this transport is still reliable enough that it's seen extensive use by Konyang's Aerospace Forces in recent years."
	shuttle = "KASF Shuttle"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	colors = list("#8492fd", "#4d61fc")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY
	designer = "Coalition of Colonies, Xanu Prime"
	volume = "12 meters length, 7 meters beam/width, 4 meters vertical height"
	sizeclass = "Stalwart-class Transport Craft"
	shiptype = "All-environment troop transport"

/obj/machinery/computer/shuttle_control/explore/terminal/kasf_shuttle
	name = "shuttle control console"
	shuttle_tag = "KASF Shuttle"

/datum/shuttle/autodock/overmap/kasf_shuttle
	name = "KASF Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/kasf_shuttle)
	current_location = "nav_hangar_kasf"
	dock_target = "airlock_kasf_shuttle"
	landmark_transition = "nav_transit_kasf_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_kasf"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/kasf_shuttle/hangar
	name = "KASF Shuttle Hangar"
	landmark_tag = "nav_hangar_kasf"
	docking_controller = "kasf_shuttle_dock"
	base_area = /area/ship/kasf_corvette/hangar
	base_turf = /turf/simulated/floor
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/kasf_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_kasf_shuttle"
	base_turf = /turf/space/transit/north
