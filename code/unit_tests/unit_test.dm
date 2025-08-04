/*   Unit Tests originally designed by Ccomp5950
 *
 *   Tests are created to prevent changes that would create bugs or change expected behaviour.
 *   For the most part I think any test can be created that doesn't require a client in a mob or require a game mode other then extended
 *
 *   The easiest way to make effective tests is to create a "template" if you intend to run the same test over and over and make your actual
 *   tests be a "child object" of those templates.  Be sure and name your templates with the word "template" somewhere in var/name.
 *
 *   The goal is to have all sorts of tests that run and to run them as quickly as possible.
 *
 *   Tests that require time to run we instead just check back on their results later instead of waiting around in a sleep(1) for each test.
 *   This allows us to finish unit testing quicker since we can start other tests while we're waiting on that one to finish.
 *
 *   An example of that is listed in mob_tests.dm with the human_breath test.  We spawn the mob in space and set the async flag to 1 so that we run the check later.
 *   After 10 life ticks for that mob we check it's oxyloss but while that is going on we've already ran other tests.
 *
 *   If your test requires a significant amount of time...cheat on the timers.  Either speed up the process/life runs or do as we did in the timers for the shuttle
 *   transfers in zas_tests.dm   we move a shuttle but instead of waiting 3 minutes we set the travel time to a very low number.
 *
 *   At the same time, Unit tests are intended to reflect standard usage so avoid changing to much about how stuff is processed.
 *
 *
 *   WRITE UNIT TEST TEMPLATES AS GENERIC AS POSSIBLE (makes for easy reusability)
 *
 */


GLOBAL_VAR_INIT(all_unit_tests_passed, TRUE)
GLOBAL_VAR_INIT(unit_tests_failures, 0)
GLOBAL_VAR_INIT(total_unit_tests, 0)


// We list these here so we can remove them from the for loop running this.
// Templates aren't intended to be ran but just serve as a way to create child objects of it with inheritable tests for quick test creation.

ABSTRACT_TYPE(/datum/unit_test)
	var/name = "template - should not be ran."
	var/disabled = 0        // If we want to keep a unit test in the codebase but not run it for some reason.
	var/async = 0           // If the check can be left to do it's own thing, you must define a check_result() proc if you use this.
	var/reported = 0	// If it's reported a success or failure.  Any tests that have not are assumed to be failures.
	var/why_disabled = "No reason set."   // If we disable a unit test we will display why so it reminds us to check back on it later.
	var/map_path // This should be the same as the path var on /datum/map - The unit test will only run for that map

	///A list of strings, each of which represents a group which this UT belongs to, the UT pods will only run UTs that are in their list
	var/list/groups = list()

	///The priority of the test, the larger it is the later it fires
	var/priority = 1000


/*
 * Log levels used to prettify correctly, only defined in this file (aka undef'd at the end)
 * Build unit test messages as per https://docs.github.com/en/actions/using-workflows/workflow-commands-for-github-actions, or for console output
 */
#define LOG_UNIT_TEST_DEBUG 7
#define LOG_UNIT_TEST_INFORMATION 6
#define LOG_UNIT_TEST_WARNING 4
#define LOG_UNIT_TEST_ERROR 3


/datum/unit_test/proc/log_unit_test(var/severity, var/message, var/filename, var/line, var/title)

	#if defined(MANUAL_UNIT_TEST)

	// We are manually running, write in a more sensible format
	switch(severity)
		if(LOG_UNIT_TEST_DEBUG)
			severity = "\[\[ DEBUG \]\] "
		if(LOG_UNIT_TEST_INFORMATION)
			severity = TEST_OUTPUT_GREEN(" *** NOTICE *** ")
		if(LOG_UNIT_TEST_WARNING)
			severity = TEST_OUTPUT_YELLOW(" === WARNING === ")
		if(LOG_UNIT_TEST_ERROR)
			severity = TEST_OUTPUT_RED(" !!! FAILURE !!! ")
	#else

	// We are running off Travis, which means github (or someone fucked up very badly)

	// Spaces or lack thereof are significant here!
	switch(severity)
		if(LOG_UNIT_TEST_DEBUG)
			severity = "debug"
		if(LOG_UNIT_TEST_INFORMATION)
			severity = "notice "
		if(LOG_UNIT_TEST_WARNING)
			severity = "warning "
		if(LOG_UNIT_TEST_ERROR)
			severity = "error "

	// Of the #if defined(MANUAL_UNIT_TEST)
	#endif

	var/printstring = "::[severity]"

	if(title)
		printstring += " title=[title]"

	printstring += "::[message] → " + TEST_OUTPUT_U_CYAN("@@@[filename]:[line]")


	world.log <<  printstring


/datum/unit_test/proc/debug(var/message, var/file, var/line)
	log_unit_test(LOG_UNIT_TEST_DEBUG, message, file, line)

/datum/unit_test/proc/notice(var/message, var/file, var/line)
	log_unit_test(LOG_UNIT_TEST_INFORMATION, message, file, line)

/datum/unit_test/proc/warn(var/message, var/file, var/line)
	log_unit_test(LOG_UNIT_TEST_WARNING, message, file, line)

/datum/unit_test/proc/fail(var/message, var/file, var/line)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	GLOB.all_unit_tests_passed = FALSE
	GLOB.unit_tests_failures++
	reported = TRUE

	//If we're running in manual mode, raise an exception so we can see it in VSC directly
	#if defined(MANUAL_UNIT_TEST)
	stack_trace("Unit test failed: [src.name] - Message: [message] @@@ [file]:[line]")
	#endif

	log_unit_test(LOG_UNIT_TEST_ERROR, message, file, line)
	return UNIT_TEST_FAILED

/datum/unit_test/proc/pass(var/message, var/file, var/line)
	reported = 1
	log_unit_test(LOG_UNIT_TEST_INFORMATION, TEST_OUTPUT_GREEN("[message]"), file, line, title = "SUCCESS: [name]")
	return UNIT_TEST_PASSED


#undef LOG_UNIT_TEST_DEBUG
#undef LOG_UNIT_TEST_INFORMATION
#undef LOG_UNIT_TEST_WARNING
#undef LOG_UNIT_TEST_ERROR

/datum/unit_test/proc/start_test()
	fail("No test proc.")

/datum/unit_test/proc/check_result()
	fail("No check results proc")
	return 1

/**
 * Used to compare the priority of the tests to order them according to the `priority` var,
 * so that tests with a lower value runs first
 */
/datum/unit_test/proc/compare_priority(datum/unit_test/comparedto)
	return cmp_numeric_dsc(src.priority, comparedto.priority)

/proc/load_unit_test_changes()
/*
	//This takes about 60 seconds to run on Travis and is only used for the ZAS vacume check on The Asteroid.
	if(GLOB.config.generate_asteroid != 1)
		log_unit_test("Overiding Configuration option for Asteroid Generation to ENABLED")
		config.generate_asteroid = 1	// The default map requires it, the example config doesn't have this enabled.
 */
