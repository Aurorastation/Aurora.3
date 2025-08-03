// Shuttle
/obj/effect/overmap/visitable/ship/landable/hailstorm_shuttle
	name = "Spacer Militia Shuttle"
	class = "DPRAMV" //Democratic People's Republic of Adhomai Vessel
	designation = "Yve'kha"
	desc = "A simple and reliable shuttle design used by the Spacer Militia Shuttle."
	designer = "Obfuscated, hull origin uncertain"
	shuttle = "Spacer Militia Shuttle"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	colors = list("#B9BDC4")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000 //very inefficient pod
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/terminal/hailstorm_shuttle
	name = "shuttle control console"
	shuttle_tag = "Spacer Militia Shuttle"
	req_access = list(ACCESS_DPRA)
// --------

// Controls docking behaviour
/datum/shuttle/autodock/overmap/hailstorm_shuttle
	name = "Spacer Militia Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/hailstorm_shuttle)
	current_location = "nav_hangar_hailstorm"
	landmark_transition = "nav_transit_hailstorm_shuttle"
	dock_target = "hailstorm_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_hailstorm"
	defer_initialisation = TRUE
// --------

// Hangar marker
/obj/effect/shuttle_landmark/hailstorm_shuttle/hangar
	name = "Shuttle Port"
	landmark_tag = "nav_hangar_hailstorm"
	docking_controller = "hailstorm_shuttle_dock"
	base_area = /area/space
	base_turf = /turf/space
	movable_flags = MOVABLE_FLAG_EFFECTMOVE
// --------

// Transit landmark
/obj/effect/shuttle_landmark/hailstorm_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_hailstorm_shuttle"
	base_turf = /turf/space/transit/north
// --------

// Shuttle docking port
/obj/effect/map_effect/marker/airlock/docking/hailstorm_shuttle/shuttle_port
	name = "Shuttle Dock"
	landmark_tag = "nav_hangar_hailstorm"
	master_tag = "hailstorm_shuttle_dock"
// --------

// Shuttle airlock
/obj/effect/map_effect/marker/airlock/shuttle/hailstorm_shuttle
	name = "hailstorm_shuttle"
	master_tag = "hailstorm_shuttle"
	shuttle_tag = "Spacer Militia Shuttle"
	cycle_to_external_air = TRUE
// --------
