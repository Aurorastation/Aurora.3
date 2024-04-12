/**
 * Tests loadouts
 */
/datum/unit_test/loadout_test
	name = "Loadout Test"
	groups = list("generic")

/datum/unit_test/loadout_test/start_test()
	return UNIT_TEST_SKIPPED //This is just a generic to inherit from, hence skip it

/**
 * Tests loadout gears
 */
/datum/unit_test/loadout_test/loadout_gear_test
	name = "Loadout Gears Test"

/datum/unit_test/loadout_test/loadout_gear_test/start_test()

	//We overwrite it if we fail, let's assume it passes for now
	var/test_result = UNIT_TEST_PASSED

	//The test mob we'll give the items to
	var/mob/living/test_mob = new /mob/living/carbon/human(locate(1,1,1))

	//List of item names, to ensure they're unique
	var/list/names = list()

	for(var/typepath in subtypesof(/datum/gear))
		//We do not care about abstract types
		var/datum/gear/fake_gear_but_is_a_path = typepath
		if(initial(fake_gear_but_is_a_path.abstract_type) == initial(fake_gear_but_is_a_path.abstract_type))
			TEST_DEBUG("Not creating [typepath] because it matches the abstract_type")
			continue

		TEST_DEBUG("Creating [typepath]")

		var/datum/gear/gear_item = new typepath(null)


		//Check that we have an unique name
		TEST_ASSERT(!(gear_item.display_name in names), "The display name of [typepath] is not unique!")
		names += gear_item.display_name

		//Check that if we areaugment we don't have a slot set
		if(gear_item.augment)
			TEST_ASSERT( (isnull(gear_item.slot)), "A slot is defined for gear item [typepath] that is an augment!")

		//Check that allowed_roles and whitelisted are either null or lists
		TEST_ASSERT( (istype(gear_item.allowed_roles) || isnull(gear_item.allowed_roles)), "The allowed_roles var of [typepath] is neither null nor a list!")
		TEST_ASSERT( (istype(gear_item.whitelisted) || isnull(gear_item.whitelisted)), "The whitelisted var of [typepath] is neither null nor a list!")

		//Check culture restrictions
		if(length(gear_item.culture_restriction) || isnull(gear_item.culture_restriction))
			for(var/whitelisted_culture in gear_item.culture_restriction)
				if(!ispath(whitelisted_culture, /singleton/origin_item/culture))
					test_result = TEST_FAIL("The culture_restriction var of [typepath] contains the following element that is not a valid /singleton/origin_item/culture: [whitelisted_culture]!")
		else
			test_result = TEST_FAIL("The culture_restriction var of [typepath] is neither null nor a list!")

		//Check origin restriction
		if(length(gear_item.origin_restriction) || isnull(gear_item.origin_restriction))
			for(var/whitelisted_culture in gear_item.origin_restriction)
				if(!ispath(whitelisted_culture, /singleton/origin_item/origin))
					test_result = TEST_FAIL("The origin_restriction var of [typepath] contains the following element that is not a valid /singleton/origin_item/origin: [whitelisted_culture]!")
		else
			test_result = TEST_FAIL("The origin_restriction var of [typepath] is neither null nor a list!")

		//Check that the object can actually spawn
		TEST_ASSERT(ispath(gear_item.path), "The path of the object to spawn for [typepath] isn't a path!")
		var/obj/item/actual_item = gear_item.spawn_item(test_mob, list(), test_mob)
		TEST_ASSERT(!QDELETED(actual_item), "The actual item of [typepath] did not spawn correctly!")


	if(test_result == UNIT_TEST_FAILED)
		return TEST_FAIL("Errors were encountered in the test, read the logs above!")
	else
		return TEST_PASS("All loadout gears items (/datum/gear) successfully tested")
