/// gives us the stack trace from CRASH() without ending the current proc.
#define stack_trace(message) _stack_trace(message, __FILE__, __LINE__)

#define WORKAROUND_IDENTIFIER "%//%"

// ---

#ifdef UNIT_TEST

/// If running in unit tests, print the stack trace and fail tests.
/// If not tests, does nothing.
#define dbg_stack_trace(reason) \
	do { \
		var/_dbg_reason = (reason); \
		stack_trace("Failed: [_dbg_reason]"); \
	} while (0)

/// If running in unit tests, assert that an expression is true.
/// If assertion fails, print the stack trace and fail tests.
/// If not tests, does nothing.
#define dbg_assert(assertion, reason...) \
	do { \
		if (!(assertion)) { \
			var/_dbg_reason = (__VA_ARGS__ ? ("; " + (__VA_ARGS__)) : ""); \
			stack_trace("Assertion failed: " + #assertion + "[_dbg_reason]"); \
		} \
	} while (0)

#else

/// If running in unit tests, print the stack trace and fail tests.
/// If not tests, does nothing.
#define dbg_stack_trace(reason)
/// If running in unit tests, assert that an expression is true.
/// If assertion fails, print the stack trace and fail tests.
/// If not tests, does nothing.
#define dbg_assert(assertion, reason...)

#endif
