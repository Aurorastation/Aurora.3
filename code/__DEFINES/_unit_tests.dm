//include unit test files in this module in this ifdef
//Keep this sorted alphabetically

// #if defined(UNIT_TEST) || defined(SPACEMAN_DMM) //tgstation style, not relevant for us, for now

/// Constants indicating unit test completion status
#define UNIT_TEST_FAILED null
#define UNIT_TEST_PASSED 1
#define UNIT_TEST_SKIPPED 2 //Currently not implemented

/**
 * Output colouring macros, ANSI as per https://gist.github.com/stevewithington/b1b620b5bc9252e2c32e2cad35efbf83
 */

/// Underlined Blue
#define TEST_OUTPUT_HI_BLUE(text) "\x1B\x5B0;94m[text]\x1B\x5B0m"
/// High Intensity Cyan
#define TEST_OUTPUT_U_CYAN(text) "\x1B\x5B4;36m[text]\x1B\x5B0m"


/**
 * Macros used to log the Unit Test messages
 */

#define TEST_FAIL(reason) (fail(reason || "No reason", __FILE__, __LINE__))
#define TEST_PASS(reason) (pass(reason || "No reason", __FILE__, __LINE__))

/// Logs a warning message, to be used when something is important to be known to the reader, like a test that did not run,
/// but not a failure or something that necessarily indicates an issue
#define TEST_WARN(message) warn(##message, __FILE__, __LINE__)


/// Logs a notice, something that is good to be known to a scrutinizing eye, without being obnoxious
/// Do not use this with long lists or internals that most people would never care about for the vast majority of the time
#define TEST_NOTICE(message) notice(##message, __FILE__, __LINE__)


/// Logs debug messages of the test run, this is NOT normally visible in GitHub, the test has to be run in debug mode (on the GitHub actions) for that.
/// To be used to log debugging, internals information
#define TEST_DEBUG(message) debug(##message, __FILE__, __LINE__)

/// Groups management
#define TEST_GROUP_OPEN(groupname) world.log << TEST_OUTPUT_HI_BLUE("----> UNIT TEST \[[groupname]\] <----") //world.log << "::group::"+##name <-- if we want to switch back to github auto-grouping
#define TEST_GROUP_CLOSE(message) world.log << TEST_OUTPUT_HI_BLUE("\n") //world.log << ##message + "\n::endgroup::" <-- if we want to switch back to github auto-grouping

/// Asserts that a condition is true
#define TEST_ASSERT(assertion, reason) if (!(assertion)) { return fail("Assertion failed: [reason || "No reason"]", __FILE__, __LINE__) }

/// Asserts that a parameter is not null
#define TEST_ASSERT_NOTNULL(a, reason) if (isnull(a)) { return fail("Expected non-null value: [reason || "No reason"]", __FILE__, __LINE__) }

/// Asserts that a parameter is null
#define TEST_ASSERT_NULL(a, reason) if (!isnull(a)) { return fail("Expected null value but received [a]: [reason || "No reason"]", __FILE__, __LINE__) }

/// Asserts that the two parameters passed are equal
/// Optionally allows an additional message in the case of a failure
#define TEST_ASSERT_EQUAL(a, b, message) do { \
	var/lhs = ##a; \
	var/rhs = ##b; \
	if (lhs != rhs) { \
		return fail("Expected [isnull(lhs) ? "null" : lhs] to be equal to [isnull(rhs) ? "null" : rhs].[message ? " [message]" : ""]", __FILE__, __LINE__); \
	} \
} while (FALSE)

/// Asserts that the two parameters passed are not equal
/// Optionally allows an additional message in the case of a failure
#define TEST_ASSERT_NOTEQUAL(a, b, message) do { \
	var/lhs = ##a; \
	var/rhs = ##b; \
	if (lhs == rhs) { \
		return fail("Expected [isnull(lhs) ? "null" : lhs] to not be equal to [isnull(rhs) ? "null" : rhs].[message ? " [message]" : ""]", __FILE__, __LINE__); \
	} \
} while (FALSE)
