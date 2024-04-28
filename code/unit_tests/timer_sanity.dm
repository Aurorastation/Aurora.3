/datum/unit_test/timer_sanity
	name = "SStimer Sanity (no negative count) Test"
	groups = list("generic")

/datum/unit_test/timer_sanity/start_test()
	TEST_ASSERT(SStimer.bucket_count >= 0,
		"SStimer is going into negative bucket count from something")
	return TEST_PASS("SStimer bucket count is positive, as expected.")
