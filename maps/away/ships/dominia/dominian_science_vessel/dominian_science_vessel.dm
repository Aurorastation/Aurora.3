/datum/map_template/ruin/away_site/dominian_science_vessel
	name = "Dominian Science Vessel"
	description = "Based on the Lammergeier-class corvette, this vessel has been repurposed by House Volvalaad for long range survey and scientific tasks. Due to its repurposement, the vessel features an enlarged hangar and shuttle, as well as scientific labs and a smaller defensive armament."
	suffixes = list("ships/dominia/dominian_science_vessel/dominian_science_vessel.dmm")
	sectors = list(SECTOR_BADLANDS)
	spawn_weight = 1
	ship_cost = 1
	id = "dominian_"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/dominian_science_shuttle)

	unit_test_groups = list(2)

/singleton/submap_archetype/dominian_science_vessel
	map = "Dominian Science Vessel"
	descriptor = "Based on the Lammergeier-class corvette, this vessel has been repurposed by House Volvalaad for long range survey and scientific tasks. Due to its repurposement, the vessel features an enlarged hangar and shuttle, as well as scientific labs and a smaller defensive armament."

//ship stuff

/obj/effect/overmap/visitable/ship/dominian_science_vessel
	name = "Dominian Science Vessel"
	class = "HIMS"
	desc = "Based on the Lammergeier-class corvette, this vessel has been repurposed by House Volvalaad for long range survey and scientific tasks. Due to its repurposement, the vessel features an enlarged hangar and shuttle, as well as scientific labs and a smaller defensive armament."
	icon_state = "lammergeier"
	moving_state = "lammergeier_moving"
	colors = list("#df1032", "#d4296b")
	scanimage = "dominian_science_vessel.png"
	designer = "Zhurong Naval Arsenal, Empire of Dominia"
	volume = "42 meters length, 75 meters beam/width, 18 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "Single wingtip-mounted extruding medium-caliber ballistic armament, aft obscured flight craft bay"
	sizeclass = "Lammergeier-class Corvette"
	shiptype = "Survey and scientific research"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	initial_restricted_waypoints = list(
		"Dominian Shuttle" = list("nav_hangar_dominia")
	)

	initial_generic_waypoints = list(
		"nav_dominian_science_vessel_1",
		"nav_dominian_science_vessel_2"
	)

	invisible_until_ghostrole_spawn = TRUE

/obj/effect/overmap/visitable/ship/dominian_science_vessel/New()
	designation = "[pick("Lammergeier", "Eagle", "Hawk", "Owl", "Vulture", "Sparrowhawk", "Falcon", "Peregrine", "Condor", "Harrier", "Kestrel", "Osprey", "Yastr", "Merlin", "Kite", "Seriema", "Caracaras")]"
	..()

/obj/effect/overmap/visitable/ship/dominian_science_vessel/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/subcapital_ships.dmi', "dominian_science_vessel")
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

/obj/effect/shuttle_landmark/dominian_science_vessel/transit
	name = "In transit"
	landmark_tag = "nav_transit_dominian_science_vessel"
	base_turf = /turf/space/transit/north

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/dominian_science_shuttle
	name = "Dominian Shuttle"
	class = "HIMS"
	designation = "Chariot"
	desc = "A light shuttle used by the Imperial Fleet to move small amounts of cargo or personnel between vessels, the Yupmi-class shuttle is a dependable utility craft. Like most Dominian vessels it is relatively well armored for its size but is not a combat vessel by any means. A short operational range means a Yupmi should never stray too far from its vessel of origin as it will soon run out of fuel."
	shuttle = "Dominian Shuttle"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	colors = list("#df1032", "#d4296b")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/dominian_science_shuttle
	name = "shuttle control console"
	shuttle_tag = "Dominian Shuttle"
	req_access = list(ACCESS_IMPERIAL_FLEET_VOIDSMAN_SHIP)

/datum/shuttle/autodock/overmap/dominian_science_shuttle
	name = "Dominian Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/dominian_science_shuttle)
	current_location = "nav_hangar_dominia"
	landmark_transition = "nav_transit_dominian_science_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_dominia"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/dominian_science_shuttle/hangar
	name = "Dominian Shuttle Hangar"
	landmark_tag = "nav_hangar_dominia"
	docking_controller = "dominian_science_shuttle_dock"
	base_area = /area/ship/dominian_science_vessel
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/dominian_science_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_dominian_science_shuttle"
	base_turf = /turf/space/transit/north
