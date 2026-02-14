// --------------------- base type

/obj/effect/shuttle_landmark/nka_merchant

// --------------------- shuttle

/obj/effect/shuttle_landmark/nka_merchant_shuttle/hangar
	name = "Her Majesty's Mercantile Flotilla Shuttle Hangar"
	landmark_tag = "nav_nka_merchant_shuttle"
	docking_controller = "nka_merchant_shuttle_dock"
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

// ----

/obj/effect/shuttle_landmark/nka_merchant_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_nka_merchant_shuttle"

// --------------------- docks

/obj/effect/shuttle_landmark/nka_merchant/dock/starboard
	name = "Dock, Starboard"
	landmark_tag = "nav_nka_merchant_dock_starboard"
	docking_controller = "airlock_nka_merchant_dock_starboard"

/obj/effect/map_effect/marker/airlock/docking/nka_merchant/dock/starboard
	name = "Dock, Starboard"
	landmark_tag = "nav_nka_merchant_dock_starboard"
	master_tag = "airlock_nka_merchant_dock_starboard"
