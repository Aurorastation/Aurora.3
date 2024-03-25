
// todo: document
/atom/proc/check_non_initial_vars()
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

// todo: document
#define CHECK_NON_INITIAL(VARNAME) \
	if(VARNAME!=initial(VARNAME)) { \
		SSunit_tests_config.UT.fail("**** var has non-initial value: [#VARNAME]; [src]; [type]; xyz: [x] [y] [z];", __FILE__, __LINE__) \
	}

	// 	check_mapped_in_vars()
	// 		#if defined(UNIT_TEST)
	// 		if(density!=initial(density)) {SSunit_tests_config.UT.fail("**** foo bar [src], [type], [x] [y] [z],", __FILE__, __LINE__)}
	// 		#endif

// #if defined(UNIT_TEST)
// 	#define NO_MAP_OVERRIDE(X) UNLINT(check_mapped_in_vars() { if(density!=initial(density)) { SSunit_tests_config.UT.fail("**** foo bar [src], [type], [x] [y] [z],", __FILE__, __LINE__) } })
// #else
// 	#define NO_MAP_OVERRIDE(X)
// #endif

// #define FOOBAR(X) X
