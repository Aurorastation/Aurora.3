// This is a bare-bones shuttle only designed for transport, no interceptors here.
/obj/effect/overmap/visitable/ship/landable/Solfrig_shuttle
	name = "Sol Frigate Shuttle"
	class = "SAMV"
	desc = "A modified variant of the Fuji-class space superiority fighter, the Kita-class is essentially a disarmed version of it's cousin in favor of passenger capacity and additional speed. This design is particularly popular with the larger escort vessels of the Solarian Navy, who appreciate the Kita's ability to interdict and board fleeing targets with exceptional speed."
	shuttle = "Solarian Frigate Shuttle"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	designer = "Solarian Navy"
	sizeclass = "Kita-Class interdiction craft"
	shiptype = "Short-distance transportation, high-speed interception/boarding"
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
	current_location = "nav_hangar_solfrig"
	landmark_transition = "nav_transit_Solfrig_shuttle"
	dock_target = "Solfrig_shuttle_dock"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_solfrig"
	defer_initialisation = TRUE
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
