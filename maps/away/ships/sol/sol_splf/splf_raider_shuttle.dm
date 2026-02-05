// Their shuttle is a stolen Chainlink passenger skiff.
/obj/effect/overmap/visitable/ship/landable/splf_shuttle
	name = "SPLF Shuttle"
	class = "SPLFV"
	desc = "This appears to be a Bluebell-class passenger skiff, quite a mundane design utilised widely to transport Stellar Corporate Conglomerate personnel over short distances, such as in and out of a planet's atmosphere. Sensors indicate that the outward hull of this one is unusually badly denatured, implying a clumsily performed orbital re-entry."
	shuttle = "SPLF Shuttle"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	designer = "Stellar Corporate Conglomerate, Commonwealth of Valkyrie"
	sizeclass = "Bluebell-class passenger craft"
	shiptype = "Short-distance passenger transportation"
	colors = list("#aaafd4", "#78adf8")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 3000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY

/obj/effect/overmap/visitable/ship/landable/splf_shuttle/New()
	designation = "[pick("Ours Now", "Better Use", "Watch It Closer", "Repurposed", "Liberated", "People's Mule", "You're Welcome")]"
	..()

/obj/machinery/computer/shuttle_control/explore/terminal/splf_shuttle
	name = "shuttle control console"
	shuttle_tag = "SPLF Shuttle"
	req_access = list(ACCESS_SPLF)
// --------

// Controls docking behaviour
/datum/shuttle/autodock/overmap/splf_shuttle
	name = "SPLF Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/splf)
	current_location = "nav_hangar_splf"
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
/obj/effect/shuttle_landmark/splf_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_splf_shuttle"
	base_turf = /turf/space/transit/north
// --------

// Shuttle docking port
/obj/effect/map_effect/marker/airlock/docking/splf_raider/shuttle_port
	name = "Shuttle Dock"
	landmark_tag = "nav_hangar_splf"
	master_tag = "splf_shuttle_dock"
// --------

// Shuttle airlock
/obj/effect/map_effect/marker/airlock/shuttle/splf_shuttle
	name = "splf_shuttle"
	master_tag = "splf_shuttle"
	shuttle_tag = "SPLF Shuttle"
	cycle_to_external_air = TRUE
// --------
