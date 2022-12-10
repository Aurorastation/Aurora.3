/datum/unit_test/shuttle_landmarks_shall_exist
	name = "SHUTTLE: Defined shuttle landmarks shall exist."

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
			log_unit_test("Failed to find 'current_location' landmark for [shuttle].")
			failed++
		if(initial(shuttle.landmark_transition) && !found_transition_location)
			log_unit_test("Failed to find 'landmark_transition' landmark for [shuttle].")
			failed++
		if(initial(shuttle.logging_home_tag) && !found_logging_home_location)
			log_unit_test("Failed to find 'logging_home_tag' landmark for [shuttle].")
			failed++

	if(failed)
		fail("[failed] shuttle transition and start location landmarks were not found.")
	else
		pass("All shuttle transition and start location landmarks were found.")
	return TRUE
