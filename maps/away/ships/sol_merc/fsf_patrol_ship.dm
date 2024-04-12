/datum/map_template/ruin/away_site/fsf_patrol_ship
	name = "FSF Corvette"
	description = "A small corvette manufactured for the Solarian Navy by Hephaestus, the Montevideo-class is an anti-piracy vessel through and through - with a shuttle bay that takes up a third of the ship and only a single weapon hardpoint located in one arm of the ship, the Montevideo is designed for long-term, self-sufficient operations in inhabited space against small-time pirate vessels that would be unable to overcome the ship's lackluster armaments. Generous automation and streamlined equipment allows it to function with a very small crew."
	suffixes = list("ships/sol_merc/fsf_patrol_ship.dmm")
	sectors = list(SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE)
	spawn_weight = 1
	ship_cost = 1
	id = "fsf_patrol_ship"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/fsf_shuttle)

	unit_test_groups = list(3)

/singleton/submap_archetype/fsf_patrol_ship
	map = "FSF Corvette"
	descriptor = "A small corvette manufactured for the Solarian Navy by Hephaestus, the Montevideo-class is an anti-piracy vessel through and through - with a shuttle bay that takes up a third of the ship and only a single weapon hardpoint located in one arm of the ship, the Montevideo is designed for long-term, self-sufficient operations in inhabited space against small-time pirate vessels that would be unable to overcome the ship's lackluster armaments. Generous automation and streamlined equipment allows it to function with a very small crew."

//areas
/area/ship/fsf_patrol_ship
	name = "FSF Corvette"

/area/shuttle/fsf_shuttle
	name = "FSF Shuttle"
	icon_state = "shuttle2"

//ship stuff

/obj/effect/overmap/visitable/ship/fsf_patrol_ship
	name = "FSF Corvette"
	class = "FSFV"
	desc = "A small corvette manufactured for the Solarian Navy by Einstein Engines, the Montevideo-class is an anti-piracy vessel through and through - with a shuttle bay that takes up a third of the ship and only a single weapon hardpoint located in one arm of the ship, the Montevideo is designed for long-term, self-sufficient operations in inhabited space against small-time pirate vessels that would be unable to overcome the ship's lackluster armaments. Generous automation and streamlined equipment allows it to function with a very small crew."
	icon_state = "corvette"
	moving_state = "corvette_moving"
	colors = list("#9dc04c", "#52c24c")
	scanimage = "corvette.png"
	designer = "Solarian Navy, Tiscareno y Volante Shipbuilding modifications"
	volume = "41 meters length, 39 meters beam/width, 17 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "Dual extruding fore and starboard-mounted medium caliber ballistic armament, fore obscured flight craft bay"
	sizeclass = "Montevideo-class Corvette"
	shiptype = "Military patrol and combat utility"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	initial_restricted_waypoints = list(
		"FSF Shuttle" = list("nav_hangar_fsf")
	)

	initial_generic_waypoints = list(
		"nav_fsf_patrol_ship_1",
		"nav_fsf_patrol_ship_2"
	)

	invisible_until_ghostrole_spawn = TRUE

/obj/effect/overmap/visitable/ship/fsf_patrol_ship/New()
	designation = "[pick("Varangian", "Swiss Guard", "Free Company", "Praetorian", "Gurkha", "Roland", "Whispering Death", "Gordon Ingram", "Jungle Work", "Habiru", "Francs-Tireurs", "Catalan", "Navarrese", "Breton", "Corsair", "Landsknecht", "Hessian")]"
	..()

/obj/effect/overmap/visitable/ship/fsf_patrol_ship/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/subcapital_ships.dmi', "corvette")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	return skybox_image

/obj/effect/shuttle_landmark/fsf_patrol_ship/nav1
	name = "FSF Corvette - Port Side"
	landmark_tag = "nav_fsf_patrol_ship_1"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/fsf_patrol_ship/nav2
	name = "FSF Corvette - Port Side"
	landmark_tag = "nav_fsf_patrol_ship_2"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/fsf_patrol_ship/transit
	name = "In transit"
	landmark_tag = "nav_transit_fsf_patrol_ship"
	base_turf = /turf/space/transit/north

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/fsf_shuttle
	name = "FSF Shuttle"
	class = "FSFV"
	designation = "Condottiere"
	desc = "An inefficient design of ultra-light shuttle known as the Wisp-class. Its only redeeming features are the extreme cheapness of the design and the ease of finding replacement parts. Manufactured by Hephaestus."
	shuttle = "FSF Shuttle"
	icon_state = "pod"
	moving_state = "pod_moving"
	colors = list("#9dc04c", "#52c24c")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/fsf_shuttle
	name = "shuttle control console"
	shuttle_tag = "FSF Shuttle"
	req_access = list(ACCESS_SOL_SHIPS)

/datum/shuttle/autodock/overmap/fsf_shuttle
	name = "FSF Shuttle"
	move_time = 90
	shuttle_area = list(/area/shuttle/fsf_shuttle)
	current_location = "nav_hangar_fsf"
	landmark_transition = "nav_transit_fsf_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_fsf"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/fsf_shuttle/hangar
	name = "FSF Shuttle Hangar"
	landmark_tag = "nav_hangar_fsf"
	docking_controller = "fsf_shuttle_dock"
	base_area = /area/ship/fsf_patrol_ship
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/fsf_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_fsf_shuttle"
	base_turf = /turf/space/transit/north
