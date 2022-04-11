/datum/map_template/ruin/away_site/sfa_patrol_ship
	name = "SFA Patrol Ship"
	description = "A naval ship belonging to the now all-but-defunct Southern Fleet Administration, a Solarian warlord state."
	suffix = "ships/sfa_patrol_ship.dmm"
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE)
	spawn_weight = 1
	spawn_cost = 1
	id = "sfa_patrol_ship"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/sfa_patrol_ship, /datum/shuttle/autodock/overmap/sfa_shuttle)

/obj/effect/overmap/visitable/sector/sfa_patrol_ship
	name = "faint ship activity"
	desc = "A sector with faint hints of previous military ship presence."
	in_space = 1

/decl/submap_archetype/sfa_patrol_ship
	map = "SFA Patrol Ship"
	descriptor = "A naval ship belonging to the now all-but-defunct Southern Fleet Administration, a Solarian warlord state."

//areas

/area/shuttle/sfa_patrol_ship
	name = "SFA Patrol Ship"
	icon_state = "shuttle"

/area/shuttle/sfa_shuttle
	name = "SFA Shuttle"
	icon_state = "shuttle2"

//ship stuff

/obj/effect/overmap/visitable/ship/landable/sfa_patrol_ship
	name = "SFA Patrol Ship"
	desc = "A naval ship belonging to the now all-but-defunct Southern Fleet Administration, a Solarian warlord state."
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "SFA Patrol Ship"
	initial_restricted_waypoints = list(
		"SFA Shuttle" = list("nav_hangar_sfa")
	)

	initial_generic_waypoints = list(
		"nav_sfa_patrol_ship_1"
	)

/obj/effect/overmap/visitable/ship/landable/sfa_patrol_ship/New()
	name = "SFAV [pick("Brigand", "Zheng Yi Sao", "Watchman", "Edward Teach", "Beauchamp's Revenge", "Blackguard")]"
	..()

/obj/effect/shuttle_landmark/sfa_patrol_ship/nav1
	name = "SFA Patrol Ship #1"
	landmark_tag = "nav_sfa_patrol_ship_1"
	base_turf = /turf/space/dynamic
	base_area = /area/template_noop

/datum/shuttle/autodock/overmap/sfa_patrol_ship
	name = "SFA Patrol Ship"
	warmup_time = 5
	range = 1
	current_location = "nav_sfa_patrol_ship_start"
	shuttle_area = list(/area/shuttle/sfa_patrol_ship)
	knockdown = FALSE

	fuel_consumption = 4
	logging_home_tag = "nav_sfa_patrol_ship_start"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/sfa_patrol_ship/start
	name = "Uncharted Space"
	landmark_tag = "nav_sfa_patrol_ship_start"

/obj/effect/shuttle_landmark/sfa_patrol_ship/transit
	name = "In transit"
	landmark_tag = "nav_transit_sfa_patrol_ship"
	base_turf = /turf/space/transit/south

/obj/machinery/computer/shuttle_control/explore/sfa_patrol_ship
	name = "ship control console"
	shuttle_tag = "SFA Patrol Ship"
	req_access = list(access_sfa_patrol_ship)

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/sfa_shuttle
	name = "SFA Shuttle"
	desc = "A shuttle used by the SFA for boarding and interdiction purposes."
	shuttle = "SFA Shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/sfa_shuttle
	name = "shuttle control console"
	shuttle_tag = "SFA Shuttle"
	req_access = list(access_sfa_patrol_ship)

/datum/shuttle/autodock/overmap/sfa_shuttle
	name = "SFA Shuttle"
	move_time = 90
	shuttle_area = list(/area/shuttle/sfa_shuttle)
	dock_target = "sfa_shuttle"
	current_location = "nav_hangar_sfa"
	landmark_transition = "nav_transit_sfa"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_sfa"
	defer_initialisation = TRUE
	mothershuttle = "SFA Patrol Ship"

/obj/effect/shuttle_landmark/sfa_shuttle/hangar
	name = "SFA Shuttle Hangar"
	landmark_tag = "nav_hangar_sfa"
	docking_controller = "sfa_shuttle_dock"
	base_area = /area/shuttle/sfa_patrol_ship
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/sfa_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_sfa_shuttle"
	base_turf = /turf/space/transit/south
