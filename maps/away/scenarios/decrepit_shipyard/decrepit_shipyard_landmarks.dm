//---- Base types

/obj/effect/shuttle_landmark/decrepit_shipyard
	base_area = /area/space
	base_turf = /turf/space

// Upper deck docking landmarks

// ----
// Docking arm
// ----

/obj/effect/shuttle_landmark/decrepit_shipyard/upper/dock_1a
	name = "Docking Arm, South-West, 1a"
	landmark_tag = "nav_decrepit_shipyard_dock_1a"
	docking_controller = "airlock_decrepit_shipyard_dock_1a"
	dir = NORTH

/obj/effect/map_effect/marker/airlock/docking/decrepit_shipyard/upper/dock_1a
	name = "Docking Arm, South-West, 1a"
	landmark_tag = "nav_decrepit_shipyard_dock_1a"
	master_tag = "airlock_decrepit_shipyard_dock_1a"

// ----

/obj/effect/shuttle_landmark/decrepit_shipyard/upper/dock_1b
	name = "Docking Arm, South-West, 1b"
	landmark_tag = "nav_decrepit_shipyard_dock_1b"
	docking_controller = "airlock_decrepit_shipyard_dock_1b"
	dir = WEST

/obj/effect/map_effect/marker/airlock/docking/decrepit_shipyard/upper/dock_1b
	name = "Docking Arm, South-West, 1b"
	landmark_tag = "nav_decrepit_shipyard_dock_1b"
	master_tag = "airlock_decrepit_shipyard_dock_1b"

// ----

/obj/effect/shuttle_landmark/decrepit_shipyard/upper/dock_1c
	name = "Docking Arm, South-West, 1c"
	landmark_tag = "nav_decrepit_shipyard_dock_1c"
	docking_controller = "airlock_decrepit_shipyard_dock_1c"
	base_area = /area/decrepit_shipyard/exterior
	base_turf = /turf/simulated/floor/reinforced/airless
	dir = SOUTH

/obj/effect/map_effect/marker/airlock/docking/decrepit_shipyard/upper/dock_1c
	name = "Docking Arm, South-West, 1c"
	landmark_tag = "nav_decrepit_shipyard_dock_1c"
	master_tag = "airlock_decrepit_shipyard_dock_1c"

// ----

/obj/effect/shuttle_landmark/decrepit_shipyard/upper/dock_1d
	name = "Docking Arm, South-West, 1d"
	landmark_tag = "nav_decrepit_shipyard_dock_1d"
	docking_controller = "airlock_decrepit_shipyard_dock_1d"
	dir = EAST

/obj/effect/map_effect/marker/airlock/docking/decrepit_shipyard/upper/dock_1d
	name = "Docking Arm, South-West, 1d"
	landmark_tag = "nav_decrepit_shipyard_dock_1d"
	master_tag = "airlock_decrepit_shipyard_dock_1d"

// ----
// Visitors docking
// ----

/obj/effect/shuttle_landmark/decrepit_shipyard/upper/dock_2a
	name = "Visitors Dock, South-East, 2a"
	landmark_tag = "nav_decrepit_shipyard_dock_2a"
	docking_controller = "airlock_decrepit_shipyard_dock_2a"
	dir = NORTH

/obj/effect/map_effect/marker/airlock/docking/decrepit_shipyard/upper/dock_2a
	name = "Visitors Dock, South-East, 2a"
	landmark_tag = "nav_decrepit_shipyard_dock_2a"
	master_tag = "airlock_decrepit_shipyard_dock_2a"

// ----

/obj/effect/shuttle_landmark/decrepit_shipyard/upper/dock_2b
	name = "Visitors Dock, South-East, 2b"
	landmark_tag = "nav_decrepit_shipyard_dock_2b"
	docking_controller = "airlock_decrepit_shipyard_dock_2b"
	dir = WEST

/obj/effect/map_effect/marker/airlock/docking/decrepit_shipyard/upper/dock_2b
	name = "Visitors Dock, South-East, 2b"
	landmark_tag = "nav_decrepit_shipyard_dock_2b"
	master_tag = "airlock_decrepit_shipyard_dock_2b"

