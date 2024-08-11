// --------------------- base type

/obj/effect/shuttle_landmark/adhomian_circus
	base_area = /area/space
	base_turf = /turf/space

// --------------------- shuttle

/obj/effect/shuttle_landmark/adhomian_circus_shuttle/hangar
	name = "Adhomian Circus Shuttle Hangar"
	landmark_tag = "nav_hangar_adhomian_circus_shuttle"
	docking_controller = "adhomian_circus_shuttle_dock"
	base_area = /area/space
	base_turf = /turf/space
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

// ----

/obj/effect/shuttle_landmark/adhomian_circus_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_adhomian_circus_shuttle"
	base_turf = /turf/space/transit/north

// --------------------- docks

/obj/effect/shuttle_landmark/adhomian_circus/dock/port
	name = "Dock, Port"
	landmark_tag = "nav_adhomian_circus_dock_port"
	docking_controller = "airlock_adhomian_circus_dock_port"

/obj/effect/map_effect/marker/airlock/docking/adhomian_circus/dock/port
	name = "Dock, Port"
	landmark_tag = "nav_adhomian_circus_dock_port"
	master_tag = "airlock_adhomian_circus_port"
