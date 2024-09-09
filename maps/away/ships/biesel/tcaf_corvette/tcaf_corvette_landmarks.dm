// Lift
/datum/shuttle/autodock/multi/lift/tcaf
	name = "TCAF Lift"
	current_location = "nav_tcaf_lift_second_deck"
	shuttle_area = /area/turbolift/tcaf_corvette/tcaf_lift
	destination_tags = list(
		"nav_tcaf_lift_first_deck",
		"nav_tcaf_lift_second_deck"
		)

/obj/effect/shuttle_landmark/lift/tcaf_first_deck
	name = "Republican Fleet Corvette - First Deck"
	landmark_tag = "nav_tcaf_lift_first_deck"
	base_area = /area/tcaf_corvette/hangar
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/lift/tcaf_second_deck
	name = "Republican Fleet Corvette - Second Deck"
	landmark_tag = "nav_tcaf_lift_second_deck"
	base_area = /area/tcaf_corvette/central_lift
	base_turf = /turf/simulated/open

/obj/machinery/computer/shuttle_control/multi/lift/tcaf
	shuttle_tag = "TCAF Lift"
