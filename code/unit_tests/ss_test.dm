// This file exists so unit tests work with SMC.
// It initializes last in the subsystem order, and queues
// the tests to start about 20 seconds after init is done.

/**
 * Wondering if you should change this to run the tests? NO!
 * Because the preproc checks for this in other areas too, set it in code\__defines\manual_unit_testing.dm instead!
 */
#ifdef UNIT_TEST

var/datum/controller/subsystem/unit_tests_config/SSunit_tests_config = new
/datum/controller/subsystem/unit_tests_config
	name = "Unit Test Config"
	var/datum/unit_test/UT = new
	init_order = SS_INIT_PERSISTENT_CONFIG

	///What is our identifier, what pod are we, and hence what are we supposed to run
	var/identifier = null

	///The configuration, decoded from `config/unit_test/ut_pods_configuration.json`, specific for our identifier
	var/list/config = list()

/datum/controller/subsystem/unit_tests_config/New()
	. = ..()

	//Acquire our identifier, or enter Hopper mode if failing to do so
	try
		src.identifier = rustg_file_read("config/unit_test/identifier.txt")

		if(isnull(src.identifier))
			UT.fail("**** This UT is being run without an identifier! Aborting... ****")
			del world
	catch()
		UT.fail("**** Exception encountered while trying to acquire an identifier for this UT! ***")
		del world


	//Try to acquire our configuration
	try
		src.config = json_decode(rustg_file_read("config/unit_test/ut_pods_configuration.json"))

		UT.notice("Pods configuration file read as: [json_encode(src.config)]")

		src.config = src.config[identifier]

		UT.notice("Pods configuration extrapolated as: [json_encode(src.config)]")

		if(isnull(src.config))
			UT.fail("**** This UT is being run without a config, it's null! Aborting... ****")
			del world

		if(!src.config.len)
			UT.fail("**** This UT is being run without a config! Aborting... ****")
			del world

	catch(var/exception/e)
		UT.fail("**** Exception encountered while trying to acquire the config for this UT! Identifier: [identifier] ***")
		UT.fail("**** Exception encountered: [e] ***")
		. = ..(e)
		del world

/datum/controller/subsystem/unit_tests
	name = "Unit Tests"
	var/datum/unit_test/UT = new // Use this to log things from outside where a specific unit_test is defined
	init_order = -1e6	// last.
	var/list/queue = list()
	var/list/async_tests = list()
	var/list/current_async
	var/stage = 0
	wait = 2 SECONDS
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY | RUNLEVEL_INIT


/datum/controller/subsystem/unit_tests/Initialize(timeofday)
	UT.notice("Initializing Unit Testing", __FILE__, __LINE__)



	//
	//Start the Round.
	//

	for (var/thing in subtypesof(/datum/unit_test) - typecacheof(current_map.excluded_test_types))
		var/datum/unit_test/D = new thing

		if(findtext(D.name, "template"))
			qdel(D)
			continue

		if(isnull(D.groups))
			UT.fail("**** Unit Test has no group assigned! [D.name] ****")
			del world

		for(var/group in D.groups)
			if((group in SSunit_tests_config.config["unit_test_groups"]) || (SSunit_tests_config.config["unit_test_groups"][1] == "*"))
				queue += D
				break

	UT.notice("[queue.len] unit tests loaded.", __FILE__, __LINE__)
	..()

/datum/controller/subsystem/unit_tests/proc/start_game()
	if (SSticker.current_state == GAME_STATE_PREGAME)
		SSticker.current_state = GAME_STATE_SETTING_UP

		UT.debug("Round has been started.", __FILE__, __LINE__)
		stage++
	else
		UT.fail("Unable to start testing; SSticker.current_state=[SSticker.current_state]!", __FILE__, __LINE__)
		del world

/datum/controller/subsystem/unit_tests/proc/handle_tests()
	var/list/curr = queue
	while (curr.len)
		var/datum/unit_test/test = curr[curr.len]
		curr.len--

		if (test.map_path && current_map && current_map.path != test.map_path)
			test.pass("[ascii_red]Check Disabled: This test is not allowed to run on this map.", __FILE__, __LINE__)
			if (MC_TICK_CHECK)
				return
			continue

		if (test.disabled)
			test.pass("[ascii_red]Check Disabled: [test.why_disabled]", __FILE__, __LINE__)
			if (MC_TICK_CHECK)
				return
			continue

		TEST_GROUP_OPEN("[test.name]")
		if (test.start_test() == null)	// Runtimed.
			test.fail("Test Runtimed: [test.name]", __FILE__, __LINE__)
		TEST_GROUP_CLOSE("[test.name]")

		if (test.async)
			async_tests += test

		total_unit_tests++

		if (MC_TICK_CHECK)
			return

	if (!curr.len)
		stage++

/datum/controller/subsystem/unit_tests/proc/handle_async(resumed = 0)
	if (!resumed)
		current_async = async_tests.Copy()

	var/list/async = current_async
	while (async.len)
		var/datum/unit_test/test = current_async[current_async.len]
		current_async.len--

		TEST_GROUP_OPEN("[test.name]")
		if (test.check_result())
			async_tests -= test
		TEST_GROUP_CLOSE("[test.name]")

		if (MC_TICK_CHECK)
			return

	if (!async.len)
		stage++

/datum/controller/subsystem/unit_tests/fire(resumed = 0)
	switch (stage)
		if (0)
			start_game()

		if (1)
			// wait a moment
			stage++

		if (2)	// do normal tests
			handle_tests()

		if (3)
			handle_async(resumed)

		if (4)	// Finalization.
			if(all_unit_tests_passed)
				UT.pass("**** All Unit Tests Passed \[[total_unit_tests]\] ****", __FILE__, __LINE__)
			else
				UT.fail("**** \[[unit_tests_failures]\] Errors Encountered! Read the logs above! ****", __FILE__, __LINE__)
			del world

#endif
