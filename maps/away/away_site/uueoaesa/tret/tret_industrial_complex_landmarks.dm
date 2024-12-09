
// --------------------- base type

/obj/effect/shuttle_landmark/tret_industrial
	base_area = /area/tret_industrial/outside/landing
	base_turf = /turf/simulated/floor/exoplanet/basalt/tret

/obj/effect/map_effect/marker/airlock/docking/tret_industrial/dock
	cycle_to_external_air = TRUE
	req_one_access = null
	req_access = null

// --------------------- shuttle

/obj/effect/shuttle_landmark/tret_industrial/transit
	name = "In transit"
	landmark_tag = "nav_tret_industrial_shuttle_transit"
	base_turf = /turf/space/transit/north
	base_area = /area/space

// --------------------- docks

/obj/effect/shuttle_landmark/tret_industrial/dock/outpost_1
	name = "Dock, Landing Pad 1"
	landmark_tag = "nav_tret_industrial_dock_outpost_1"
	docking_controller = "airlock_tret_industrial_dock_outpost_1"

/obj/effect/map_effect/marker/airlock/docking/tret_industrial/dock/outpost_1
	name = "Dock, Landing Pad 1"
	landmark_tag = "nav_tret_industrial_dock_outpost_1"
	master_tag = "airlock_tret_industrial_dock_outpost_1"

// ----

/obj/effect/shuttle_landmark/tret_industrial/dock/outpost_2
	name = "Dock, Landing Pad 2"
	landmark_tag = "nav_tret_industrial_dock_outpost_2"
	docking_controller = "airlock_tret_industrial_dock_outpost_2"

/obj/effect/map_effect/marker/airlock/docking/tret_industrial/dock/outpost_2
	name = "Dock, Landing Pad 2"
	landmark_tag = "nav_tret_industrial_dock_outpost_2"
	master_tag = "airlock_tret_industrial_dock_outpost_2"

// ----

/obj/effect/shuttle_landmark/tret_industrial/dock/outpost_3
	name = "Dock, Landing Pad 3"
	landmark_tag = "nav_tret_industrial_dock_outpost_3"
	docking_controller = "airlock_tret_industrial_dock_outpost_3"

/obj/effect/map_effect/marker/airlock/docking/tret_industrial/dock/outpost_3
	name = "Dock, Landing Pad 3"
	landmark_tag = "nav_tret_industrial_dock_outpost_3"
	master_tag = "airlock_tret_industrial_dock_outpost_3"

// ----

/obj/effect/shuttle_landmark/tret_industrial/dock/outpost_4
	name = "Dock, Landing Pad 4"
	landmark_tag = "nav_tret_industrial_dock_outpost_4"
	docking_controller = "airlock_tret_industrial_dock_outpost_4"

/obj/effect/map_effect/marker/airlock/docking/tret_industrial/dock/outpost_4
	name = "Dock, Landing Pad 4"
	landmark_tag = "nav_tret_industrial_dock_outpost_4"
	master_tag = "airlock_tret_industrial_dock_outpost_4"

// ----

/obj/effect/shuttle_landmark/tret_industrial/dock/outpost_5
	name = "Dock, Landing Pad 5"
	landmark_tag = "nav_tret_industrial_dock_outpost_5"
	docking_controller = "airlock_tret_industrial_dock_outpost_5"

/obj/effect/map_effect/marker/airlock/docking/tret_industrial/dock/outpost_5
	name = "Dock, Landing Pad 5"
	landmark_tag = "nav_tret_industrial_dock_outpost_5"
	master_tag = "airlock_tret_industrial_dock_outpost_5"

// --------------------- surface, outpost

/obj/effect/shuttle_landmark/tret_industrial/surface/outpost_1
	name = "Surface, Landing Pad 1"
	landmark_tag = "nav_tret_industrial_surface_outpost_1"

/obj/effect/shuttle_landmark/tret_industrial/surface/outpost_2
	name = "Surface, Landing Pad 2"
	landmark_tag = "nav_tret_industrial_surface_outpost_2"

/obj/effect/shuttle_landmark/tret_industrial/surface/outpost_3
	name = "Surface, Landing Pad 3"
	landmark_tag = "nav_tret_industrial_surface_outpost_3"

/obj/effect/shuttle_landmark/tret_industrial/surface/outpost_4
	name = "Surface, Landing Pad 4"
	landmark_tag = "nav_tret_industrial_surface_outpost_4"

/obj/effect/shuttle_landmark/tret_industrial/surface/outpost_5
	name = "Surface, Landing Pad 5"
	landmark_tag = "nav_tret_industrial_surface_outpost_5"

// --------------------- surface, far

/obj/effect/shuttle_landmark/tret_industrial/surface/far_1
	name = "Surface, Far 1"
	landmark_tag = "nav_tret_industrial_surface_far_1"

/obj/effect/shuttle_landmark/tret_industrial/surface/far_2
	name = "Surface, Far 2"
	landmark_tag = "nav_tret_industrial_surface_far_2"

/obj/effect/shuttle_landmark/tret_industrial/surface/far_3
	name = "Surface, Far 3"
	landmark_tag = "nav_tret_industrial_surface_far_3"

/obj/effect/shuttle_landmark/tret_industrial/surface/far_4
	name = "Surface, Far 4"
	landmark_tag = "nav_tret_industrial_surface_far_4"
