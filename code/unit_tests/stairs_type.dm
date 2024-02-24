/datum/unit_test/stairs_type
	name = "Test stairs types"
	groups = list("generic")
	priority = 1

/datum/unit_test/stairs_type/start_test()
	var/test_status = UNIT_TEST_PASSED

	for(var/obj/structure/stairs/stair_type as anything in subtypesof(/obj/structure/stairs))
		//No need for abstract stairs to respect this really
		if(is_abstract(stair_type))
			continue

		//The bounds have to be set based on the direction of the stairs, that must be set in code for sanity
		switch(initial(stair_type.dir))

			if(NORTH)
				if((initial(stair_type.bound_height) != 64) || (initial(stair_type.bound_y) != -32))
					test_status = TEST_FAIL("The stairs type [stair_type.type] does not have the bounds set correctly!")

			if(SOUTH)
				if((initial(stair_type.bound_height) != 64) || (initial(stair_type.bound_y) != 0))
					test_status = TEST_FAIL("The stairs type [stair_type.type] does not have the bounds set correctly!")

			if(EAST)
				if((initial(stair_type.bound_width) != 64) || (initial(stair_type.bound_x) != -32))
					test_status = TEST_FAIL("The stairs type [stair_type.type] does not have the bounds set correctly!")

			if(WEST)
				if((initial(stair_type.bound_width) != 64) || (initial(stair_type.bound_x) != 0))
					test_status = TEST_FAIL("The stairs type [stair_type.type] does not have the bounds set correctly!")

	return test_status
