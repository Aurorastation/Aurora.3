/datum/map_template/ruin/away_site/headmaster_ship
	name = "Headmaster Ship"
	description = "A People's Republic Orbital Fleet ship."

	prefix = "ships/pra/headmaster/"
	suffix = "headmaster_ship.dmm"

	traits = list(
		// Deck one
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = TRUE, ZTRAIT_DOWN = FALSE),
		// Deck two
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = FALSE, ZTRAIT_DOWN = TRUE),
	)

	sectors = list(SECTOR_BADLANDS, SECTOR_SRANDMARR, SECTOR_NRRAHRAHUL)
	spawn_weight_sector_dependent = list(SECTOR_SRANDMARR = 2, SECTOR_NRRAHRAHUL = 2, SECTOR_BADLANDS = 0.5)
	spawn_weight = 1
	ship_cost = 1
	id = "headmaster_ship"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/headmaster_shuttle, /datum/shuttle/autodock/multi/lift/headmaster)

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
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	scanimage = "headmaster.png"
	designer = "People's Republic of Adhomai"
	volume = "61 meters length, 35 meters beam/width, 17 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "Starboard deck-mounted medium calibre ballistic armament, fore pintle-mounted small calibre ballistic armament"
	sizeclass = "Headmaster Cruiser"
	shiptype = "Military patrol and combat utility"
	initial_restricted_waypoints = list(
		"Orbital Fleet Shuttle" = list("nav_hangar_headmaster")
	)

	initial_generic_waypoints = list(
		"nav_headmaster_ship_1",
		"nav_headmaster_ship_2",
		"nav_headmaster_ship_3",
		"nav_headmaster_ship_4",
		"nav_headmaster_ship_dock_fore",
		"nav_headmaster_ship_dock_aft",
		"nav_headmaster_ship_dock_starboard",
		"nav_headmaster_ship_dock_port"
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

// Shuttle
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
	vessel_mass = 2500 // Same as the SCCV Canary. Lower than usual to compensate for only having two thrusters.
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/terminal/headmaster_shuttle
	name = "shuttle control console"
	shuttle_tag = "Orbital Fleet Shuttle"
	req_access = list(ACCESS_PRA)

// Controls docking behaviour
/datum/shuttle/autodock/overmap/headmaster_shuttle
	name = "Orbital Fleet Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/headmaster_shuttle)
	current_location = "nav_hangar_headmaster"
	landmark_transition = "nav_transit_headmaster_shuttle"
	dock_target = "headmaster_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_headmaster"
	defer_initialisation = TRUE

// Hangar marker
/obj/effect/shuttle_landmark/headmaster_shuttle/hangar
	name = "Orbital Fleet Shuttle Hangar"
	landmark_tag = "nav_hangar_headmaster"
	docking_controller = "headmaster_shuttle_dock"
	base_area = /area/space
	base_turf = /turf/space
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

// Shuttle docking port
/obj/effect/map_effect/marker/airlock/docking/headmaster_ship/shuttle_port
	name = "Shuttle Dock"
	landmark_tag = "nav_hangar_headmaster"
	master_tag = "headmaster_shuttle_dock"

// Transit landmark
/obj/effect/shuttle_landmark/headmaster_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_headmaster_shuttle"
	base_turf = /turf/space/transit/north

// Shuttle airlock
/obj/effect/map_effect/marker/airlock/shuttle/headmaster_shuttle
	name = "headmaster_shuttle"
	master_tag = "headmaster_shuttle"
	shuttle_tag = "Headmaster Shuttle"
	cycle_to_external_air = TRUE
