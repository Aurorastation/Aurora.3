// This file exists so unit tests work with SMC.

#ifdef UNIT_TEST

/datum/subsystem/unit_tests
	name = "Unit Tests"
	init_order = -10	// last.
	flags = SS_NO_TICK_CHECK

/datum/subsystem/unit_tests/Initialize(timeofday)
	log_unit_test("Initializing Unit Testing")	
	
	//
	//Start the Round.
	//

	if(!ticker)
		crash_with("No Ticker")
		world.Del()

	world.save_mode("extended")

	addtimer(CALLBACK(GLOBAL_PROC, .proc/_ut_start_game), 10 SECONDS)

/proc/_ut_start_game()
	if (ticker.current_state == GAME_STATE_PREGAME)
		ticker.current_state = GAME_STATE_SETTING_UP

		log_unit_test("Round has been started.")

/datum/subsystem/unit_tests/fire()
	var/list/test_datums = typesof(/datum/unit_test)

	var/list/async_test = list()
	var/list/started_tests = list()

	log_unit_test("Testing Started.")

	for (var/test in test_datums)
		var/datum/unit_test/d = new test()

		if(d.disabled)
			d.pass("[ascii_red]Check Disabled: [d.why_disabled]")
			continue

		if(findtext(d.name, "template"))
			continue

		if(isnull(d.start_test()))		// Start the test.
			d.fail("Test Runtimed")
		if(d.async)				// If it's async then we'll need to check back on it later.
			async_test.Add(d)
		total_unit_tests++
		


	//
	// Check the async tests to see if they are finished.
	// 

	while(async_test.len)
		for(var/datum/unit_test/test  in async_test)
			if(test.check_result())
				async_test.Remove(test)
		sleep(1)

	//
	// Make sure all Unit Tests reported a result
	//

	for(var/datum/unit_test/test in started_tests)
		if(!test.reported)
			test.fail("Test failed to report a result.")

	if(all_unit_tests_passed)
		log_unit_test("[ascii_green]**** All Unit Tests Passed \[[total_unit_tests]\] ****[ascii_reset]")
		world.Del()
	else
		log_unit_test("[ascii_red]**** \[[failed_unit_tests]\\[total_unit_tests]\] Unit Tests Failed ****[ascii_reset]")
		world.Del()

#endif
