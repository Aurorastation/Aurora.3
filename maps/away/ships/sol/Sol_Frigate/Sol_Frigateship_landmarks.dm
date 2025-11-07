// Midships port airlock
/obj/effect/map_effect/marker/airlock/sol_frigate/mid_starboard
	name = "Midships port airlock"
	master_tag = "solfrig_airlock"
// --------

// Docking ports
// Aft dock
/obj/effect/map_effect/marker/airlock/docking/sol_frigate/aft_dock
	name = "Aft Dock"
	master_tag = "airlock_solfrig_aft_dock"
	landmark_tag = "sol_frigate_aft_dock"

/obj/effect/shuttle_landmark/sol_frigate/dock_aft
	name = "Aft Dock"
	docking_controller = "airlock_solfrig_aft_dock"
	landmark_tag = "sol_frigate_aft_dock"
// --------
// Port dock
/obj/effect/map_effect/marker/airlock/docking/sol_frigate/port_dock
	name = "Port Dock"
	master_tag = "airlock_solfrig_port_dock"
	landmark_tag = "sol_frigate_port_dock"

/obj/effect/shuttle_landmark/sol_frigate/dock_port
	name = "Port Dock"
	docking_controller = "airlock_solfrig_port_dock"
	landmark_tag = "sol_frigate_port_dock"
// --------

// Starboard dock
/obj/effect/map_effect/marker/airlock/docking/sol_frigate/starboard_dock
	name = "Starboard Dock"
	master_tag = "airlock_solfrig_starboard_dock"
	landmark_tag = "sol_frigate_starboard_dock"

/obj/effect/shuttle_landmark/sol_frigate/dock_starboard
	name = "Starboard Dock"
	docking_controller = "airlock_solfrig_starboard_dock"
	landmark_tag = "sol_frigate_starboard_dock"
// --------

//Fore Airlock, right
/obj/effect/map_effect/marker/airlock/docking/sol_frigate/catwalkA
	name = "Forward Catwalk airlock, A"
	master_tag = "airlock_solfrig_fore_dock"
	landmark_tag = "sol_frigate_fore_dock"
// --------

//Fore Airlock, left
/obj/effect/map_effect/marker/airlock/docking/sol_frigate/catwalkB
	name = "Forward Catwalk airlock, B"
	master_tag = "airlock_solfrig_fore_lockB"
	landmark_tag = "airlock_solfrig_fore_lockB"
// --------

// Space landmarks
/obj/effect/shuttle_landmark/sol_frigate/nav1
	name = "Fore"
	landmark_tag = "sol_frigate_nav1"

/obj/effect/shuttle_landmark/sol_frigate/nav2
	name = "Aft"
	landmark_tag = "sol_frigate_nav2"

/obj/effect/shuttle_landmark/sol_frigate/nav3
	name = "Port"
	landmark_tag = "sol_frigate_nav3"

/obj/effect/shuttle_landmark/sol_frigate/nav4
	name = "Starboard"
	landmark_tag = "sol_frigate_nav4"
// --------
//hangar landmarks
/obj/effect/shuttle_landmark/solfrig_shuttle/hangar
	name = "Solarian Frigate - Catwalk docking area"
	landmark_tag = "nav_hangar_solfrig"
	docking_controller = "solfrig_shuttle_dock"
	base_area = /area/ship/sol_frigate
	base_turf = /turf/simulated/floor/plating
	movable_flags = MOVABLE_FLAG_EFFECTMOVE
	// -------
