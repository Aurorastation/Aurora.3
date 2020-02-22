/datum/unit_test/icon_test
	name = "ICON STATE template"

/datum/unit_test/icon_test/all_initial_icon_states_shall_exist
	name = "ICON STATE - All initial icon states shall exist"
	var/list/excepted_atoms = list() // Any specific atoms that should not be included
	var/list/excepted_icon_files = list() //Contains any .dmi files you do not want this test to run on
	var/list/excepted_icon_states = list() //Any individual icon states you do not want this test to run on

/datum/unit_test/icon_test/all_initial_icon_states_shall_exist/start_test()
	var/list/failed_icons = list()

	for(var/atom_type in typecacheof(/atom) - excepted_atoms)
		var/failed = FALSE
		var/atom/test_atom = atom_type

		var/atom_icon = initial(test_atom.icon)
		if(atom_icon in excepted_icon_files)
			continue
		if(atom_icon)
			var/atom_icon_state = initial(test_atom.icon_state)
			if(!atom_icon_state || (atom_icon_state in excepted_icon_states))
				continue

			var/list/valid_states = icon_states(atom_icon)
			if(!(atom_icon_state in valid_states))
				failed = TRUE
				log_unit_test("[ascii_red]--------------- [atom_type] - Icon state [atom_icon_state] was not found in [atom_icon].")
				log_unit_test("[ascii_red]--------------- Icon states in [atom_icon] are [english_list(valid_states)].")

		if(failed)
			failed_icons += atom_type

	if(LAZYLEN(failed_icons))
		fail("One or more atom initial icons were not found.")
	else
		pass("All atom initial icons were valid.")

	return TRUE
