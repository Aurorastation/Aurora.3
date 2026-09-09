/datum/unit_test/shuttle_landmarks_shall_exist
	name = "SHUTTLE: Defined shuttle landmarks shall exist."
	groups = list("map")

/datum/unit_test/shuttle_landmarks_shall_exist/start_test()
	var/failed = 0

	for(var/A in subtypesof(/datum/shuttle/autodock))
		var/datum/shuttle/autodock/shuttle = A
		// Check start location and transition locations exist
		var/found_current_location = FALSE
		var/found_transition_location = FALSE
		var/found_logging_home_location = FALSE
		for(var/L in subtypesof(/obj/effect/shuttle_landmark))
			var/obj/effect/shuttle_landmark/landmark = L
			if(initial(landmark.landmark_tag) == initial(shuttle.current_location))
				found_current_location = TRUE
			if(initial(landmark.landmark_tag) == initial(shuttle.landmark_transition))
				found_transition_location = TRUE
			if(initial(landmark.landmark_tag) == initial(shuttle.logging_home_tag))
				found_logging_home_location = TRUE

		if(initial(shuttle.current_location) && !found_current_location)
			TEST_FAIL("Failed to find 'current_location' landmark for [shuttle].")
			failed++
		if(initial(shuttle.landmark_transition) && !found_transition_location)
			TEST_FAIL("Failed to find 'landmark_transition' landmark for [shuttle].")
			failed++
		if(initial(shuttle.logging_home_tag) && !found_logging_home_location)
			TEST_FAIL("Failed to find 'logging_home_tag' landmark for [shuttle].")
			failed++

	if(failed)
		TEST_FAIL("[failed] shuttle transition and start location landmarks were not found.")
	else
		TEST_PASS("All shuttle transition and start location landmarks were found.")
	return TRUE

/datum/unit_test/shuttle_rotation
	name = "SHUTTLE: Landmark-relative offsets rotate clockwise."
	groups = list("generic")

/datum/unit_test/shuttle_rotation/start_test()
	var/list/north = rotate_shuttle_offset(2, 1, 0)
	var/list/east = rotate_shuttle_offset(2, 1, 90)
	var/list/south = rotate_shuttle_offset(2, 1, 180)
	var/list/west = rotate_shuttle_offset(2, 1, 270)

	if(!((north[1] == 2) && (north[2] == 1)))
		TEST_FAIL("Zero-degree shuttle offset was [english_list(north)], expected 2, 1.")
		return TRUE
	if(!((east[1] == 1) && (east[2] == -2)))
		TEST_FAIL("90-degree shuttle offset was [english_list(east)], expected 1, -2.")
		return TRUE
	if(!((south[1] == -2) && (south[2] == -1)))
		TEST_FAIL("180-degree shuttle offset was [english_list(south)], expected -2, -1.")
		return TRUE
	if(!((west[1] == -1) && (west[2] == 2)))
		TEST_FAIL("270-degree shuttle offset was [english_list(west)], expected -1, 2.")
		return TRUE

	TEST_PASS("Shuttle offsets rotated correctly for every cardinal orientation.")
	return TRUE
