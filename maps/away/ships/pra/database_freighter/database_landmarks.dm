// --------------------- base type

/obj/effect/shuttle_landmark/database_freighter
	base_area = /area/space
	base_turf = /turf/space

// --------------------- shuttle

/obj/effect/shuttle_landmark/database_freighter_shuttle/hangar
	name = "Database Freighter Shuttle Hangar"
	landmark_tag = "nav_database_freighter_shuttle"
	docking_controller = "database_freighter_shuttle_dock"
	base_area = /area/database_freighter/hangar
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

// ----

/obj/effect/shuttle_landmark/database_freighter_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_database_freighter_shuttle"
	base_turf = /turf/space/transit/north

// --------------------- docks

/obj/effect/shuttle_landmark/database_freighter/dock/aft
	name = "Dock, Aft"
	landmark_tag = "nav_database_freighter_dock_starboard"
	docking_controller = "airlock_database_freighter_dock_starboard"

/obj/effect/map_effect/marker/airlock/docking/database_freighter/dock/aft
	name = "Dock, Aft"
	landmark_tag = "nav_database_freighter_dock_starboard"
	master_tag = "airlock_database_freighter_starboard"
