/*
 *  Ruins tests
 *  Basically loads the ruins to then check them
 */

/datum/unit_test/ruins_test
	name = "Ruins Test"
	groups = list("ruins")
	priority = 100 //Have to load the ruins first if you want to check them later

/datum/unit_test/ruins_test/start_test()
	return UNIT_TEST_SKIPPED

/datum/unit_test/ruins_test/exoplanet_ruins
	name = "Exoplanet Ruins"

/datum/unit_test/ruins_test/exoplanet_ruins/start_test()

	//Generate a planet WITH VACUUM ATMOS to use as a baseline
	var/obj/effect/overmap/visitable/sector/exoplanet/barren/asteroid/test_exoplanet = new()
	test_exoplanet.generate_atmosphere()
	TEST_ASSERT(length(test_exoplanet.map_z), "The test exoplanet somehow doesn't have any level!")

	//Set the exoplanet like it exists on the zlevel, so that exoplanet turfs can copy the atmosphere from and not cause
	//active edges with the vacuum of space, since the exoplanet is without atmos as per above
	for(var/zlevel in test_exoplanet.map_z[length(test_exoplanet.map_z)] to 1024) //I pray to the lord we won't ever have 1024 ruins
		GLOB.map_sectors["[zlevel]"] = test_exoplanet

	//ZAS could run and remove an active edge before we can scan for one, we don't want that as things could get missed otherwise,
	//hence we stop ZAS from running
	SSair.can_fire = FALSE

	for(var/ruin in subtypesof(/datum/map_template/ruin/exoplanet))
		var/datum/map_template/ruin/exoplanet/tested_ruin = new ruin()
		var/turf/center_ruin = tested_ruin.load_new_z(FALSE)

		if(!tested_ruin)
			TEST_FAIL("Failed to load ruin [ruin]!")
			return UNIT_TEST_FAILED

		var/loaded_zlevel = null
		if(center_ruin)
			loaded_zlevel = center_ruin.z
		else
			TEST_WARN("Ruin [tested_ruin.name] didn't load in a Z level, or it could not be located, or it was not returned by the loader")
			loaded_zlevel = "Unknown, read above!"

		TEST_DEBUG("Loaded ruin [tested_ruin.name] in Z [loaded_zlevel]")

	TEST_PASS("All the ruins in [src.name] loaded successfully!")
	return UNIT_TEST_PASSED
