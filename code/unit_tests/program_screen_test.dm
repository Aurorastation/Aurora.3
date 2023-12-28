/datum/unit_test/program_screens
	name = "Program Screen Test - All modular computer programs will have a screen"
	groups = list("generic")

/datum/unit_test/program_screens/start_test()
	var/list/screen_types = list()
	var/list/program_types = subtypesof(/datum/computer_file/program)
	for(var/datum/computer_file/program/program as anything in program_types)
		var/screen_type = initial(program.program_icon_state)
		var/usage_flags = initial(program.usage_flags)
		screen_types[program] = list(screen_type, usage_flags)

	var/failures = 0
	var/list/computer_types = subtypesof(/obj/item/modular_computer)
	for(var/obj/item/modular_computer/computer as anything in computer_types)
		var/icon_path = initial(computer.icon)
		var/list/icon_states = icon_states(icon_path)
		var/hardware_flag = initial(computer.hardware_flag)

		for(var/program in screen_types)
			var/screen_type = screen_types[program][1]
			var/usage_flags = screen_types[program][2]
			if(HAS_FLAG(hardware_flag, usage_flags) && !(screen_type in icon_states))
				TEST_FAIL("[computer] does not have a [screen_type] screen!")
				failures++

	if(failures)
		TEST_FAIL("[failures] error(s) found.")
	else
		TEST_PASS("All modular computer programs have a screen.")
	return TRUE
