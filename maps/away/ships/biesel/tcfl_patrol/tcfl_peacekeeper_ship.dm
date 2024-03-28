/datum/map_template/ruin/away_site/tcfl_peacekeeper_ship
	name = "TCFL Corvette"
	description = "Serving as the very foundation of the SCC's (And more specifically, NanoTrasen's) fleet of asset protection vessels, the Cetus-class is versatile and durable, but also clumsy and somewhat underpowered in regards to its engine and propulsion. It features small weapon hardpoints in its thruster arms, and a massive hangar host to the design's interdiction counterpart - the Hydrus-class shuttle. This one appears to be a Decanus-class, the Tau Ceti Foreign Legion variation of the design."
	suffixes = list("ships/tcfl_patrol/tcfl_peacekeeper_ship.dmm")
	sectors = list(ALL_TAU_CETI_SECTORS, SECTOR_VALLEY_HALE, SECTOR_BADLANDS)
	spawn_weight = 1
	ship_cost = 1
	id = "tcfl_peacekeeper_ship"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/tcfl_shuttle)
	ban_ruins = list(/datum/map_template/ruin/away_site/tcaf_corvette)

	unit_test_groups = list(3)

/singleton/submap_archetype/tcfl_peacekeeper_ship
	map = "TCFL Corvette"
	descriptor = "Serving as the very foundation of the SCC's (And more specifically, NanoTrasen's) fleet of asset protection vessels, the Cetus-class is versatile and durable, but also clumsy and somewhat underpowered in regards to its engine and propulsion. It features small weapon hardpoints in its thruster arms, and a massive hangar host to the design's interdiction counterpart - the Hydrus-class shuttle. This one appears to be a Decanus-class, the Tau Ceti Foreign Legion variation of the design."

//areas
/area/ship/tcfl_peacekeeper_ship
	name = "TCFL Corvette"

/area/shuttle/tcfl_shuttle
	name = "TCFL Shuttle"
	icon_state = "shuttle2"

//ship stuff

/obj/effect/overmap/visitable/ship/tcfl_peacekeeper_ship
	name = "TCFL Corvette"
	class = "BLV"
	desc = "Serving as the very foundation of the SCC's (And more specifically, NanoTrasen's) fleet of asset protection vessels, the Cetus-class is versatile and durable, but also clumsy and somewhat underpowered in regards to its engine and propulsion. It features small weapon hardpoints in its thruster arms, and a massive hangar host to the design's interdiction counterpart - the Hydrus-class shuttle. This one appears to be a Decanus-class, the Tau Ceti Foreign Legion variation of the design."
	icon_state = "cetus"
	moving_state = "cetus_moving"
	colors = list("#263aeb", "#3d8cfa")
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	scanimage = "tcfl_cetus.png"
	designer = "NanoTrasen, Stellar Corporate Conglomerate"
	volume = "51 meters length, 42 meters beam/width, 12 meters vertical height"
	drive = "Low-Speed Warp Acceleration FTL Drive"
	weapons = "Two extruding wing mounted naval ballistic weapon mounts, aft obscured flight craft bay"
	sizeclass = "Cetus Class Corvette"
	shiptype = "Military patrol and combat utility"
	initial_restricted_waypoints = list(
		"TCFL Shuttle" = list("nav_hangar_tcfl")
	)

	initial_generic_waypoints = list(
		"nav_tcfl_peacekeeper_ship_1",
		"nav_tcfl_peacekeeper_ship_2"
	)

	invisible_until_ghostrole_spawn = TRUE

/obj/effect/overmap/visitable/ship/tcfl_peacekeeper_ship/New()
	designation = "[pick("Castle", "Rook", "Gin Rummy", "Pawn", "Bishop", "Knight", "Blackjack", "Torch", "Liberty", "President Dorn", "Independence", "Civic Duty", "Democracy", "Progress", "Prosperity", "New Gibson", "Biesel", "Justice", "Equality")]"
	..()

/obj/effect/overmap/visitable/ship/tcfl_peacekeeper_ship/get_skybox_representation()
	var/image/skybox_image = image('icons/skybox/subcapital_ships.dmi', "tcfl_corvette")
	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	return skybox_image

/obj/effect/shuttle_landmark/tcfl_peacekeeper_ship/nav1
	name = "TCFL Corvette - Port Side"
	landmark_tag = "nav_tcfl_peacekeeper_ship_1"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/tcfl_peacekeeper_ship/nav2
	name = "TCFL Corvette - Port Airlock"
	landmark_tag = "nav_tcfl_peacekeeper_ship_2"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/tcfl_peacekeeper_ship/transit
	name = "In transit"
	landmark_tag = "nav_transit_tcfl_peacekeeper_ship"
	base_turf = /turf/space/transit/north

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/tcfl_shuttle
	name = "TCFL Shuttle"
	designation = "BLV"
	class = "Stake"
	desc = "A large and unusually-shaped shuttle, the Hydrus-class is deceptively fast and is designed to operate out of a Cetus-class corvette's rear hangar bay, interdicting targets that its mothership intercepts. This one appears to be a Velite-class Interceptor - the TCFL designation for this design."
	shuttle = "TCFL Shuttle"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	colors = list("#263aeb", "#3d8cfa")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/tcfl_shuttle
	name = "shuttle control console"
	shuttle_tag = "TCFL Shuttle"
	req_access = list(ACCESS_TCAF_SHIPS)

/datum/shuttle/autodock/overmap/tcfl_shuttle
	name = "TCFL Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/tcfl_shuttle)
	current_location = "nav_hangar_tcfl"
	landmark_transition = "nav_transit_tcfl_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_tcfl"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/tcfl_shuttle/hangar
	name = "TCFL Shuttle Hangar"
	landmark_tag = "nav_hangar_tcfl"
	docking_controller = "tcfl_shuttle_dock"
	base_area = /area/ship/tcfl_peacekeeper_ship
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/tcfl_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_tcfl_shuttle"
	base_turf = /turf/space/transit/north
