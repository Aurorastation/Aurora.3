// This file exists so unit tests work with SMC.
// It initializes last in the subsystem order, and queues
// the tests to start about 20 seconds after init is done.

#ifdef UNIT_TEST

/datum/controller/subsystem/unit_tests
	name = "Unit Tests"
	init_order = -1e6	// last.
	var/list/queue = list()
	var/list/async_tests = list()
	var/list/current_async
	var/stage = 0
	wait = 2 SECONDS
	flags = SS_FIRE_IN_LOBBY

/datum/controller/subsystem/unit_tests/Initialize(timeofday)
	log_unit_test("Initializing Unit Testing")

	//
	//Start the Round.
	//

	for (var/thing in subtypesof(/datum/unit_test) - typecacheof(current_map.excluded_test_types))
		var/datum/unit_test/D = new thing
		if(findtext(D.name, "template"))
			qdel(D)
			continue

		queue += D

	log_unit_test("[queue.len] unit tests loaded.")
	..()

/datum/controller/subsystem/unit_tests/proc/start_game()
	if (SSticker.current_state == GAME_STATE_PREGAME)
		SSticker.current_state = GAME_STATE_SETTING_UP

		log_unit_test("Round has been started.")
		stage++
	else
		log_unit_test("Unable to start testing; SSticker.current_state=[SSticker.current_state]!")
		del world

/datum/controller/subsystem/unit_tests/proc/handle_tests()
	var/list/curr = queue
	while (curr.len)
		var/datum/unit_test/test = curr[curr.len]
		curr.len--

		if (test.disabled)
			test.pass("[ascii_red]Check Disabled: [test.why_disabled]")
			if (MC_TICK_CHECK)
				return
			continue

		if (test.start_test() == null)	// Runtimed.
			test.fail("Test Runtimed")
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

		if (test.check_result())
			async_tests -= test

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
				log_unit_test("[ascii_green]**** All Unit Tests Passed \[[total_unit_tests]\] ****[ascii_reset]")
			else
				log_unit_test("[ascii_red]**** \[[failed_unit_tests]\\[total_unit_tests]\] Unit Tests Failed ****[ascii_reset]")
			del world

#endif
