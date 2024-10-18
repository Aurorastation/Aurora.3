ABSTRACT_TYPE(/datum/unit_test/area_configuration)
	name = "AREA CONFIG: Test stairs types"
	groups = list("generic")
	priority = 1

/datum/unit_test/area_configuration/exoplanet_area_with_exoplanet_base_turfs
	name = "AREA CONFIG: Exoplanet areas must have exoplanet base turfs"

/datum/unit_test/area_configuration/exoplanet_area_with_exoplanet_base_turfs/start_test()
	var/test_status = UNIT_TEST_PASSED

	for(var/area/exoplanet/exoplanet_area_typepath in subtypesof(/area/exoplanet))
		//No need for abstract areas to respect this really
		if(is_abstract(exoplanet_area_typepath))
			TEST_DEBUG("Skipping abstract exoplanet area [exoplanet_area_typepath]")
			continue

		TEST_DEBUG("Now testing exoplanet area [exoplanet_area_typepath]")

		//The bounds have to be set based on the direction of the stairs, that must be set in code for sanity
		if(!istype(exoplanet_area_typepath::base_turf, /turf/simulated/floor/exoplanet))
			test_status = TEST_FAIL("The exoplanet area [exoplanet_area_typepath] does not have an exoplanet base turf!")

		else
			TEST_NOTICE("The exoplanet area [exoplanet_area_typepath] has an exoplanet base turf.")
			TEST_DEBUG("The exoplanet area [exoplanet_area_typepath] has [exoplanet_area_typepath::base_turf] as its base turf.")

	if(test_status == UNIT_TEST_PASSED)
		TEST_PASS("All exoplanet areas have an exoplanet base turf.")

	return test_status
