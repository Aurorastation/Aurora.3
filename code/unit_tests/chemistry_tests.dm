/*
 *
 *  Specific Heat Chemistry Test
 *  Checks if a reagent has a specific heat value.
 *
 */

/datum/unit_test/specific_heat
	name = "Chemistry Test - Specific Heat"
	groups = list("generic", "chemistry")

/datum/unit_test/specific_heat/start_test()

	var/error_count = 0

	for(var/reagent in GET_SINGLETON_SUBTYPE_MAP(/singleton/reagent/))
		var/singleton/reagent/R = reagent
		if(!SSchemistry.has_valid_specific_heat(R))
			TEST_FAIL("[reagent] lacks a proper specific heat value!")
			error_count++

	if(error_count)
		TEST_FAIL("[error_count] reagents(s) found without a proper specific heat value. Assign a specific heat value or make a recipe with these reagents as the final product.")
	else
		TEST_PASS("All reagents have a specific heat value.")

	return 1
