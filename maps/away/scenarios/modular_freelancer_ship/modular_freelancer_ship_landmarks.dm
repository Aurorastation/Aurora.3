
// --------------------- base type

/obj/effect/shuttle_landmark/modular_freelancer_ship
	base_area = /area/space
	base_turf = /turf/space
	auto_register = TRUE

// --------------------- shuttle a dock landmarks and airlocks

/obj/effect/shuttle_landmark/modular_freelancer_ship/shuttle_a_dock
	name				= "Shuttle Dock A"
	landmark_tag		= "nav_modular_freelancer_ship_shuttle_a_dock"
	docking_controller	= "airlock_modular_freelancer_ship_shuttle_a_dock"
	dir = EAST

/obj/effect/map_effect/marker/airlock/docking/modular_freelancer_ship/shuttle_a_dock
	name			= /obj/effect/shuttle_landmark/modular_freelancer_ship/shuttle_a_dock::name
	landmark_tag	= /obj/effect/shuttle_landmark/modular_freelancer_ship/shuttle_a_dock::landmark_tag
	master_tag		= /obj/effect/shuttle_landmark/modular_freelancer_ship/shuttle_a_dock::docking_controller

// ----

/obj/effect/shuttle_landmark/modular_freelancer_ship/shuttle_a_transit
	name = "In transit"
	landmark_tag = "nav_modular_freelancer_ship_shuttle_a_transit"
	base_turf = /turf/space/transit
	auto_register = FALSE

// --------------------- shuttle b dock landmarks and airlocks

/obj/effect/shuttle_landmark/modular_freelancer_ship/shuttle_b_dock
	name				= "Shuttle Dock B"
	landmark_tag		= "nav_modular_freelancer_ship_shuttle_b_dock"
	docking_controller	= "airlock_modular_freelancer_ship_shuttle_b_dock"
	dir = WEST

/obj/effect/map_effect/marker/airlock/docking/modular_freelancer_ship/shuttle_b_dock
	name			= /obj/effect/shuttle_landmark/modular_freelancer_ship/shuttle_b_dock::name
	landmark_tag	= /obj/effect/shuttle_landmark/modular_freelancer_ship/shuttle_b_dock::landmark_tag
	master_tag		= /obj/effect/shuttle_landmark/modular_freelancer_ship/shuttle_b_dock::docking_controller

// ----

/obj/effect/shuttle_landmark/modular_freelancer_ship/shuttle_b_transit
	name = "In transit"
	landmark_tag = "nav_modular_freelancer_ship_shuttle_b_transit"
	base_turf = /turf/space/transit
	auto_register = FALSE

// --------------------- dock landmarks and airlocks, fore

/obj/effect/shuttle_landmark/modular_freelancer_ship/dock/fore_a
	name 				= "Dock, Fore, A"
	landmark_tag 		= "nav_modular_freelancer_ship_dock_fore_a"
	docking_controller 	= "airlock_modular_freelancer_ship_dock_fore_a"
	dir = NORTH

/obj/effect/map_effect/marker/airlock/docking/modular_freelancer_ship/dock/fore_a
	name 			= /obj/effect/shuttle_landmark/modular_freelancer_ship/dock/fore_a::name
	landmark_tag 	= /obj/effect/shuttle_landmark/modular_freelancer_ship/dock/fore_a::landmark_tag
	master_tag 		= /obj/effect/shuttle_landmark/modular_freelancer_ship/dock/fore_a::docking_controller

// ----

/obj/effect/shuttle_landmark/modular_freelancer_ship/dock/fore_b
	name 				= "Dock, Fore, B"
	landmark_tag 		= "nav_modular_freelancer_ship_dock_fore_b"
	docking_controller 	= "airlock_modular_freelancer_ship_dock_fore_b"
	dir = NORTH

/obj/effect/map_effect/marker/airlock/docking/modular_freelancer_ship/dock/fore_b
	name 			= /obj/effect/shuttle_landmark/modular_freelancer_ship/dock/fore_b::name
	landmark_tag 	= /obj/effect/shuttle_landmark/modular_freelancer_ship/dock/fore_b::landmark_tag
	master_tag 		= /obj/effect/shuttle_landmark/modular_freelancer_ship/dock/fore_b::docking_controller

// ----

