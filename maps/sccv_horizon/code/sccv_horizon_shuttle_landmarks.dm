
//
// This file is intended for "generic" shuttle landmarks.
// Generic, meaning visible to and selectable by any shuttle.
//

// ================================ hangars

/obj/effect/shuttle_landmark/horizon/hangar1
	name = "First Deck Port Hangar Bay 1a"
	landmark_tag = "nav_hangar_horizon_1"
	base_turf = /turf/simulated/floor/plating
	base_area = /area/hangar/auxiliary

/obj/effect/shuttle_landmark/horizon/hangar2
	name = "First Deck Port Hangar Bay 2a"
	landmark_tag = "nav_hangar_horizon_2"
	base_turf = /turf/simulated/floor/plating
	base_area = /area/hangar/auxiliary

// ================================ exterior docks

/obj/effect/shuttle_landmark/horizon/dock/deck_3/starboard_1
	name = "Third Deck Starboard Dock 2"
	landmark_tag = "nav_dock_horizon_1"
	docking_controller = "dock_horizon_1_airlock"
	base_turf = /turf/simulated/floor/reinforced/airless
	base_area = /area/space

/obj/effect/shuttle_landmark/horizon/dock/deck_3/starboard_3
	name = "Third Deck Starboard Dock 3"
	landmark_tag = "nav_dock_horizon_3"
	docking_controller = "dock_horizon_3_airlock"
	base_turf = /turf/simulated/floor/reinforced/airless
	base_area = /area/space

/obj/effect/shuttle_landmark/horizon/dock/deck_3/port_1
	name = "Third Deck Port Dock 1"
	landmark_tag = "nav_dock_horizon_2"
	docking_controller = "green_dock_aft_airlock"
	base_turf = /turf/simulated/floor/reinforced/airless
	base_area = /area/space

/obj/effect/shuttle_landmark/horizon/dock/deck_3/port_2
	name = "Third Deck Port Dock 2"
	landmark_tag = "nav_dock_horizon_4"
	docking_controller = "dock_horizon_4_airlock"
	base_turf = /turf/simulated/floor/reinforced/airless
	base_area = /area/space

/obj/effect/shuttle_landmark/horizon/dock/deck_3/port_3
	name = "Third Deck Port Dock 3"
	landmark_tag = "nav_dock_horizon_5"
	docking_controller = "specops_dock_airlock"
	base_turf = /turf/simulated/floor/reinforced/airless
	base_area = /area/space

// ================================ exterior deck 1

/obj/effect/shuttle_landmark/horizon/exterior/deck_1
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/horizon/exterior/deck_1/fore
	name = "Deck One, Fore of Horizon"
	landmark_tag = "deck_one_fore_of_horizon"

/obj/effect/shuttle_landmark/horizon/exterior/deck_1/port
	name = "Deck One, Port of Horizon"
	landmark_tag = "deck_one_port_side"

/obj/effect/shuttle_landmark/horizon/exterior/deck_1/starboard
	name = "Deck One, Starboard of Horizon"
	landmark_tag = "deck_one_starboard_side"

/obj/effect/shuttle_landmark/horizon/exterior/deck_1/aft
	name = "Deck One, Aft of Horizon"
	landmark_tag = "deck_one_aft_of_horizon"

/obj/effect/shuttle_landmark/horizon/exterior/deck_1/port_propulsion
	name = "Deck One, Near Port Propulsion"
	landmark_tag = "deck_one_near_port_propulsion"

/obj/effect/shuttle_landmark/horizon/exterior/deck_1/starboard_propulsion
	name = "Deck One, Near Starboard Propulsion"
	landmark_tag = "deck_one_near_starboard_propulsion"

// ================================ exterior deck 2

/obj/effect/shuttle_landmark/horizon/exterior/deck_2
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/horizon/exterior/deck_2/fore
	name = "Deck Two, Fore of Horizon"
	landmark_tag = "deck_two_fore_of_horizon"

/obj/effect/shuttle_landmark/horizon/exterior/deck_2/starboard_fore
	name = "Deck Two, Starboard Fore of Horizon"
	landmark_tag = "deck_two_starboard_fore"

/obj/effect/shuttle_landmark/horizon/exterior/deck_2/port_fore
	name = "Deck Two, Port Fore of Horizon"
	landmark_tag = "deck_two_port_fore"

/obj/effect/shuttle_landmark/horizon/exterior/deck_2/aft
	name = "Deck Two, Aft of Horizon"
	landmark_tag = "deck_two_aft_of_horizon"

/obj/effect/shuttle_landmark/horizon/exterior/deck_2/starboard_aft
	name = "Deck One, Starboard Aft of horizon"
	landmark_tag = "deck_two_starboard_aft"

/obj/effect/shuttle_landmark/horizon/exterior/deck_2/port_aft
	name = "Deck One, Port Aft of Horizon"
	landmark_tag = "deck_two_port_aft"

// ================================ exterior deck 3

/obj/effect/shuttle_landmark/horizon/exterior/deck_3
	base_turf = /turf/space
	base_area = /area/space

/obj/effect/shuttle_landmark/horizon/exterior/deck_3/fore
	name = "Deck Three, Fore of Horizon"
	landmark_tag = "deck_three_fore_of_horizon"

/obj/effect/shuttle_landmark/horizon/exterior/deck_3/starboardfore
	name = "Deck Three, Starboard Fore of Horizon"
	landmark_tag = "deck_three_fore_starboard_of_horizon"

/obj/effect/shuttle_landmark/horizon/exterior/deck_3/portfore
	name = "Deck Three, Fore Port of Horizon"
	landmark_tag = "deck_three_port_fore_of_horizon"

/obj/effect/shuttle_landmark/horizon/exterior/deck_3/portaft
	name = "Deck Three, Aft Port of Horizon"
	landmark_tag = "deck_three_port_aft_of_horizon"

/obj/effect/shuttle_landmark/horizon/exterior/deck_3/aft
	name = "Deck Three, Aft of Horizon"
	landmark_tag = "deck_three_aft_of_horizon"
