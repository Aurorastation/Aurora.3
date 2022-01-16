/datum/shuttle/autodock/ferry/city
	name = "City Transit Shuttle"
	location = 1
	warmup_time = 10
	shuttle_area = /area/shuttle/city
	move_time = 50
	dock_target = "City Transit Shuttle"
	waypoint_station = "nav_city_dock"
	landmark_transition = "nav_city_interim"
	waypoint_offsite = "nav_city_start"

/obj/effect/shuttle_landmark/city/start
	name = "City Shuttle Base"
	landmark_tag = "nav_city_start"
	docking_controller = "city_station"
	base_turf = /turf/unsimulated/floor/plating
	base_area = /area/city/mendell

/obj/effect/shuttle_landmark/city/interim
	name = "In Transit"
	landmark_tag = "nav_city_interim"
	base_turf = /turf/unsimulated/floor/plating
	base_area = /area/city/mendell

/obj/effect/shuttle_landmark/city/dock
	name = "city Shuttle Dock"
	landmark_tag = "nav_city_dock"
	docking_controller = "city_shuttle_dock"
	landmark_flags = SLANDMARK_FLAG_AUTOSET
	base_turf = /turf/unsimulated/floor/plating
	base_area = /area/city/mendell