/obj/effect/shuttle_landmark/modular_freelancer_ship/dock/fore_c
	name 				= "Dock, Fore, C"
	landmark_tag 		= "nav_modular_freelancer_ship_dock_fore_c"
	docking_controller 	= "airlock_modular_freelancer_ship_dock_fore_c"
	dir = NORTH

/obj/effect/map_effect/marker/airlock/docking/modular_freelancer_ship/dock/fore_c
	name 			= /obj/effect/shuttle_landmark/modular_freelancer_ship/dock/fore_c::name
	landmark_tag 	= /obj/effect/shuttle_landmark/modular_freelancer_ship/dock/fore_c::landmark_tag
	master_tag 		= /obj/effect/shuttle_landmark/modular_freelancer_ship/dock/fore_c::docking_controller

// ----

/obj/effect/shuttle_landmark/modular_freelancer_ship/dock/fore_port
	name 				= "Dock, Fore Port"
	landmark_tag 		= "nav_modular_freelancer_ship_dock_fore_port"
	docking_controller 	= "airlock_modular_freelancer_ship_dock_fore_port"
	dir = WEST

/obj/effect/map_effect/marker/airlock/docking/modular_freelancer_ship/dock/fore_port
	name 			= /obj/effect/shuttle_landmark/modular_freelancer_ship/dock/fore_port::name
	landmark_tag 	= /obj/effect/shuttle_landmark/modular_freelancer_ship/dock/fore_port::landmark_tag
	master_tag 		= /obj/effect/shuttle_landmark/modular_freelancer_ship/dock/fore_port::docking_controller


// ----

/obj/effect/shuttle_landmark/modular_freelancer_ship/dock/fore_starboard
	name 				= "Dock, Fore Starboard"
	landmark_tag 		= "nav_modular_freelancer_ship_dock_fore_starboard"
	docking_controller 	= "airlock_modular_freelancer_ship_dock_fore_starboard"
	dir = EAST

/obj/effect/map_effect/marker/airlock/docking/modular_freelancer_ship/dock/fore_starboard
	name 			= /obj/effect/shuttle_landmark/modular_freelancer_ship/dock/fore_starboard::name
	landmark_tag 	= /obj/effect/shuttle_landmark/modular_freelancer_ship/dock/fore_starboard::landmark_tag
	master_tag 		= /obj/effect/shuttle_landmark/modular_freelancer_ship/dock/fore_starboard::docking_controller

// ----

/obj/effect/shuttle_landmark/modular_freelancer_ship/dock/fore_back
	name 				= "Dock, Fore Back"
	landmark_tag 		= "nav_modular_freelancer_ship_dock_fore_back"
	docking_controller 	= "airlock_modular_freelancer_ship_dock_fore_back"
	dir = SOUTH

/obj/effect/map_effect/marker/airlock/docking/modular_freelancer_ship/dock/fore_back
	name 			= /obj/effect/shuttle_landmark/modular_freelancer_ship/dock/fore_back::name
	landmark_tag 	= /obj/effect/shuttle_landmark/modular_freelancer_ship/dock/fore_back::landmark_tag
	master_tag 		= /obj/effect/shuttle_landmark/modular_freelancer_ship/dock/fore_back::docking_controller

// --------------------- dock landmarks and airlocks, aft

/obj/effect/shuttle_landmark/modular_freelancer_ship/dock/aft
	name 				= "Dock, Aft"
	landmark_tag 		= "nav_modular_freelancer_ship_dock_aft"
	docking_controller 	= "airlock_modular_freelancer_ship_dock_aft"
	dir = SOUTH

/obj/effect/map_effect/marker/airlock/docking/modular_freelancer_ship/dock/aft
	name 			= /obj/effect/shuttle_landmark/modular_freelancer_ship/dock/aft::name
	landmark_tag 	= /obj/effect/shuttle_landmark/modular_freelancer_ship/dock/aft::landmark_tag
	master_tag 		= /obj/effect/shuttle_landmark/modular_freelancer_ship/dock/aft::docking_controller

// ----

/obj/effect/shuttle_landmark/modular_freelancer_ship/dock/aft_port
	name 				= "Dock, Aft Port"
	landmark_tag 		= "nav_modular_freelancer_ship_dock_aft_port"
	docking_controller 	= "airlock_modular_freelancer_ship_dock_aft_port"
	dir = WEST

