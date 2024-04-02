/datum/map_template/ruin/away_site/database_freighter
	name = "Database Freighter"
	id = "database_freighter"
	description = "Made from adapted designs of the first freighter Tajara ever worked upon, Database freighters are PRA vessels made specially for gathering information on star systems and what passes through them."
	suffixes = list("ships/pra/database_freighter/database_freighter.dmm")
	ship_cost = 1
	spawn_weight = 1
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/database_freighter_shuttle)
	sectors = list(SECTOR_BADLANDS, SECTOR_SRANDMARR, SECTOR_NRRAHRAHUL)

	unit_test_groups = list(3)

/singleton/submap_archetype/database_freighter
	map = "Database Freighter"
	descriptor = "Made from adapted designs of the first freighter Tajara ever worked upon, Database freighters are PRA vessels made specially for gathering information on star systems and what passes through them."

/obj/effect/overmap/visitable/ship/database_freighter
	name = "Database Freighter"
	desc = "Made from adapted designs of the first freighter Tajara ever worked upon, Database freighters are PRA vessels made specially for gathering information on star systems and what passes through them."
	class = "PRAMV" //People's Republic of Adhomai Vessel
	icon_state = "tramp"
	moving_state = "tramp_moving"
	colors = list("#8C8A81")
	vessel_mass = 10000
	max_speed = 1/(2 SECONDS)
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_SMALL
	scanimage = "pra_freighter.png"
	designer = "People's Republic of Adhomai"
	volume = "51 meters length, 28 meters beam/width, 12 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "Not apparent, port obscured flight craft bay"
	sizeclass = "Database Freighter"
	shiptype = "Stellar, cosmic study and long-term research missions"
	initial_generic_waypoints = list(
		"nav_database_freighter_1",
		"nav_database_freighter_2",
		"nav_database_freighter_3",
		"nav_database_freighter_4"
	)
	initial_restricted_waypoints = list(
		"Database Freighter Shuttle" = list("nav_database_freighter_shuttle")
	)

	invisible_until_ghostrole_spawn = TRUE

/obj/effect/overmap/visitable/ship/database_freighter/New()
	if (prob(50))
		designation = "Hadii"
	else
		designation = "[pick("Pursuer of Knowledge", "Guiding Light", "Pioneer of the Dawn", "Party's Vanguard", "Hadiist Adventurer", "First Step", "Maker of the Future", "Indomitable Hadiist Spirit")]"
	..()


/obj/effect/overmap/visitable/ship/database_freighter/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/subcapital_ships.dmi', "pra_freighter")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	return skybox_image

/obj/effect/shuttle_landmark/database_freighter
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/nav_database_freighter/nav1
	name = "Database Freighter Navpoint #1"
	landmark_tag = "nav_database_freighter_1"

/obj/effect/shuttle_landmark/nav_database_freighter/nav2
	name = "Database Freighter Navpoint #2"
	landmark_tag = "nav_database_freighter_2"

/obj/effect/shuttle_landmark/nav_database_freighter/nav3
	name = "Database Freighter Navpoint #3"
	landmark_tag = "nav_database_freighter_3"

/obj/effect/shuttle_landmark/nav_database_freighter/nav4
	name = "Database Freighter Navpoint #4"
	landmark_tag = "nav_database_freighter_4"

//shuttle
/obj/effect/overmap/visitable/ship/landable/database_freighter_shuttle
	name = "Database Freighter Shuttle"
	desc = "A simple and reliable shuttle design used by the Orbital Fleet."
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	colors = list("#8C8A81")
	class = "PRAMV"
	designation = "Yve'kha"
	shuttle = "Database Freighter Shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/database_freighter_shuttle
	name = "shuttle control console"
	shuttle_tag = "Database Freighter Shuttle"


/datum/shuttle/autodock/overmap/database_freighter_shuttle
	name = "Database Freighter Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/database_freighter_shuttle)
	dock_target = "database_freighter_shuttle"
	current_location = "nav_database_freighter_shuttle"
	landmark_transition = "nav_transit_database_freighter_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_database_freighter_shuttle"
	defer_initialisation = TRUE

/obj/effect/map_effect/marker/airlock/shuttle/database_freighter_shuttle
	name = "Database Freighter Shuttle"
	shuttle_tag = "Database Freighter Shuttle"
	master_tag = "nav_database_freighter_shuttle"
