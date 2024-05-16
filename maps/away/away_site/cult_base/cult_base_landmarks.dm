
// --------------------- base type

/obj/effect/shuttle_landmark/cult_base
	base_area = /area/space
	base_turf = /turf/space
	ghostspawners_to_activate_on_shuttle_arrival = list("cult_base_cultist")

/obj/effect/map_effect/marker/airlock/docking/cult_base
	req_one_access = null
	req_access = null

// --------------------- shuttle

/obj/effect/shuttle_landmark/cult_base/dock/hangar
	name = "Dock, Hangar"
	landmark_tag = "nav_cult_base_dock_hangar"
	docking_controller = "airlock_cult_base_dock_hangar"

/obj/effect/map_effect/marker/airlock/docking/cult_base/dock/hangar
	name = "Dock, Hangar"
	landmark_tag = "nav_cult_base_dock_hangar"
	master_tag = "airlock_cult_base_dock_hangar"

// ----

/obj/effect/shuttle_landmark/cult_base/shuttle_transit
	name = "In transit"
	landmark_tag = "nav_cult_base_shuttle_transit"
	base_turf = /turf/space/transit/north

// --------------------- docks

/obj/effect/shuttle_landmark/cult_base/dock/west_1
	name = "Dock, West 1"
	landmark_tag = "nav_cult_base_dock_west_1"
	docking_controller = "airlock_cult_base_dock_west_1"
	dir = EAST

/obj/effect/map_effect/marker/airlock/docking/cult_base/dock/west_1
	name = "Dock, West 1"
	landmark_tag = "nav_cult_base_dock_west_1"
	master_tag = "airlock_cult_base_dock_west_1"

// ----

/obj/effect/shuttle_landmark/cult_base/dock/west_2
	name = "Dock, West 2"
	landmark_tag = "nav_cult_base_dock_west_2"
	docking_controller = "airlock_cult_base_dock_west_2"
	dir = SOUTH

/obj/effect/map_effect/marker/airlock/docking/cult_base/dock/west_2
	name = "Dock, West 2"
	landmark_tag = "nav_cult_base_dock_west_2"
	master_tag = "airlock_cult_base_dock_west_2"

// ----

/obj/effect/shuttle_landmark/cult_base/dock/west_3
	name = "Dock, West 3"
	landmark_tag = "nav_cult_base_dock_west_3"
	docking_controller = "airlock_cult_base_dock_west_3"
	dir = NORTH

/obj/effect/map_effect/marker/airlock/docking/cult_base/dock/west_3
	name = "Dock, West 3"
	landmark_tag = "nav_cult_base_dock_west_3"
	master_tag = "airlock_cult_base_dock_west_3"

// ----

/obj/effect/shuttle_landmark/cult_base/dock/south_1
	name = "Dock, South 1"
	landmark_tag = "nav_cult_base_dock_south_1"
	docking_controller = "airlock_cult_base_dock_south_1"
	dir = NORTH

/obj/effect/map_effect/marker/airlock/docking/cult_base/dock/south_1
	name = "Dock, South 1"
	landmark_tag = "nav_cult_base_dock_south_1"
	master_tag = "airlock_cult_base_dock_south_1"

// ----

/obj/effect/shuttle_landmark/cult_base/dock/south_2
	name = "Dock, South 2"
	landmark_tag = "nav_cult_base_dock_south_2"
	docking_controller = "airlock_cult_base_dock_south_2"
	dir = WEST

/obj/effect/map_effect/marker/airlock/docking/cult_base/dock/south_2
	name = "Dock, South 2"
	landmark_tag = "nav_cult_base_dock_south_2"
	master_tag = "airlock_cult_base_dock_south_2"

// --------------------- space

/obj/effect/shuttle_landmark/cult_base/space/south_close
	name = "Space, South, Close"
	landmark_tag = "nav_cult_base_space_south_close"
	dir = NORTH

/obj/effect/shuttle_landmark/cult_base/space/west_close
	name = "Space, West, Far"
	landmark_tag = "nav_cult_base_space_west_close"
	dir = EAST

/obj/effect/shuttle_landmark/cult_base/space/south_far
	name = "Space, South, Far"
	landmark_tag = "nav_cult_base_space_south_far"
	dir = NORTH

/obj/effect/shuttle_landmark/cult_base/space/west_far
	name = "Space, West, Far"
	landmark_tag = "nav_cult_base_space_west_far"
	dir = EAST

/obj/effect/shuttle_landmark/cult_base/space/south_west_far
	name = "Space, South West, Far"
	landmark_tag = "nav_cult_base_space_south_west_far"
	dir = NORTH

// ---------------------
