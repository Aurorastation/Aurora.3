/// gives us the stack trace from CRASH() without ending the current proc.
#define stack_trace(message) _stack_trace(message, __FILE__, __LINE__)

#define WORKAROUND_IDENTIFIER "%//%"

// ---

#ifdef UNIT_TEST

/// If running in unit tests, print the stack trace and fail tests.
/// If not tests, does nothing.
#define tests_stack_trace(assertion, reason) \
	do { \
		stack_trace("Assertion failed: " + #assertion + "; " + #reason); \
	} while (0)

/// If running in unit tests, assert that an expression is true.
/// If assertion fails, print the stack trace and fail tests.
/// If not tests, does nothing.
#define tests_assert_or_stack_trace(assertion, reason) \
	do { \
		if (!(assertion)) { \
			tests_stack_trace("Assertion failed: " + #assertion + "; " + #reason); \
		} \
	} while (0)


#else

#define tests_stack_trace(assertion, reason)
#define tests_assert_or_stack_trace(assertion, reason)

#endif
