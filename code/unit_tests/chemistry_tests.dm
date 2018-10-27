/*
 *
 *  Specific Heat Chemistry Test
 *  Checks if a reagent has a specific heat value.
 *
 */

datum/unit_test/specific_heat
	name = "Chemistry Test - Specific Heat"

datum/unit_test/specific_heat/start_test()

	var/error_count = 0

	for(var/type_found in subtypesof(/datum/reagent/))
		var/datum/reagent/R = new type_found
		if(istype(R) && R.id && R.name)
			if(!SSchemistry.has_valid_specific_heat(R))
				log_unit_test("[ascii_red][R.type] lacks a proper specific heat value![ascii_reset]")
				error_count++
		qdel(R)

	if(error_count)
		fail("[error_count] reagents(s) found without a proper specific heat value. Assign a specific heat value or make a recipe with these reagents as the final product.")
	else
		pass("All reagents have a specific heat value.")

	return 1

