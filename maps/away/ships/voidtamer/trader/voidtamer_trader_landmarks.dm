// --------------------- base type

/obj/effect/shuttle_landmark/voidtamer/trader
	base_area = /area/space
	base_turf = /turf/space

// --------------------- shuttle

/obj/effect/shuttle_landmark/voidtamer_trader/hangar
	name = "Voidtamer Trader Hangar"
	docking_controller = "nav_voidtamer_shuttle_dock"
	base_area = /area/voidtamer/trader/dock
	base_turf = /turf/simulated/floor
	movable_flags = MOVABLE_FLAG_EFFECTMOVE
	landmark_tag = "nav_voidtamer_shuttle_dock"

// ----

/obj/effect/shuttle_landmark/voidtamer_trader/shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_voidtamer_shuttle"
	base_turf = /turf/space/transit/north

// --------------------- docks

/obj/effect/shuttle_landmark/voidtamer_trader/dock/west
	name = "Dock, West"
	landmark_tag = "nav_voidtamer_ship_west"
	docking_controller = "airlock_voidtamer_ship_west"

/obj/effect/map_effect/marker/airlock/docking/voidtamer_trader/dock/west
	name = "Dock, West"
	landmark_tag = "nav_voidtamer_ship_dock_west"
	master_tag = "airlock_voidtamer_ship_west"

/obj/effect/shuttle_landmark/voidtamer_trader/dock/east
	name = "Dock, East"
	landmark_tag = "nav_voidtamer_ship_east"
	docking_controller = "airlock_voidtamer_ship_east"

/obj/effect/map_effect/marker/airlock/docking/voidtamer_trader/dock/east
	name = "Dock, East"
	landmark_tag = "nav_voidtamer_ship_dock_east"
	master_tag = "airlock_voidtamer_ship_east"

/obj/effect/shuttle_landmark/voidtamer_trader/dock/west
	name = "Hangar Dock, East"
	landmark_tag = "nav_voidtamer_ship_east_hangar"
	docking_controller = "airlock_voidtamer_ship_east_hangar"

/obj/effect/map_effect/marker/airlock/voidtamer_trader/dock/hangar_west
	name = "Hangar Dock, West"
	master_tag = "airlock_voidtamer_ship_hangar_west"

/obj/effect/shuttle_landmark/voidtamer_trader/dock/east
	name = "Hangar Dock, East"
	landmark_tag = "nav_voidtamer_ship_east_hangar"
	docking_controller = "airlock_voidtamer_ship_east_hangar"

/obj/effect/map_effect/marker/airlock/voidtamer_trader/dock/hangar_east
	name = "Hangar Dock, East"
	master_tag = "airlock_voidtamer_ship_hangar_east"
