/datum/unit_test/icon_test
	name = "ICON STATE template"

/datum/unit_test/icon_test/closets/closets_shall_have_valid_icons_for_each_state
	name = "ICON STATES: Closets shall have valid icons for each state"

/datum/unit_test/icon_test/closets/closets_shall_have_valid_icons_for_each_state/start_test()
	var/missing_states = 0
	var/list/closet_paths = typesof(/obj/structure/closet)

	// Matches logic in /obj/structure/closet/update_icons()
	var/list/closet_state_suffixes = list(
		"opened" = "_open",
		"broken" = "_broken",
		"door" = "_door",
		"back" = "_back",
		"locked" = "locked",
		"unlocked" = "unlocked",
		"off" = "off",
		"emag" = "emag"
	)

	// If any closet types and their subtypes should be excluded from this test, include them here. Make sure they are covered by their own test.
	var/list/exclude_closets = list(
		/obj/structure/closet/airbubble,
		/obj/structure/closet/body_bag,
		/obj/structure/closet/crate,
		/obj/structure/closet/secure_closet/guncabinet,
		/obj/structure/closet/statue
	)

	for(var/exclude in exclude_closets)
		for(var/exclude_type in typesof(exclude))
			closet_paths -= exclude_type

	var/list/closet_dmis = list()
	for(var/path in closet_paths)
		var/obj/structure/closet/closet_path = path
		closet_dmis |= initial(closet_path.icon)

	var/list/closet_states = list()
	for(var/dmi in closet_dmis)
		closet_states += icon_states(dmi)

	var/state
	for(var/path in closet_paths)
		var/obj/structure/closet/closet_path = path
		state = initial(closet_path.icon_state)
		// Base icon state
		if(!(state in closet_states))
			missing_states += 1
			log_unit_test("icon_state [state] missing for [initial(closet_path.name)] -- ([closet_path])")
		// Non-animated door states
		if(!initial(closet_path.is_animating_door))
			// Door icon
			if(initial(closet_path.icon_door))
				state = "[initial(closet_path.icon_door)][closet_state_suffixes["door"]]"
				if(!(state in closet_states))
					missing_states += 1
					log_unit_test("Door icon [state] missing for [initial(closet_path.name)] -- ([closet_path])")
			else
				state = "[initial(closet_path.icon_state)][closet_state_suffixes["door"]]"
				if(!(state in closet_states))
					missing_states += 1
					log_unit_test("Door icon [state] missing for [initial(closet_path.name)] -- ([closet_path])")
			// Secure closet icon overlays
			if(initial(closet_path.secure))
				// Emagged
				state = "[initial(closet_path.icon_door_overlay)][closet_state_suffixes["emag"]]"
				if(!(state in closet_states))
					missing_states += 1
					log_unit_test("Emag'd icon [state] missing for [initial(closet_path.name)] -- ([closet_path])")
				// Locked
				state = "[initial(closet_path.icon_door_overlay)][closet_state_suffixes["locked"]]"
				if(!(state in closet_states))
					missing_states += 1
					log_unit_test("Locked icon [state] missing for [initial(closet_path.name)] -- ([closet_path])")
				// Unlocked
				state = "[initial(closet_path.icon_door_overlay)][closet_state_suffixes["unlocked"]]"
				if(!(state in closet_states))
					missing_states += 1
					log_unit_test("Unlocked icon [state] missing for [initial(closet_path.name)] -- ([closet_path])")
			// Opened
			if(initial(closet_path.icon_door_override))
				state = "[initial(closet_path.icon_door)][closet_state_suffixes["open"]]"
				if(!(state in closet_states))
					missing_states += 1
					log_unit_test("Opened icon [state] missing for [initial(closet_path.name)] -- ([closet_path])")
			else
				state = "[initial(closet_path.icon_state)][closet_state_suffixes["open"]]"
				if(!(state in closet_states))
					missing_states += 1
					log_unit_test("Opened icon [state] missing for [initial(closet_path.name)] -- ([closet_path])")
		// Animated Door
		else
			state = "[initial(closet_path.icon_door) || initial(closet_path.icon_state)][closet_state_suffixes["door"]]"
			if(!(state in closet_states))
				missing_states += 1
				log_unit_test("Animated door icon [state] missing for [initial(closet_path.name)] -- ([closet_path])")
			state = "[initial(closet_path.icon_door) || initial(closet_path.icon_state)][closet_state_suffixes["back"]]"
			if(!(state in closet_states))
				missing_states += 1
				log_unit_test("Animated door icon [state] missing for [initial(closet_path.name)] -- ([closet_path])")

	if(missing_states)
		fail("[missing_states] closet icon state\s [missing_states == 1 ? "is" : "are"] missing.")
	else
		pass("All related closet icon states exist.")
	return TRUE
