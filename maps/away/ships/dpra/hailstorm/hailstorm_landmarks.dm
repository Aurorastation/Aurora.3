// --------------------- base type

/obj/effect/shuttle_landmark/hailstorm_ship
	base_area = /area/space
	base_turf = /turf/space

// --------------------- shuttle

/obj/effect/shuttle_landmark/hailstorm_shuttle/hangar
	name = "Spacer Militia Shuttle Hangar"
	landmark_tag = "nav_hailstorm_shuttle"
	docking_controller = "hailstorm_shuttle_dock"
	base_area = /area/space
	base_turf = /turf/space
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/map_effect/marker/airlock/docking/hailstorm_shuttle/shuttle_hangar
	name = "Spacer Militia Shuttle Hangar"
	landmark_tag = "nav_hailstorm_shuttle"
	master_tag = "hailstorm_shuttle_dock"

// ----

/obj/effect/shuttle_landmark/hailstorm_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_hailstorm_shuttle"
	base_turf = /turf/space/transit/north

// --------------------- docks

/obj/effect/shuttle_landmark/hailstorm_ship/dock/aft
	name = "Dock, Aft"
	landmark_tag = "nav_hailstorm_ship_starboard"
	docking_controller = "airlock_hailstorm_ship_starboard"

/obj/effect/map_effect/marker/airlock/docking/hailstorm_ship/dock/aft
	name = "Dock, Aft"
	landmark_tag = "nav_hailstorm_ship_dock_starboard"
	master_tag = "airlock_hailstorm_ship_starboard"
