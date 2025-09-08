// Midships port airlock
/obj/effect/map_effect/marker/airlock/Sol_Frigate/mid_starboard
	name = "Midships port airlock"
	master_tag = "Solfrig_airlock"
// --------

// Docking ports
// Aft dock
/obj/effect/map_effect/marker/airlock/docking/Sol_Frigate/aft_dock
	name = "Aft Dock"
	master_tag = "airlock_Solfrig_aft_dock"
	landmark_tag = "Sol_Frigate_aft_dock"

/obj/effect/shuttle_landmark/Sol_Frigate/dock_aft
	name = "Aft Dock"
	docking_controller = "airlock_Solfrig_aft_dock"
	landmark_tag = "Sol_Frigate_aft_dock"
// --------
// Port dock
/obj/effect/map_effect/marker/airlock/docking/Sol_Frigate/port_dock
	name = "Port Dock"
	master_tag = "airlock_Solfrig_port_dock"
	landmark_tag = "Sol_Frigate_port_dock"

/obj/effect/shuttle_landmark/Sol_Frigate/dock_port
	name = "Port Dock"
	docking_controller = "airlock_Solfrig_port_dock"
	landmark_tag = "Sol_Frigate_port_dock"
// --------

// Starboard dock
/obj/effect/map_effect/marker/airlock/docking/Sol_Frigate/starboard_dock
	name = "Starboard Dock"
	master_tag = "airlock_Solfrig_starboard_dock"
	landmark_tag = "Sol_Frigate_starboard_dock"

/obj/effect/shuttle_landmark/Sol_Frigate/dock_starboard
	name = "Starboard Dock"
	docking_controller = "airlock_Solfrig_starboard_dock"
	landmark_tag = "Sol_Frigate_starboard_dock"
// --------

// Space landmarks
/obj/effect/shuttle_landmark/Sol_Frigate/nav1
	name = "Fore"
	landmark_tag = "Sol_Frigate_nav1"

/obj/effect/shuttle_landmark/Sol_Frigate/nav2
	name = "Aft"
	landmark_tag = "Sol_Frigate_nav2"

/obj/effect/shuttle_landmark/Sol_Frigate/nav3
	name = "Port"
	landmark_tag = "Sol_Frigate_nav3"

/obj/effect/shuttle_landmark/Sol_Frigate/nav4
	name = "Starboard"
	landmark_tag = "Sol_Frigate_nav4"
// --------
//hangar landmarks
/obj/effect/shuttle_landmark/Solfrig_shuttle/hangar
	name = "Solarian Frigate - Hangar"
	landmark_tag = "nav_hangar_solfrig"
	docking_controller = "solf_shuttle_dock"
	base_area = /area/ship/Sol_Frigate
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE
	// -------
