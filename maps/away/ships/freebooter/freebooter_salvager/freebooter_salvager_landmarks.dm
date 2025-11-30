/obj/effect/shuttle_landmark/freebooter_salvager
	base_turf = /turf/space/dynamic
	base_area = /area/space

/obj/effect/shuttle_landmark/freebooter_salvager/fore
	name = "Freebooter Salvager Ship, Fore"
	landmark_tag = "freebooter_salvager_fore"

/obj/effect/shuttle_landmark/freebooter_salvager/aft
	name = "Freebooter Salvager Ship, Aft"
	landmark_tag = "freebooter_salvager_aft"

/obj/effect/shuttle_landmark/freebooter_salvager/port
	name = "Freebooter Salvager Ship, Port"
	landmark_tag = "freebooter_salvager_port"

/obj/effect/shuttle_landmark/freebooter_salvager/starboard
	name = "Freebooter Salvager Ship, Starboard"
	landmark_tag = "freebooter_salvager_starboard"

/obj/effect/shuttle_landmark/freebooter_salvager/fore_upper_deck
	name = "Freebooter Salvager Ship, Upper Deck Fore EVA Docking"
	landmark_tag = "freebooter_salvager_upfore"

/obj/effect/shuttle_landmark/freebooter_salvager/eva_port
	name = "Freebooter Salvager Ship, Lower Deck Port EVA Docking"
	landmark_tag = "freebooter_salvager_eva_port"

/obj/effect/shuttle_landmark/freebooter_salvager/eva_starboard
	name = "Freebooter Salvager Ship, Lower Deck Starboard EVA Docking"
	landmark_tag = "freebooter_salvager_eva_starboard"

/obj/effect/shuttle_landmark/freebooter_salvager/eva_aft_starboard
	name = "Freebooter Salvager Ship, Lower Deck Aft Starboard EVA Docking"
	landmark_tag = "freebooter_salvager_eva_aft_starboard"

/obj/effect/shuttle_landmark/freebooter_salvager/eva_aft_port
	name = "Freebooter Salvager Ship, Lower Deck Aft Port EVA Docking"
	landmark_tag = "freebooter_salvager_eva_aft_port"

// Non-docking airlocks

/obj/effect/map_effect/marker/airlock/freebooter_salvager/fore_upper_deck
	name = "Upper Deck Fore"
	master_tag = "airlock_freebooter_salvager_upfore"

/obj/effect/map_effect/marker/airlock/freebooter_salvager/fore
	name = "Fore Airlock"
	master_tag = "airlock_freebooter_salvager_fore"

/obj/effect/map_effect/marker/airlock/freebooter_salvager/port
	name = "Port Airlock"
	master_tag = "airlock_freebooter_salvager_port"

/obj/effect/map_effect/marker/airlock/freebooter_salvager/starboard
	name = "Starboard Airlock"
	master_tag = "airlock_freebooter_salvager_starboard"

// Lift

/datum/shuttle/autodock/multi/lift/freebooter_salvager
	name = "Freebooter Salvager Lift"
	current_location = "nav_freebooter_salvager_lift_first_deck"
	shuttle_area = /area/turbolift/freebooter_salvager/freebooter_salvager_lift
	destination_tags = list(
		"nav_freebooter_salvager_lift_first_deck",
		"nav_freebooter_salvager_lift_second_deck",
		)

/obj/effect/shuttle_landmark/lift/freebooter_salvager_first_deck
	name = "Freebooter Salvager Ship - First Deck"
	landmark_tag = "nav_freebooter_salvager_lift_first_deck"
	base_area = /area/ship/freebooter_salvager/mining
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/lift/freebooter_salvager_second_deck
	name = "Freebooter Salvager Ship - Second Deck"
	landmark_tag = "nav_freebooter_salvager_lift_second_deck"
	base_area = /area/ship/freebooter_salvager/warehouse
	base_turf = /turf/simulated/open

/obj/machinery/computer/shuttle_control/multi/lift/freebooter_salvager
	shuttle_tag = "Freebooter Salvager Lift"
