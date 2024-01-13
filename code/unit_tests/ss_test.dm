// This file exists so unit tests work with SMC.
// It initializes last in the subsystem order, and queues
// the tests to start about 20 seconds after init is done.

/*
 * Wondering if you should change this to run the tests? NO!
 * Because the preproc checks for this in other areas too, set it in code\__DEFINES\manual_unit_testing.dm instead!
 */
#ifdef UNIT_TEST

/*
	The Unit Tests Configuration subsystem
*/

SUBSYSTEM_DEF(unit_tests_config)
	name = "Unit Test Config"
	init_order = SS_INIT_PERSISTENT_CONFIG
	flags = SS_NO_FIRE | SS_NO_INIT

	var/datum/unit_test/UT // Logging/output, use this to log things from outside where a specific unit_test is defined

	///What is our identifier, what pod are we, and hence what are we supposed to run
	var/identifier = null

	///The configuration, decoded from `config/unit_test/ut_pods_configuration.json`, specific for our identifier
	var/list/config = list()

	///Boolean, if the tests should fast fail (Anything fails = the pod shuts down)
	var/fail_fast = FALSE

	///How many times can the pod retries before the unit test is considered failed
	var/retries = 0

/datum/controller/subsystem/unit_tests_config/PreInit()
	. = ..()

	UT = new

	world.fps = 10

	//Acquire our identifier, or enter Hopper mode if failing to do so
	try
		src.identifier = rustg_file_read("config/unit_test/identifier.txt")

		if(isnull(src.identifier))
			UT.fail("**** This UT is being run without an identifier! Aborting... ****")
			del world
	catch()
		UT.fail("**** Exception encountered while trying to acquire an identifier for this UT! ***")
		del world



	ASSERT(!isnull(src.identifier))

	//Try to acquire our configuration
	try

		src.config = json_decode(rustg_file_read("config/unit_test/ut_pods_configuration.json"))

		UT.debug("Pods configuration file read as: [json_encode(src.config)]")
		UT.debug("Will extract the pod configuration for pod with identifier: [src.identifier]")

		for(var/k in src.config)
			UT.debug("The following pod configuration is defined: [k]")

		src.config = src.config[src.identifier]

		UT.debug("Pods configuration extrapolated as: [json_encode(src.config)]")

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

	refresh_retries(FALSE)
	refresh_fail_fast()


/**
 * Refresh the `retries` variable from the environment variables
 *
 * * decrement - A boolean, if `TRUE` it decrements the environment variable that holds the retries left
 */
/datum/controller/subsystem/unit_tests_config/proc/refresh_retries(decrement = FALSE)
	src.retries = text2num(world.GetConfig("env", "CI_MAX_RETRIES"))

	if(decrement && src.retries)
		world.SetConfig("env", "CI_MAX_RETRIES", num2text((src.retries - 1)))

/**
 * Refresh the `fail_fast` variable depending on the CI trigger reason
 */
/datum/controller/subsystem/unit_tests_config/proc/refresh_fail_fast()

	//Off by default, so only need to flip it on when we wish it to
	if(world.GetConfig("env", "CI_TRIGGER_REASON") == "merge_group")
		src.fail_fast = TRUE


/*
	The Unit Tests subsystem
*/
SUBSYSTEM_DEF(unit_tests)
	name = "Unit Tests"
	init_order = -1e6	// last.
	var/list/queue = list()
	var/list/async_tests = list()
	var/list/current_async
	var/stage = 0
	wait = 2 SECONDS
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY | RUNLEVEL_INIT


/datum/controller/subsystem/unit_tests/Initialize(timeofday)
	SSunit_tests_config.UT.notice("Initializing Unit Testing", __FILE__, __LINE__)

	//
	//Start the Round.
	//

	for(var/thing in subtypesof(/datum/unit_test) - typecacheof(current_map.excluded_test_types))
		var/datum/unit_test/D = new thing

		if(findtext(D.name, "template"))
			qdel(D)
			continue

		if(!length(D.groups))
			SSunit_tests_config.UT.fail("**** Unit Test has no group assigned! [D.name] ****")
			del world

		for(var/group in D.groups)
			if((group in SSunit_tests_config.config["unit_test_groups"]) || (SSunit_tests_config.config["unit_test_groups"][1] == "*"))
				queue += D
				break

	SSunit_tests_config.UT.notice("[queue.len] unit tests loaded.", __FILE__, __LINE__)

	return SS_INIT_SUCCESS

/datum/controller/subsystem/unit_tests/proc/start_game()
	if (SSticker.current_state == GAME_STATE_PREGAME)
		SSticker.current_state = GAME_STATE_SETTING_UP

		SSunit_tests_config.UT.debug("Round has been started.", __FILE__, __LINE__)
		stage++
	else
		SSunit_tests_config.UT.fail("Unable to start testing; SSticker.current_state=[SSticker.current_state]!", __FILE__, __LINE__)
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

		var/current_test_result = null

		current_test_result = test.start_test()

		//If the result is still null, the test have runtimed or not returned a valid result, either way rise an error
		if (isnull(current_test_result))
			test.fail("Unit Test runtimed or returned an illicit result: [test.name]", __FILE__, __LINE__)

		TEST_GROUP_CLOSE("[test.name]")

		if (test.async)
			async_tests += test

		total_unit_tests++

		if(unit_tests_failures && SSunit_tests_config.fail_fast)
			SSunit_tests_config.UT.fail("**** Fail fast is enabled and an unit test failed! Aborting... ****", __FILE__, __LINE__)
			handle_tests_ending(TRUE)
			break

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
				SSunit_tests_config.UT.pass("**** All Unit Tests Passed \[[total_unit_tests]\] ****", __FILE__, __LINE__)
				handle_tests_ending(FALSE)
			else
				SSunit_tests_config.UT.fail("**** \[[unit_tests_failures]\] Errors Encountered! Read the logs above! ****", __FILE__, __LINE__)
				handle_tests_ending(TRUE)

/datum/controller/subsystem/unit_tests/proc/handle_tests_ending(is_failure = FALSE)
	if(is_failure && SSunit_tests_config.retries)
		SSunit_tests_config.refresh_retries(TRUE)
		world.Reboot("Restarting for another UT try, remaining tries: [SSunit_tests_config.retries]", TRUE)
	else
		del world

//This is only valid during unit tests
/world/Error(var/exception/e)

	var/datum/unit_test/UT

	//Try to use the SSunit_tests_config.UT, but if for some god forsaken reason it doesn't exist, make a new one
	if(SSunit_tests_config?.UT)
		UT = SSunit_tests_config?.UT
	else
		UT = new

	UT.fail("**** !!! Encountered a world exception during unit testing !!! - Exception name: [e.name] → @@@ [e.file]:[e.line] ****", __FILE__, __LINE__)

	return ..(e)

#endif
