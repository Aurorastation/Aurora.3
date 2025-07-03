// Lift

/datum/shuttle/autodock/multi/lift/burzsia_station
	name = "HICS Etna Dockyard Lift"
	current_location = "nav_burzsia_station_lift_first_deck"
	shuttle_area = /area/turbolift/burzsia_station/burzsia_station_lift
	destination_tags = list(
		"nav_burzsia_station_lift_first_deck",
		"nav_burzsia_station_lift_second_deck"
	)

/obj/effect/shuttle_landmark/lift/burzsia_station_first_deck
	name = "HICS Etna - Deck 1"
	landmark_tag = "nav_burzsia_station_lift_first_deck"
	base_area = /area/burzsia_station/civilian_docks
	base_turf = /turf/simulated/floor/plating


/obj/effect/shuttle_landmark/lift/burzsia_station_second_deck
	name = "HICS Etna - Deck 2"
	landmark_tag = "nav_burzsia_station_lift_second_deck"
	base_area = /area/burzsia_station/lifts
	base_turf = /turf/simulated/open

/obj/machinery/computer/shuttle_control/multi/lift/burzsia_station
	shuttle_tag = "HICS Etna Dockyard Lift"
