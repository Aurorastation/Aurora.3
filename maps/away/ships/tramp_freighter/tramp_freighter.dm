/datum/map_template/ruin/away_site/tramp_freighter
	name = "Independent Freighter"
	description = "A favourite of small-scale independent businesses, the Farthing-class is one of few popular commercial designs of hauling vessel not manufactured by any particular megacorporation. Designed as a versatile tool, it popularly finds itself used to freight for remote areas of space. Tolerances are cut throughout the ship to achieve its legendary cost efficiency, making it a horribly oppressive ship to live on, and a vulnerable target for pirates - between its vulnerable bridge and limited means of self-defence, the Farthing is risky to operate in unpoliced space."

	prefix = "ships/tramp_freighter/"
	suffix = "tramp_freighter.dmm"

	sectors = list(ALL_POSSIBLE_SECTORS)
	spawn_weight = 1
	ship_cost = 1
	id = "tramp_freighter"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/freighter_shuttle)

	unit_test_groups = list(3)

/singleton/submap_archetype/tramp_freighter
	map = "Independent Freighter"
	descriptor = "A favourite of small-scale independent businesses, the Farthing-class is one of few popular commercial designs of hauling vessel not manufactured by any particular megacorporation. Designed as a versatile tool, it popularly finds itself used to freight for remote areas of space. Tolerances are cut throughout the ship to achieve its legendary cost efficiency, making it a horribly oppressive ship to live on, and a vulnerable target for pirates - between its vulnerable bridge and limited means of self-defence, the Farthing is risky to operate in unpoliced space."

//ship stuff

/obj/effect/overmap/visitable/ship/tramp_freighter
	name = "Independent Freighter"
	class = "ICV"
	desc = "A favourite of small-scale independent businesses, the Farthing-class is one of few popular commercial designs of hauling vessel not manufactured by any particular megacorporation. Designed as a versatile tool, it popularly finds itself used to freight for remote areas of space. Tolerances are cut throughout the ship to achieve its legendary cost efficiency, making it a horribly oppressive ship to live on, and a vulnerable target for pirates - between its vulnerable bridge and limited means of self-defence, the Farthing is risky to operate in unpoliced space."
	icon_state = "tramp"
	moving_state = "tramp_moving"
	colors = list("#c3c7eb", "#a0a8ec")
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	scanimage = "tramp_freighter.png"
	designer = "Independent, Unknown"
	volume = "49 meters length, 26 meters beam/width, 11 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "Fore low-end ballistic weapon mount, aft flight craft dock"
	sizeclass = "Farthing Class Freighter"
	shiptype = "Long-term shipping utilities"

	initial_restricted_waypoints = list(
		"Freight Shuttle" = list("nav_tramp_start")
	)

	initial_generic_waypoints = list(
		"nav_tramp_freighter_1",
		"nav_tramp_freighter_2",
		"nav_tramp_freighter_3",
		"nav_tramp_freighter_4",
		"nav_tramp_freighter_stbd_aft",
		"nav_tramp_freighter_stbd_fore",
		"nav_tramp_freighter_stbd_berth",
		"nav_tramp_freighter_port_aft",
		"nav_tramp_freighter_port_fore",
		"nav_tramp_freighter_port_berth"
	)

	invisible_until_ghostrole_spawn = TRUE

/obj/effect/overmap/visitable/ship/tramp_freighter/New()
	designation = "[pick("Tuckerbag", "Do No Harm", "Volatile Cargo", "Stay Clear", "Entrepreneurial", "Good Things Only", "Worthless", "Skip This One", "Pay No Mind", "Customs-Cleared", "Friendly", "Reactor Leak", "Fool's Gold", "Cursed Cargo", "Guards Aboard")]"
	..()

/obj/effect/overmap/visitable/ship/tramp_freighter/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/subcapital_ships.dmi', "tramp_freighter")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	return skybox_image

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/freighter_shuttle
	name = "Freight Shuttle"
	class = "ICV"
	designation = "Dame"
	desc = "An inefficient design of ultra-light shuttle known as the Wisp-class. Its only redeeming features are the extreme cheapness of the design and the ease of finding replacement parts. Manufactured by Hephaestus. This one's transponder identifies it as belonging to an independent freighter."
	shuttle = "Freight Shuttle"
	icon_state = "pod"
	moving_state = "pod_moving"
	colors = list("#c3c7eb", "#a0a8ec")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = EAST
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/terminal/freighter_shuttle
	name = "shuttle control console"
	shuttle_tag = "Freight Shuttle"

/datum/shuttle/autodock/overmap/freighter_shuttle
	name = "Freight Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/freighter_shuttle)
	dock_target = "airlock_tramp_shuttle"
	current_location = "nav_tramp_start"
	landmark_transition = "nav_transit_freighter_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_tramp_start"
	defer_initialisation = TRUE
