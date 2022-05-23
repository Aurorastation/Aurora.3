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

//Cargo Lift
/datum/shuttle/autodock/ferry/lift/scc_ship/cargo
	name = "Operations Lift"
	location = 1
	shuttle_area = /area/turbolift/scc_ship/cargo_lift
	waypoint_station = "nav_cargo_lift_bottom"
	waypoint_offsite = "nav_cargo_lift_top"

/obj/effect/shuttle_landmark/lift/cargo_top
	name = "Operations Top"
	landmark_tag = "nav_cargo_lift_top"
	base_area = /area/operations/storage
	base_turf = /turf/simulated/open

/obj/effect/shuttle_landmark/lift/cargo_bottom
	name = "Operations Bottom"
	landmark_tag = "nav_cargo_lift_bottom"
	flags = SLANDMARK_FLAG_AUTOSET
	base_area = /area/operations/loading
	base_turf = /turf/simulated/floor/plating

/area/turbolift/scc_ship/cargo_lift
	name = "Operations Lift"
	sound_env = STANDARD_STATION
	ambience = AMBIENCE_HANGAR

//Morgue Lift
/datum/shuttle/autodock/ferry/lift/scc_ship/morgue
	name = "Morgue Lift"
	location = 1
	shuttle_area = /area/turbolift/scc_ship/morgue_lift
	waypoint_station = "nav_morgue_lift_bottom"
	waypoint_offsite = "nav_morgue_lift_top"

/obj/effect/shuttle_landmark/lift/morgue_top
	name = "Morgue Top"
	landmark_tag = "nav_morgue_lift_top"
	base_area = /area/hallway/medical
	base_turf = /turf/simulated/open

/obj/effect/shuttle_landmark/lift/morgue_bottom
	name = "Morgue Bottom"
	landmark_tag = "nav_morgue_lift_bottom"
	flags = SLANDMARK_FLAG_AUTOSET
	base_area = /area/medical/morgue/lower
	base_turf = /turf/simulated/floor/plating

/area/turbolift/scc_ship/morgue_lift
	name = "Morgue Lift"
	sound_env = TUNNEL_ENCLOSED
	ambience = AMBIENCE_GHOSTLY

//Robotics Lift
/datum/shuttle/autodock/ferry/lift/scc_ship/robotics
	name = "Robotics Lift"
	location = 1
	shuttle_area = /area/turbolift/scc_ship/robotics_lift
	waypoint_station = "nav_robotics_lift_bottom"
	waypoint_offsite = "nav_robotics_lift_top"

/obj/effect/shuttle_landmark/lift/robotics_top
	name = "Robotics Top"
	landmark_tag = "nav_robotics_lift_top"
	base_area = /area/hallway/medical
	base_turf = /turf/simulated/open

/obj/effect/shuttle_landmark/lift/robotics_bottom
	name = "Robotics Bottom"
	landmark_tag = "nav_robotics_lift_bottom"
	flags = SLANDMARK_FLAG_AUTOSET
	base_area = /area/rnd/eva
	base_turf = /turf/simulated/floor/plating

/area/turbolift/scc_ship/robotics_lift
	name = "Robotics Lift"
	sound_env = TUNNEL_ENCLOSED
	ambience = AMBIENCE_GHOSTLY