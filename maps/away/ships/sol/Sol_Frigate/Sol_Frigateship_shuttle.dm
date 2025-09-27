// This is a bare-bones shuttle only designed for transport, no interceptors here.
/obj/effect/overmap/visitable/ship/landable/splf_shuttle
	name = "Sol Frigate Shuttle"
	class = "SAMV"
	desc = "The Norman-Class transport shuttle is the Destrier's smaller, and slightly faster cousin. Prmarily designed for utility transport above all else, it lacks any means to protect itself.\ Normans are usually seen in the hangars of escort warships in the Navy, and in the hands of the Solarian Navy's fag officers as a personal transport."
	shuttle = "Solarian Navy"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	designer = "Solarian Navy"
	sizeclass = "Norman-Class transport shuttle"
	shiptype = "Short-distance transportation"
	colors = list("#9dc04c", "#52c24c")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000
	fore_dir = WEST
	vessel_size = SHIP_SIZE_TINY

/obj/effect/overmap/visitable/ship/landable/Solfrig_shuttle/New()
	designation = "[pick("Courier", "Messanger", "Dispatcher")]"
	..()

/obj/machinery/computer/shuttle_control/explore/terminal/Solfrig_shuttle
	name = "shuttle control console"
	shuttle_tag = "Solarian Frigate Shuttle"
	req_access = list(ACCESS_SOL_SHIPS)
// --------

// Controls docking behaviour
/datum/shuttle/autodock/overmap/Solfrig_shuttle
	name = "Solarian Frigate Shuttle"
	move_time = 15
	shuttle_area = list(/area/shuttle/Solfrig_shuttle)
	current_location = "nav_hangar_"
	landmark_transition = "nav_transit_splf_shuttle"
	dock_target = "splf_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_splf"
	defer_initialisation = TRUE
// --------

// Hangar marker
/obj/effect/shuttle_landmark/splf_shuttle/hangar
	name = "Shuttle Port"
	landmark_tag = "nav_hangar_splf"
	docking_controller = "splf_shuttle_dock"
	base_area = /area/space
	base_turf = /turf/space
	movable_flags = MOVABLE_FLAG_EFFECTMOVE
// --------

// Transit landmark
/obj/effect/shuttle_landmark/Sol_Frigate/transit
	name = "In transit"
	landmark_tag = "nav_transit_Solfrig_shuttle"
	base_turf = /turf/space/transit/north
// --------

// Shuttle docking port
/obj/effect/map_effect/marker/airlock/docking/Sol_frigate/shuttle_port
	name = "Shuttle Dock"
	landmark_tag = "nav_hangar_solfrig"
	master_tag = "Solfrig_shuttle_dock"
// --------

// Shuttle airlock
/obj/effect/map_effect/marker/airlock/shuttle/Solfrig_shuttle
	name = "Solfrig_shuttle"
	master_tag = "Solfrig_shuttle"
	shuttle_tag = "Solarian Frigate Shuttle"
	cycle_to_external_air = TRUE
// --------
