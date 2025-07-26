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

//---- Inner docking zones

// left side
/obj/effect/shuttle_landmark/quarantined_outpost/asteroid/landing_1a
	name = "Asteroid, Landing Zone, South 1"
	landmark_tag = "nav_quarantined_outpost_asteroid_south_1"
	dir = NORTH

/obj/effect/shuttle_landmark/quarantined_outpost/asteroid/landing_1b
	name = "Asteroid, Landing Zone, East 1"
	landmark_tag = "nav_quarantined_outpost_asteroid_east_1"
	dir = WEST

/obj/effect/shuttle_landmark/quarantined_outpost/asteroid/landing_1c
	name = "Asteroid, Landing Zone, West 1"
	landmark_tag = "nav_quarantined_outpost_asteroid_west_1"
	dir = EAST

// right side
/obj/effect/shuttle_landmark/quarantined_outpost/asteroid/landing_2a
	name = "Asteroid, Landing Zone, South 2"
	landmark_tag = "nav_quarantined_outpost_asteroid_south_2"
	dir = NORTH

/obj/effect/shuttle_landmark/quarantined_outpost/asteroid/landing_2b
	name = "Asteroid, Landing Zone, East 2"
	landmark_tag = "nav_quarantined_outpost_asteroid_east_2"
	dir = WEST

/obj/effect/shuttle_landmark/quarantined_outpost/asteroid/landing_2c
	name = "Asteroid, Landing Zone, West 2"
	landmark_tag = "nav_quarantined_outpost_asteroid_west_2"
	dir = EAST

//--- Space

//south
/obj/effect/shuttle_landmark/quarantined_outpost/space/south_1
	name = "Space, South, 1"
	landmark_tag = "nav_quarantined_outpost_space_south_1"
	dir = NORTH

/obj/effect/shuttle_landmark/quarantined_outpost/space/south_2
	name = "Space, South, 2"
	landmark_tag = "nav_quarantined_outpost_space_south_2"
	dir = NORTH

//north
/obj/effect/shuttle_landmark/quarantined_outpost/space/north_1
	name = "Space, North, 1"
	landmark_tag = "nav_quarantined_outpost_space_north_1"
	dir = SOUTH

/obj/effect/shuttle_landmark/quarantined_outpost/space/north_2
	name = "Space, North, 2"
	landmark_tag = "nav_quarantined_outpost_space_north_2"
	dir = SOUTH

//east
/obj/effect/shuttle_landmark/quarantined_outpost/space/east_1
	name = "Space, East, 1"
	landmark_tag = "nav_quarantined_outpost_space_east_1"
	dir = WEST

/obj/effect/shuttle_landmark/quarantined_outpost/space/east_2
	name = "Space, East, 2"
	landmark_tag = "nav_quarantined_outpost_space_east_2"
	dir = WEST

//west
/obj/effect/shuttle_landmark/quarantined_outpost/space/west_1
	name = "Space, West, 1"
	landmark_tag = "nav_quarantined_outpost_space_west_1"
	dir = EAST

/obj/effect/shuttle_landmark/quarantined_outpost/space/west_2
	name = "Space, West, 2"
	landmark_tag = "nav_quarantined_outpost_space_west_2"
	dir = EAST

// Airlocks

/obj/effect/map_effect/marker/airlock/quarantined_outpost/entrance
	name = "Entrance"
	master_tag = "airlock_quarantined_outpost_entrance"

/obj/effect/map_effect/marker/airlock/quarantined_outpost/mining
	name = "Excavation Sector"
	master_tag = "airlock_quarantined_outpost_mining"


