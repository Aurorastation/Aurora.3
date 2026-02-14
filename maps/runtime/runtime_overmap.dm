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
	ship_area_type = /area/runtime

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

	ship_area_type = /area/shuttle/runtime

/obj/machinery/computer/shuttle_control/explore/runtime
	name = "whiletrue control console"
	shuttle_tag = "WhileTrue"
	req_access = list()

/area/shuttle/runtime
	name = "While True"

/datum/shuttle/overmap/runtime
	name = "WhileTrue"
	move_time = 90
	shuttle_area = list(/area/shuttle/runtime)
	dock_target = "runtime_shuttle"
	current_location = "nav_runtime_hangar"
	range = 1
	fuel_consumption = 4
	ceiling_baseturf = /turf/simulated/floor/shuttle_ceiling

/obj/effect/shuttle_landmark/runtime/hangar
	name = "Runtime Hangar"
	landmark_tag = "nav_runtime_hangar"

/obj/effect/shuttle_landmark/runtime/transit
	name = "In transit"
	landmark_tag = "nav_transit_runtime"
