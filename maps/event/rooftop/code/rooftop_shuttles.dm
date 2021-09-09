/datum/shuttle/autodock/ferry/city
	name = "City Transit Shuttle"
	location = 1
	warmup_time = 10
	shuttle_area = /area/shuttle/city
	move_time = 50
	dock_target = "city_shuttle"
	waypoint_station = "nav_city_dock"
	landmark_transition = "nav_city_interim"
	waypoint_offsite = "nav_city_start"

/obj/effect/shuttle_landmark/city/start
	name = "Transit Station Pad"
	landmark_tag = "nav_city_start"
	docking_controller = "city_station"
	base_turf = /turf/space/dynamic
	base_area = /area/template_noop

/obj/effect/shuttle_landmark/city/interim
	name = "In Transit"
	landmark_tag = "nav_city_interim"
	base_turf = /turf/space/transit/west

/obj/effect/shuttle_landmark/city/dock
	name = "Cosmopolitan Shuttle Dock"
	landmark_tag = "nav_city_dock"
	docking_controller = "merchant_shuttle_dock"
	landmark_flags = SLANDMARK_FLAG_AUTOSET