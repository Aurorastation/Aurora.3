// Maintenance airlocks
/obj/effect/map_effect/marker/airlock/dominian_corvette/aft_hangar
	name = "Maintenance Hatch"
	master_tag = "dominia_aft_hangar"

/obj/effect/map_effect/marker/airlock/dominian_corvette/aft_starboard
	name = "Maintenance Hatch"
	master_tag = "dominia_aft_starboard"

/obj/effect/map_effect/marker/airlock/dominian_corvette/aft_port
	name = "Maintenance Hatch"
	master_tag = "dominia_aft_port"

// Docking Ports
// Starboard dock
/obj/effect/map_effect/marker/airlock/docking/dominian_corvette/starboard_dock
	name = "Starboard Dock"
	master_tag = "airlock_dominia_starboard_dock"
	landmark_tag = "dominian_corvette_starboard_dock"

/obj/effect/shuttle_landmark/dominian_corvette/dock_starboard
	name = "Starboard Dock"
	docking_controller = "airlock_dominia_starboard_dock"
	landmark_tag = "dominian_corvette_starboard_dock"

// Port dock
/obj/effect/map_effect/marker/airlock/docking/dominian_corvette/port_dock
	name = "Port Dock"
	master_tag = "airlock_dominia_port_dock"
	landmark_tag = "dominian_corvette_port_dock"

/obj/effect/shuttle_landmark/dominian_corvette/dock_port
	name = "Port Dock"
	docking_controller = "airlock_dominia_port_dock"
	landmark_tag = "dominian_corvette_port_dock"

// Aft dock
/obj/effect/map_effect/marker/airlock/docking/dominian_corvette/aft_dock
	name = "Aft Dock"
	master_tag = "airlock_dominia_aft_dock"
	landmark_tag = "dominian_corvette_aft_dock"

/obj/effect/shuttle_landmark/dominian_corvette/dock_aft
	name = "Aft Dock"
	docking_controller = "airlock_dominia_aft_dock"
	landmark_tag = "dominian_corvette_aft_dock"

// Fore dock
/obj/effect/map_effect/marker/airlock/docking/dominian_corvette/fore_dock
	name = "Fore Dock"
	master_tag = "airlock_dominia_fore_dock"
	landmark_tag = "dominian_corvette_fore_dock"

/obj/effect/shuttle_landmark/dominian_corvette/dock_fore
	name = "Fore Dock"
	docking_controller = "airlock_dominia_fore_dock"
	landmark_tag = "dominian_corvette_fore_dock"

// Space landmarks
/obj/effect/shuttle_landmark/dominian_corvette/nav1
	name = "Dominian Corvette - Fore"
	landmark_tag = "nav_dominian_corvette_1"

/obj/effect/shuttle_landmark/dominian_corvette/nav2
	name = "Dominian Corvette - Aft"
	landmark_tag = "nav_dominian_corvette_2"

/obj/effect/shuttle_landmark/dominian_corvette/nav3
	name = "Dominian Corvette - Starboard"
	landmark_tag = "nav_dominian_corvette_3"

/obj/effect/shuttle_landmark/dominian_corvette/nav4
	name = "Dominian Corvette - Port"
	landmark_tag = "nav_dominian_corvette_4"

// Lift
/datum/shuttle/autodock/multi/lift/dominia
	name = "Dominian Corvette Lift"
	current_location = "nav_dominia_lift_second_deck"
	shuttle_area = /area/turbolift/dominian_corvette/dominian_lift
	destination_tags = list(
		"nav_dominia_lift_first_deck",
		"nav_dominia_lift_second_deck",
		)

/obj/effect/shuttle_landmark/lift/dominia_first_deck
	name = "Dominian Corvette - First Deck"
	landmark_tag = "nav_dominia_lift_first_deck"
	base_area = /area/dominian_corvette/hangar
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/lift/dominia_second_deck
	name = "Dominian Corvette - Second Deck"
	landmark_tag = "nav_dominia_lift_second_deck"
	base_area = /area/dominian_corvette/central_lift
	base_turf = /turf/simulated/open

/obj/machinery/computer/shuttle_control/multi/lift/dominian_corvette
	shuttle_tag = "Dominian Corvette Lift"
