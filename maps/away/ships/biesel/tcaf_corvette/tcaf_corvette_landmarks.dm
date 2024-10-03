// Lift
/datum/shuttle/autodock/multi/lift/tcaf
	name = "TCAF Lift"
	current_location = "nav_tcaf_lift_first_deck"
	shuttle_area = /area/turbolift/tcaf_corvette/tcaf_lift
	destination_tags = list(
		"nav_tcaf_lift_first_deck",
		"nav_tcaf_lift_second_deck",
		)

/obj/effect/shuttle_landmark/lift/tcaf_first_deck
	name = "Republican Fleet Corvette - First Deck"
	landmark_tag = "nav_tcaf_lift_first_deck"
	base_area = /area/tcaf_corvette/hangar
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/lift/tcaf_second_deck
	name = "Republican Fleet Corvette - Second Deck"
	landmark_tag = "nav_tcaf_lift_second_deck"
	base_area = /area/tcaf_corvette/central_lift
	base_turf = /turf/simulated/open

/obj/machinery/computer/shuttle_control/multi/lift/tcaf
	shuttle_tag = "TCAF Lift"

// Shuttle landmarks.
/obj/effect/shuttle_landmark/tcaf_corvette
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/tcaf_corvette/nav1
	name = "Fore"
	landmark_tag = "tcaf_corvette_nav1"

/obj/effect/shuttle_landmark/tcaf_corvette/nav2
	name = "Aft"
	landmark_tag = "tcaf_corvette_nav2"

/obj/effect/shuttle_landmark/tcaf_corvette/nav3
	name = "Port"
	landmark_tag = "tcaf_corvette_nav3"

/obj/effect/shuttle_landmark/tcaf_corvette/nav4
	name = "Starboard"
	landmark_tag = "tcaf_corvette_nav4"

/obj/effect/shuttle_landmark/tcaf_corvette/dock_port
	name = "Port Docking Port"
	docking_controller = "airlock_tcaf_port_dock"
	landmark_tag = "tcaf_corvette_port_dock"

/obj/effect/shuttle_landmark/tcaf_corvette/dock_starboard
	name = "Starboard Docking Port"
	docking_controller = "airlock_tcaf_starboard_dock"
	landmark_tag = "tcaf_corvette_starboard_dock"

/obj/effect/shuttle_landmark/tcaf_corvette/dock_aft
	name = "Aft Docking Port"
	docking_controller = "airlock_tcaf_aft_dock"
	landmark_tag = "tcaf_corvette_aft_dock"

/obj/effect/shuttle_landmark/tcaf_corvette/dock_fore
	name = "Fore Docking Port"
	docking_controller = "airlock_tcaf_fore_dock"
	landmark_tag = "tcaf_corvette_fore_dock"

// Non-docking airlock markers, for the small airlocks on deck two.
/obj/effect/map_effect/marker/airlock/tcaf_corvette/starboard_small_aft
	name = "Starboard Aft, Small"
	master_tag = "airlock_tcaf_starboard_aft"

/obj/effect/map_effect/marker/airlock/tcaf_corvette/port_small_aft
	name = "Port Aft, Small"
	master_tag = "airlock_tcaf_port_aft"

/obj/effect/map_effect/marker/airlock/tcaf_corvette/starboard_small_fore
	name = "Starboard Fore, Small"
	master_tag = "airlock_tcaf_starboard_fore"

/obj/effect/map_effect/marker/airlock/tcaf_corvette/port_small_fore
	name = "Port Fore, Small"
	master_tag = "airlock_tcaf_port_fore"

// Docking airlock markers, for deck one.
/obj/effect/map_effect/marker/airlock/docking/tcaf_corvette/aft_dock
	name = "Aft"
	master_tag = "airlock_tcaf_aft_dock"
	landmark_tag = "tcaf_corvette_aft_dock"

/obj/effect/map_effect/marker/airlock/docking/tcaf_corvette/fore_dock
	name = "Fore"
	master_tag = "airlock_tcaf_fore_dock"
	landmark_tag = "tcaf_corvette_fore_dock"

/obj/effect/map_effect/marker/airlock/docking/tcaf_corvette/port_dock
	name = "Port"
	master_tag = "airlock_tcaf_port_dock"
	landmark_tag = "tcaf_corvette_port_dock"

/obj/effect/map_effect/marker/airlock/docking/tcaf_corvette/starboard_dock
	name = "Starboard"
	master_tag = "airlock_tcaf_starboard_dock"
	landmark_tag = "tcaf_corvette_starboard_dock"
