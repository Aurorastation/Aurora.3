/obj/effect/shuttle_landmark/nuclear_silo
	base_area = /area/nuclear_silo/outside/landing
	base_turf = /turf/simulated/floor/exoplanet/dirt_konyang

// --- Lift
/datum/shuttle/autodock/multi/lift/nuclear_silo
	name = "Bunker Lift"
	current_location = "nav_nuclear_silo_lift_upper_level"
	shuttle_area = /area/turbolift/nuclear_silo/bunker_lift
	destination_tags = list(
		"nav_nuclear_silo_lift_lower_level",
		"nav_nuclear_silo_lift_upper_level",
		)

/obj/effect/shuttle_landmark/lift/nuclear_silo_lower_level
	name = "Nuclear Missile Silo Bunker - Lower Level"
	landmark_tag = "nav_nuclear_silo_lift_lower_level"
	base_area = /area/nuclear_silo/lower_level_lift
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/lift/nuclear_silo_upper_level
	name = "Nuclear Missile Silo Bunker - Upper Level"
	landmark_tag = "nav_nuclear_silo_lift_upper_level"
	base_area = /area/nuclear_silo/upper_level_lift
	base_turf = /turf/simulated/open

/obj/machinery/computer/shuttle_control/multi/lift/nuclear_silo
	shuttle_tag = "Bunker Lift"

// --------------------- surface, South

/obj/effect/shuttle_landmark/nuclear_silo/surface/south_1a
	name = "Surface, Landing Pad, South, 1a"
	landmark_tag = "nav_nuclear_silo_surface_south_1a"
	dir = NORTH

/obj/effect/shuttle_landmark/nuclear_silo/surface/south_1b
	name = "Surface, Landing Pad, South, 1b"
	landmark_tag = "nav_nuclear_silo_surface_south_1b"
	dir = SOUTH

/obj/effect/shuttle_landmark/nuclear_silo/surface/south_1c
	name = "Surface, Landing Pad, South, 1c"
	landmark_tag = "nav_nuclear_silo_surface_south_1c"
	dir = EAST

/obj/effect/shuttle_landmark/nuclear_silo/surface/south_1d
	name = "Surface, Landing Pad, South, 1d"
	landmark_tag = "nav_nuclear_silo_surface_south_1d"
	dir = WEST

// ----

/obj/effect/shuttle_landmark/nuclear_silo/surface/south_2a
	name = "Surface, Landing Pad, South, 2a"
	landmark_tag = "nav_nuclear_silo_surface_south_2a"
	dir = NORTH

/obj/effect/shuttle_landmark/nuclear_silo/surface/south_2b
	name = "Surface, Landing Pad, South, 2b"
	landmark_tag = "nav_nuclear_silo_surface_south_2b"
	dir = SOUTH

/obj/effect/shuttle_landmark/nuclear_silo/surface/south_2c
	name = "Surface, Landing Pad, South, 2c"
	landmark_tag = "nav_nuclear_silo_surface_south_2c"
	dir = EAST

/obj/effect/shuttle_landmark/nuclear_silo/surface/south_2d
	name = "Surface, Landing Pad, South, 2d"
	landmark_tag = "nav_nuclear_silo_surface_south_2d"
	dir = WEST

// --------------------- surface, North

/obj/effect/shuttle_landmark/nuclear_silo/surface/north_1a
	name = "Surface, Landing Pad, North, 1a"
	landmark_tag = "nav_nuclear_silo_surface_north_1a"
	dir = NORTH

/obj/effect/shuttle_landmark/nuclear_silo/surface/north_1b
	name = "Surface, Landing Pad, North, 1b"
	landmark_tag = "nav_nuclear_silo_surface_north_1b"
	dir = SOUTH

/obj/effect/shuttle_landmark/nuclear_silo/surface/north_1c
	name = "Surface, Landing Pad, North, 1c"
	landmark_tag = "nav_nuclear_silo_surface_north_1c"
	dir = EAST

/obj/effect/shuttle_landmark/nuclear_silo/surface/north_1d
	name = "Surface, Landing Pad, North, 1d"
	landmark_tag = "nav_nuclear_silo_surface_north_1d"
	dir = WEST

// ----

/obj/effect/shuttle_landmark/nuclear_silo/surface/north_2a
	name = "Surface, Landing Pad, North, 2a"
	landmark_tag = "nav_nuclear_silo_surface_north_2a"
	dir = NORTH

/obj/effect/shuttle_landmark/nuclear_silo/surface/north_2b
	name = "Surface, Landing Pad, North, 2b"
	landmark_tag = "nav_nuclear_silo_surface_north_2b"
	dir = SOUTH

/obj/effect/shuttle_landmark/nuclear_silo/surface/north_2c
	name = "Surface, Landing Pad, North, 2c"
	landmark_tag = "nav_nuclear_silo_surface_north_2c"
	dir = EAST

/obj/effect/shuttle_landmark/nuclear_silo/surface/north_2d
	name = "Surface, Landing Pad, North, 2d"
	landmark_tag = "nav_nuclear_silo_surface_north_2d"
	dir = WEST

// ----

/obj/effect/shuttle_landmark/nuclear_silo/surface/north_3a
	name = "Surface, Landing Pad, North, 3a"
	landmark_tag = "nav_nuclear_silo_surface_north_3a"
	dir = NORTH

/obj/effect/shuttle_landmark/nuclear_silo/surface/north_3b
	name = "Surface, Landing Pad, North, 3b"
	landmark_tag = "nav_nuclear_silo_surface_north_3b"
	dir = SOUTH

/obj/effect/shuttle_landmark/nuclear_silo/surface/north_3c
	name = "Surface, Landing Pad, North, 3c"
	landmark_tag = "nav_nuclear_silo_surface_north_3c"
	dir = EAST

/obj/effect/shuttle_landmark/nuclear_silo/surface/north_3d
	name = "Surface, Landing Pad, North, 3d"
	landmark_tag = "nav_nuclear_silo_surface_north_3d"
	dir = WEST
