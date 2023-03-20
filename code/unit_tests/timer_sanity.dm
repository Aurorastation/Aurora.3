/datum/unit_test/timer_sanity/start_test()
	TEST_ASSERT(SStimer.bucket_count >= 0,
		"SStimer is going into negative bucket count from something")
	return UNIT_TEST_PASSED
