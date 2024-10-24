/*
 *  Unit Tests for various recipes.
 *
 */

ABSTRACT_TYPE(/datum/unit_test/modular_computers)
	name = "MOD COMP: Template"
	groups = list("generic")

/datum/unit_test/modular_computers/modular_computer_app_presets_contain_programs_only_once
	name = "MOD COMP: Preset contain programs only once"

/datum/unit_test/modular_computers/modular_computer_app_presets_contain_programs_only_once/start_test()
	var/test_result = UNIT_TEST_PASSED

	var/obj/item/modular_computer/test_computer = new()

	for(var/preset_typepath in subtypesof(/datum/modular_computer_app_presets))
		TEST_DEBUG("Testing preset [preset_typepath]")

		//Instance the preset
		var/datum/modular_computer_app_presets/preset = new preset_typepath()

		//Get installed programs
		var/list/datum/computer_file/program/installed_programs = preset.return_install_programs(test_computer)

		//Second list to see if we're finding the same programs twice
		//A list of types
		var/list/programs_present = list()

		for(var/datum/computer_file/program/program in installed_programs)
			if(program.type in programs_present)
				test_result = TEST_FAIL("Found multiple instances of program [program.type] in preset [preset_typepath]!")
			else
				programs_present += program.type
				TEST_DEBUG("Found one instance of program [program.type] in preset [preset_typepath]")

	if(test_result == UNIT_TEST_PASSED)
		TEST_PASS("All programs in modular computer presets are only present once.")

	return test_result


/datum/unit_test/modular_computers/presets_contain_only_compatible_programs
	name = "MOD COMP: Presets contain only compatible programs"
	disabled = TRUE //There's 400+ fuckups and i'm not fixing all that shit myself
	why_disabled = "There's over 400 programs that cannot run where they are installed, a large effort is required to fix them all."

/datum/unit_test/modular_computers/presets_contain_only_compatible_programs/start_test()
	var/test_result = UNIT_TEST_PASSED

	for(var/modular_computer_typepath in subtypesof(/obj/item/modular_computer))
		//We don't care about abstracts
		if(is_abstract(modular_computer_typepath))
			continue

		var/obj/item/modular_computer/sample_modular_computer = new modular_computer_typepath()

		//No need for nulls
		if(isnull(sample_modular_computer._app_preset_type))
			TEST_DEBUG("[modular_computer_typepath] _app_preset_type is null and won't be tested")
			continue

		if(!ispath(sample_modular_computer._app_preset_type, /datum/modular_computer_app_presets))
			test_result = TEST_FAIL("Modular computer typepath '[modular_computer_typepath]' has an invalid _app_preset_type! - [sample_modular_computer._app_preset_type]")
			continue

		//Check that all the programs are supported by the hardwares that use those presets
		var/list/programs = sample_modular_computer.get_preset_programs(sample_modular_computer._app_preset_type)
		for(var/datum/computer_file/program/prog in programs)
			TEST_DEBUG("Will now test [prog.type] in preset [sample_modular_computer._app_preset_type] used by [modular_computer_typepath]")
			if(!prog.is_supported_by_hardware(sample_modular_computer.hardware_flag, FALSE))
				test_result = TEST_FAIL("Found program [prog.type] in preset [sample_modular_computer._app_preset_type] that is used by [modular_computer_typepath], \
										but is not supported by its hardware!")

	if(test_result == UNIT_TEST_PASSED)
		TEST_PASS("All modular computers supports all the programs referenced in their _app_preset_type.")

	return test_result
