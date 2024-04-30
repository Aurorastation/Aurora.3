
// --------------------- base type

/obj/effect/shuttle_landmark/yacht_civ
	base_area = /area/space
	base_turf = /turf/space

// --------------------- shuttle

/obj/effect/shuttle_landmark/yacht_civ/shuttle_hangar
	name = "Shuttle Hangar"
	landmark_tag = "nav_yacht_civ_shuttle_dock"
	docking_controller = "airlock_yacht_civ_shuttle_dock"
	base_turf = /turf/simulated/floor/reinforced/airless

/obj/effect/map_effect/marker/airlock/docking/yacht_civ/shuttle_hangar
	name = "Shuttle Hangar"
	landmark_tag = "nav_yacht_civ_shuttle_dock"
	master_tag = "airlock_yacht_civ_shuttle_dock"

// ----

/obj/effect/shuttle_landmark/yacht_civ/shuttle_transit
	name = "In transit"
	landmark_tag = "nav_yacht_civ_shuttle_transit"
	base_turf = /turf/space/transit

// --------------------- docks

/obj/effect/shuttle_landmark/yacht_civ/dock/starboard
	name = "Dock, Starboard"
	landmark_tag = "nav_yacht_civ_dock_starboard"
	docking_controller = "airlock_yacht_civ_dock_starboard"

/obj/effect/map_effect/marker/airlock/docking/yacht_civ/dock/starboard
	name = "Dock, Starboard"
	landmark_tag = "nav_yacht_civ_dock_starboard"
	master_tag = "airlock_yacht_civ_dock_starboard"

// ----

/obj/effect/shuttle_landmark/yacht_civ/dock/port
	name = "Dock, Port"
	landmark_tag = "nav_yacht_civ_dock_port"
	docking_controller = "airlock_yacht_civ_dock_port"

/obj/effect/map_effect/marker/airlock/docking/yacht_civ/dock/port
	name = "Dock, Port"
	landmark_tag = "nav_yacht_civ_dock_port"
	master_tag = "airlock_yacht_civ_dock_port"

// ----

/obj/effect/shuttle_landmark/yacht_civ/dock/aft
	name = "Dock, Aft"
	landmark_tag = "nav_yacht_civ_dock_aft"
	docking_controller = "airlock_yacht_civ_dock_aft"

/obj/effect/map_effect/marker/airlock/docking/yacht_civ/dock/aft
	name = "Dock, Aft"
	landmark_tag = "nav_yacht_civ_dock_aft"
	master_tag = "airlock_yacht_civ_dock_aft"

// ----

/obj/effect/shuttle_landmark/yacht_civ/dock/fore
	name = "Dock, Fore"
	landmark_tag = "nav_yacht_civ_dock_fore"
	docking_controller = "airlock_yacht_civ_dock_fore"

/obj/effect/map_effect/marker/airlock/docking/yacht_civ/dock/fore
	name = "Dock, Fore"
	landmark_tag = "nav_yacht_civ_dock_fore"
	master_tag = "airlock_yacht_civ_dock_fore"

// --------------------- space

/obj/effect/shuttle_landmark/yacht_civ/space/fore_starboard
	name = "Space, Fore Starboard"
	landmark_tag = "nav_yacht_civ_space_fore_starboard"

/obj/effect/shuttle_landmark/yacht_civ/space/fore_port
	name = "Space, Fore Port"
	landmark_tag = "nav_yacht_civ_space_fore_port"

/obj/effect/shuttle_landmark/yacht_civ/space/aft_starboard
	name = "Space, Aft Starboard"
	landmark_tag = "nav_yacht_civ_space_aft_starboard"

/obj/effect/shuttle_landmark/yacht_civ/space/aft_port
	name = "Space, Aft Port"
	landmark_tag = "nav_yacht_civ_space_aft_port"

/obj/effect/shuttle_landmark/yacht_civ/space/port_far
	name = "Space, Port, Far"
	landmark_tag = "nav_yacht_civ_space_port_far"

/obj/effect/shuttle_landmark/yacht_civ/space/starboard_far
	name = "Space, Starboard, Far"
	landmark_tag = "nav_yacht_civ_space_starboard_far"
