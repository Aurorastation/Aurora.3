/datum/unit_test/icon_test
	name = "ICON STATE template"

/datum/unit_test/icon_test/closets
	name = "CLOSET template"
	// Matches logic in /obj/structure/closet/update_icons()
	var/list/closet_state_suffixes = list(
		"nothing" = "",
		"opened" = "_open",
		"broken" = "_broken",
		"door" = "_door",
		"back" = "_back",
		"locked" = "locked",
		"unlocked" = "unlocked",
		"off" = "off",
		"emag" = "emag"
	)
/datum/unit_test/icon_test/closets/closets_shall_have_valid_icons_for_each_state
	name = "ICON STATES: Closets shall have valid icons for each state"

/datum/unit_test/icon_test/closets/closets_shall_have_valid_icons_for_each_state/start_test()
	var/missing_states = 0
	var/list/closet_paths = typesof(/obj/structure/closet)

	// If any closet types and their subtypes should be excluded from this test, include them here. Make sure they are covered by their own test.
	var/list/exclude_closets = list(
		/obj/structure/closet/airbubble,
		/obj/structure/closet/body_bag,
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
				state = "[initial(closet_path.icon_door)][closet_state_suffixes["opened"]]"
				if(!(state in closet_states))
					missing_states += 1
					log_unit_test("Opened icon [state] missing for [initial(closet_path.name)] -- ([closet_path])")
			else
				state = "[initial(closet_path.icon_state)][closet_state_suffixes["opened"]]"
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

/datum/unit_test/icon_test/closets/mapped_closets_shall_have_invalid_icon_states
	name = "ICON STATES: Mapped closets shall not have altered icon states"

/datum/unit_test/icon_test/closets/mapped_closets_shall_have_invalid_icon_states/start_test()
	var/invalid_states = 0
	var/checked_closets = 0
	for(var/obj/structure/closet/C in world)
		checked_closets++
		var/list/valid_icon_states = list()
		for(var/closet_suffix in closet_state_suffixes)
			valid_icon_states |= "[initial(C.icon_state)][closet_state_suffixes[closet_suffix]]"
		if(C.icon_state in valid_icon_states)
			continue

		invalid_states++
		log_unit_test("Mapped closet [C] at [C.x], [C.y], [C.z] had an invalid icon_state defined: [C.icon_state]!")

	if(invalid_states)
		fail("Found [invalid_states] / [checked_closets] mapped closets with invalid mapped icon states!")
	else
		pass("All mapped closets had valid icon states.")

	return TRUE

#define UNDERSCORE_OR_NULL(target) "[target ? "[target]_" : ""]"
/datum/unit_test/icon_test/hardsuit_sprite_test
	name = "ICON STATES: Hardsuit Sprite Test"

/datum/unit_test/icon_test/hardsuit_sprite_test/start_test()
	for(var/rig_path in subtypesof(/obj/item/rig))
		var/obj/item/rig/R = new rig_path
		var/list/rig_states = icon_states(R.icon)

		if(!(R.icon_state in rig_states))
			fail("[R.name]'s module icon_state isn't in its icon file.")
		if(!("[R.icon_state]_ba" in rig_states))
			fail("[R.name]'s on-back module icon_state isn't in its icon file.")

		var/list/species_to_check = list("") // blank means default, human
		if(length(R.icon_supported_species_tags))
			species_to_check += R.icon_supported_species_tags

		if(R.helm_type)
			if(!("[R.icon_state]_helmet" in rig_states))
				fail("[R.name]'s helmet icon_state isn't in its icon file.")
			if(!("[R.icon_state]_sealed_helmet" in rig_states))
				fail("[R.name]'s sealed helmet icon_state isn't in its icon file.")
		if(R.suit_type)
			if(!("[R.icon_state]_suit" in rig_states))
				fail("[R.name]'s suit icon_state isn't in its icon file.")
			if(!("[R.icon_state]_sealed_suit" in rig_states))
				fail("[R.name]'s sealed suit icon_state isn't in its icon file.")
		if(R.glove_type)
			if(!("[R.icon_state]_gloves" in rig_states))
				fail("[R.name]'s gloves icon_state isn't in its icon file.")
			if(!("[R.icon_state]_sealed_gloves" in rig_states))
				fail("[R.name]'s sealed gloves icon_state isn't in its icon file.")
		if(R.boot_type)
			if(!("[R.icon_state]_shoes" in rig_states))
				fail("[R.name]'s shoes icon_state isn't in its icon file.")
			if(!("[R.icon_state]_sealed_shoes" in rig_states))
				fail("[R.name]'s sealed shoes icon_state isn't in its icon file.")

		for(var/short in species_to_check)
			short = UNDERSCORE_OR_NULL(short)
			if(R.helm_type)
				if(!("[short][R.icon_state]_he" in rig_states))
					fail("[short] [R.name]'s helmet item_state isn't in its icon file.")
				if(!("[short][R.icon_state]_sealed_he" in rig_states))
					fail("[short] [R.name]'s sealed helmet item_state isn't in its icon file.")
			if(R.suit_type)
				if(!("[short][R.icon_state]_su" in rig_states))
					fail("[short] [R.name]'s suit item_state isn't in its icon file.")
				if(!("[short][R.icon_state]_sealed_su" in rig_states))
					fail("[short] [R.name]'s sealed suit item_state isn't in its icon file.")
			if(R.glove_type)
				if(!("[short][R.icon_state]_gl" in rig_states))
					fail("[short] [R.name]'s gloves item_state isn't in its icon file.")
				if(!("[short][R.icon_state]_sealed_gl" in rig_states))
					fail("[short] [R.name]'s sealed gloves item_state isn't in its icon file.")
			if(R.boot_type)
				if(!("[short][R.icon_state]_sh" in rig_states))
					fail("[short] [R.name]'s shoes item_state isn't in its icon file.")
				if(!("[short][R.icon_state]_sealed_sh" in rig_states))
					fail("[short] [R.name]'s sealed shoes item_state isn't in its icon file.")

	if(!reported)
		pass("All hardsuits have their correct sprites.")

	return TRUE

#undef UNDERSCORE_OR_NULL
