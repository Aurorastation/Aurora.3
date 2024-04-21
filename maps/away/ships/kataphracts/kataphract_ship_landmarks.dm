/obj/effect/shuttle_landmark/nav_kataphract_ship
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/nav_kataphract_ship/nav1
	name = "Kataphract Ship Navpoint #1"
	landmark_tag = "nav_kataphract_ship_1"

/obj/effect/shuttle_landmark/nav_kataphract_ship/nav2
	name = "Kataphract Ship Navpoint #2"
	landmark_tag = "nav_kataphract_ship_2"

/obj/effect/shuttle_landmark/nav_kataphract_ship/nav3
	name = "Kataphract Ship Navpoint #3"
	landmark_tag = "nav_kataphract_ship_3"

/obj/effect/shuttle_landmark/nav_kataphract_ship/nav4
	name = "Kataphract Ship Navpoint #4"
	landmark_tag = "nav_kataphract_ship_4"

/obj/effect/shuttle_landmark/nav_kataphract_ship/nav5
	name = "Kataphract Ship Navpoint #5"
	landmark_tag = "nav_kataphract_ship_5"

/obj/effect/shuttle_landmark/nav_kataphract_ship/starboard
	name = "Kataphract Ship Starboard Dock"
	landmark_tag = "nav_kataphract_ship_starboard"
    master_tag = "airlock_kataphract_ship_starboard"

/obj/effect/shuttle_landmark/nav_kataphract_ship/port
	name = "Kataphract Ship Starboard Dock"
	landmark_tag = "nav_kataphract_ship_port"

/obj/effect/map_effect/marker/airlock/docking/airlock_kataphract_ship/port
	name = "Kataphract Ship Port Dock"
	landmark_tag = "nav_kataphract_ship_port"
	master_tag = "airlock_kataphract_ship_port"

/obj/effect/shuttle_landmark/nav_kataphract_ship/dockintrepid // restricted for the intrepid only or else other ships will be able to use this point, and not properly dock
	name = "Kataphract Ship Intrepid Starboard Docking"
	landmark_tag = "nav_kataphract_ship_dockintrepid"
