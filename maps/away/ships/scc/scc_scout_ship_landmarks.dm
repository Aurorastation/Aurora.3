
// --------------------- base type

/obj/effect/shuttle_landmark/scc_scout_ship
	base_area = /area/space
	base_turf = /turf/space
	auto_register = TRUE

// --------------------- shuttle

/obj/effect/shuttle_landmark/scc_scout_ship/shuttle_hangar
	name				= "Shuttle Dock"
	landmark_tag		= "nav_scc_scout_shuttle_dock"
	docking_controller	= "airlock_scc_scout_shuttle_dock"
	shuttle_restricted	= /obj/effect/overmap/visitable/ship/landable/scc_scout_shuttle::name

/obj/effect/map_effect/marker/airlock/docking/scc_scout_ship/shuttle_hangar
	name			= /obj/effect/shuttle_landmark/scc_scout_ship/shuttle_hangar::name
	landmark_tag	= /obj/effect/shuttle_landmark/scc_scout_ship/shuttle_hangar::landmark_tag
	master_tag		= /obj/effect/shuttle_landmark/scc_scout_ship/shuttle_hangar::docking_controller

// ----

/obj/effect/shuttle_landmark/scc_scout_ship/shuttle_transit
	name = "In transit"
	landmark_tag = "nav_scc_scout_shuttle_transit"
	base_turf = /turf/space/transit
	auto_register = FALSE

// --------------------- docks

/obj/effect/shuttle_landmark/scc_scout_ship/dock/starboard
	name 				= "Dock, Starboard"
	landmark_tag 		= "nav_scc_scout_dock_starboard"
	docking_controller 	= "airlock_scc_scout_dock_starboard"

/obj/effect/map_effect/marker/airlock/docking/scc_scout_ship/dock/starboard
	name 			= /obj/effect/shuttle_landmark/scc_scout_ship/dock/starboard::name
	landmark_tag 	= /obj/effect/shuttle_landmark/scc_scout_ship/dock/starboard::landmark_tag
	master_tag 		= /obj/effect/shuttle_landmark/scc_scout_ship/dock/starboard::docking_controller

// ----

/obj/effect/shuttle_landmark/scc_scout_ship/dock/port
	name 				= "Dock, Port"
	landmark_tag 		= "nav_scc_scout_dock_port"
	docking_controller 	= "airlock_scc_scout_dock_port"

/obj/effect/map_effect/marker/airlock/docking/scc_scout_ship/dock/port
	name 			= /obj/effect/shuttle_landmark/scc_scout_ship/dock/port::name
	landmark_tag 	= /obj/effect/shuttle_landmark/scc_scout_ship/dock/port::landmark_tag
	master_tag 		= /obj/effect/shuttle_landmark/scc_scout_ship/dock/port::docking_controller

// ----

/obj/effect/shuttle_landmark/scc_scout_ship/dock/aft
	name 				= "Dock, Aft"
	landmark_tag 		= "nav_scc_scout_dock_aft"
	docking_controller 	= "airlock_scc_scout_dock_aft"

/obj/effect/map_effect/marker/airlock/docking/scc_scout_ship/dock/aft
	name 			= /obj/effect/shuttle_landmark/scc_scout_ship/dock/aft::name
	landmark_tag 	= /obj/effect/shuttle_landmark/scc_scout_ship/dock/aft::landmark_tag
	master_tag 		= /obj/effect/shuttle_landmark/scc_scout_ship/dock/aft::docking_controller

// --------------------- catwalk

/obj/effect/shuttle_landmark/scc_scout_ship/catwalk/aft
	name = "Catwalk, Aft"
	landmark_tag = "nav_scc_scout_catwalk_aft"

/obj/effect/shuttle_landmark/scc_scout_ship/catwalk/fore_starboard
	name = "Catwalk, Fore Starboard"
	landmark_tag = "nav_scc_scout_catwalk_fore_starboard"

/obj/effect/shuttle_landmark/scc_scout_ship/catwalk/fore_port
	name = "Catwalk, Fore Port"
	landmark_tag = "nav_scc_scout_catwalk_fore_port"

// --------------------- space

/obj/effect/shuttle_landmark/scc_scout_ship/space/fore_starboard
	name = "Space, Fore Starboard"
	landmark_tag = "nav_scc_scout_space_fore_starboard"

/obj/effect/shuttle_landmark/scc_scout_ship/space/fore_port
	name = "Space, Fore Port"
	landmark_tag = "nav_scc_scout_space_fore_port"

/obj/effect/shuttle_landmark/scc_scout_ship/space/aft_starboard
	name = "Space, Aft Starboard"
	landmark_tag = "nav_scc_scout_space_aft_starboard"

/obj/effect/shuttle_landmark/scc_scout_ship/space/aft_port
	name = "Space, Aft Port"
	landmark_tag = "nav_scc_scout_space_aft_port"

/obj/effect/shuttle_landmark/scc_scout_ship/space/port_far
	name = "Space, Port, Far"
	landmark_tag = "nav_scc_scout_space_port_far"

/obj/effect/shuttle_landmark/scc_scout_ship/space/starboard_far
	name = "Space, Starboard, Far"
	landmark_tag = "nav_scc_scout_space_starboard_far"
