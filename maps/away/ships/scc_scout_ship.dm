/datum/map_template/ruin/away_site/scc_scout_ship
	name = "SCCV XYZ Scout Ship"
	description = "SCCV XYZ Desc."
	suffix = "ships/scc_scout_ship.dmm"
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE)
	spawn_weight = 1000
	spawn_cost = 1
	id = "scc_scout_ship"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/scc_scout_shuttle)

/decl/submap_archetype/scc_scout_ship
	map = "SCCV XYZ Scout Ship"
	descriptor = "SCCV XYZ Desc."

//areas
/area/ship/scc_scout_ship
	name = "SCCV XYZ Scout Ship"

/area/shuttle/scc_scout_shuttle
	name = "SCCV XYZ Scout Shuttle"
	icon_state = "shuttle2"

//ship stuff

/obj/effect/overmap/visitable/ship/scc_scout_ship
	name = "SCCV XYZ Scout Ship"
	class = "SCCV"
	desc = "SCCV XYZ Desc."
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	vessel_size = SHIP_SIZE_SMALL
	fore_dir = SOUTH
	initial_restricted_waypoints = list(
		"SCCV XYZ Scout Shuttle" = list("nav_hangar_scc_scout")
	)

	initial_generic_waypoints = list(
		"nav_scc_scout_ship_1",
		"nav_scc_scout_ship_2"
	)

/obj/effect/overmap/visitable/ship/scc_scout_ship/New()
	designation = "[pick("Foo", "Bar")]"
	..()

/obj/effect/shuttle_landmark/scc_scout_ship/nav1
	name = "SCCV XYZ Scout Ship - Port Side"
	landmark_tag = "nav_scc_scout_ship_1"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/scc_scout_ship/nav2
	name = "SCCV XYZ Scout Ship - Port Airlock"
	landmark_tag = "nav_scc_scout_ship_2"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/scc_scout_ship/transit
	name = "In transit"
	landmark_tag = "nav_transit_scc_scout_ship"
	base_turf = /turf/space/transit/south

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/scc_scout_shuttle
	name = "SCCV XYZ Scout Shuttle"
	desc = "SCCV XYZ Shuttle Desc."
	shuttle = "SCCV XYZ Scout Shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/scc_scout_shuttle
	name = "shuttle control console"
	shuttle_tag = "SCCV XYZ Scout Shuttle"
	req_access = list()

/datum/shuttle/autodock/overmap/scc_scout_shuttle
	name = "SCCV XYZ Scout Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/scc_scout_shuttle)
	current_location = "nav_hangar_scc_scout"
	landmark_transition = "nav_transit_scc_scout_ship"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_scc_scout"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/scc_scout_shuttle/hangar
	name = "SCCV XYZ Scout Shuttle Dock"
	landmark_tag = "nav_hangar_scc_scout"
	docking_controller = "scc_scout_shuttle_dock"
	base_area = /area/ship/scc_scout_ship
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/scc_scout_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_scc_scout_ship"
	base_turf = /turf/space/transit/south
