//-// Burglar Shuttle //-//

/datum/shuttle/autodock/multi/antag/burglar_ship
	name = "Water Bear"
	current_location = "nav_burglar_start"
	landmark_transition = "nav_burglar_interim"
	dock_target = "burglar_shuttle"
	warmup_time = 10
	move_time = 75
	shuttle_area = /area/shuttle/burglar
	destination_tags = list(
		"nav_burglar_start",
		"nav_burglar_hangar",
		"nav_horizon_dock_deck_3_starboard_1",
		NAV_HORIZON_EXTERIOR_ALL_DECKS,
		NAV_HORIZON_EXTERIOR_ALL_SNEAKY,
		)

	announcer = "Automated Radar System"
	arrival_message = "Attention, the radar systems have detected a small spacecraft approaching the ship's perimeter."
	departure_message = "Attention, the radar systems have detected a small spacecraft leaving the ship's perimeter. "

/obj/effect/shuttle_landmark/burglar_ship/start
	name = "Hideout"
	landmark_tag = "nav_burglar_start"
	docking_controller = "burglar_hideout"
	base_turf = /turf/unsimulated/floor/plating
	base_area = /area/antag/burglar

/obj/effect/shuttle_landmark/burglar_ship/interim
	name = "In Transit"
	landmark_tag = "nav_burglar_interim"
	base_turf = /turf/space/transit/north

/obj/effect/shuttle_landmark/burglar_ship/hangar
	name = "First Deck Port Hangar Bay 1b"
	landmark_tag = "nav_burglar_hangar"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

//-// Raider Skipjack //-//

/datum/shuttle/autodock/multi/antag/skipjack_ship
	name = "Skipjack"
	current_location = "nav_skipjack_start"
	landmark_transition = "nav_skipjack_interim"
	dock_target = "raider_east_control"
	warmup_time = 10
	move_time = 75
	shuttle_area = /area/shuttle/skipjack
	destination_tags = list(
		"nav_skipjack_start",
		"nav_horizon_dock_deck_3_starboard_3",
		NAV_HORIZON_EXTERIOR_ALL_DECKS,
		NAV_HORIZON_EXTERIOR_ALL_SNEAKY,
		)

	announcer = "SCCV Horizon Sensor Array"
	arrival_message = "Attention, the radar systems have detected a small spacecraft approaching the ship's perimeter."
	departure_message = "Attention, the radar systems have detected a small spacecraft leaving the ship's perimeter. "

/obj/effect/shuttle_landmark/skipjack_ship/start
	name = "Raider Hideout"
	landmark_tag = "nav_skipjack_start"
	docking_controller = "pirate_hideout"
	base_turf = /turf/space/dynamic

/obj/effect/shuttle_landmark/skipjack_ship/interim
	name = "In Transit"
	landmark_tag = "nav_skipjack_interim"
	base_turf = /turf/space/transit/north

//-// Mercenary Shuttle //-//

/datum/shuttle/autodock/multi/antag/merc_ship
	name = "ICV Raskolnikov"
	current_location = "nav_merc_start"
	landmark_transition = "nav_merc_interim"
	dock_target = "merc_shuttle"
	warmup_time = 10
	move_time = 75
	shuttle_area = /area/shuttle/mercenary
	destination_tags = list(
		"nav_merc_start",
		"nav_horizon_dock_deck_3_starboard_1",
		NAV_HORIZON_EXTERIOR_ALL_DECKS,
		NAV_HORIZON_EXTERIOR_ALL_SNEAKY,
		)

	announcer = "SCCV Horizon Sensor Array"
	arrival_message = "Attention, the radar systems have detected a spacecraft approaching the ship's perimeter."
	departure_message = "Attention, the radar systems have detected a spacecraft leaving the ship's perimeter. "

/obj/effect/shuttle_landmark/merc_ship/base
	name = "Mercenary Base"
	landmark_tag = "nav_merc_start"
	docking_controller = "merc_base"
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/merc_ship/interim
	name = "In Transit"
	landmark_tag = "nav_merc_interim"
	base_turf = /turf/space/transit/north

// Intrepid
/datum/shuttle/autodock/overmap/intrepid
	name = "Intrepid"
	move_time = 20
	shuttle_area = list(/area/horizon/shuttle/intrepid/main_compartment, /area/horizon/shuttle/intrepid/port_compartment, /area/horizon/shuttle/intrepid/starboard_compartment, /area/horizon/shuttle/intrepid/junction_compartment, /area/horizon/shuttle/intrepid/buffet, /area/horizon/shuttle/intrepid/medical, /area/horizon/shuttle/intrepid/engineering, /area/horizon/shuttle/intrepid/port_storage, /area/horizon/shuttle/intrepid/flight_deck)
	dock_target = "airlock_shuttle_intrepid"
	current_location = "nav_hangar_intrepid"
	landmark_transition = "nav_transit_intrepid"
	range = 2
	fuel_consumption = 4
	logging_home_tag = "nav_hangar_intrepid"

