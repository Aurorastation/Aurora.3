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

/datum/unit_test/modular_computers/departmental_ringers
	name = "MOD COMP: Job ringer registry survives rotation and deletion"
	groups = list("generic", "departmental ringers")

/datum/unit_test/modular_computers/departmental_ringers/start_test()
	. = UNIT_TEST_PASSED
	var/obj/structure/machinery/ringer/north/medical/medical = new(locate(1, 1, 1))
	var/obj/structure/machinery/ringer/south/pharmacy/pharmacy = new(locate(1, 1, 1))
	var/obj/item/modular_computer/medical_pda = new()
	var/obj/item/modular_computer/pharmacy_pda = new()
	var/obj/item/modular_computer/unrelated_pda = new()
	var/datum/weakref/medical_ref = WEAKREF(medical)
	if(!(medical_ref in GLOB.ringers_by_job["Physician"]))
		. = TEST_FAIL("Medical ringer did not register a weak reference for its jobs.")

	medical.set_dir(WEST)
	medical_pda.connect_departmental_ringers("Resident Physician")
	medical_pda.connect_departmental_ringers("Resident Physician")
	pharmacy_pda.connect_departmental_ringers("Pharmacy Intern")
	unrelated_pda.connect_departmental_ringers("Paramedic Trainee")
	if(length(medical.rings_pdas) != 1 || !(medical_pda in medical.rings_pdas))
		. = TEST_FAIL("A rotated medical ringer did not link its resident exactly once.")
	if(length(pharmacy.rings_pdas) != 1 || !(pharmacy_pda in pharmacy.rings_pdas))
		. = TEST_FAIL("Pharmacy interns were not linked exclusively to the pharmacy ringer.")

	qdel(medical_pda)
	if(length(medical.rings_pdas))
		. = TEST_FAIL("Deleting an automatically linked PDA did not unlink it.")
	qdel(medical)
	if(medical_ref.resolve() || (medical_ref in GLOB.ringers_by_job["Physician"]))
		. = TEST_FAIL("Deleting a ringer left its reference in the job registry.")

	// A stale entry must also be safe if it survives until the next lookup.
	LAZYADD(GLOB.ringers_by_job["Unit Test Ringer Job"], medical_ref)
	unrelated_pda.connect_departmental_ringers("Unit Test Ringer Job")
	if("Unit Test Ringer Job" in GLOB.ringers_by_job)
		. = TEST_FAIL("Looking up a deleted ringer did not prune its empty registry entry.")
	GLOB.ringers_by_job -= "Unit Test Ringer Job"
	qdel(pharmacy_pda)
	qdel(unrelated_pda)
	qdel(pharmacy)
	if(. == UNIT_TEST_PASSED)
		return TEST_PASS("Ringers link by job after rotation, preserve intern roles, and clean up deleted devices and weak references.")
