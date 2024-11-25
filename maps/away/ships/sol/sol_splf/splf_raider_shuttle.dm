// Their shuttle is a stolen Chainlink passeneger skiff.
/obj/effect/overmap/visitable/ship/landable/splf_shuttle
	name = "SPLF Transport Skiff"
	class = "SPLFV"
	desc = ""
	shuttle = "SPLF Transport Skiff"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	designer = "Stellar Corporate Conglomerate, Commonwealth of Valkyrie"
	sizeclass = "Bluebell-class passenger craft"
	colors = list("#aaafd4", "#78adf8")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY

/obj/effect/overmap/visitable/ship/landable/splf_shuttle/New()
	designation = "[pick("Ours Now")]"
	..()

/obj/machinery/computer/shuttle_control/explore/terminal/splf_shuttle
	name = "shuttle control console"
	shuttle_tag = "SPLF Shuttle"
	req_access = list(ACCESS_SPLF)

/datum/shuttle/autodock/overmap/splf_shuttle
	name = "SPLF Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/splf)
	current_location = "nav_hangar_splf"
	landmark_transition = "nav_transit_splf_shuttle"
	dock_target = "airlock_splf_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_splf"
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/splf_shuttle/hangar
	name = "Shuttle Port"
	landmark_tag = "nav_hangar_splf"
	docking_controller = "splf_shuttle_dock"
	base_area = /area/space
	base_turf = /turf/space
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/splf_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_splf_shuttle"
	base_turf = /turf/space/transit/north
