// Staffpod Lift
/area/turbolift/ringstation/staffpod_lift
	name = "Staffpod Lift"

/datum/shuttle/autodock/multi/lift/ringstation
	name = "Staffpod Lift"
	current_location = "nav_ringstation_lift_z1"
	shuttle_area = /area/turbolift/ringstation/staffpod_lift
	destination_tags = list(
		"nav_ringstation_lift_z1",
		"nav_ringstation_lift_z2",
		"nav_ringstation_lift_z3"
		)

/obj/effect/shuttle_landmark/lift/ringstation_z1
	name = "Ringstation - Staffpod Lift - Bottom"
	landmark_tag = "nav_ringstation_lift_z1"
	base_area = /area/ringstation/z1/cryogenics
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/lift/ringstation_z2
	name = "Ringstation - Staffpod Lift - Middle"
	landmark_tag = "nav_ringstation_lift_z2"
	base_area = /area/ringstation/z2/staffpod
	base_turf = /turf/simulated/open

/obj/effect/shuttle_landmark/lift/ringstation_z3
	name = "Ringstation - Staffpod Lift - Top"
	landmark_tag = "nav_ringstation_lift_z3"
	base_area = /area/ringstation/z3/station_control_room
	base_turf = /turf/simulated/open

/obj/machinery/computer/shuttle_control/multi/lift/ringstation
	shuttle_tag = "Staffpod Lift"

// Landing Spots - Bases

/obj/effect/shuttle_landmark/ringstation
	base_area = /area/space
	base_turf = /turf/space

/obj/effect/shuttle_landmark/ringstation/roof
	base_area = /area/ringstation/exterior/roof
	base_turf = /turf/simulated/floor/reinforced/airless

/obj/effect/shuttle_landmark/ringstation/hangar
	base_area = /area/ringstation/z2/supply/hangar
	base_turf = /turf/simulated/floor/plating

// Landing Spots - Far Exterior
/obj/effect/shuttle_landmark/ringstation/north_z1
	name = "Ringstation - Exterior Shuttle Tetherpoint - North, Below Station"
	landmark_tag = "nav_ringstation_shuttle_exterior_north_z1"
	dir = SOUTH

/obj/effect/shuttle_landmark/ringstation/east_z1
	name = "Ringstation - Exterior Shuttle Tetherpoint - East, Below Station"
	landmark_tag = "nav_ringstation_shuttle_exterior_east_z1"
	dir = SOUTH

/obj/effect/shuttle_landmark/ringstation/south_z1
	name = "Ringstation - Exterior - Shuttle Tetherpoint, South, Below Station"
	landmark_tag = "nav_ringstation_shuttle_exterior_south_z1"
	dir = NORTH

/obj/effect/shuttle_landmark/ringstation/west_z1
	name = "Ringstation - Exterior Shuttle Tetherpoint - West, Below Station"
	landmark_tag = "nav_ringstation_shuttle_exterior_west_z1"
	dir = NORTH

/obj/effect/shuttle_landmark/ringstation/north_z2
	name = "Ringstation - Exterior Shuttle Tetherpoint - North"
	landmark_tag = "nav_ringstation_shuttle_exterior_north_z2"
	dir = SOUTH

/obj/effect/shuttle_landmark/ringstation/east_z2
	name = "Ringstation - Exterior Shuttle Tetherpoint - East"
	landmark_tag = "nav_ringstation_shuttle_exterior_east_z2"
	dir = SOUTH

/obj/effect/shuttle_landmark/ringstation/south_z2
	name = "Ringstation - Exterior Shuttle Tetherpoint - South"
	landmark_tag = "nav_ringstation_shuttle_exterior_south_z2"
	dir = NORTH

/obj/effect/shuttle_landmark/ringstation/west_z2
	name = "Ringstation - Exterior Shuttle Tetherpoint - West"
	landmark_tag = "nav_ringstation_shuttle_exterior_west_z2"
	dir = NORTH

/obj/effect/shuttle_landmark/ringstation/north_z3
	name = "Ringstation - Exterior Shuttle Tetherpoint - North, Above Station"
	landmark_tag = "nav_ringstation_shuttle_exterior_north_z3"
	dir = SOUTH

/obj/effect/shuttle_landmark/ringstation/east_z3
	name = "Ringstation - Exterior Shuttle Tetherpoint - East, Above Station"
	landmark_tag = "nav_ringstation_shuttle_exterior_east_z3"
	dir = SOUTH

/obj/effect/shuttle_landmark/ringstation/south_z3
	name = "Ringstation - Exterior Shuttle Tetherpoint - South, Above Station"
	landmark_tag = "nav_ringstation_shuttle_exterior_south_z3"
	dir = NORTH

/obj/effect/shuttle_landmark/ringstation/west_z3
	name = "Ringstation - Exterior Shuttle Tetherpoint - West, Above Station"
	landmark_tag = "nav_ringstation_shuttle_exterior_west_z3"
	dir = NORTH

// Landing Spots - Docks
/obj/effect/shuttle_landmark/ringstation/north_dock_a
	name = "Ringstation - North Dock - Airlock A"
	landmark_tag = "nav_ringstation_shuttle_dock_north_a"
	dir = SOUTH

/obj/effect/shuttle_landmark/ringstation/roof/north_dock_b
	name = "Ringstation - North Dock - Airlock B"
	landmark_tag = "nav_ringstation_shuttle_dock_north_b"
	dir = NORTH

/obj/effect/shuttle_landmark/ringstation/south_dock_a
	name = "Ringstation - South Dock - Airlock A"
	landmark_tag = "nav_ringstation_shuttle_dock_south_a"
	dir = NORTH

/obj/effect/shuttle_landmark/ringstation/roof/south_dock_b
	name = "Ringstation - South Dock - Airlock B"
	landmark_tag = "nav_ringstation_shuttle_dock_south_b"
	dir = SOUTH

/obj/effect/shuttle_landmark/ringstation/west_dock_a
	name = "Ringstation - West Dock - Airlock A"
	landmark_tag = "nav_ringstation_shuttle_dock_west_a"
	dir = NORTH

/obj/effect/shuttle_landmark/ringstation/west_dock_b
	name = "Ringstation - West Dock - Airlock B"
	landmark_tag = "nav_ringstation_shuttle_dock_west_b"
	dir = EAST

/obj/effect/shuttle_landmark/ringstation/west_dock_c
	name = "Ringstation - West Dock - Airlock C"
	landmark_tag = "nav_ringstation_shuttle_dock_west_c"
	dir = SOUTH

/obj/effect/shuttle_landmark/ringstation/west_dock_d
	name = "Ringstation - West Dock - Airlock D"
	landmark_tag = "nav_ringstation_shuttle_dock_west_d"
	dir = WEST

// Landing Spot - Hangar

/obj/effect/shuttle_landmark/ringstation/hangar/a
	name = "Ringstation - Supply Hangar - Landing Spot"
	landmark_tag = "nav_ringstation_shuttle_hangar"
	dir = NORTH
