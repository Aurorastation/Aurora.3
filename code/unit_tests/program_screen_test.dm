/datum/unit_test/program_screens
	name = "Program Screen Test - All modular computer programs will have a screen"
	groups = list("generic")

/datum/unit_test/program_screens/start_test()
	var/list/screen_types = list()
	var/list/program_types = subtypesof(/datum/computer_file/program)
	for(var/datum/computer_file/program/program as anything in program_types)
		var/screen_type = initial(program.program_icon_state)
		var/usage_flags = initial(program.usage_flags)
		var/program_type = initial(program.program_type)
		screen_types[program] = list(program, screen_type, usage_flags, program_type)

	var/failures = 0
	var/list/icon_paths = list()
	var/list/computer_types = subtypesof(/obj/item/modular_computer)
	for(var/obj/item/modular_computer/computer as anything in computer_types)
		var/icon_path = initial(computer.icon)
		if(icon_path in icon_paths)
			continue
		icon_paths += icon_path

		var/list/icon_states = icon_states(icon_path)
		var/hardware_flag = initial(computer.hardware_flag)

		for(var/program in screen_types)
			var/program_path = screen_types[program][1]
			var/screen_type = screen_types[program][2]
			var/usage_flags = screen_types[program][3]
			var/program_type = screen_types[program][4]
			if(HAS_FLAG(hardware_flag, usage_flags) && HAS_FLAG(program_type, PROGRAM_NORMAL) && !(screen_type in icon_states))
				TEST_FAIL("[computer] does not have a [screen_type ? screen_type : "!!! SCREEN TYPE UNSET !!!"] screen for program [program_path]!")
				failures++

	if(failures)
		TEST_FAIL("[failures] error(s) found.")
	else
		TEST_PASS("All modular computer programs have a screen.")
	return TRUE
