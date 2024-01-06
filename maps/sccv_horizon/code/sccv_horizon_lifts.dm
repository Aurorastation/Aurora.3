/obj/turbolift_map_holder/scc_ship
	depth = 2
	lift_size_x = 4
	lift_size_y = 4
	clear_objects = 0

//Primary Lift
/obj/turbolift_map_holder/scc_ship/primary
	name = "NCV Aurora Lift - Primary"
	dir = SOUTH

	depth = 3
	lift_size_x = 4
	lift_size_y = 4

	areas_to_use = list(
		/area/turbolift/primary/deck_1,
		/area/turbolift/primary/deck_2,
		/area/turbolift/primary/deck_3
		)

/area/turbolift/primary/deck_1
	name = "Primary Lift - Deck 1"
	lift_announce_str = "Arriving at Deck 1."

	lift_floor_label = "Deck 1"
	lift_floor_name = "Lower Deck"

	base_turf = /turf/simulated/floor/plating

/area/turbolift/primary/deck_2
	name = "Primary Lift - Deck 2"
	lift_announce_str = "Arriving at Deck 2."

	lift_floor_label = "Deck 2"
	lift_floor_name = "Main Deck"

/area/turbolift/primary/deck_3
	name = "Primary Lift - Deck 3"
	lift_announce_str = "Arriving at Deck 3."

	lift_floor_label = "Deck 3"
	lift_floor_name = "Upper Deck"

//Research Lift
/obj/turbolift_map_holder/scc_ship/research
	name = "NCV Aurora Lift - Research"
	icon = 'icons/obj/turbolift_preview_2x2.dmi'
	dir = SOUTH

	depth = 2
	lift_size_x = 3
	lift_size_y = 3

	areas_to_use = list(
		/area/turbolift/research/deck_1,
		/area/turbolift/research/deck_2
		)

/area/turbolift/research/deck_1
	name = "Research Lift - Deck 1"
	lift_announce_str = "Arriving at Deck 1."

	lift_floor_label = "Deck 1"
	lift_floor_name = "Lower Deck"

	base_turf = /turf/simulated/floor/plating

/area/turbolift/research/deck_2
	name = "Research Lift - Deck 2"
	lift_announce_str = "Arriving at Deck 2."

	lift_floor_label = "Deck 2"
	lift_floor_name = "Main Deck"

//Morgue Lift
/datum/shuttle/autodock/ferry/lift/scc_ship/morgue
	name = "Morgue Lift"
	location = 1
	shuttle_area = /area/turbolift/scc_ship/morgue_lift
	waypoint_station = "nav_morgue_lift_bottom"
	waypoint_offsite = "nav_morgue_lift_top"

/obj/effect/shuttle_landmark/lift
	name = "ABSTRACT DEF; DO NOT USE THIS"
	icon_state = "lift_landmark"

/obj/effect/shuttle_landmark/lift/morgue_top
	name = "Morgue Top"
	landmark_tag = "nav_morgue_lift_top"
	base_area = /area/hallway/medical
	base_turf = /turf/simulated/open

/obj/effect/shuttle_landmark/lift/morgue_bottom
	name = "Morgue Bottom"
	landmark_tag = "nav_morgue_lift_bottom"
	landmark_flags = SLANDMARK_FLAG_AUTOSET
	base_area = /area/medical/morgue/lower
	base_turf = /turf/simulated/floor/plating

/area/turbolift/scc_ship/morgue_lift
	name = "Morgue Lift"
	sound_env = TUNNEL_ENCLOSED
	ambience = AMBIENCE_GHOSTLY

//Operations Lift
/datum/shuttle/autodock/multi/lift/operations
	name = "Operations Lift"
	current_location = "nav_operations_lift_first_deck"
	shuttle_area = /area/turbolift/scc_ship/operations_lift
	destination_tags = list(
		"nav_operations_lift_first_deck",
		"nav_operations_lift_second_deck",
		)

/obj/effect/shuttle_landmark/lift/operations_first_deck
	name = "Operations Lift - First Deck"
	landmark_tag = "nav_operations_lift_first_deck"
	base_area = /area/operations/storage
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/lift/operations_second_deck
	name = "Operations Lift - Second Deck"
	landmark_tag = "nav_operations_lift_second_deck"
	base_area = /area/operations/office
	base_turf = /turf/simulated/open

/obj/machinery/computer/shuttle_control/multi/lift/operations
	shuttle_tag = "Operations Lift"

/obj/machinery/computer/shuttle_control/multi/lift/wall/operations
	shuttle_tag = "Operations Lift"

/area/turbolift/scc_ship/operations_lift
	name = "Operations Lift"
	sound_env = TUNNEL_ENCLOSED
	ambience = AMBIENCE_GHOSTLY


//Robotics Lift
/datum/shuttle/autodock/multi/lift/robotics
	name = "Robotics Lift 2"
	current_location = "nav_robotics_lift_second_deck"
	shuttle_area = /area/turbolift/scc_ship/robotics_lift
	destination_tags = list(
		"nav_robotics_lift_first_deck",
		"nav_robotics_lift_second_deck",
		"nav_robotics_lift_third_deck"
		)

/obj/effect/shuttle_landmark/lift/robotics_first_deck
	name = "Robotics Lift - First Deck"
	landmark_tag = "nav_robotics_lift_first_deck"
	landmark_flags = SLANDMARK_FLAG_AUTOSET
	base_area = /area/rnd/eva
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/lift/robotics_second_deck
	name = "Robotics Lift - Second Deck"
	landmark_tag = "nav_robotics_lift_second_deck"
	// landmark_flags = SLANDMARK_FLAG_AUTOSET
	base_area = /area/hallway/medical
	base_turf = /turf/simulated/open

/obj/effect/shuttle_landmark/lift/robotics_third_deck
	name = "Robotics Lift - Third Deck"
	landmark_tag = "nav_robotics_lift_third_deck"
	landmark_flags = SLANDMARK_FLAG_AUTOSET
	base_area = /area/hallway/medical
	base_turf = /turf/simulated/open

/obj/machinery/computer/shuttle_control/multi/lift/robotics
	shuttle_tag = "Robotics Lift 2"

/obj/machinery/computer/shuttle_control/multi/lift/wall/robotics
	shuttle_tag = "Robotics Lift 2"

/area/turbolift/scc_ship/robotics_lift
	name = "Robotics Lift"
	sound_env = TUNNEL_ENCLOSED
	ambience = AMBIENCE_GHOSTLY


