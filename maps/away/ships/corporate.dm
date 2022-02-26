/datum/map_template/ruin/away_site/orion_express_ship
	name = "Orion Express ship"
	description = "A light ship belonging to the Orion Express corporation."
	suffix = "ships/orion_express_ship.dmm"
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE)
	spawn_weight = 1
	spawn_cost = 1
	id = "orion_express_ship"

decl/submap_archetype/orion_express_ship
	map = "Orion Express ship"
	descriptor = "A light ship belonging to the Orion Express corporation."

/obj/effect/overmap/visitable/ship/landable/orion_express_ship
	name = "Orion Express Ship"
	desc = "A light trading ship."

/obj/effect/overmap/visitable/ship/landable/orion_express_ship/New()
	name = "OEV [pick("Messenger", "Traveler", "Highspeed", "Punctual","Unstoppable")]"
	..()

//areas

/area/shuttle/orion_express_ship
	name = "Orion Express Ship"
	icon_state = "shuttle"

/area/shuttle/orion_express_shuttle
	name = "Orion Express Shuttle"
	icon_state = "shuttle2"

//ship stuff

/obj/effect/overmap/visitable/ship/landable/orion_express_ship
	name = "Orion Express ship"
	desc = "A light ship belonging to the Orion Express corporation."
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_SMALL

	initial_restricted_waypoints = list(
		"Orion Express Shuttle" = list("nav_orion_express_shuttle")
	)

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
	name = "mining shuttle control console"
	shuttle_tag = "Orion Express Shuttle"
	req_access = list(access_orion_exress_ship)

//shuttle stuff

/datum/shuttle/autodock/overmap/orion_express_shuttle
	name = "Orion Express Shuttle"
	move_time = 90
	shuttle_area = list(/area/shuttle/orion_express_shuttle)
	current_location = "orion_express_shuttle"
	landmark_transition = "nav_transit_orion_express"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_orion_express"

/obj/effect/shuttle_landmark/orion_express_shuttle/hangar
	name = "Orion Express Shuttle Hangar"
	landmark_tag = "nav_hangar_orion_express"
	docking_controller = "orion_express_shuttle"
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/orion_express_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_orion_express"