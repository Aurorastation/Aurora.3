/*
 *  Ruins tests
 *  Basically loads the ruins to then check them
 */
//Since we rely on SSunit_tests_config.config that isn't defined without this
#if defined(UNIT_TEST)
/datum/unit_test/ruins_test
	name = "Ruins Test"
	groups = list("ruins")
	priority = 100 //Have to load the ruins first if you want to check them later

/datum/unit_test/ruins_test/start_test()
	return UNIT_TEST_SKIPPED

/datum/unit_test/ruins_test/exoplanet_ruins
	name = "Exoplanet Ruins"

/datum/unit_test/ruins_test/exoplanet_ruins/start_test()

	var/list/ruin_report_map = list()

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

		//We don't care about abstract types
		if(is_abstract(tested_ruin))
			continue

		//Every ruin must have at least one test group
		if(!length(tested_ruin.unit_test_groups))
			TEST_FAIL("Ruin [tested_ruin.name] - [tested_ruin.type] has no unit test groups!")
			return UNIT_TEST_FAILED

		//See if the ruin is in the unit test groups we're supposed to run
		var/is_in_unit_test_groups = FALSE
		for(var/unit_test_group in tested_ruin.unit_test_groups)
			if(unit_test_group in SSunit_tests_config.config["ruins_unit_test_groups"] || SSunit_tests_config.config["ruins_unit_test_groups"][1] == "*")
				is_in_unit_test_groups = TRUE
				break

		//If it's not in the unit test groups, skip it
		if(!is_in_unit_test_groups)
			TEST_DEBUG("Ruin [tested_ruin.name] - [tested_ruin.type] is not part of this pod configuration, skipping")
			continue

		TEST_NOTICE("Testing ruin [tested_ruin.name] - [tested_ruin.type] -- Size: [tested_ruin.width]x[tested_ruin.height]")

		var/list/ruin_bounds = tested_ruin.load_new_z(FALSE)

		if(!tested_ruin)
			TEST_FAIL("Failed to load ruin [ruin]!")
			return UNIT_TEST_FAILED

		if(!ruin_bounds)
			TEST_FAIL("Failed to load ruin [ruin], no bounds were received!")
		else
			TEST_NOTICE("Loaded ruin [tested_ruin.name] - [tested_ruin.type] with the following bounds:")
			TEST_NOTICE("Lower X: [ruin_bounds[MAP_MINX]] - Upper X: [ruin_bounds[MAP_MAXX]]")
			TEST_NOTICE("Lower Y: [ruin_bounds[MAP_MINY]] - Upper Y: [ruin_bounds[MAP_MAXY]]")

			//Only print the z level bounds if they're not the same
			if(ruin_bounds[MAP_MINZ] != ruin_bounds[MAP_MAXZ])
				TEST_NOTICE("Lower Z: [ruin_bounds[MAP_MINZ]] - Upper Z: [ruin_bounds[MAP_MAXZ]]")

			for(var/zlevel in ruin_bounds[MAP_MINZ] to ruin_bounds[MAP_MAXZ])
				ruin_report_map["[zlevel]"] = "[tested_ruin.name] ([tested_ruin.type]) -- X: [ruin_bounds[MAP_MINX]] → [ruin_bounds[MAP_MAXX]] Y: [ruin_bounds[MAP_MINY]] → [ruin_bounds[MAP_MAXY]]"

	TEST_PASS("All the ruins in [src.name] loaded successfully!")

	//Print a report in an expandable group
	world.log << "::group::{Report of ruin placements}"
	for(var/zlevel in ruin_report_map)
		TEST_NOTICE("Z: [zlevel] --> [ruin_report_map["[zlevel]"]]")
	world.log << "::endgroup::"

	return UNIT_TEST_PASSED

/datum/unit_test/ruins_test/all_files_valid
	name = "All Ruins Files Exist"
	groups = list("generic") //This runs as a generic test as we only need to pass them once, not in every pod

/datum/unit_test/ruins_test/all_files_valid/start_test()

	. = UNIT_TEST_PASSED

	//Look into every ruin, and see if all the file paths are valid (the file exists)
	//or otherwise do not respect the convention
	for(var/ruin in subtypesof(/datum/map_template/ruin))
		if(is_abstract(ruin))
			LOG_GITHUB_DEBUG("Skipping abstract ruin [ruin]")
			continue

		LOG_GITHUB_NOTICE("Testing files for ruin [ruin]")

		var/datum/map_template/ruin/tested_ruin = new ruin()

		LOG_GITHUB_DEBUG("Now testing [tested_ruin.mappath] for ruin [ruin]")

		//Path format must be respected, start without a slash, and end with a slash
		if(!initial(tested_ruin.prefix) || tested_ruin.prefix[1] == "/" || tested_ruin.prefix[length_char(tested_ruin.prefix)] != "/")
			TEST_FAIL("Ruin [tested_ruin.name] has an invalid prefix path: [tested_ruin.prefix]")
			. = UNIT_TEST_FAILED

		//No subfolders in the suffix list
		var/regex/no_subfolders_in_suffixes = regex(@"[\\\/]+")
		LOG_GITHUB_DEBUG("Checking suffix [tested_ruin.suffix]")
		if(no_subfolders_in_suffixes.Find(tested_ruin.suffix))
			TEST_FAIL("Ruin [ruin] contains a slash or a backslash in the suffixes list!")
			. = UNIT_TEST_FAILED

		//See if the file actually exists
		var/file_content = file2text(file(tested_ruin.mappath))
		if(!length(file_content))
			TEST_FAIL("Ruin [ruin] - [tested_ruin.mappath] have paths that do not exist or are empty!")
			. = UNIT_TEST_FAILED



	if(. == UNIT_TEST_PASSED)
		TEST_PASS("All ruins have valid files!")
		return UNIT_TEST_PASSED

	else
		TEST_FAIL("Some ruins have invalid paths, read above!")
		return UNIT_TEST_FAILED

#endif //UNIT_TEST
