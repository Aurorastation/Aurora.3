// ---- Base type
/obj/effect/shuttle_landmark/abandoned_casino
	base_area = /area/space
	base_turf = /turf/space

// ----
// Docking and airlock landmarks
// ----

// ---- Starboard
/obj/effect/shuttle_landmark/abandoned_casino/dock/starboard_1a
	name = "Docking Arm, Starboard, 1a"
	landmark_tag = "nav_abandoned_casino_dock_starboard_1a"
	docking_controller = "airlock_abandoned_casino_dock_starboard_1a"

/obj/effect/map_effect/marker/airlock/docking/abandoned_casino/starboard_1a
	name = "Docking Arm, Starboard, 1a"
	landmark_tag = "nav_abandoned_casino_dock_starboard_1a"
	master_tag = "airlock_abandoned_casino_dock_starboard_1a"

// ----

/obj/effect/shuttle_landmark/abandoned_casino/dock/starboard_1b
	name = "Docking Arm, Starboard, 1b"
	landmark_tag = "nav_abandoned_casino_dock_starboard_1b"
	docking_controller = "airlock_abandoned_casino_dock_starboard_1b"

/obj/effect/map_effect/marker/airlock/docking/abandoned_casino/starboard_1b
	name = "Docking Arm, Starboard, 1b"
	landmark_tag = "nav_abandoned_casino_dock_starboard_1b"
	master_tag = "airlock_abandoned_casino_dock_starboard_1b"

// ----

/obj/effect/shuttle_landmark/abandoned_casino/dock/starboard_1c
	name = "Docking Arm, Starboard, 1c"
	landmark_tag = "nav_abandoned_casino_dock_starboard_1c"
	docking_controller = "airlock_abandoned_casino_dock_starboard_1c"

/obj/effect/map_effect/marker/airlock/docking/abandoned_casino/starboard_1c
	name = "Docking Arm, Starboard, 1c"
	landmark_tag = "nav_abandoned_casino_dock_starboard_1c"
	master_tag = "airlock_abandoned_casino_dock_starboard_1c"

// ---- Port
/obj/effect/shuttle_landmark/abandoned_casino/dock/port_2a
	name = "Docking Arm, Port, 2a"
	landmark_tag = "nav_abandoned_casino_dock_port_2a"
	docking_controller = "airlock_abandoned_casino_dock_port_2a"

/obj/effect/map_effect/marker/airlock/docking/abandoned_casino/port_2a
	name = "Docking Arm, Port, 2a"
	landmark_tag = "nav_abandoned_casino_dock_port_2a"
	master_tag = "airlock_abandoned_casino_dock_port_2a"

// ----

/obj/effect/shuttle_landmark/abandoned_casino/dock/port_2b
	name = "Docking Arm, Port, 2b"
	landmark_tag = "nav_abandoned_casino_dock_port_2b"
	docking_controller = "airlock_abandoned_casino_dock_port_2b"

/obj/effect/map_effect/marker/airlock/docking/abandoned_casino/port_2b
	name = "Docking Arm, Port, 2b"
	landmark_tag = "nav_abandoned_casino_dock_port_2b"
	master_tag = "airlock_abandoned_casino_dock_port_2b"

// ---- Space
/obj/effect/shuttle_landmark/abandoned_casino/space_1a
	name = "Casino Station, North"
	landmark_tag = "nav_casino_1"
	dir = SOUTH

/obj/effect/shuttle_landmark/abandoned_casino/space_1b
	name = "Casino Station, West"
	landmark_tag = "nav_casino_2"
	dir = EAST

/obj/effect/shuttle_landmark/abandoned_casino/space_1c
	name = "Casino Station, South"
	landmark_tag = "nav_casino_3"
	dir = NORTH

/obj/effect/shuttle_landmark/abandoned_casino/space_1d
	name = "Casino Station, East"
	landmark_tag = "nav_casino_4"
	dir = WEST

// ----
// Non-docking airlock landmarks
// ----

/obj/effect/map_effect/marker/airlock/abandoned_casino/solars
	name = "Solar Array Access"
	master_tag = "airlock_abandoned_casino_solar"
