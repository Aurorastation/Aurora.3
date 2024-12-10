
// --- base type

/obj/effect/shuttle_landmark/bastion_station
	base_area = /area/space
	base_turf = /turf/space

// --- docks

/obj/effect/shuttle_landmark/bastion_station/dock/south
	name = "Dock, Aft"
	landmark_tag = "nav_bastion_station_dock_south"
	docking_controller = "airlock_bastion_station_dock_south"
	dir = NORTH

/obj/effect/shuttle_landmark/bastion_station/dock/west
	name = "Dock, Port"
	landmark_tag = "nav_bastion_station_dock_west"
	docking_controller = "airlock_bastion_station_dock_west"
	dir = EAST

/obj/effect/shuttle_landmark/bastion_station/dock/east
	name = "Dock, Starboard"
	landmark_tag = "nav_bastion_station_dock_east"
	docking_controller = "airlock_bastion_station_dock_east"
	dir = WEST

/obj/effect/shuttle_landmark/bastion_station/dock/north
	name = "Dock, Fore"
	landmark_tag = "nav_bastion_station_dock_north"
	docking_controller = "airlock_bastion_station_dock_north"
	dir = SOUTH

// --- space

/obj/effect/shuttle_landmark/bastion_station/space/northwest
	name = "Space, Port Fore, Deck 2"
	landmark_tag = "nav_bastion_station_space_north_west"
	dir = NORTH

/obj/effect/shuttle_landmark/bastion_station/space/northeast
	name = "Space, Starboard Fore, Deck 2"
	landmark_tag = "nav_bastion_station_space_north_east"
	dir = NORTH

/obj/effect/shuttle_landmark/bastion_station/space/southwest
	name = "Space, Port Aft, Deck 2"
	landmark_tag = "nav_bastion_station_space_south_west"
	dir = SOUTH

/obj/effect/shuttle_landmark/bastion_station/space/southeast
	name = "Space, Starboard Aft, Deck 2"
	landmark_tag = "nav_bastion_station_space_south_east"
	dir = SOUTH

// --- Shuttles

/obj/effect/shuttle_landmark/shrike_red
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/shrike_blue
	base_turf = /turf/space
	base_area = /area/space
