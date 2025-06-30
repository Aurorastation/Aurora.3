// This is for the shuttle in the auxiliary hangar of the station.
/obj/effect/overmap/visitable/ship/landable/crumbling_station_shuttle
	name = "Independent Shuttle"
	class = "ICV"
	desc = "An entirely ordinary hauling skiff, frequently used by independent traders or less savoury types to conduct all manners of business."
	shuttle = "Crumbling Station Shuttle"
	icon_state = "shuttle"
	moving_state = "shuttle_moving"
	designer = "Hephaestus Industries"
	sizeclass = "Cichlid-class hauling skiff"
	colors = list("#505050", "#161616")
	max_speed = 1/(3 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 2500 // Same as the SCCV Canary. Lower than usual to compensate for only having two thrusters.
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_TINY

/obj/effect/overmap/visitable/ship/landable/crumbling_station_shuttle/New()
	designation = "[pick("Tired Eyes", "Distant Shores", "Possibility", "Brown Dwarf", "Dart", "Flicker", "Not-Going-To-Crash", "Tunnel")]"
	..()
// --------

// Autodock stuff!
/datum/shuttle/autodock/overmap/crumbling_station_shuttle
	name = "Independent Shuttle"
	move_time = 20
	shuttle_area = list(/area/shuttle/crumbling)
	current_location = "nav_hangar_crumbling"
	landmark_transition = "nav_transit_crumbling_shuttle"
	dock_target = "airlock_crumbling_shuttle"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_crumbling"
	defer_initialisation = TRUE
// --------

// Shuttle airlock
/obj/effect/map_effect/marker/airlock/shuttle/crumbling_station_shuttle
	name = "airlock_crumbling_shuttle"
	master_tag = "airlock_crumbling_shuttle"
	shuttle_tag = "Independent Shuttle"
	cycle_to_external_air = TRUE
// --------

// Shuttle docking port
/obj/effect/map_effect/marker/airlock/docking/crumbling_station_shuttle_port
	name = "Shuttle Dock"
	landmark_tag = "nav_hangar_crumbling"
	master_tag = "crumbling_shuttle_dock"
// --------

// Secondary shuttle airlock
/obj/effect/map_effect/marker/airlock/crumbling_station/shuttle
	name = "Secondary Airlock"
	master_tag = "airlock_crumbling_station_shuttle"
	cycle_to_external_air = TRUE
// --------

// Hangar marker.
/obj/effect/shuttle_landmark/crumbling_station_shuttle/hangar
	name = "Auxiliary Hangar"
	landmark_tag = "nav_hangar_crumbling"
	docking_controller = "crumbling_shuttle_dock"
	base_area = /area/space
	base_turf = /turf/space
	movable_flags = MOVABLE_FLAG_EFFECTMOVE
// --------

// Transit marker.
/obj/effect/shuttle_landmark/crumbling_station_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_crumbling_shuttle"
	base_turf = /turf/space/transit/north
// --------

// Control console.
/obj/machinery/computer/shuttle_control/explore/terminal/crumbling_station
	name = "shuttle control console"
	shuttle_tag = "Crumbling Station Shuttle"
// --------
