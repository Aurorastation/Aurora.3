/datum/map_template/ruin/away_site/tirakqi_ship
	name = "Ti'Rakqi Freighter"
	description = "A light ship belonging to the Ti'Rakqi."
	suffix = "ships/tirakqi_ship.dmm"
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE)
	spawn_weight = 1
	spawn_cost = 1
	id = "tirakqi_ship"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/tirakqi_ship, /datum/shuttle/autodock/overmap/tirakqi_shuttle)

/obj/effect/overmap/visitable/sector/tirakqi_ship
	name = "faint ship activity"
	desc = "A sector with faint hints of previous civilian ship presence."
	in_space = 1

/decl/submap_archetype/tirakqi_ship
	map = "Ti'Rakqi Freighter"
	descriptor = "A small, advanced, skrellian freighter in service to the Ti'Rakqi."

//areas

/area/shuttle/tirakqi_ship
	name = "Ti'Rakqi Freighter"
	icon_state = "shuttle"

/area/shuttle/tirakqi_shuttle
	name = "Ti'Rakqi Shuttle"
	icon_state = "shuttle2"

//ship stuff

/obj/effect/overmap/visitable/ship/landable/tirakqi_ship
	name = "Ti'Rakqi Freighter"
	desc = "A small, advanced, skrellian freighter in service to the Ti'Rakqi."
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	vessel_size = SHIP_SIZE_SMALL
	fore_dir = SOUTH
	shuttle = "Ti'Rakqi Freighter"
	initial_restricted_waypoints = list(
		"Ti'Rakqi Shuttle" = list("nav_hangar_tirakqi_ship")
	)

	initial_generic_waypoints = list(
		"nav_tirakqi_ship_1"
	)

/obj/effect/overmap/visitable/ship/landable/tirakqi_ship/New()
	name = "[pick("Leviathan", "Void Whale", "Qub Qub", "Seafall", "Clam Trap", "Buurgis Bloc", "Void Tanker", "Star Crate", "Q'opi")]"
	..()

/obj/effect/shuttle_landmark/tirakqi_ship/nav1
	name = "Ti'Rakqi Ship #1"
	landmark_tag = "nav_tirakqi_ship_1"
	base_turf = /turf/space/dynamic
	base_area = /area/template_noop

/datum/shuttle/autodock/overmap/tirakqi_ship
	name = "Ti'Rakqi Freighter"
	warmup_time = 5
	range = 1
	current_location = "nav_tirakqi_ship_start"
	shuttle_area = list(/area/shuttle/tirakqi_ship)
	knockdown = FALSE

	fuel_consumption = 3
	logging_home_tag = "nav_tirakqi_ship_start"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/tirakqi_ship/start
	name = "Uncharted Space"
	landmark_tag = "nav_tirakqi_ship_start"

/obj/effect/shuttle_landmark/tirakqi_ship/transit
	name = "In transit"
	landmark_tag = "nav_transit_tirakqi_ship"
	base_turf = /turf/space/transit/south

/obj/machinery/computer/shuttle_control/explore/tirakqi_ship
	name = "ship control console"
	shuttle_tag = "Ti'Rakqi Freigher"
	req_access = list(access_tirakqi_ship)

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/tirakqi_shuttle
	name = "Ti'Rakqi Shuttle"
	desc = "A shuttle used by the Ti'Rakqi to deliver their goods."
	shuttle = "Ti'Rakqi Shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 2500 //not 
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY
	subshuttle = TRUE

/obj/machinery/computer/shuttle_control/explore/tirakqi_shuttle
	name = "shuttle control console"
	shuttle_tag = "Ti'Rakqi Shuttle"
	req_access = list(access_tirakqi_ship)

/datum/shuttle/autodock/overmap/tirakqi_shuttle
	name = "Ti'Rakqi Shuttle"
	move_time = 90
	shuttle_area = list(/area/shuttle/tirakqi_shuttle)
	current_location = "nav_hangar_tirakqi"
	landmark_transition = "nav_transit_tirakqi"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_tirakqi"
	defer_initialisation = TRUE
	mothershuttle = "Orion Express Ship"

/obj/effect/shuttle_landmark/tirakqi_shuttle/hangar
	name = "Ti'Rakqi Hangar"
	landmark_tag = "nav_hangar_tirakqi"
	docking_controller = "tirakqi_shuttle_dock"
	base_area = /area/shuttle/tirakqi_ship
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/tirakqi_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_tirakqi"
	base_turf = /turf/space/transit/south