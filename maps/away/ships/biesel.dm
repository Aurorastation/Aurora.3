/datum/map_template/ruin/away_site/tcfl_peacekeeper_ship
	name = "TCFL Peacekeeper Ship"
	description = "Serving as the very foundation of the SCC’s (And more specifically, NanoTrasen’s) fleet of asset protection vessels, the Cetus-class is versatile and durable, but also clumsy and somewhat underpowered in regards to its engine and propulsion. It features small weapon hardpoints in its thruster arms, and a massive hangar host to the design’s interdiction counterpart - the Hydrus-class shuttle. This one’s transponder identifies it as a Tau Ceti Foreign Legion patrol vessel, and as a Decanus-class Clipper - the TCFL designation for this design."
	suffix = "ships/tcfl_peacekeeper_ship.dmm"
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE)
	spawn_weight = 1
	spawn_cost = 1
	id = "tcfl_peacekeeper_ship"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/tcfl_peacekeeper_ship, /datum/shuttle/autodock/overmap/tcfl_shuttle)

/obj/effect/overmap/visitable/sector/tcfl_peacekeeper_ship
	name = "faint ship activity"
	desc = "A sector with faint hints of previous ship presence."
	in_space = 1

/decl/submap_archetype/tcfl_peacekeeper_ship
	map = "TCFL Peacekeeper Ship"
	descriptor = "Serving as the very foundation of the SCC’s (And more specifically, NanoTrasen’s) fleet of asset protection vessels, the Cetus-class is versatile and durable, but also clumsy and somewhat underpowered in regards to its engine and propulsion. It features small weapon hardpoints in its thruster arms, and a massive hangar host to the design’s interdiction counterpart - the Hydrus-class shuttle. This one’s transponder identifies it as a Tau Ceti Foreign Legion patrol vessel, and as a Decanus-class Clipper - the TCFL designation for this design."

//areas

/area/shuttle/tcfl_peacekeeper_ship
	name = "TCFL Peacekeeper Ship"
	icon_state = "shuttle"

/area/shuttle/tcfl_shuttle
	name = "TCFL Shuttle"
	icon_state = "shuttle2"

//ship stuff

/obj/effect/overmap/visitable/ship/landable/tcfl_peacekeeper_ship
	name = "TCFL Peacekeeper Ship"
	desc = "Serving as the very foundation of the SCC’s (And more specifically, NanoTrasen’s) fleet of asset protection vessels, the Cetus-class is versatile and durable, but also clumsy and somewhat underpowered in regards to its engine and propulsion. It features small weapon hardpoints in its thruster arms, and a massive hangar host to the design’s interdiction counterpart - the Hydrus-class shuttle. This one’s transponder identifies it as a Tau Ceti Foreign Legion patrol vessel, and as a Decanus-class Clipper - the TCFL designation for this design."
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "TCFL Peacekeeper Ship"
	initial_restricted_waypoints = list(
		"TCFL Shuttle" = list("nav_hangar_tcfl")
	)

	initial_generic_waypoints = list(
		"nav_tcfl_peacekeeper_ship_1"
	)

/obj/effect/overmap/visitable/ship/landable/tcfl_peacekeeper_ship/New()
	name = "BLV [pick("Castle", "Rook", "Gin Rummy", "Pawn", "Bishop", "Knight", "Blackjack", "Torch", "Liberty", "President Dorn")]"
	..()

/obj/effect/shuttle_landmark/tcfl_peacekeeper_ship/nav1
	name = "TCFL Peacekeeper Ship #1"
	landmark_tag = "nav_tcfl_peacekeeper_ship_1"
	base_turf = /turf/space/dynamic
	base_area = /area/template_noop

/datum/shuttle/autodock/overmap/tcfl_peacekeeper_ship
	name = "TCFL Peacekeeper Ship"
	warmup_time = 5
	range = 1
	current_location = "nav_tcfl_peacekeeper_ship_start"
	shuttle_area = list(/area/shuttle/tcfl_peacekeeper_ship)
	knockdown = FALSE

	fuel_consumption = 4
	logging_home_tag = "nav_tcfl_peacekeeper_ship_start"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/tcfl_peacekeeper_ship/start
	name = "Uncharted Space"
	landmark_tag = "nav_tcfl_peacekeeper_ship_start"

/obj/effect/shuttle_landmark/tcfl_peacekeeper_ship/transit
	name = "In transit"
	landmark_tag = "nav_transit_tcfl_peacekeeper_ship"
	base_turf = /turf/space/transit/south

/obj/machinery/computer/shuttle_control/explore/tcfl_peacekeeper_ship
	name = "ship control console"
	shuttle_tag = "TCFL Peacekeeper Ship"
	req_access = list(access_tcfl_peacekeeper_ship)

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/tcfl_shuttle
	name = "TCFL Shuttle"
	desc = "A large and unusually-shaped shuttle, the Shooting Star-class is deceptively fast and is designed to operate out of a Cetus-class corvette’s rear hangar bay, interdicting targets that its mothership intercepts. This one’s transponder identifies it as a Tau Ceti Foreign Legion shuttle, and as a Velite-class Interceptor - the TCFL designation for this design."
	shuttle = "TCFL Shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/tcfl_shuttle
	name = "shuttle control console"
	shuttle_tag = "TCFL Shuttle"
	req_access = list(access_tcfl_peacekeeper_ship)

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
	mothershuttle = "TCFL Peacekeeper Ship"

/obj/effect/shuttle_landmark/tcfl_shuttle/hangar
	name = "TCFL Shuttle Hangar"
	landmark_tag = "nav_hangar_tcfl"
	docking_controller = "tcfl_shuttle_dock"
	base_area = /area/shuttle/tcfl_peacekeeper_ship
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/tcfl_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_tcfl_shuttle"
	base_turf = /turf/space/transit/south
