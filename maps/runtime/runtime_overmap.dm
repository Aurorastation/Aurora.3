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

/obj/machinery/computer/shuttle_control/explore/terminal/runtime
	name = "whiletrue control console"
	shuttle_tag = "WhileTrue"

/area/shuttle/runtime
	name = "While True"
	base_turf = /turf/simulated/floor/shuttle/black

/datum/shuttle/autodock/overmap/runtime
	name = "WhileTrue"
	move_time = 90
	shuttle_area = list(/area/shuttle/runtime)
	dock_target = "airlock_runtime_shuttle"
	current_location = "nav_runtime_dock"
	landmark_transition = "nav_transit_runtime"
	logging_home_tag = "nav_runtime_dock"
	range = 1
	fuel_consumption = 4
	ceiling_type = /turf/simulated/floor/shuttle_ceiling

/obj/effect/shuttle_landmark/runtime/dock
	name = "Runtime Dock"
	landmark_tag = "nav_runtime_dock"
	docking_controller = "nav_runtime_dock"
	base_area = /area/exterior
	base_turf = /turf/simulated/floor/airless
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

// runtime dock airlocks
/obj/effect/map_effect/marker/airlock/docking/runtime/dock
	name = "Shuttle Dock"
	landmark_tag = "nav_runtime_dock"
	master_tag = "nav_runtime_dock"

// runtime shuttle airlocks
/obj/effect/map_effect/marker/airlock/shuttle/runtime
	name = "WhileTrue"
	shuttle_tag = "WhileTrue"
	master_tag = "airlock_runtime_shuttle"
	cycle_to_external_air = TRUE

/obj/effect/shuttle_landmark/runtime/transit
	name = "In transit"
	landmark_tag = "nav_transit_runtime"
