ABSTRACT_TYPE(/datum/unit_test/area_configuration)
	name = "AREA CONFIG: Test stairs types"
	groups = list("generic")
	priority = 1

/datum/unit_test/area_configuration/exoplanet_area_with_exoplanet_base_turfs
	name = "AREA CONFIG: Exoplanet areas must have exoplanet base turfs"

/datum/unit_test/area_configuration/exoplanet_area_with_exoplanet_base_turfs/start_test()
	var/test_status = UNIT_TEST_PASSED

	for(var/exoplanet_area_typepath in subtypesof(/area/exoplanet))
		//No need for abstract areas to respect this really
		if(is_abstract(exoplanet_area_typepath))
			continue

		//The bounds have to be set based on the direction of the stairs, that must be set in code for sanity
		if(!istype(exoplanet_area_typepath::base_turf, /turf/simulated/floor/exoplanet))
			test_status = TEST_FAIL("The exoplanet area [exoplanet_area_typepath] does not have an exoplanet base turf!")

	return test_status
