
//Base

/obj/effect/shuttle_landmark/idris_cruiser
	base_area = /area/space
	base_turf = /turf/space

//Starboard Docking Arm

/obj/effect/shuttle_landmark/idris_cruiser/starboard_aft //Houses the runabout
	name = "Starboard Aft Dock"
	landmark_tag = "nav_idris_cruiser_stbd_aft"
	docking_controller = "airlock_idriscruiser_dock_stbd_aft"

/obj/effect/shuttle_landmark/idris_cruiser/starboard_fore
	name = "Starboard Fore Dock"
	landmark_tag = "nav_idris_cruiser_stbd_fore"
	docking_controller = "airlock_idriscruiser_dock_stbd_fore"

/obj/effect/shuttle_landmark/idris_cruiser/starboard_berth
	name = "Starboard Berthing Dock"
	landmark_tag = "nav_idris_cruiser_stbd_berth"
	docking_controller = "airlock_idriscruiser_dock_stbd_berth"

//Port Docking Arm

/obj/effect/shuttle_landmark/idris_cruiser/port_aft
	name = "Port Aft Dock"
	landmark_tag = "nav_idris_cruiser_port_aft"
	docking_controller = "airlock_idriscruiser_dock_port_aft"

/obj/effect/shuttle_landmark/idris_cruiser/port_fore
	name = "Port Fore Dock"
	landmark_tag = "nav_idris_cruiser_port_fore"
	docking_controller = "airlock_idriscruiser_dock_port_fore"

/obj/effect/shuttle_landmark/idris_cruiser/port_berth
	name = "Port Berthing Dock"
	landmark_tag = "nav_idris_cruiser_port_berth"
	docking_controller = "airlock_idriscruiser_dock_port_berth"

//Space

/obj/effect/shuttle_landmark/idris_cruiser/space/fore_port
	name = "Space, Fore Port"
	landmark_tag = "nav_idris_cruiser_space_fore_port"

/obj/effect/shuttle_landmark/idris_cruiser/space/aft_port
	name = "Space, Aft Port"
	landmark_tag = "nav_idris_cruiser_space_aft_port"

/obj/effect/shuttle_landmark/idris_cruiser/space/fore_starboard
	name = "Space, Fore Starboard"
	landmark_tag = "nav_idris_cruiser_space_fore_starboard"

/obj/effect/shuttle_landmark/idris_cruiser/space/aft_starboard
	name = "Space, Aft Starboard"
	landmark_tag = "nav_idris_cruiser_space_aft_starboard"

/obj/effect/shuttle_landmark/idris_cruiser/space/starboard_far
	name = "Space, Far Starboard"
	landmark_tag = "nav_idris_cruiser_space_starboard_far"

/obj/effect/shuttle_landmark/idris_cruiser/space/port_far
	name = "Space, Far Port"
	landmark_tag = "nav_idris_cruiser_space_port_far"

/obj/effect/shuttle_landmark/idris_cruiser/transit
	name = "In Transit"
	landmark_tag = "nav_idris_cruiser_transit"
	base_turf = /turf/space/transit
