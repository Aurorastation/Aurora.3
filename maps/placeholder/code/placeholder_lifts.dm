/obj/turbolift_map_holder/placeholder
	depth = 2
	lift_size_x = 4
	lift_size_y = 4
	clear_objects = 0

//Primary Lift
/obj/turbolift_map_holder/placeholder/primary
	name = "Placeholder lift placeholder - Primary"
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
/obj/turbolift_map_holder/placeholder/research
	name = "Placeholder lift placeholder - Research"
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
	lift_announce_str = "Arriving at Deck 2."

	lift_floor_label = "Deck 1"
	lift_floor_name = "Lower Deck"

	base_turf = /turf/simulated/floor/plating

/area/turbolift/research/deck_2
	name = "Research Lift - Deck 2"
	lift_announce_str = "Arriving at Deck 1."

	lift_floor_label = "Deck 2"
	lift_floor_name = "Main Deck"

//Cargo Lift
/datum/shuttle/autodock/ferry/lift/placeholder/cargo
	name = "Cargo Lift"
	location = 1
	shuttle_area = /area/turbolift/placeholder/cargo_lift
	waypoint_station = "nav_cargo_lift_bottom"
	waypoint_offsite = "nav_cargo_lift_top"

/obj/effect/shuttle_landmark/lift/cargo_top
	name = "Cargo Top"
	landmark_tag = "nav_cargo_lift_top"
	base_area = /area/quartermaster/storage
	base_turf = /turf/simulated/open

/obj/effect/shuttle_landmark/lift/cargo_bottom
	name = "Cargo Bottom"
	landmark_tag = "nav_cargo_lift_bottom"
	flags = SLANDMARK_FLAG_AUTOSET
	base_area = /area/quartermaster/loading
	base_turf = /turf/simulated/floor/plating

/area/turbolift/placeholder/cargo_lift
	name = "Cargo Lift"
	sound_env = STANDARD_STATION
	ambience = AMBIENCE_HANGAR

//Morgue Lift
/datum/shuttle/autodock/ferry/lift/placeholder/morgue
	name = "Morgue Lift"
	location = 1
	shuttle_area = /area/turbolift/placeholder/morgue_lift
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

/area/turbolift/placeholder/morgue_lift
	name = "Morgue Lift"
	sound_env = TUNNEL_ENCLOSED
	ambience = AMBIENCE_GHOSTLY