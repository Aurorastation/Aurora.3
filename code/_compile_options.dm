/*
	This file must be one of the first files included right after the linters to lint it
	This is because the compile options must be defined in every other file, including /world that are included
*/


#define BACKGROUND_ENABLED 0    // The default value for all uses of set background. Set background can cause gradual lag and is recommended you only turn this on if necessary.
								// 1 will enable set background. 0 will disable set background.

// If defined, the sunlight system is enabled. Caution: this uses a LOT of memory.
//#define ENABLE_SUNLIGHT

// We want to use external resources. Kthx.
#define PRELOAD_RSC 0

#ifndef PRELOAD_RSC				//set to:
	#define PRELOAD_RSC 2		//  0 to allow using external resources or on-demand behaviour;
#endif							//  1 to use the default behaviour;
								//  2 for preloading absolutely everything;


//Since we do not currently use some of the flags that TG uses, we have to perform a bit of an adaptation
#if defined(UNIT_TEST) && !defined(OPENDREAM) && !defined(SPACEMAN_DMM)
	#define CIBUILDING
	#define TESTING
#endif //UNIT_TEST


/*
	Manual runs area, uncomment the appropriate defines depending on what you want to do
*/

// !!! For manual use only, remember to recomment before PRing !!!
// #define TESTING // Creates debug feedback messages and enables many optional testing procs/checks
// #define UNIT_TEST
// #define MANUAL_UNIT_TEST

#if defined(MANUAL_UNIT_TEST) && !defined(SPACEMAN_DMM) && !defined(OPENDREAM)
	#warn Manual unit test is defined, remember to recomment it before PRing!
#endif // MANUAL_UNIT_TEST

#ifdef TESTING
	///Used to find the sources of harddels, quite laggy, don't be surpised if it freezes your client for a good while
	// #define REFERENCE_TRACKING
	#ifdef REFERENCE_TRACKING

		//Run a lookup on things hard deleting by default.
		#define GC_FAILURE_HARD_LOOKUP

		#ifdef GC_FAILURE_HARD_LOOKUP
			///Don't stop when searching, go till you're totally done
			#define FIND_REF_NO_CHECK_TICK
		#endif //GC_FAILURE_HARD_LOOKUP

	#endif //REFERENCE_TRACKING

#endif //TESTING



//Additional code for the above flags.
//A warning on compile is treated as an error in the CI, therefore unlike TG we must avoid the warn if it's running in the CI
#if defined(TESTING) && !defined(CIBUILDING) && !defined(OPENDREAM) && !defined(SPACEMAN_DMM)
	#warn compiling in TESTING mode. testing() debug messages will be visible.
#endif //TESTING

//CIBUILDING requires UNIT_TEST to be defined, if it isn't, define it here
#if defined(CIBUILDING) && !defined(UNIT_TEST)
	#define UNIT_TEST
#endif //CIBUILDING


//Enable various trackings and debugs if we're running the unit tests
#if defined(UNIT_TEST) && !defined(OPENDREAM) && !defined(SPACEMAN_DMM)

	//Hard del testing defines, if you leave a reference, it will search for it
	#define REFERENCE_TRACKING
	#define REFERENCE_TRACKING_DEBUG
	#define FIND_REF_NO_CHECK_TICK
	#define GC_FAILURE_HARD_LOOKUP

	//Ensures all early assets can actually load early
	#define DO_NOT_DEFER_ASSETS

	//Test at full capacity, the extra cost doesn't matter
	#define TIMER_DEBUG

	//If you really are lost with atmos issues
	// #define ZASDBG

	#define SQL_PREF_DEBUG
#endif //UNIT_TEST

#ifdef TGS
	// TGS performs its own build of dm.exe, but includes a prepended TGS define.
	#define CBT
#endif //TGS


//Poor man's code to try to catch people that are running the codebase without compiling tgui, aka in an unsupported way
//Basically, this tells you to use a supported compilation as defined in the repo's README
#if !defined(CBT) && !defined(SPACEMAN_DMM) && !defined(OPENDREAM) && !defined(CIBUILDING)
	#warn Building with Dream Maker is no longer supported and will result in errors.
	#warn In order to build, run BUILD.bat in the root directory.
	#warn Consider switching to VSCode editor instead, where you can press Ctrl+Shift+B to build.
	#error Not compiling in a supported environment! Use Visual Studio Code or BUILD.bat!
#endif
