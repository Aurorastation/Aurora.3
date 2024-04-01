/datum/map_template/ruin/away_site/headmaster_ship
	name = "Headmaster Ship"
	id = "headmaster_ship"
	description = "A People's Republic Orbital Fleet ship."
	suffixes = list("ships/pra/headmaster/headmaster_ship.dmm")
	ship_cost = 1
	spawn_weight = 1
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/headmaster_shuttle)
	sectors = list(SECTOR_BADLANDS, SECTOR_SRANDMARR, SECTOR_NRRAHRAHUL)

	unit_test_groups = list(3)

/singleton/submap_archetype/headmaster_ship
	map = "Headmaster Ship"
	descriptor = "The second heaviest ship created by the People's Republic of Adhomai. As of now, it's the lightest heavy ship ever designed, barely staying above the classification of a cruiser."

/obj/effect/overmap/visitable/ship/headmaster_ship
	name = "Headmaster Ship"
	desc = "The second heaviest ship created by the People's Republic of Adhomai. As of now, it's the lightest heavy ship ever designed, barely staying above the classification of a cruiser."
	class = "PRAMV" //People's Republic of Adhomai Vessel
	icon_state = "headmaster"
	moving_state = "headmaster_moving"
	colors = list("#8C8A81")
	vessel_mass = 10000
	max_speed = 1/(2 SECONDS)
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_SMALL
	scanimage = "headmaster.png"
	designer = "People's Republic of Adhomai"
	volume = "61 meters length, 35 meters beam/width, 17 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "Extruding starboard-mounted medium caliber ballistic armament, starboard obscured flight craft bay"
	sizeclass = "Headmaster Cruiser"
	shiptype = "Military patrol and combat utility"
	initial_generic_waypoints = list(
		"nav_headmaster_ship_1",
		"nav_headmaster_ship_2",
		"nav_headmaster_ship_3",
		"nav_headmaster_ship_4",
		"nav_headmaster_ship_dock_starboard",
		"nav_headmaster_ship_dock_port"
	)
	initial_restricted_waypoints = list(
		"Orbital Fleet Shuttle" = list("nav_headmaster_shuttle")
	)

	invisible_until_ghostrole_spawn = TRUE

/obj/effect/overmap/visitable/ship/headmaster_ship/New()
	if (prob(50))
		designation = "Hadii"
	else
		designation = "[pick("Al'mari Hadii", "Adhomai's Shield", "Loyal Comrade", "People's Guardian", "Visionary", "Great Future", "Fearless Pioneer", "Adhomian Dream")]"
	..()

/obj/effect/overmap/visitable/ship/headmaster_ship/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/subcapital_ships.dmi', "headmaster")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	return skybox_image

/obj/effect/shuttle_landmark/headmaster_ship
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/nav_headmaster_ship/nav1
	name = "Headmaster Ship Navpoint #1"
	landmark_tag = "nav_headmaster_ship_1"

/obj/effect/shuttle_landmark/nav_headmaster_ship/nav2
	name = "Headmaster Ship Navpoint #2"
	landmark_tag = "nav_headmaster_ship_2"

/obj/effect/shuttle_landmark/nav_headmaster_ship/nav3
	name = "Headmaster Ship Navpoint #3"
	landmark_tag = "nav_headmaster_ship_3"

/obj/effect/shuttle_landmark/nav_headmaster_ship/nav4
	name = "Headmaster Ship Navpoint #4"
	landmark_tag = "nav_headmaster_ship_4"

/obj/effect/shuttle_landmark/nav_headmaster_ship/dock/starboard
	name = "Starboard Dock"
	landmark_tag = "nav_headmaster_ship_dock_starboard"
	docking_controller = "nav_headmaster_ship_dock_starboard"
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/nav_headmaster_ship/dock/port
	name = "Port Dock"
	landmark_tag = "nav_headmaster_ship_dock_port"
	docking_controller = "nav_headmaster_ship_dock_port"
	base_turf = /turf/space
	base_area = /area/space

//shuttle
/obj/effect/overmap/visitable/ship/landable/headmaster_shuttle
	name = "Orbital Fleet Shuttle"
	desc = "A simple and reliable shuttle design used by the Orbital Fleet."
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	colors = list("#8C8A81")
	class = "PRAMV"
	designation = "Yve'kha"
	shuttle = "Orbital Fleet Shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/terminal/headmaster_shuttle
	name = "shuttle control console"
	shuttle_tag = "Orbital Fleet Shuttle"

/datum/shuttle/autodock/overmap/headmaster_shuttle
	name = "Orbital Fleet Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/headmaster_shuttle)
	current_location = "nav_headmaster_shuttle"
	landmark_transition = "nav_transit_headmaster_shuttle"
	dock_target = "headmaster_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_headmaster_shuttle"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/headmaster_shuttle/hangar
	name = "Orbital Fleet Shuttle Hangar"
	landmark_tag = "nav_headmaster_shuttle"
	docking_controller = "headmaster_shuttle_dock"
	base_area = /area/headmaster_ship/hangar
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/headmaster_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_headmaster_shuttle"
	base_turf = /turf/space/transit/north
