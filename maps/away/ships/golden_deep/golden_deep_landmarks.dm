/obj/effect/shuttle_landmark/golden_deep
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/golden_deep/nav1
	name = "Golden Deep Mercantile Vessel, Fore"
	landmark_tag = "gd_nav1"

/obj/effect/shuttle_landmark/golden_deep/nav2
	name = "Golden Deep Mercantile Vessel, Aft"
	landmark_tag = "gd_nav2"

/obj/effect/shuttle_landmark/golden_deep/nav3
	name = "Golden Deep Mercantile Vessel, Port"
	landmark_tag = "gd_nav3"

/obj/effect/shuttle_landmark/golden_deep/nav4
	name = "Golden Deep Mercantile Vessel, Starboard"
	landmark_tag = "gd_nav4"

// Docking port shuttle landmarks and airlock markers, D2.
// Aft docking port.
/obj/effect/shuttle_landmark/golden_deep/dock1
	name = "Golden Deep Mercantile Vessel, Aft Port"
	docking_controller = "airlock_gd_dock1"
	landmark_tag = "gd_dock1"

/obj/effect/map_effect/marker/airlock/docking/golden_deep/dock1
	name = "Aft"
	master_tag = "airlock_gd_dock1"
	landmark_tag = "gd_dock1"

// Portside docking port.
/obj/effect/shuttle_landmark/golden_deep/dock2
	name = "Golden Deep Mercantile Vessel, Portside Port"
	docking_controller = "airlock_gd_dock2"
	landmark_tag = "gd_dock2"

/obj/effect/map_effect/marker/airlock/docking/golden_deep/dock2
	name = "Port"
	master_tag = "airlock_gd_dock2"
	landmark_tag = "gd_dock2"

// Starboard docking port.
/obj/effect/shuttle_landmark/golden_deep/dock3
	name = "Golden Deep Mercantile Vessel, Starboard Port"
	docking_controller = "airlock_gd_dock3"
	landmark_tag = "gd_dock3"

/obj/effect/map_effect/marker/airlock/docking/golden_deep/dock3
	name = "Starboard"
	master_tag = "airlock_gd_dock3"
	landmark_tag = "gd_dock3"

// First fore docking port.
/obj/effect/shuttle_landmark/golden_deep/dock4
	name = "Golden Deep Mercantile Vessel, Fore Dock #1"
	docking_controller = "airlock_gd_dock4"
	landmark_tag = "gd_dock4"

/obj/effect/map_effect/marker/airlock/docking/golden_deep/dock4
	name = "Fore #1"
	master_tag = "airlock_gd_dock4"
	landmark_tag = "gd_dock4"

// Second fore docking port.
/obj/effect/shuttle_landmark/golden_deep/dock5
	name = "Golden Deep Mercantile Vessel, Fore Dock #2"
	docking_controller = "airlock_gd_dock5"
	landmark_tag = "gd_dock5"

/obj/effect/map_effect/marker/airlock/docking/golden_deep/dock5
	name = "Fore #2"
	master_tag = "airlock_gd_dock5"
	landmark_tag = "gd_dock5"

// Non-docking airlocks.
/obj/effect/map_effect/marker/airlock/golden_deep/bridge
	name = "Bridge Airlock"
	master_tag = "airlock_gd_bridge"

/obj/effect/map_effect/marker/airlock/golden_deep/fore_port
	name = "Fore Port Airlock"
	master_tag = "airlock_gd_fore_port"

/obj/effect/map_effect/marker/airlock/golden_deep/fore_starboard
	name = "Fore Starboard Airlock"
	master_tag = "airlock_gd_fore_starboard"

/obj/effect/map_effect/marker/airlock/golden_deep/d2_aft_starboard
	name = "Deck Two Aft Starboard Airlock"
	master_tag = "airlock_gd_aft_starboard_d2"

/obj/effect/map_effect/marker/airlock/golden_deep/d2_port_starboard
	name = "Deck Two Port Starboard Airlock"
	master_tag = "airlock_gd_aft_port_d2"

// Lift
/datum/shuttle/autodock/multi/lift/gd
	name = "Golden Deep Lift"
	current_location = "nav_gd_lift_first_deck"
	shuttle_area = /area/turbolift/golden_deep/gd_lift
	destination_tags = list(
		"nav_gd_lift_first_deck",
		"nav_gd_lift_second_deck",
		)

/obj/effect/shuttle_landmark/lift/gd_first_deck
	name = "Collective Mercantile Vessel - First Deck"
	landmark_tag = "nav_gd_lift_first_deck"
	base_area = /area/golden_deep/warehouse
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/lift/gd_second_deck
	name = "Collective Mercantile Vessel - Second Deck"
	landmark_tag = "nav_gd_lift_second_deck"
	base_area = /area/golden_deep/central_hallway
	base_turf = /turf/simulated/open

/obj/machinery/computer/shuttle_control/multi/lift/gd
	shuttle_tag = "Golden Deep Lift"

/obj/machinery/computer/shuttle_control/multi/lift/wall/gd
	shuttle_tag = "Golden Deep Lift"

// Storage compartment submaps.
/obj/effect/map_effect/marker/mapmanip/submap/extract/golden_deep
	name = "Golden Deep Mercantile Vessel - Storage Compartment"

/obj/effect/map_effect/marker/mapmanip/submap/insert/golden_deep
	name = "Golden Deep Mercantile Vessel - Storage Compartment"
