/obj/effect/shuttle_landmark/freebooter_salvager
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/freebooter_salvager/nav1
	name = "Freebooter Salvager Ship, Fore"
	landmark_tag = "fbs_nav1"

/obj/effect/shuttle_landmark/freebooter_salvager/nav2
	name = "Freebooter Salvager Ship, Aft"
	landmark_tag = "fbs_nav2"

/obj/effect/shuttle_landmark/freebooter_salvager/nav3
	name = "Freebooter Salvager Ship, Port"
	landmark_tag = "fbs_nav3"

/obj/effect/shuttle_landmark/freebooter_salvager/nav4
	name = "Freebooter Salvager Ship, Starboard"
	landmark_tag = "fbs_nav4"

// Non-docking airlocks

/obj/effect/map_effect/marker/airlock/freebooter_salvager/fore
	name = "Fore Airlock"
	master_tag = "airlock_fbs_fore"

// Lift

/datum/shuttle/autodock/multi/lift/fbs
	name = "Freebooter Salvager Lift"
	current_location = "nav_fbs_lift_first_deck"
	shuttle_area = /area/turbolift/freebooter_salvager/fbs_lift
	destination_tags = list(
		"nav_fbs_lift_first_deck",
		"nav_fbs_lift_second_deck",
		)

/obj/effect/shuttle_landmark/lift/fbs_first_deck
	name = "Freebooter Salvager Ship - First Deck"
	landmark_tag = "nav_fbs_lift_first_deck"
	base_area = /area/ship/freebooter_salvager/mining
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/lift/fbs_second_deck
	name = "Freebooter Salvager Ship - Second Deck"
	landmark_tag = "nav_fbs_lift_second_deck"
	base_area = /area/ship/freebooter_salvager/warehouse
	base_turf = /turf/simulated/open

/obj/machinery/computer/shuttle_control/multi/lift/fbs
	shuttle_tag = "Freebooter Salvager Lift"
