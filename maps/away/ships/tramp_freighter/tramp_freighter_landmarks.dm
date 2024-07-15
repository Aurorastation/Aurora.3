/obj/effect/shuttle_landmark/tramp_freighter
	base_area = /area/space
	base_turf = /turf/space

//space landmarks
/obj/effect/shuttle_landmark/tramp_freighter/nav1
	name = "Independent Freighter - Fore"
	landmark_tag = "nav_tramp_freighter_1"

/obj/effect/shuttle_landmark/tramp_freighter/nav2
	name = "Independent Freighter - Aft"
	landmark_tag = "nav_tramp_freighter_2"

/obj/effect/shuttle_landmark/tramp_freighter/nav3
	name = "Independent Freighter - Port"
	landmark_tag = "nav_tramp_freighter_3"

/obj/effect/shuttle_landmark/tramp_freighter/nav4
	name = "Independent Freighter - Starboard"
	landmark_tag = "nav_tramp_freighter_4"

//starboard docking arm
/obj/effect/shuttle_landmark/tramp_freighter/starboard_aft
	name = "Independent Freighter - Starboard Aft Dock"
	landmark_tag = "nav_tramp_freighter_stbd_aft"
	docking_controller = "airlock_tramp_freighter_dock_stbd_aft"

/obj/effect/shuttle_landmark/tramp_freighter/starboard_fore
	name = "Independent Freighter - Starboard Fore Dock"
	landmark_tag = "nav_tramp_freighter_stbd_fore"
	docking_controller = "airlock_tramp_freighter_dock_stbd_fore"

/obj/effect/shuttle_landmark/tramp_freighter/starboard_berth
	name = "Independent Freighter - Starboard Berthing Dock"
	landmark_tag = "nav_tramp_freighter_stbd_berth"
	docking_controller = "airlock_tramp_freighter_dock_stbd_berth"

//port docking arm
/obj/effect/shuttle_landmark/tramp_freighter/port_aft
	name = "Independent Freighter - Port Aft Dock"
	landmark_tag = "nav_tramp_freighter_port_aft"
	docking_controller = "airlock_tramp_freighter_dock_port_aft"

/obj/effect/shuttle_landmark/tramp_freighter/port_fore
	name = "Independent Freighter - Port Fore Dock"
	landmark_tag = "nav_tramp_freighter_port_fore"
	docking_controller = "airlock_tramp_freighter_dock_port_fore"

/obj/effect/shuttle_landmark/tramp_freighter/port_berth
	name = "Independent Freighter - Port Berthing Dock"
	landmark_tag = "nav_tramp_freighter_port_berth"
	docking_controller = "airlock_tramp_freighter_dock_port_berth"

/obj/effect/shuttle_landmark/tramp_freighter/transit
	name = "In transit"
	landmark_tag = "nav_transit_tramp_freighter"
	base_turf = /turf/space/transit/east

//airlocks, port
/obj/effect/map_effect/marker/airlock/docking/tramp_freighter/port_aft
	name = "Port, Aft"
	master_tag = "port_aft_docking_port"
	landmark_tag = "nav_tramp_freighter_port_aft"

/obj/effect/map_effect/marker/airlock/docking/tramp_freighter/port_berth
	name = "Port, Berth"
	master_tag = "port_berth_docking_port"
	landmark_tag = "nav_tramp_freighter_port_berth"

/obj/effect/map_effect/marker/airlock/docking/tramp_freighter/port_fore
	name = "Port, Fore"
	master_tag = "port_fore_docking_port"
	landmark_tag = "nav_tramp_freighter_port_fore"

//airlocks, starboard
/obj/effect/map_effect/marker/airlock/docking/tramp_freighter/starboard_aft
	name = "Starboard, Aft"
	master_tag = "starboard_aft_docking_port"
	landmark_tag = "nav_tramp_freighter_stbd_aft"

/obj/effect/map_effect/marker/airlock/docking/tramp_freighter/starboard_berth
	name = "Starboard, Berth"
	master_tag = "starboard_berth_docking_port"
	landmark_tag = "nav_tramp_freighter_stbd_berth"

/obj/effect/map_effect/marker/airlock/docking/tramp_freighter/starboard_fore
	name = "Starboard, Fore"
	master_tag = "starboard_fore_docking_port"
	landmark_tag = "nav_tramp_freighter_stbd_fore"

//airlocks, non-docking
/obj/effect/map_effect/marker/airlock/tramp_freighter/starboard_small
	name = "Starboard, Small"
	master_tag = "airlock_tramp_starboard"

/obj/effect/map_effect/marker/airlock/tramp_freighter/port_small
	name = "Port, Small"
	master_tag = "airlock_tramp_port"

//shuttle stuff
/obj/effect/shuttle_landmark/freighter_shuttle/hangar
	name = "nav_tramp_start"
	landmark_tag = "nav_tramp_start"
	docking_controller = "tramp_shuttle_dock"

/obj/effect/shuttle_landmark/freighter_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_freighter_shuttle"
	base_turf = /turf/space/transit/north

/obj/effect/map_effect/marker/airlock/docking/tramp_freighter/shuttle_dock
	name = "tramp_shuttle_dock"
	master_tag = "tramp_shuttle_dock"
	landmark_tag = "nav_tramp_start"

/obj/effect/map_effect/marker/airlock/shuttle/tramp_freighter
	name = "airlock_tramp_shuttle"
	master_tag = "airlock_tramp_shuttle"
	shuttle_tag = "Freight Shuttle"
	cycle_to_external_air = TRUE
