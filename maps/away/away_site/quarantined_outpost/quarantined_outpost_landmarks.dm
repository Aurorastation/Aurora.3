//---- Base types

/obj/effect/shuttle_landmark/quarantined_outpost
	base_area = /area/space
	base_turf = /turf/space

/obj/effect/shuttle_landmark/quarantined_outpost/asteroid
	base_area = /area/space
	base_turf = /turf/simulated/floor/exoplanet/asteroid/ash/rocky

/obj/effect/shuttle_landmark/quarantined_outpost/shuttle_transit
	name = "In transit"
	landmark_tag = "nav_quarantined_outpost_shuttle_transit"
	base_turf = /turf/space/transit/north
	dir = NORTH

// ---- Inner docking zones

// ---- left side

/obj/effect/shuttle_landmark/quarantined_outpost/asteroid/landing_1a
	name = "Asteroid, Landing Zone, 1a"
	landmark_tag = "nav_quarantined_outpost_asteroid_1a"
	dir = NORTH

/obj/effect/shuttle_landmark/quarantined_outpost/asteroid/landing_1b
	name = "Asteroid, Landing Zone, 1b"
	landmark_tag = "nav_quarantined_outpost_asteroid_1b"
	dir = SOUTH

/obj/effect/shuttle_landmark/quarantined_outpost/asteroid/landing_1c
	name = "Asteroid, Landing Zone, 1c"
	landmark_tag = "nav_quarantined_outpost_asteroid_1c"
	dir = EAST

/obj/effect/shuttle_landmark/quarantined_outpost/asteroid/landing_1d
	name = "Asteroid, Landing Zone, 1d"
	landmark_tag = "nav_quarantined_outpost_asteroid_1d"
	dir = WEST

// ---- right side

/obj/effect/shuttle_landmark/quarantined_outpost/asteroid/landing_2a
	name = "Asteroid, Landing Zone, 2a"
	landmark_tag = "nav_quarantined_outpost_asteroid_2a"
	dir = NORTH

/obj/effect/shuttle_landmark/quarantined_outpost/asteroid/landing_2b
	name = "Asteroid, Landing Zone, 2b"
	landmark_tag = "nav_quarantined_outpost_asteroid_2b"
	dir = SOUTH

/obj/effect/shuttle_landmark/quarantined_outpost/asteroid/landing_2c
	name = "Asteroid, Landing Zone, 2c"
	landmark_tag = "nav_quarantined_outpost_asteroid_2c"
	dir = EAST

/obj/effect/shuttle_landmark/quarantined_outpost/asteroid/landing_2d
	name = "Asteroid, Landing Zone, 2d"
	landmark_tag = "nav_quarantined_outpost_asteroid_2d"
	dir = WEST

// ---- Space

/obj/effect/shuttle_landmark/quarantined_outpost/space/space_1a
	name = "Space, 1a"
	landmark_tag = "nav_quarantined_outpost_space_1a"
	dir = NORTH

/obj/effect/shuttle_landmark/quarantined_outpost/space/space_1b
	name = "Space, 1b"
	landmark_tag = "nav_quarantined_outpost_space_1b"
	dir = SOUTH

/obj/effect/shuttle_landmark/quarantined_outpost/space/space_1c
	name = "Space, 1c"
	landmark_tag = "nav_quarantined_outpost_space_1c"
	dir = EAST

/obj/effect/shuttle_landmark/quarantined_outpost/space/space_1d
	name = "Space, 1d"
	landmark_tag = "nav_quarantined_outpost_space_1d"
	dir = WEST

// ----

/obj/effect/shuttle_landmark/quarantined_outpost/space/space_2a
	name = "Space, 2a"
	landmark_tag = "nav_quarantined_outpost_space_2a"
	dir = NORTH

/obj/effect/shuttle_landmark/quarantined_outpost/space/space_2b
	name = "Space, 2b"
	landmark_tag = "nav_quarantined_outpost_space_2b"
	dir = SOUTH

/obj/effect/shuttle_landmark/quarantined_outpost/space/space_2c
	name = "Space, 2c"
	landmark_tag = "nav_quarantined_outpost_space_2c"
	dir = EAST

/obj/effect/shuttle_landmark/quarantined_outpost/space/space_2d
	name = "Space, 2d"
	landmark_tag = "nav_quarantined_outpost_space_2d"
	dir = WEST

// Airlocks

/obj/effect/map_effect/marker/airlock/quarantined_outpost/entrance
	name = "Entrance"
	master_tag = "airlock_quarantined_outpost_entrance"

/obj/effect/map_effect/marker/airlock/quarantined_outpost/mining
	name = "Excavation Sector"
	master_tag = "airlock_quarantined_outpost_mining"


