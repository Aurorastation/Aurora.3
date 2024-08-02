/obj/effect/shuttle_landmark/fishing_trawler
	base_area = /area/space
	base_turf = /turf/space/dynamic

//Fore
/obj/effect/shuttle_landmark/fishing_trawler/fore
	name = "Fishing Trawler - Fore"
	landmark_tag = "fishing_trawler_fore"

//Mid

/obj/effect/shuttle_landmark/fishing_trawler/port
	name = "Fishing Trawler - Port"
	landmark_tag = "fishing_trawler_port"

/obj/effect/shuttle_landmark/fishing_trawler/port_dock
	name = "Fishing Trawler - Port Dock"
	landmark_tag = "fishing_trawler_port_dock"
	docking_controller = "fishing_trawler_port_dock"

/obj/effect/shuttle_landmark/fishing_trawler/starboard
	name = "Fishing Trawler - Starboard"
	landmark_tag = "fishing_trawler_starboard"

/obj/effect/shuttle_landmark/fishing_trawler/starboard_dock
	name = "Fishing Trawler - Starboard Dock"
	landmark_tag = "fishing_trawler_starboard_dock"
	docking_controller = "fishing_trawler_starboard_dock"

//Aft

/obj/effect/shuttle_landmark/fishing_trawler/shuttle_dock
	name = "Fishing Trawler Shuttle Dock"
	landmark_tag = "fishing_trawler_shuttle"
	docking_controller = "fishing_trawler_shuttle_dock"
	movable_flags = MOVABLE_FLAG_EFFECTMOVE
	base_area = /area/space
	base_turf = /turf/space

/obj/effect/shuttle_landmark/fishing_trawler/aux_dock
	name = "Fishing Trawler - Auxiliary Dock"
	landmark_tag = "fishing_trawler_aux_dock"
	docking_controller = "fishing_trawler_aux_dock"

/obj/effect/shuttle_landmark/fishing_trawler/aft
	name = "Fishing Trawler - Aft"
	landmark_tag = "fishing_trawler_aft"

//Transit
/obj/effect/shuttle_landmark/fishing_trawler/transit
	name = "In transit"
	landmark_tag = "fishing_trawler_transit"
	base_turf = /turf/space/transit/north
	base_area = /area/space
