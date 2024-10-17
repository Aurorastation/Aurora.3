/*
 *  Unit Tests for various recipes.
 *
 */

ABSTRACT_TYPE(/datum/unit_test/modular_computers)
	name = "MOD COMP: Template"
	groups = list("generic")

/datum/unit_test/modular_computers/presets_contain_only_compatible_programs
	name = "MOD COMP: Presets contain only compatible programs"

/datum/unit_test/modular_computers/presets_contain_only_compatible_programs/start_test()
	var/test_result = UNIT_TEST_PASSED

	for(var/obj/item/modular_computer/modular_computer_typepath in subtypesof(/obj/item/modular_computer))
		//We don't care about abstracts
		if(is_abstract(modular_computer_typepath))
			continue

		var/obj/item/modular_computer/sample_modular_computer = new modular_computer_typepath()

		//No need for nulls
		if(isnull(sample_modular_computer._app_preset_type))
			continue

		if(!ispath(sample_modular_computer._app_preset_type, /datum/modular_computer_app_presets))
			test_result = TEST_FAIL("Modular computer typepath '[modular_computer_typepath]' has an invalid _app_preset_type! - [sample_modular_computer._app_preset_type]")
			continue

		//Check that all the programs are supported by the hardwares that use those presets
		var/list/programs = sample_modular_computer.get_preset_programs(sample_modular_computer._app_preset_type)
		for(var/datum/computer_file/program/prog in programs)
			if(!prog.is_supported_by_hardware(sample_modular_computer.hardware_flag, FALSE))
				test_result = TEST_FAIL("Found program [prog.type] in preset [sample_modular_computer._app_preset_type] that is used by [modular_computer_typepath], \
										but is not supported by its hardware!")

	if(test_result == UNIT_TEST_PASSED)
		TEST_PASS("All modular computers supports all the programs referenced in their _app_preset_type.")

	return test_result
