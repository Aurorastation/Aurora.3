// Space landmarks
/obj/effect/shuttle_landmark/hailstorm_ship/nav1
	name = "Fore"
	landmark_tag = "hailstorm_ship_nav1"

/obj/effect/shuttle_landmark/hailstorm_ship/nav2
	name = "Aft"
	landmark_tag = "hailstorm_ship_nav2"

/obj/effect/shuttle_landmark/hailstorm_ship/nav3
	name = "Port"
	landmark_tag = "hailstorm_ship_nav3"

/obj/effect/shuttle_landmark/hailstorm_ship/nav4
	name = "Starboard"
	landmark_tag = "hailstorm_ship_nav4"
// --------

// Docking ports
// Port dock
/obj/effect/map_effect/marker/airlock/docking/hailstorm_ship/port_dock
	name = "Port Dock"
	master_tag = "airlock_hailstorm_port_dock"
	landmark_tag = "hailstorm_ship_port_dock"

/obj/effect/shuttle_landmark/hailstorm_ship/dock_port
	name = "Port Dock"
	docking_controller = "airlock_hailstorm_port_dock"
	landmark_tag = "hailstorm_ship_port_dock"

// Starboard dock
/obj/effect/map_effect/marker/airlock/docking/hailstorm_ship/starboard_dock
	name = "Starboard Dock"
	master_tag = "airlock_hailstorm_starboard_dock"
	landmark_tag = "hailstorm_ship_starboard_dock"

/obj/effect/shuttle_landmark/hailstorm_ship/dock_starboard
	name = "Starboard Dock"
	docking_controller = "airlock_hailstorm_starboard_dock"
	landmark_tag = "hailstorm_ship_starboard_dock"
// --------
