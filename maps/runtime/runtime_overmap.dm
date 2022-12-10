/obj/effect/overmap/visitable/ship/runtime
	name = "NSS Runtime"
	class = "NSS"
	designation = "Runtime"
	desc = "A large cube-shaped station, a penal colony of sorts for the likes of video game developers."
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

/obj/machinery/computer/shuttle_control/explore/runtime
	name = "whiletrue control console"
	shuttle_tag = "WhileTrue"
	req_access = list()

/area/shuttle/runtime
	name = "While True"
	base_turf = /turf/simulated/floor/shuttle/black

/datum/shuttle/autodock/overmap/runtime
	name = "WhileTrue"
	move_time = 90
	shuttle_area = list(/area/shuttle/runtime)
	dock_target = "runtime_shuttle"
	current_location = "nav_runtime_hangar"
	landmark_transition = "nav_transit_runtime"
	range = 1
	fuel_consumption = 4
	ceiling_type = /turf/simulated/floor/shuttle_ceiling

/obj/effect/shuttle_landmark/runtime/hangar
	name = "Runtime Hangar"
	landmark_tag = "nav_runtime_hangar"
	base_area = /area/construction
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/runtime/transit
	name = "In transit"
	landmark_tag = "nav_transit_runtime"