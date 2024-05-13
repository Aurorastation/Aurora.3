
// --------------------- base type

/obj/effect/shuttle_landmark/tret_industrial
	base_area = /area/tret_industrial/outside/landing
	base_turf = /turf/simulated/floor/exoplanet/basalt/tret

// --------------------- shuttle

/obj/effect/shuttle_landmark/tret_industrial/transit
	name = "In transit"
	landmark_tag = "tret_industrial_navtransit"
	base_turf = /turf/space/transit/north
	base_area = /area/space

// ----

/obj/effect/shuttle_landmark/tret_industrial/hangar
	name = "Tret Industrial Complex - Landing Pad 1"
	landmark_tag = "tret_industrial_navhangar"
	docking_controller = "airlock_tret_dock1"

/obj/effect/map_effect/marker/airlock/docking/tret_industrial/hangar
	name = "Shuttle Hangar"
	landmark_tag = "nav_yacht_civ_shuttle_dock"
	master_tag = "airlock_yacht_civ_shuttle_dock"

// --------------------- docks

/obj/effect/shuttle_landmark/yacht_civ/dock/starboard
	name = "Dock, Starboard"
	landmark_tag = "nav_yacht_civ_dock_starboard"
	docking_controller = "airlock_yacht_civ_dock_starboard"

/obj/effect/map_effect/marker/airlock/docking/yacht_civ/dock/starboard
	name = "Dock, Starboard"
	landmark_tag = "nav_yacht_civ_dock_starboard"
	master_tag = "airlock_yacht_civ_dock_starboard"
	req_one_access = null
	req_access = null

// ----

// ----

// ----

// ----

// ----

// ----

// --------------------- space

// --------------------- fin
