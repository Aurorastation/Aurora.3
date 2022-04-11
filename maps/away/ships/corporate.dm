/datum/map_template/ruin/away_site/orion_express_ship
	name = "Orion Express Ship"
	description = "A light ship belonging to the Orion Express corporation."
	suffix = "ships/orion_express_ship.dmm"
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE)
	spawn_weight = 1
	spawn_cost = 1
	id = "orion_express_ship"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/orion_express_ship, /datum/shuttle/autodock/overmap/orion_express_shuttle)

/obj/effect/overmap/visitable/sector/orion_express_ship
	name = "faint ship activity"
	desc = "A sector with faint hints of previous civilian ship presence."
	in_space = 1

/decl/submap_archetype/orion_express_ship
	map = "Orion Express ship"
	descriptor = "A light ship belonging to the Orion Express corporation."

//areas

/area/shuttle/orion_express_ship
	name = "Orion Express Ship"
	icon_state = "shuttle"

/area/shuttle/orion_express_shuttle
	name = "Orion Express Shuttle"
	icon_state = "shuttle2"

//ship stuff

/obj/effect/overmap/visitable/ship/landable/orion_express_ship
	name = "Orion Express Ship"
	desc = "A light ship belonging to the Orion Express corporation."
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Orion Express Ship"
	initial_restricted_waypoints = list(
		"Orion Express Shuttle" = list("nav_hangar_orion_express")
	)

	initial_generic_waypoints = list(
		"nav_orion_express_ship_1"
	)

/obj/effect/overmap/visitable/ship/landable/orion_express_ship/New()
	name = "OEV [pick("Messenger", "Traveler", "Highspeed", "Punctual","Unstoppable")]"
	..()

/obj/effect/shuttle_landmark/orion_express_ship/nav1
	name = "Orion Express Ship #1"
	landmark_tag = "nav_orion_express_ship_1"
	base_turf = /turf/space/dynamic
	base_area = /area/template_noop

/datum/shuttle/autodock/overmap/orion_express_ship
	name = "Orion Express Ship"
	warmup_time = 5
	range = 1
	current_location = "nav_orion_express_ship_start"
	shuttle_area = list(/area/shuttle/orion_express_ship)
	knockdown = FALSE

	fuel_consumption = 4
	logging_home_tag = "nav_orion_express_ship_start"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/orion_express_ship/start
	name = "Uncharted Space"
	landmark_tag = "nav_orion_express_ship_start"

/obj/effect/shuttle_landmark/orion_express_ship/transit
	name = "In transit"
	landmark_tag = "nav_transit_orion_express_ship"
	base_turf = /turf/space/transit/south

/obj/machinery/computer/shuttle_control/explore/orion_express_ship
	name = "ship control console"
	shuttle_tag = "Orion Express Ship"
	req_access = list(access_orion_express_ship)

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/orion_express_shuttle
	name = "Orion Express Shuttle"
	desc = "A shuttle used by the Orion Express to deliver its goods."
	shuttle = "Orion Express Shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/orion_express_shuttle
	name = "shuttle control console"
	shuttle_tag = "Orion Express Shuttle"
	req_access = list(access_orion_express_ship)

/datum/shuttle/autodock/overmap/orion_express_shuttle
	name = "Orion Express Shuttle"
	move_time = 90
	shuttle_area = list(/area/shuttle/orion_express_shuttle)
	dock_target = "orion_express_shuttle"
	current_location = "nav_hangar_orion_express"
	landmark_transition = "nav_transit_orion_express"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_orion_express"
	defer_initialisation = TRUE
	mothershuttle = "Orion Express Ship"

/obj/effect/shuttle_landmark/orion_express_shuttle/hangar
	name = "Orion Express Shuttle Hangar"
	landmark_tag = "nav_hangar_orion_express"
	docking_controller = "orion_express_shuttle_dock"
	base_area = /area/shuttle/orion_express_ship
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/orion_express_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_orion_express"
	base_turf = /turf/space/transit/south