/obj/effect/shuttle_landmark/intrepid/hangar
	name = "First Deck Intrepid Hangar Bay"
	landmark_tag = "nav_hangar_intrepid"
	docking_controller = "intrepid_dock"
	base_area = /area/horizon/hangar/intrepid
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/intrepid/transit
	name = "In transit"
	landmark_tag = "nav_transit_intrepid"
	base_turf = /turf/space/transit/north

// Canary
/datum/shuttle/autodock/overmap/canary
	name = "Canary"
	move_time = 20
	shuttle_area = list(/area/horizon/shuttle/canary)
	dock_target = "canary_shuttle"
	current_location = "nav_hangar_canary"
	landmark_transition = "nav_transit_canary"
	range = 2
	fuel_consumption = 4
	logging_home_tag = "nav_hangar_canary"

/obj/effect/shuttle_landmark/canary/hangar
	name = "First Deck Canary Hangar Bay"
	landmark_tag = "nav_hangar_canary"
	docking_controller = "canary_dock"
	base_area = /area/horizon/hangar/auxiliary
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/canary/transit
	name = "In transit"
	landmark_tag = "nav_transit_canary"
	base_turf = /turf/space/transit/north

// Quark
/datum/shuttle/autodock/overmap/quark
	name = "Quark"
	move_time = 20
	shuttle_area = list(/area/horizon/shuttle/quark/cockpit, /area/horizon/shuttle/quark/cargo_hold)
	dock_target = "airlock_shuttle_quark"
	current_location = "nav_hangar_quark"
	landmark_transition = "nav_transit_quark"
	range = 1
	fuel_consumption = 3
	logging_home_tag = "nav_hangar_quark"

/obj/effect/shuttle_landmark/quark/hangar
	name = "First Deck Quark Hangar Bay"
	landmark_tag = "nav_hangar_quark"
	docking_controller = "quark_dock"
	base_area = /area/horizon/hangar/auxiliary
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/quark/transit
	name = "In transit"
	landmark_tag = "nav_transit_quark"
	base_turf = /turf/space/transit/north

// Mining Shuttle
/datum/shuttle/autodock/overmap/mining
	name = "Spark"
	move_time = 20
	shuttle_area = /area/horizon/shuttle/mining
	dock_target = "airlock_shuttle_spark"
	current_location = "nav_hangar_mining"
	landmark_transition = "nav_transit_mining"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_mining"

/obj/effect/shuttle_landmark/mining/hangar
	name = "First Deck Spark Hangar Bay"
	landmark_tag = "nav_hangar_mining"
	docking_controller = "mining_shuttle_dock"
	base_turf = /turf/simulated/floor/airless
	base_area = /area/horizon/hangar/operations
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/effect/shuttle_landmark/mining/transit
	name = "In transit"
	landmark_tag = "nav_transit_mining"

// Cargo Elevator
/datum/shuttle/autodock/ferry/supply/horizon
	name = "Cargo Elevator"
	location = 1
	shuttle_area = /area/supply/dock
	dock_target = "cargo_shuttle"
	waypoint_station = "nav_cargo_shuttle_dock"
	waypoint_offsite = "nav_cargo_shuttle_start"
	squishes = FALSE
	cargo_elevator = TRUE

/obj/effect/shuttle_landmark/supply/horizon/start
	name = "Cargo Elevator - Bottom Automated Cargo Hold Dock"
	landmark_tag = "nav_cargo_shuttle_start"
	base_turf = /turf/unsimulated/floor/plating
	base_area = /area/centcom

/obj/effect/shuttle_landmark/supply/horizon/dock
	name = "Cargo Elevator - Top Operations Dock"
	landmark_tag = "nav_cargo_shuttle_dock"
	docking_controller = "cargo_shuttle_dock"
	base_turf = /turf/simulated/floor/plating/cargo_elevator
	base_area = /area/horizon/hangar/operations

//-// Admin Corvette //-//
/datum/shuttle/autodock/multi/crescent
	name = "ICV Crescent"
	current_location = "nav_crescent_start"
	warmup_time = 10
	shuttle_area = /area/shuttle/hapt
	dock_target = "crescent_shuttle"
	destination_tags = list(
		"nav_crescent_start",
		"nav_horizon_dock_deck_3_starboard_2"
		)

/obj/effect/shuttle_landmark/crescent/start
	name = "Corvette Hangar"
	landmark_tag = "nav_crescent_start"
	docking_controller = "crescent_shuttle_bay"
	base_turf = /turf/unsimulated/floor/plating
	base_area = /area/centcom
