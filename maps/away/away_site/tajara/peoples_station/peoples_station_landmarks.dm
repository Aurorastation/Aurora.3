// --------------------- base type

/obj/effect/shuttle_landmark/saniorios_outpost
	base_turf = /turf/space
	base_area = /area/space

// --------------------- shuttle

// ---- fang

/obj/effect/shuttle_landmark/peoples_station_fang/hangar
	name = "People's Station Fang Hangar"
	landmark_tag = "nav_hangar_peoples_station_fang"
	docking_controller = "peoples_station_fang_dock"
	base_area = /area/peoples_station/fang
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/peoples_station_fang/transit
	name = "In transit"
	landmark_tag = "nav_transit_peoples_station_fang"
	base_turf = /turf/space/transit/north

// ---- transport

/obj/effect/shuttle_landmark/peoples_station_transport/hangar
	name = "People's Station Transport Hangar"
	landmark_tag = "nav_peoples_station_transport"
	docking_controller = "peoples_station_transport_dock"
	base_area = /area/peoples_station/transport_hangar
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/peoples_station_transport/transit
	name = "In transit"
	landmark_tag = "nav_transit_peoples_station_transport"
	base_turf = /turf/space/transit/north

/obj/effect/map_effect/marker/airlock/shuttle/peoples_station_transport
	name = "People's Station Transport Shuttle"
	shuttle_tag = "People's Station Transport Shuttle"
	master_tag = "peoples_station_transport"

// --------------------- docks

// ----

/obj/effect/shuttle_landmark/nav_peoples_station/fore_dock
	name = "People's Space Station Fore Dock"
	landmark_tag = "nav_peoples_station_fore_dock"
	docking_controller = "peoples_station_dock_fore"

/obj/effect/map_effect/marker/airlock/docking/peoples_station/dock/fore
	name = "People's Space Station Fore Dock"
	landmark_tag = "nav_peoples_station_fore_dock"
	master_tag = "peoples_station_dock_fore"

// ----

/obj/effect/shuttle_landmark/nav_peoples_station/port_dock
	name = "People's Space Station Port Dock"
	landmark_tag = "nav_peoples_station_port_dock"
	docking_controller = "peoples_station_port_dock"

/obj/effect/map_effect/marker/airlock/docking/peoples_station/dock/port
	name = "People's Space Station Port Dock"
	landmark_tag = "nav_peoples_station_port_dock"
	master_tag = "peoples_station_dock_port"

// ----

/obj/effect/shuttle_landmark/nav_peoples_station/starboard_dock
	name = "People's Space Station Starboard Dock"
	landmark_tag = "nav_peoples_station_starboard_dock"
	docking_controller = "peoples_station_port_dock"

/obj/effect/map_effect/marker/airlock/docking/peoples_station/dock/starboard
	name = "People's Space Station Starboard Dock"
	landmark_tag = "nav_peoples_station_starboard_dock"
	master_tag = "peoples_station_starboard_port"

// ----

/obj/effect/shuttle_landmark/nav_peoples_station/aft_dock
	name = "People's Space Station Aft Dock"
	landmark_tag = "nav_peoples_station_aft_dock"
	docking_controller = "peoples_station_aft_dock"

/obj/effect/map_effect/marker/airlock/docking/peoples_station/dock/aft
	name = "People's Space Station Starboard Dock"
	landmark_tag = "nav_peoples_station_aft_dock"
	master_tag = "peoples_station_aft_port"

// ----

/obj/effect/shuttle_landmark/nav_peoples_station/nav1
	name = "People's Space Station Navpoint #1"
	landmark_tag = "nav_peoples_station_ship_1"

/obj/effect/shuttle_landmark/nav_peoples_station/nav2
	name = "People's Space Station Navpoint #2"
	landmark_tag = "nav_peoples_station_ship_2"

/obj/effect/shuttle_landmark/nav_peoples_station/nav3
	name = "People's Space Station Navpoint #3"
	landmark_tag = "nav_peoples_station_ship_3"

/obj/effect/shuttle_landmark/nav_peoples_station/nav4
	name = "People's Space Station Navpoint #4"
	landmark_tag = "nav_peoples_station_ship_4"
