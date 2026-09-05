/obj/effect/overmap/visitable/ship/runtime
	name = "NSS Runtime"
	class = "NSS"
	designation = "Runtime"
	desc = "A large cube-shaped station, a penal colony of sorts for the likes of video game developers."
	icon = 'icons/obj/overmap/overmap_stationary.dmi'
	icon_state = "runtime_penal_colony"
	moving_state = "runtime_penal_colony"
	colors = list("#f147cd", "#f79aea")
	vessel_mass = 100000
	burn_delay = 2 SECONDS
	base = TRUE

/obj/effect/overmap/visitable/ship/landable/runtime
	name = "NSV While True"
	class = "NSV"
	designation = "While True"
	desc = "A RUN-T1M3 long range shuttle."
	shuttle = "WhileTrue"
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = WEST
	vessel_size = SHIP_SIZE_SMALL

/obj/structure/machinery/computer/shuttle_control/explore/terminal/runtime
	name = "whiletrue control console"
	shuttle_tag = "WhileTrue"

/area/shuttle/runtime
	name = "While True"
	base_turf = /turf/simulated/floor/shuttle/black
	requires_power = TRUE

/datum/shuttle/autodock/overmap/runtime
	name = "WhileTrue"
	move_time = 90
	shuttle_area = list(/area/shuttle/runtime)
	dock_target = "airlock_runtime_shuttle"
	current_location = "nav_runtime_dock_north"
	landmark_transition = "nav_transit_runtime"
	logging_home_tag = "nav_runtime_dock_north"
	range = 1
	fuel_consumption = 4
	ceiling_type = /turf/simulated/floor/shuttle_ceiling

ABSTRACT_TYPE(/obj/effect/shuttle_landmark/runtime/dock)
	base_area = /area/space
	base_turf = /turf/simulated/floor/airless
	movable_flags = MOVABLE_FLAG_EFFECTMOVE
	auto_register = TRUE
	shuttle_restricted = "WhileTrue"

/obj/effect/shuttle_landmark/runtime/dock/north
	name = "Runtime Dock - North Facing"
	dir = NORTH
	landmark_tag = "nav_runtime_dock_north"
	docking_controller = "nav_runtime_dock_north"

/obj/effect/shuttle_landmark/runtime/dock/east
	name = "Runtime Dock - East Facing"
	dir = EAST
	landmark_tag = "nav_runtime_dock_east"
	docking_controller = "nav_runtime_dock_east"

/obj/effect/shuttle_landmark/runtime/dock/south
	name = "Runtime Dock - South Facing"
	dir = SOUTH
	landmark_tag = "nav_runtime_dock_south"
	docking_controller = "nav_runtime_dock_south"

/obj/effect/shuttle_landmark/runtime/dock/west
	name = "Runtime Dock - West Facing"
	dir = WEST
	landmark_tag = "nav_runtime_dock_west"
	docking_controller = "nav_runtime_dock_west"

// runtime dock airlocks
ABSTRACT_TYPE(/obj/effect/map_effect/marker/airlock/docking/runtime/dock)

/obj/effect/map_effect/marker/airlock/docking/runtime/dock/north
	name = "Shuttle Dock - North Facing"
	dir = NORTH
	landmark_tag = "nav_runtime_dock_north"
	master_tag = "nav_runtime_dock_north"

/obj/effect/map_effect/marker/airlock/docking/runtime/dock/east
	name = "Shuttle Dock - East Facing"
	dir = EAST
	landmark_tag = "nav_runtime_dock_east"
	master_tag = "nav_runtime_dock_east"

/obj/effect/map_effect/marker/airlock/docking/runtime/dock/south
	name = "Shuttle Dock - South Facing"
	dir = SOUTH
	landmark_tag = "nav_runtime_dock_south"
	master_tag = "nav_runtime_dock_south"

/obj/effect/map_effect/marker/airlock/docking/runtime/dock/west
	name = "Shuttle Dock - West Facing"
	dir = WEST
	landmark_tag = "nav_runtime_dock_west"
	master_tag = "nav_runtime_dock_west"

// runtime shuttle airlocks
/obj/effect/map_effect/marker/airlock/shuttle/runtime
	name = "WhileTrue"
	shuttle_tag = "WhileTrue"
	master_tag = "airlock_runtime_shuttle"
	cycle_to_external_air = TRUE

/obj/effect/shuttle_landmark/runtime/transit
	name = "In transit"
	landmark_tag = "nav_transit_runtime"
