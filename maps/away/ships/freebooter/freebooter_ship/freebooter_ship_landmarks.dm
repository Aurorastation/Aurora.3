
// ------------------ shuttle

/obj/effect/shuttle_landmark/freebooter_shuttle/hangar
	name = "Freebooter Shuttle Hangar"
	landmark_tag = "nav_hangar_freebooter"
	docking_controller = "freebooter_shuttle_dock"
	base_area = /area/ship/freebooter_ship
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/freebooter_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_freebooter_shuttle"
	base_turf = /turf/space/transit/north

// ------------------ other

/obj/effect/shuttle_landmark/freebooter_ship/nav1
	name = "Freebooter Ship - Port Side"
	landmark_tag = "nav_freebooter_ship_1"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/freebooter_ship/nav2
	name = "Freebooter Ship - Port Side"
	landmark_tag = "nav_freebooter_ship_2"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/freebooter_ship/transit
	name = "In transit"
	landmark_tag = "nav_transit_freebooter_ship"
	base_turf = /turf/space/transit/north