/obj/effect/map_effect/marker/airlock/docking/modular_freelancer_ship/dock/aft_port
	name 			= /obj/effect/shuttle_landmark/modular_freelancer_ship/dock/aft_port::name
	landmark_tag 	= /obj/effect/shuttle_landmark/modular_freelancer_ship/dock/aft_port::landmark_tag
	master_tag 		= /obj/effect/shuttle_landmark/modular_freelancer_ship/dock/aft_port::docking_controller


// ----

/obj/effect/shuttle_landmark/modular_freelancer_ship/dock/aft_starboard
	name 				= "Dock, Aft Starboard"
	landmark_tag 		= "nav_modular_freelancer_ship_dock_aft_starboard"
	docking_controller 	= "airlock_modular_freelancer_ship_dock_aft_starboard"
	dir = EAST

/obj/effect/map_effect/marker/airlock/docking/modular_freelancer_ship/dock/aft_starboard
	name 			= /obj/effect/shuttle_landmark/modular_freelancer_ship/dock/aft_starboard::name
	landmark_tag 	= /obj/effect/shuttle_landmark/modular_freelancer_ship/dock/aft_starboard::landmark_tag
	master_tag 		= /obj/effect/shuttle_landmark/modular_freelancer_ship/dock/aft_starboard::docking_controller

// --------------------- catwalk landmarks

/obj/effect/shuttle_landmark/modular_freelancer_ship/catwalk/aft
	name = "Catwalk, Aft"
	landmark_tag = "nav_modular_freelancer_ship_catwalk_aft"
	dir = SOUTH

// --------------------- space landmarks

/obj/effect/shuttle_landmark/modular_freelancer_ship/space/fore_starboard
	name = "Space, Fore Starboard"
	landmark_tag = "nav_modular_freelancer_ship_space_fore_starboard"

/obj/effect/shuttle_landmark/modular_freelancer_ship/space/fore_port
	name = "Space, Fore Port"
	landmark_tag = "nav_modular_freelancer_ship_space_fore_port"

/obj/effect/shuttle_landmark/modular_freelancer_ship/space/aft_starboard
	name = "Space, Aft Starboard"
	landmark_tag = "nav_modular_freelancer_ship_space_aft_starboard"

/obj/effect/shuttle_landmark/modular_freelancer_ship/space/aft_port
	name = "Space, Aft Port"
	landmark_tag = "nav_modular_freelancer_ship_space_aft_port"

/obj/effect/shuttle_landmark/modular_freelancer_ship/space/port_far
	name = "Space, Port, Far"
	landmark_tag = "nav_modular_freelancer_ship_space_port_far"

/obj/effect/shuttle_landmark/modular_freelancer_ship/space/starboard_far
	name = "Space, Starboard, Far"
	landmark_tag = "nav_modular_freelancer_ship_space_starboard_far"

// --------------------- non-docking airlocks

/obj/effect/map_effect/marker/airlock/external/modular_freelancer_ship/fore_a
	name = "Airlock, Fore, A"
	master_tag = "airlock_modular_freelancer_ship_external_fore_a"

/obj/effect/map_effect/marker/airlock/external/modular_freelancer_ship/fore_b
	name = "Airlock, Fore, B"
	master_tag = "airlock_modular_freelancer_ship_external_fore_b"

/obj/effect/map_effect/marker/airlock/external/modular_freelancer_ship/mid_a
	name = "Airlock, Mid, A"
	master_tag = "airlock_modular_freelancer_ship_external_mid_a"

/obj/effect/map_effect/marker/airlock/external/modular_freelancer_ship/mid_b
	name = "Airlock, Mid, B"
	master_tag = "airlock_modular_freelancer_ship_external_mid_b"

/obj/effect/map_effect/marker/airlock/external/modular_freelancer_ship/aux_a
	name = "Airlock, Aux, A"
	master_tag = "airlock_modular_freelancer_ship_external_aux_a"

/obj/effect/map_effect/marker/airlock/external/modular_freelancer_ship/aux_b
	name = "Airlock, Aux, B"
	master_tag = "airlock_modular_freelancer_ship_external_aux_b"

// --------------------- fin
