/datum/shuttle/ferry/city
	name = "City Transit Shuttle"
	location = 1
	warmup_time = 10 SECONDS
	shuttle_area = /area/shuttle/city
	move_time = 50
	dock_target = "City Transit Shuttle"
	waypoint_station = "nav_city_dock"
	waypoint_offsite = "nav_city_start"

/obj/effect/shuttle_landmark/city/start
	name = "City Shuttle Base"
	landmark_tag = "nav_city_start"
	docking_controller = "city_station"

/obj/effect/shuttle_landmark/city/interim
	name = "In Transit"
	landmark_tag = "nav_city_interim"

/obj/effect/shuttle_landmark/city/dock
	name = "city Shuttle Dock"
	landmark_tag = "nav_city_dock"
	docking_controller = "city_shuttle_dock"
