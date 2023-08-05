/*
This file is used to include linter settings, as they might be incompatible with each other.
Nothing should ever be included before this file.
*/

//SpacemanDMM suite, always included as its definitions are used downstream directly, and just nulled if SPACEMAN_DMM is not defined
#include "___linters\spaceman_dmm.dm"

//Defines to extend SpacemanDMM code coverage
#if defined(SPACEMAN_DMM)

#define UNIT_TEST
#define MANUAL_UNIT_TEST

#endif


#if defined(OPENDREAM)

//OpenDream, only included if OPENDREAM is defined, as otherwise SpacemanDMM isn't happy about the pragma directives
#include "___linters\odlint.dm"

//Defines to extend OpenDream code coverage
#define TIMER_DEBUG
#define TESTING
#define UNIT_TEST
#define ZASDBG
#define FIREDBG
#define GC_FAILURE_HARD_LOOKUP
#define DO_NOT_DEFER_ASSETS
#define SQL_PREF_DEBUG
#define REFERENCE_TRACKING_DEBUG
#define MANUAL_UNIT_TEST

#endif
