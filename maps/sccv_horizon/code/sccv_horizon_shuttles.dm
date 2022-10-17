//-// Burglar Shuttle //-//

/datum/shuttle/autodock/multi/antag/burglar_ship
	name = "Burglar Pod"
	current_location = "nav_burglar_start"
	landmark_transition = "nav_burglar_interim"
	dock_target = "burglar_shuttle"
	warmup_time = 10
	move_time = 75
	shuttle_area = /area/shuttle/burglar
	destination_tags = list(
		"nav_burglar_start",
		"nav_burglar_hangar",
		"nav_burglar_second_deck",
		"nav_burglar_third_deck"
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
	base_turf = /turf/space/transit/south

/obj/effect/shuttle_landmark/burglar_ship/hangar
	name = "Port Hangar"
	landmark_tag = "nav_burglar_hangar"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/burglar_ship/second_deck
	name = "Second Deck"
	landmark_tag = "nav_burglar_second_deck"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/burglar_ship/third_deck
	name = "Third Deck"
	landmark_tag = "nav_burglar_third_deck"
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
		"nav_skipjack_third_deck",
		"nav_skipjack_second_deck",
		"nav_skipjack_first_deck"
		)

	landmark_transition = "nav_skipjack_interim"
	announcer = "SCCV Horizon Sensor Array"
	arrival_message = "Attention, the radar systems have detected a small spacecraft approaching the ship's perimeter."
	departure_message = "Attention, the radar systems have detected a small spacecraft leaving the ship's perimeter. "

/obj/effect/shuttle_landmark/skipjack_ship/start
	name = "Raider Hideout"
	landmark_tag = "nav_skipjack_start"
	docking_controller = "pirate_hideout"
	base_turf = /turf/space/dynamic
	base_area = /area/template_noop

/obj/effect/shuttle_landmark/skipjack_ship/interim
	name = "In Transit"
	landmark_tag = "nav_skipjack_interim"
	base_turf = /turf/space/transit/south

/obj/effect/shuttle_landmark/skipjack_ship/third_deck
	name = "Third Deck"
	landmark_tag = "nav_skipjack_third_deck"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/skipjack_ship/second_deck
	name = "Second Deck"
	landmark_tag = "nav_skipjack_second_deck"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/skipjack_ship/first_deck
	name = "First Deck"
	landmark_tag = "nav_skipjack_first_deck"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

//-// Mercenary Shuttle //-//

/datum/shuttle/autodock/multi/antag/merc_ship
	name = "Mercenary Shuttle"
	current_location = "nav_merc_start"
	landmark_transition = "nav_merc_interim"
	dock_target = "merc_shuttle"
	warmup_time = 10
	move_time = 75
	shuttle_area = /area/shuttle/mercenary
	destination_tags = list(
		"nav_merc_dock",
		"nav_merc_start",
		"nav_third_deck",
		"nav_second_deck",
		"nav_first_deck"
		)

	landmark_transition = "nav_merc_interim"
	announcer = "SCCV Horizon Sensor Array"
	arrival_message = "Attention, the radar systems have detected a spacecraft approaching the ship's perimeter."
	departure_message = "Attention, the radar systems have detected a spacecraft leaving the ship's perimeter. "

/obj/effect/shuttle_landmark/merc_ship/base
	name = "Mercenary Base"
	landmark_tag = "nav_merc_start"
	docking_controller = "merc_base"
	base_turf = /turf/space/dynamic
	base_area = /area/template_noop

/obj/effect/shuttle_landmark/merc_ship/interim
	name = "In Transit"
	landmark_tag = "nav_merc_interim"
	base_turf = /turf/space/transit/south

/obj/effect/shuttle_landmark/merc_ship/dock
	name = "Third Deck Dock"
	landmark_tag = "nav_merc_dock"
	docking_controller = "nuke_shuttle_dock_airlock"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/merc_ship/third_deck
	name = "Third Deck Outside"
	landmark_tag = "nav_third_deck"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/merc_ship/second_deck
	name = "Second Deck Outside"
	landmark_tag = "nav_second_deck"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

/obj/effect/shuttle_landmark/merc_ship/first_deck
	name = "First Deck Outside"
	landmark_tag = "nav_first_deck"
	landmark_flags = SLANDMARK_FLAG_AUTOSET

// Intrepid
/datum/shuttle/autodock/overmap/intrepid
	name = "Intrepid"
	move_time = 20
	shuttle_area = list(/area/shuttle/intrepid/crew_compartment, /area/shuttle/intrepid/cargo_bay, /area/shuttle/intrepid/medical_compartment, /area/shuttle/intrepid/engine_compartment, /area/shuttle/intrepid/atmos_compartment, /area/shuttle/intrepid/cockpit)
	dock_target = "intrepid_shuttle"
	current_location = "nav_hangar_intrepid"
	landmark_transition = "nav_transit_intrepid"
	range = 2
	fuel_consumption = 4
	logging_home_tag = "nav_hangar_intrepid"

/obj/effect/shuttle_landmark/intrepid/hangar
	name = "Intrepid Hangar"
	landmark_tag = "nav_hangar_intrepid"
	docking_controller = "intrepid_dock"
	base_area = /area/hangar/intrepid
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/intrepid/transit
	name = "In transit"
	landmark_tag = "nav_transit_intrepid"
	base_turf = /turf/space/transit

// Mining Shuttle
/datum/shuttle/autodock/overmap/mining
	name = "Pickaxe"
	move_time = 20
	shuttle_area = /area/shuttle/mining
	dock_target = "mining_shuttle_controller"
	current_location = "nav_hangar_mining"
	landmark_transition = "nav_transit_mining"
	range = 1
	fuel_consumption = 2
	logging_home_tag = "nav_hangar_mining"

/obj/effect/shuttle_landmark/mining/hangar
	name = "Mining Shuttle Hangar"
	landmark_tag = "nav_hangar_mining"
	docking_controller = "mining_shuttle_dock"
	base_turf = /turf/simulated/floor/airless
	base_area = /area/hangar/operations

/obj/effect/shuttle_landmark/mining/transit
	name = "In transit"
	landmark_tag = "nav_transit_mining"

// Cargo Shuttle
/datum/shuttle/autodock/ferry/supply/horizon
	name = "Horizon Cargo Shuttle"
	location = 1
	shuttle_area = /area/supply/dock
	dock_target = "cargo_shuttle"
	waypoint_station = "nav_cargo_shuttle_dock"
	waypoint_offsite = "nav_cargo_shuttle_start"

/obj/effect/shuttle_landmark/supply/horizon/start
	name = "Horizon Cargo Shuttle Central Command Dock"
	landmark_tag = "nav_cargo_shuttle_start"
	base_turf = /turf/unsimulated/floor/plating
	base_area = /area/centcom

/obj/effect/shuttle_landmark/supply/horizon/dock
	name = "Horizon Cargo Shuttle Dock"
	landmark_tag = "nav_cargo_shuttle_dock"
	docking_controller = "cargo_shuttle_dock"
	landmark_flags = SLANDMARK_FLAG_AUTOSET