// --------------------- base type

/obj/effect/shuttle_landmark/database_freighter

// --------------------- shuttle

/obj/effect/shuttle_landmark/database_freighter_shuttle/hangar
	name = "Database Freighter Shuttle Hangar"
	landmark_tag = "nav_database_freighter_shuttle"
	docking_controller = "database_freighter_shuttle_dock"
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

// ----

/obj/effect/shuttle_landmark/database_freighter_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_database_freighter_shuttle"

// --------------------- docks

/obj/effect/shuttle_landmark/database_freighter/dock/aft
	name = "Dock, Aft"
	landmark_tag = "nav_database_freighter_dock_aft"
	docking_controller = "airlock_database_freighter_dock_aft"

/obj/effect/map_effect/marker/airlock/docking/database_freighter/dock/aft
	name = "Dock, Aft"
	landmark_tag = "nav_database_freighter_dock_aft"
	master_tag = "airlock_database_freighter_aft"
