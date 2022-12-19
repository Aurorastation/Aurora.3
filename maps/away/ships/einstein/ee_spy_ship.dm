/datum/map_template/ruin/away_site/ee_spy_ship
	name = "Einstein Engines Research Ship"
	description = "A research ship belonging to Einstein Engines, the Stellar Corporate Conglomerate's main competitor."
	suffix = "ships/einstein/ee_spy_ship.dmm"
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE)
	spawn_weight = 1
	ship_cost = 1
	id = "ee_spy_ship"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/ee_shuttle)

/decl/submap_archetype/ee_spy_ship
	map = "Einstein Engines Research Ship"
	descriptor = "A research ship belonging to Einstein Engines, the Stellar Corporate Conglomerate's main competitor."

//areas
/area/ship/ee_spy_ship
	name = "Einstein Engines Research Ship"

/area/shuttle/ee_shuttle
	name = "Einstein Engines Shuttle"
	icon_state = "shuttle2"

//ship stuff

/obj/effect/overmap/visitable/ship/ee_spy_ship
	name = "Einstein Engines Research Ship"
	class = "EERV"
	desc = "A research ship belonging to Einstein Engines, the Stellar Corporate Conglomerate's main competitor."
	icon_state = "ship_green"
	moving_state = "ship_green_moving"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	initial_restricted_waypoints = list(
		"Einstein Engines Shuttle" = list("nav_hangar_ee")
	)

	initial_generic_waypoints = list(
		"nav_ee_spy_ship_1",
		"nav_ee_spy_ship_2"
	)

/obj/effect/overmap/visitable/ship/ee_spy_ship/New()
	designation = "[pick("Brilliance", "Oppenheimer", "Fermi", "Slingshot", "Shanghai", "Bern", "Hadron", "Positron", "Invention", "Nikola Tesla", "Quark")]"
	..()

/obj/effect/shuttle_landmark/ee_spy_ship/nav1
	name = "Einstein Engines Research Ship - Port Side"
	landmark_tag = "nav_ee_spy_ship_1"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/ee_spy_ship/nav2
	name = "Einstein Engines Research Ship - Port Airlock"
	landmark_tag = "nav_ee_spy_ship_2"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/ee_spy_ship/transit
	name = "In transit"
	landmark_tag = "nav_transit_ee_spy_ship"
	base_turf = /turf/space/transit/north

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/ee_shuttle
	name = "Einstein Engines Shuttle"
	class = "EEV"
	designation = "Canary"
	desc = "A shuttle used by Einstein Engines. For research purposes only."
	shuttle = "Einstein Engines Shuttle"
	icon_state = "shuttle_green"
	moving_state = "shuttle_green_moving"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/ee_shuttle
	name = "shuttle control console"
	shuttle_tag = "Einstein Engines Shuttle"
	req_access = list(access_ee_spy_ship)

/datum/shuttle/autodock/overmap/ee_shuttle
	name = "Einstein Engines Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/ee_shuttle)
	current_location = "nav_hangar_ee"
	landmark_transition = "nav_transit_ee_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_ee"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/ee_shuttle/hangar
	name = "Einstein Engines Shuttle Hangar"
	landmark_tag = "nav_hangar_ee"
	docking_controller = "ee_shuttle_dock"
	base_area = /area/ship/ee_spy_ship
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/ee_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_ee_shuttle"
	base_turf = /turf/space/transit/north
