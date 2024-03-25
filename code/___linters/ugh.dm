
/atom/proc/check_mapped_in_vars()

	// 	check_mapped_in_vars()
	// 		#if defined(UNIT_TEST)
	// 		if(density!=initial(density)) {SSunit_tests_config.UT.fail("**** foo bar [src], [type], [x] [y] [z],", __FILE__, __LINE__)}
	// 		#endif

#if defined(UNIT_TEST)
	#define NO_MAP_OVERRIDE(X) UNLINT(check_mapped_in_vars() { if(density!=initial(density)) { SSunit_tests_config.UT.fail("**** foo bar [src], [type], [x] [y] [z],", __FILE__, __LINE__) } })
#else
	#define NO_MAP_OVERRIDE(X)
#endif

#define FOOBAR(X) X
