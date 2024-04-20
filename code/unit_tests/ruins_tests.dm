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

/datum/unit_test/ruins_test/all_files_valid
	name = "All Ruins Files Exist"
	groups = list("generic") //This runs as a generic test as we only need to pass them once, not in every pod

/datum/unit_test/ruins_test/all_files_valid/start_test()

	. = UNIT_TEST_PASSED

	//Look into every ruin, and see if all the file paths are valid (the file exists)
	//or otherwise do not respect the convention
	for(var/ruin in subtypesof(/datum/map_template/ruin))
		LOG_GITHUB_NOTICE("Testing files for ruin [ruin]")

		var/datum/map_template/ruin/tested_ruin = new ruin()

		for(var/path in tested_ruin.mappaths)
			LOG_GITHUB_DEBUG("Now testing [path] for ruin [ruin]")

			//Path format must be respected, start without a slash, and end with a slash
			if(!initial(tested_ruin.prefix) || tested_ruin.prefix[1] == "/" || tested_ruin.prefix[length_char(tested_ruin.prefix)] != "/")
				TEST_FAIL("Ruin [tested_ruin.name] has an invalid prefix path: [tested_ruin.prefix]")
				. = UNIT_TEST_FAILED

			//No subfolders in the suffixes list
			var/regex/no_subfolders_in_suffixes = regex(@"[\\\/]+")
			for(var/suffix in tested_ruin.suffixes)
				LOG_GITHUB_DEBUG("Checking suffix [suffix]")
				if(no_subfolders_in_suffixes.Find(suffix))
					TEST_FAIL("Ruin [ruin] contains a slash or a backslash in the suffixes list!")
					. = UNIT_TEST_FAILED

			//See if the file actually exists
			var/file_content = file2text(file(path))
			if(!length(file_content))
				TEST_FAIL("Ruin [ruin] - [path] have paths that do not exist or are empty!")
				. = UNIT_TEST_FAILED



	if(. == UNIT_TEST_PASSED)
		TEST_PASS("All ruins have valid files!")
		return UNIT_TEST_PASSED

	else
		TEST_FAIL("Some ruins have invalid paths, read above!")
		return UNIT_TEST_FAILED
