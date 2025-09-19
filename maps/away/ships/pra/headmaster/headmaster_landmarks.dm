// Lift
/datum/shuttle/autodock/multi/lift/headmaster
	name = "Headmaster Lift"
	current_location = "nav_headmaster_lift_second_deck"
	shuttle_area = /area/turbolift/headmaster_ship/headmaster_lift
	destination_tags = list(
		"nav_headmaster_lift_first_deck",
		"nav_headmaster_lift_second_deck",
		)

/obj/effect/shuttle_landmark/lift/headmaster_first_deck
	name = "Headmaster Ship - First Deck"
	landmark_tag = "nav_headmaster_lift_first_deck"
	base_area = /area/headmaster_ship/hangar
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/lift/headmaster_second_deck
	name = "Headmaster Ship - Second Deck"
	landmark_tag = "nav_headmaster_lift_second_deck"
	base_area = /area/headmaster_ship/lift_area
	base_turf = /turf/simulated/open

/obj/machinery/computer/shuttle_control/multi/lift/headmaster
	shuttle_tag = "Headmaster Lift"

// Shuttle landmarks
/obj/effect/shuttle_landmark/headmaster_ship
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/headmaster_ship/nav1
	name = "Fore"
	landmark_tag = "nav_headmaster_ship_1"

/obj/effect/shuttle_landmark/headmaster_ship/nav2
	name = "Aft"
	landmark_tag = "nav_headmaster_ship_2"

/obj/effect/shuttle_landmark/headmaster_ship/nav3
	name = "Starboard"
	landmark_tag = "nav_headmaster_ship_3"

/obj/effect/shuttle_landmark/headmaster_ship/nav4
	name = "Port"
	landmark_tag = "nav_headmaster_ship_4"

/obj/effect/shuttle_landmark/headmaster_ship/dock/fore
	name = "Fore Dock"
	landmark_tag = "nav_headmaster_ship_dock_fore"
	docking_controller = "nav_headmaster_ship_dock_fore"

/obj/effect/shuttle_landmark/headmaster_ship/dock/aft
	name = "Aft Dock"
	landmark_tag = "nav_headmaster_ship_dock_aft"
	docking_controller = "nav_headmaster_ship_dock_aft"

/obj/effect/shuttle_landmark/headmaster_ship/dock/starboard
	name = "Starboard Dock"
	landmark_tag = "nav_headmaster_ship_dock_starboard"
	docking_controller = "nav_headmaster_ship_dock_starboard"

/obj/effect/shuttle_landmark/headmaster_ship/dock/port
	name = "Port Dock"
	landmark_tag = "nav_headmaster_ship_dock_port"
	docking_controller = "nav_headmaster_ship_dock_port"

// Docking airlock markers
/obj/effect/map_effect/marker/airlock/docking/headmaster_ship/aft_dock
	name = "Aft"
	master_tag = "airlock_headmaster_aft_dock"
	landmark_tag = "headmaster_ship_aft_dock"

/obj/effect/map_effect/marker/airlock/docking/headmaster_ship/fore_dock
	name = "Fore"
	master_tag = "airlock_headmaster_fore_dock"
	landmark_tag = "headmaster_ship_fore_dock"

/obj/effect/map_effect/marker/airlock/docking/headmaster_ship/starboard_dock
	name = "Starboard"
	master_tag = "airlock_headmaster_starboard_dock"
	landmark_tag = "headmaster_ship_starboard_dock"

/obj/effect/map_effect/marker/airlock/docking/headmaster_ship/port_dock
	name = "Port"
	master_tag = "airlock_headmaster_port_dock"
	landmark_tag = "headmaster_ship_port_dock"
