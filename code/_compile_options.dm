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

#ifndef PRELOAD_RSC             //set to:
#define PRELOAD_RSC 2           //  0 to allow using external resources or on-demand behaviour;
#endif                          //  1 to use the default behaviour;
								//  2 for preloading absolutely everything;

//#define TESTING // Creates debug feedback messages and enables many optional testing procs/checks
#ifdef TESTING
///Used to find the sources of harddels, quite laggy, don't be surpised if it freezes your client for a good while
//#define REFERENCE_TRACKING
#ifdef REFERENCE_TRACKING

//Run a lookup on things hard deleting by default.
#define GC_FAILURE_HARD_LOOKUP

#ifdef GC_FAILURE_HARD_LOOKUP
///Don't stop when searching, go till you're totally done
#define FIND_REF_NO_CHECK_TICK
#endif //ifdef GC_FAILURE_HARD_LOOKUP

#endif //ifdef REFERENCE_TRACKING

#endif //ifdef TESTING