// ----

/obj/effect/shuttle_landmark/decrepit_shipyard/upper/dock_2c
	name = "Visitors Dock, South-East, 2c"
	landmark_tag = "nav_decrepit_shipyard_dock_2c"
	docking_controller = "airlock_decrepit_shipyard_dock_2c"
	dir = EAST

/obj/effect/map_effect/marker/airlock/docking/decrepit_shipyard/upper/dock_2c
	name = "Visitors Dock, South-East, 2c"
	landmark_tag = "nav_decrepit_shipyard_dock_2c"
	master_tag = "airlock_decrepit_shipyard_dock_2c"

// Lower deck non-docking landmarks

// ----
// Dry dock
// ----

/obj/effect/shuttle_landmark/decrepit_shipyard/lower/dock_3a
	name = "Dry Dock, #06-F, 3a"
	landmark_tag = "nav_decrepit_shipyard_dock_3a"
	dir = NORTH

// ----

/obj/effect/shuttle_landmark/decrepit_shipyard/lower/dock_3b
	name = "Dry Dock, #06-F, 3b"
	landmark_tag = "nav_decrepit_shipyard_dock_3b"
	dir = WEST

// ----

/obj/effect/shuttle_landmark/decrepit_shipyard/lower/dock_3c
	name = "Dry Dock, #06-F, 3c"
	landmark_tag = "nav_decrepit_shipyard_dock_3c"
	dir = SOUTH

// ----

/obj/effect/shuttle_landmark/decrepit_shipyard/lower/dock_3d
	name = "Dry Dock, #06-F, 3d"
	landmark_tag = "nav_decrepit_shipyard_dock_3d"
	dir = EAST

// ----
// Space
// ----

/obj/effect/shuttle_landmark/decrepit_shipyard/lower/space_4a
	name = "Space, South"
	landmark_tag = "nav_decrepit_shipyard_space_4a"
	dir = NORTH

/obj/effect/shuttle_landmark/decrepit_shipyard/lower/space_4b
	name = "Space, East"
	landmark_tag = "nav_decrepit_shipyard_space_4b"
	dir = WEST

/obj/effect/shuttle_landmark/decrepit_shipyard/lower/space_4c
	name = "Space, North"
	landmark_tag = "nav_decrepit_shipyard_space_4c"
	dir = SOUTH

/obj/effect/shuttle_landmark/decrepit_shipyard/lower/space_4d
	name = "Space, West"
	landmark_tag = "nav_decrepit_shipyard_space_4d"
	dir = EAST

// Airlocks

// Upper deck

/obj/effect/map_effect/marker/airlock/decrepit_shipyard/upper/west
	name = "West Airlock"
	master_tag = "airlock_decrepit_shipyard_upper_west"

/obj/effect/map_effect/marker/airlock/decrepit_shipyard/upper/north_east
	name = "North-East Airlock"
	master_tag = "airlock_decrepit_shipyard_upper_north_east"

/obj/effect/map_effect/marker/airlock/decrepit_shipyard/upper/south_east
	name = "South-East Airlock"
	master_tag = "airlock_decrepit_shipyard_upper_south_east"

// Lower deck

/obj/effect/map_effect/marker/airlock/decrepit_shipyard/lower/main
	name = "Dry Dock Supply Airlock"
	master_tag = "airlock_decrepit_shipyard_lower_main"

/obj/effect/map_effect/marker/airlock/decrepit_shipyard/lower/secondary
	name = "Dry Dock Secondary Airlock"
	master_tag = "airlock_decrepit_shipyard_lower_secondary"

/obj/effect/map_effect/marker/airlock/decrepit_shipyard/lower/south
	name = "South Airlock"
	master_tag = "airlock_decrepit_shipyard_lower_south"

/obj/effect/map_effect/marker/airlock/decrepit_shipyard/lower/workshop
	name = "Dry Dock Workshop Airlock"
	master_tag = "airlock_decrepit_shipyard_lower_workshop"
