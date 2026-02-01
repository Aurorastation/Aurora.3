/datum/unit_test/shuttle_landmarks_shall_exist
	name = "SHUTTLE: Defined shuttle landmarks shall exist."
	groups = list("map")

/datum/unit_test/shuttle_landmarks_shall_exist/start_test()
	var/failed = 0

	for(var/A in subtypesof(/datum/shuttle))
		var/datum/shuttle/shuttle = A
		// Check start location and transition locations exist
		var/found_current_location = FALSE
		var/found_logging_home_location = FALSE
		for(var/L in subtypesof(/obj/effect/shuttle_landmark))
			var/obj/effect/shuttle_landmark/landmark = L
			if(initial(landmark.landmark_tag) == initial(shuttle.current_location))
				found_current_location = TRUE
			if(initial(landmark.landmark_tag) == initial(shuttle.logging_home_tag))
				found_logging_home_location = TRUE

		if(initial(shuttle.current_location) && !found_current_location)
			TEST_FAIL("Failed to find 'current_location' landmark for [shuttle].")
			failed++
		if(initial(shuttle.logging_home_tag) && !found_logging_home_location)
			TEST_FAIL("Failed to find 'logging_home_tag' landmark for [shuttle].")
			failed++

	if(failed)
		TEST_FAIL("[failed] shuttle transition and start location landmarks were not found.")
	else
		TEST_PASS("All shuttle transition and start location landmarks were found.")
	return TRUE
