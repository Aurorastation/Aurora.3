ABSTRACT_TYPE(/datum/unit_test/area_configuration)
	name = "AREA CONFIG: Test stairs types"
	groups = list("generic")
	priority = 1

/datum/unit_test/area_configuration/exoplanet_obj_with_exoplanet_base_turfs
	name = "AREA CONFIG: Exoplanet objs must have exoplanet base turfs"

/datum/unit_test/area_configuration/exoplanet_obj_with_exoplanet_base_turfs/start_test()
	var/test_status = UNIT_TEST_PASSED

	for(var/obj/effect/overmap/visitable/sector/exoplanet/exoplanet_obj_typepath in subtypesof(/obj/effect/overmap/visitable/sector/exoplanet))
		//No need for abstract planets to respect this really
		if(is_abstract(exoplanet_obj_typepath))
			TEST_DEBUG("Skipping abstract exoplanet [exoplanet_obj_typepath]")
			continue

		TEST_DEBUG("Now testing exoplanet [exoplanet_obj_typepath]")

		//The bounds have to be set based on the direction of the stairs, that must be set in code for sanity
		if(!istype(exoplanet_obj_typepath::turftype, /turf/simulated/floor/exoplanet))
			test_status = TEST_FAIL("The exoplanet [exoplanet_obj_typepath] does not have an exoplanet base turf!")

		else
			TEST_NOTICE("The exoplanet [exoplanet_obj_typepath] has an exoplanet base turf.")
			TEST_DEBUG("The exoplanet [exoplanet_obj_typepath] has [exoplanet_obj_typepath::turftype] as its base turf.")

	if(test_status == UNIT_TEST_PASSED)
		TEST_PASS("All exoplanets have an exoplanet base turf.")

	return test_status

/datum/unit_test/area_configuration/shuttles_area_not_station_area
	name = "AREA CONFIG: Shuttle areas must not be station areas"

/datum/unit_test/area_configuration/shuttles_area_not_station_area/start_test()
	var/test_status = UNIT_TEST_PASSED

	for(var/area/shuttle/shuttle_area_typepath in subtypesof(/area/shuttle))
		//No need for abstract areas to respect this really
		if(is_abstract(shuttle_area_typepath))
			TEST_DEBUG("Skipping abstract shuttle area [shuttle_area_typepath]")
			continue

		TEST_DEBUG("Now testing shuttle area [shuttle_area_typepath]")
		if(shuttle_area_typepath::station_area)
			test_status = TEST_FAIL("The shuttle area [shuttle_area_typepath] is a station area!")
		else
			TEST_NOTICE("The shuttle area [shuttle_area_typepath] is not a station area.")
			TEST_DEBUG("The shuttle area [shuttle_area_typepath] is not a station area.")

	if(test_status == UNIT_TEST_PASSED)
		TEST_PASS("All shuttle areas are not station areas.")

	return test_status
