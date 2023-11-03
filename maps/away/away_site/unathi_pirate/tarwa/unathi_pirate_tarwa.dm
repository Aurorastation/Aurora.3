/datum/map_template/ruin/away_site/tarwa
	name = "Tarwa Conglomerate Ship"
	description = "Ship with pirate lizards, pirate plants"
	suffixes = list("away_site/unathi_pirate/tarwa/unathi_pirate_tarwa.dmm")
	sectors = list(SECTOR_BADLANDS, SECTOR_GAKAL, SECTOR_LIGHTS_EDGE, SECTOR_WEEPING_STARS)
	spawn_weight = 1
	ship_cost = 1
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/tarwa_shuttle)
	id = "tarwa_conglomerate"

/singleton/submap_archetype/tramp_freighter
	map = "Tarwa Conglomerate Ship"
	descriptor = "Ship with pirate lizards, pirate plants"

/obj/effect/overmap/visitable/ship/tarwa
	name = "Tarwa Conglomerate Ship"
	desc = "An Azkrazal-class cargo freighter. Scans indicate it is heavily damaged, and that there appears to be some form of organic growth on the exterior hull."
	class = "ICV"
	icon_state = "tramp"
	moving_state = "tramp_moving"
	colors = list("#c2c1ac", "#1b7325")
	scanimage = "unathi_diona_freighter.png"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	designer = "Izweski Hegemony Naval Guilds, Hephaestus Industries"
	volume = "65 meters length, 35 meters beam/width, 18 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "Wingtip-mounted heavy ballistic, port obscured flight craft bay"
	sizeclass = "Modified Azkrazal-class cargo freighter"
	shiptype = "Unknown"
	initial_restricted_waypoints = list(
		"Tarwa Conglomerate Shuttle" = list("nav_hangar_tarwa")
	)
	initial_generic_waypoints = list(
		"nav_tarwa1",
		"nav_tarwa2",
		"nav_tarwa3",
		"nav_tarwa4"
	)
	invisible_until_ghostrole_spawn = TRUE

/obj/effect/overmap/visitable/ship/tarwa/New()
	designation = "[pick("Silent Sentinel", "Symbiosis", "Flying Dead", "Immortal", "Blood for Blood", "Unnatural Compatibility", "Barkscale", "Boneclaw", "Watcher in the Dark")]"
	..()

/obj/effect/overmap/visitable/ship/tarwa/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/subcapital_ships.dmi', "unathi_diona_freighter")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	return skybox_image

/obj/effect/shuttle_landmark/tarwa_ship
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/tarwa_ship/nav1
	name = "Tarwa Conglomerate Freighter - Fore"
	landmark_tag = "nav_tarwa1"

/obj/effect/shuttle_landmark/tarwa_ship/nav2
	name = "Tarwa Conglomerate Freighter - Port"
	landmark_tag = "nav_tarwa2"

/obj/effect/shuttle_landmark/tarwa_ship/nav3
	name = "Tarwa Conglomerate Freighter - Starboard"
	landmark_tag = "nav_tarwa3"

/obj/effect/shuttle_landmark/tarwa_ship/nav4
	name = "Tarwa Conglomerate Freighter - Aft"
	landmark_tag = "nav_tarwa4"

//Shuttle stuff

/obj/effect/overmap/visitable/ship/landable/tarwa_shuttle
	name = "Tarwa Conglomerate Shuttle"
	class = "ICV"
	designation = "Clash Of Sabers And Burning Steel In The Skies Of Ha'zana"
	desc = "A large diona gestalt, which seems to have grown around the framework of a cargo shuttle."
	icon_state = "pod"
	moving_state = "pod_moving"
	colors = list("#1b4720")
	shuttle = "Tarwa Conglomerate Shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = EAST
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/tarwa_shuttle
	name = "shuttle control console"
	shuttle_tag = "Tarwa Conglomerate Shuttle"

/datum/shuttle/autodock/overmap/tarwa_shuttle
	name = "Tarwa Conglomerate Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/tarwa)
	current_location = "nav_hangar_tarwa"
	landmark_transition = "nav_transit_tarwa"
	dock_target = "tarwa_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_tarwa"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/tarwa_shuttle/hangar
	name = "Tarwa Conglomerate Freighter - Hangar"
	landmark_tag = "nav_hangar_tarwa"
	base_area = /area/tarwa_ship/hangar
	base_turf = /turf/simulated/floor/plating
	docking_controller = "tarwa_shuttle_dock"
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/tarwa_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_tarwa"
	base_turf = /turf/space/transit/east
