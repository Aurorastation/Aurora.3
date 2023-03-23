//include unit test files in this module in this ifdef
//Keep this sorted alphabetically

// #if defined(UNIT_TESTS) || defined(SPACEMAN_DMM) //tgstation style, not relevant for us, for now

/// Constants indicating unit test completion status
#define UNIT_TEST_FAILED null
#define UNIT_TEST_PASSED 1
#define UNIT_TEST_SKIPPED 2 //Currently not implemented

/**
 * Macros used to log the Unit Test messages
 */

#define TEST_FAIL(reason) (fail("\t" + reason || "\t" + "No reason", __FILE__, __LINE__))
#define TEST_PASS(reason) (pass("\t" + reason || "\t" + "No reason", __FILE__, __LINE__))

/// Logs a warning message, to be used when something is important to be known to the reader, like a test that did not run,
/// but not a failure or something that necessarily indicates an issue
#define TEST_WARN(message) warn("\t" + ##message, __FILE__, __LINE__)


/// Logs a notice, comething that is good to be known to a scrutinizing eye, without being obnoxious
/// Do not use this with long lists or internals that most people would never care about for the vast majority of the time
#define TEST_NOTICE(message) notice("\t" + ##message, __FILE__, __LINE__)


/// Logs debug messages of the test run, this is NOT normally visible in GitHub, the test has to be run in debug mode (on the GitHub actions) for that.
/// To be used to log debugging, internals information
#define TEST_DEBUG(message) debug(##message, __FILE__, __LINE__)

/// Groups management
#define TEST_GROUP_OPEN(name) world.log << ##name //world.log << "::group::"+##name
#define TEST_GROUP_CLOSE(message) world.log << ##message //world.log << ##message + "\n::endgroup::"

/// Asserts that a condition is true
/// If the condition is not true, fails the test
#define TEST_ASSERT(assertion, reason) if (!(assertion)) { return fail("Assertion failed: [reason || "No reason"]", __FILE__, __LINE__) }

/// Asserts that a parameter is not null
#define TEST_ASSERT_NOTNULL(a, reason) if (isnull(a)) { return fail("Expected non-null value: [reason || "No reason"]", __FILE__, __LINE__) }

/// Asserts that a parameter is null
#define TEST_ASSERT_NULL(a, reason) if (!isnull(a)) { return fail("Expected null value but received [a]: [reason || "No reason"]", __FILE__, __LINE__) }

/// Asserts that the two parameters passed are equal, fails otherwise
/// Optionally allows an additional message in the case of a failure
#define TEST_ASSERT_EQUAL(a, b, message) do { \
	var/lhs = ##a; \
	var/rhs = ##b; \
	if (lhs != rhs) { \
		return fail("Expected [isnull(lhs) ? "null" : lhs] to be equal to [isnull(rhs) ? "null" : rhs].[message ? " [message]" : ""]", __FILE__, __LINE__); \
	} \
} while (FALSE)

/// Asserts that the two parameters passed are not equal, fails otherwise
/// Optionally allows an additional message in the case of a failure
#define TEST_ASSERT_NOTEQUAL(a, b, message) do { \
	var/lhs = ##a; \
	var/rhs = ##b; \
	if (lhs == rhs) { \
		return fail("Expected [isnull(lhs) ? "null" : lhs] to not be equal to [isnull(rhs) ? "null" : rhs].[message ? " [message]" : ""]", __FILE__, __LINE__); \
	} \
} while (FALSE)

#define TEST_PRE 0
#define TEST_DEFAULT 1
/// After most test steps, used for tests that run long so shorter issues can be noticed faster
#define TEST_LONGER 10
/// This must be the last test to run due to the inherent nature of the test iterating every single tangible atom in the game and qdeleting all of them (while taking long sleeps to make sure the garbage collector fires properly) taking a large amount of time.
#define TEST_CREATE_AND_DESTROY INFINITY

/// Change color to red on ANSI terminal output, if enabled with -DANSICOLORS.
#ifdef ANSICOLORS
#define TEST_OUTPUT_RED(text) "\x1B\x5B1;31m[text]\x1B\x5B0m"
#else
#define TEST_OUTPUT_RED(text) (text)
#endif
/// Change color to green on ANSI terminal output, if enabled with -DANSICOLORS.
#ifdef ANSICOLORS
#define TEST_OUTPUT_GREEN(text) "\x1B\x5B1;32m[text]\x1B\x5B0m"
#else
#define TEST_OUTPUT_GREEN(text) (text)
#endif

/// A trait source when adding traits through unit tests
#define TRAIT_SOURCE_UNIT_TESTS "unit_tests"
