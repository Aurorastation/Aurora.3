/datum/map_template/ruin/away_site/ceres_lance_ship
	name = "Ceres Lance Ship"
	description = "An auxiliary patrol ship operated by the Tau Ceti Foreign Legion. This one appears to be performing peacekeeper duties."
	suffix = "ships/ceres_lance_ship.dmm"
	sectors = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH, SECTOR_CORP_ZONE)
	spawn_weight = 1
	spawn_cost = 1
	id = "ceres_lance_ship"
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/ceres_lance_ship, /datum/shuttle/autodock/overmap/ceres_shuttle)
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED

/obj/effect/overmap/visitable/sector/ceres_lance_ship
	name = "faint ship activity"
	desc = "A sector with faint hints of previous military auxiliary ship presence."
	in_space = 1

/decl/submap_archetype/ceres_lance_ship
	map = "Ceres Lance Ship"
	descriptor = "An auxiliary patrol ship operated by the Tau Ceti Foreign Legion. This one appears to be performing peacekeeper duties."

//areas

/area/shuttle/ceres_lance_ship
	name = "Ceres lance Ship"
	icon_state = "shuttle"

/area/shuttle/ceres_shuttle
	name = "Ceres Shuttle"
	icon_state = "shuttle2"

//ship stuff

/obj/effect/overmap/visitable/ship/landable/ceres_lance_ship
	name = "Ceres Lance Ship"
	desc = "An auxiliary patrol ship operated by the Tau Ceti Foreign Legion. This one appears to be performing peacekeeper duties."
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Ceres Lance Ship"
	initial_restricted_waypoints = list(
		"Ceres Shuttle" = list("nav_hangar_ceres")
	)

	initial_generic_waypoints = list(
		"nav_ceres_lance_ship_1"
	)

/obj/effect/overmap/visitable/ship/landable/ceres_lance_ship/New()
	name = "CLV [pick("Castle", "Rook", "Gin Rummy", "Pawn", "Bishop", "Knight", "Blackjack", "Torch", "Liberty", "President Dorn")]"
	..()

/obj/effect/shuttle_landmark/ceres_lance_ship/nav1
	name = "Ceres Lance Ship #1"
	landmark_tag = "nav_ceres_lance_ship_1"
	base_turf = /turf/space/dynamic
	base_area = /area/template_noop

/datum/shuttle/autodock/overmap/ceres_lance_ship
	name = "Ceres Lance Ship"
	warmup_time = 5
	range = 1
	current_location = "nav_ceres_lance_ship_start"
	shuttle_area = list(/area/shuttle/ceres_lance_ship)
	knockdown = FALSE

	fuel_consumption = 4
	logging_home_tag = "nav_ceres_lance_ship_start"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/ceres_lance_ship/start
	name = "Uncharted Space"
	landmark_tag = "nav_ceres_lance_start"

/obj/effect/shuttle_landmark/ceres_lance_ship/transit
	name = "In transit"
	landmark_tag = "nav_transit_ceres_lance_ship"
	base_turf = /turf/space/transit/south

/obj/machinery/computer/shuttle_control/explore/ceres_lance_ship
	name = "ship control console"
	shuttle_tag = "Ceres Lance Ship"
	req_access = list(access_ceres_lance_ship)

//shuttle stuff
/obj/effect/overmap/visitable/ship/landable/ceres_shuttle
	name = "Ceres Lance Shuttle"
	desc = "A shuttle used by the TCFL for boarding and interdiction purposes."
	shuttle = "Ceres Shuttle"
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/ceres_shuttle
	name = "shuttle control console"
	shuttle_tag = "ceres Shuttle"
	req_access = list(access_ceres_lance_ship)

/datum/shuttle/autodock/overmap/ceres_shuttle
	name = "Ceres Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/ceres_shuttle)
	current_location = "nav_hangar_ceres"
	landmark_transition = "nav_transit_ceres_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_ceres"
	defer_initialisation = TRUE
	mothershuttle = "Ceres Lance Ship"

/obj/effect/shuttle_landmark/ceres_shuttle/hangar
	name = "Ceres Shuttle Hangar"
	landmark_tag = "nav_hangar_ceres"
	docking_controller = "ceres_shuttle_dock"
	base_area = /area/shuttle/ceres_lance_ship
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/ceres_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_ceres_shuttle"
	base_turf = /turf/space/transit/south
