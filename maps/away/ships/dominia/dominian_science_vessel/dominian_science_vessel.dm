/datum/map_template/ruin/away_site/dominian_science_vessel
	name = "Dominian Science Vessel"
	description = "Based on the Lammergeier-class corvette, this vessel has been repurposed by House Volvalaad for long range survey and scientific tasks. Due to its repurposement, the vessel features an enlarged hangar and shuttle, as well as scientific labs and a smaller defensive armament."
	suffixes = list("ships/dominia/dominian_science_vessel/dominian_science_vessel.dmm")
	sectors = list(ALL_TAU_CETI_SECTORS, ALL_COALITION_SECTORS, SECTOR_BADLANDS)
	sectors_blacklist = list(SECTOR_HANEUNIM)
	spawn_weight = 1
	ship_cost = 1
	id = "dominian_science_vessel"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/dominian_science_shuttle)

	unit_test_groups = list(3)

/singleton/submap_archetype/dominian_science_vessel
	map = "Dominian Science Vessel"
	descriptor = "Based on the Lammergeier-class corvette, this vessel has been repurposed by House Volvalaad for long range survey and scientific tasks. Due to its repurposement, the vessel features an enlarged hangar and shuttle, as well as scientific labs and a smaller defensive armament."

//ship stuff

/obj/effect/overmap/visitable/ship/dominian_science_vessel
	name = "Dominian Science Vessel"
	class = "HVS"
	desc = "Based on the Lammergeier-class corvette, this vessel has been repurposed by House Volvalaad for long range survey and scientific tasks. Due to its repurposement, the vessel features an enlarged hangar and shuttle, as well as scientific labs and a smaller defensive armament."
	icon_state = "lammergeier"//td
	moving_state = "lammergeier_moving"//td
	colors = list("#df1032", "#d4296b")
	designer = "Zhurong Naval Arsenal, Empire of Dominia"
	volume = "36 meters length, 67 meters beam/width, 18 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "Single wingtip-mounted extruding medium-caliber ballistic armament, aft obscured flight craft bay"
	sizeclass = "Explorer-class Science Vessel"
	shiptype = "Survey and scientific research"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	initial_restricted_waypoints = list(
		"Dominian Science Shuttle" = list("nav_hangar_dominian_science_vessel")
	)

	initial_generic_waypoints = list(
		"nav_dominian_science_vessel_1",
		"nav_dominian_science_vessel_2",
		"nav_dominian_science_vessel_3",
		"nav_dominian_science_vessel_4",
		"nav_dominian_science_dock_port",
		"nav_dominian_science_dock_aft"
	)

	invisible_until_ghostrole_spawn = TRUE

/obj/effect/overmap/visitable/ship/dominian_science_vessel/New()
	designation = "[pick("Vanguard", "Voyager", "Explorer", "Owl", "Ocular")]"//td
	..()

/obj/effect/overmap/visitable/ship/dominian_science_vessel/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/subcapital_ships.dmi', "dominian_corvette")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	return skybox_image

/obj/effect/shuttle_landmark/dominian_science_vessel/nav1
	name = "Dominian Science Vessel - Fore"
	landmark_tag = "nav_dominian_science_vessel_1"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/dominian_science_vessel/nav2
	name = "Dominian Science Vessel - Aft"
	landmark_tag = "nav_dominian_science_vessel_2"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/dominian_science_vessel/nav3
	name = "Dominian Science Vessel - Starboard"
	landmark_tag = "nav_dominian_science_vessel_3"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/dominian_science_vessel/nav4
	name = "Dominian Science Vessel - Port"
	landmark_tag = "nav_dominian_science_vessel_4"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/dominian_science_vessel/shuttle_transit
	name = "In transit"
	landmark_tag = "nav_transit_dominian_science_shuttle"
	base_turf = /turf/space/transit

/obj/effect/shuttle_landmark/dominian_science_vessel/dock/port
	name = "Dock, Port"
	landmark_tag = "nav_dominian_science_dock_port"
	docking_controller = "airlock_dominian_science_dock_port"

/obj/effect/shuttle_landmark/dominian_science_vessel/dock/aft
	name = "Dock, Aft"
	landmark_tag = "nav_dominian_science_dock_aft"
	docking_controller = "airlock_dominian_science_dock_aft"

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/dominian_science_shuttle
	name = "Dominian Science Shuttle"
	class = "HVS"
	designation = "Scholar"
	desc = "An exploration shuttle used by House Volvalaad on its science vessels, the Scholar is well-stocked for its mission of exploration and discovery."
	shuttle = "Dominian Science Shuttle"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	colors = list("#df1032", "#d4296b")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/dominian_science_shuttle
	name = "shuttle control console"
	shuttle_tag = "Dominian Science Shuttle"
	req_access = list(ACCESS_HOUSE_VOLVALAAD_SHIP)

/datum/shuttle/autodock/overmap/dominian_science_shuttle
	name = "Dominian Science Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/dominian_science_shuttle)
	current_location = "nav_hangar_dominian_science_vessel"
	landmark_transition = "nav_transit_dominian_science_shuttle"
	dock_target = "airlock_dominian_science_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_dominian_science_vessel"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/dominian_science_shuttle/hangar
	name = "Dominian Shuttle Hangar"
	landmark_tag = "nav_hangar_dominian_science_vessel"
	docking_controller = "dominian_science_shuttle_dock"
	base_area = /area/ship/dominian_science_vessel
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/dominian_science_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_dominian_science_shuttle"
	base_turf = /turf/space/transit/north
