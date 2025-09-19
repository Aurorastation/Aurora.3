/obj/effect/overmap/visitable/ship/landable/ssrm_shuttle
	name = "Sol Recon Corvette Shuttle"
	class = "SAMV"
	designation = "Vizsla"
	desc = "A modestly sized shuttle design used by the Solarian Armed Forces, the Destrier is well-armored but somewhat slow, and was explicitly designed to be as survivable as possible for operations during combat."
	shuttle = "SSRM Shuttle"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	colors = list("#9dc04c", "#52c24c")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/terminal/ssrm_shuttle
	name = "shuttle control console"
	shuttle_tag = "SSRM Shuttle"
	req_access = list(ACCESS_SOL_SHIPS)

// Controls docking behaviour
/datum/shuttle/autodock/overmap/ssrm_shuttle
	name = "SSRM Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/ssrm_shuttle)
	current_location = "nav_ssrm_dock"
	landmark_transition = "nav_transit_ssrm_shuttle"
	dock_target = "airlock_ssrm_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_ssrm_dock"
	defer_initialisation = TRUE

// Docking Port marker
/obj/effect/shuttle_landmark/ssrm_shuttle/dock
	name = "SSRM Docking Port"
	landmark_tag = "nav_ssrm_dock"
	docking_controller = "ssrm_shuttle_dock"
	base_area = /area/ship/ssrm_corvette
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

// Transit landmark
/obj/effect/shuttle_landmark/ssrm_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_ssrm_shuttle"
	base_turf = /turf/space/transit/north

// Shuttle docking port
/obj/effect/map_effect/marker/airlock/docking/ssrm_ship/shuttle_port
	name = "SSRM Docking Port"
	landmark_tag = "nav_ssrm_dock"
	master_tag = "ssrm_shuttle_dock"

// Shuttle airlock
/obj/effect/map_effect/marker/airlock/shuttle/ssrm_shuttle
	name = "SSRM Shuttle"
	shuttle_tag = "SSRM Shuttle"
	master_tag = "airlock_ssrm_shuttle"
	cycle_to_external_air = TRUE
