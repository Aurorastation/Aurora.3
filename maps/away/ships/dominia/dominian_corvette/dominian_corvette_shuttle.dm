/obj/effect/overmap/visitable/ship/landable/dominian_shuttle
	name = "Dominian Shuttle"
	class = "HIMS"
	designation = "Chariot"
	desc = "A light shuttle used by the Imperial Fleet to move small amounts of cargo or personnel between vessels, the Yupmi-class shuttle is a dependable utility craft. Like most Dominian vessels it is relatively well armored for its size but is not a combat vessel by any means. A short operational range means a Yupmi should never stray too far from its vessel of origin as it will soon run out of fuel."
	shuttle = "Dominian Shuttle"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	designer = "Zhurong Naval Arsenal, Empire of Dominia"
	sizeclass = "Yupmi-class Shuttle"
	shiptype = "Short-distance cargo and personnel transport"
	colors = list("#df1032", "#d4296b")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY

/obj/machinery/computer/shuttle_control/explore/terminal/dominian_shuttle
	name = "shuttle control console"
	shuttle_tag = "Dominian Shuttle"
	req_access = list(ACCESS_IMPERIAL_FLEET_VOIDSMAN_SHIP)

// Controls docking behaviour
/datum/shuttle/autodock/overmap/dominian_shuttle
	name = "Dominian Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/dominian_shuttle)
	current_location = "nav_hangar_dominia"
	landmark_transition = "nav_transit_dominian_shuttle"
	dock_target = "dominian_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_dominia"
	defer_initialisation = TRUE

// Hangar marker
/obj/effect/shuttle_landmark/dominian_shuttle/hangar
	name = "Shuttle Port"
	landmark_tag = "nav_hangar_dominia"
	docking_controller = "dominian_shuttle_dock"
	base_area = /area/space
	base_turf = /turf/space
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

// Transit landmark
/obj/effect/shuttle_landmark/dominian_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_dominian_shuttle"
	base_turf = /turf/space/transit/north

// Shuttle docking port
/obj/effect/map_effect/marker/airlock/docking/dominian_corvette/shuttle_port
	name = "Shuttle Dock"
	landmark_tag = "nav_hangar_dominia"
	master_tag = "dominia_shuttle_dock"

// Shuttle airlock
/obj/effect/map_effect/marker/airlock/shuttle/dominian_shuttle
	name = "dominian_shuttle"
	master_tag = "dominian_shuttle"
	shuttle_tag = "Dominian Shuttle"
	cycle_to_external_air = TRUE
