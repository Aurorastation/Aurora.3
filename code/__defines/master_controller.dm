#define MAPTICK_MC_MIN_RESERVE 70 // Percentage of tick to save for the MC to run
#define MAPTICK_LAST_TICK_USAGE world.map_cpu
#define TICK_LIMIT_RUNNING max(98 - MAPTICK_LAST_TICK_USAGE, MAPTICK_MC_MIN_RESERVE)
#define TICK_LIMIT_TO_RUN 70
#define TICK_LIMIT_MC 70
#define TICK_LIMIT_MC_INIT config.mc_init_tick_limit
#define TICK_LIMIT_MC_INIT_DEFAULT 98

#define MC_TICK_CHECK ( world.tick_usage > CURRENT_TICKLIMIT ? pause() : 0 )

#define GAME_STATE 2 ** (Master.current_runlevel - 1)
#define SS_IS_RUNNING(subsystem) (subsystem.can_fire && !subsystem.suspended && (GAME_STATE & subsystem.runlevels))

// For multi-step subsystems that want to split their tick into multiple parts.
#define MC_SPLIT_TICK_INIT(phase_count) var/original_tick_limit = CURRENT_TICKLIMIT; var/split_tick_phases = ##phase_count
#define MC_SPLIT_TICK \
	if(split_tick_phases > 1){\
		CURRENT_TICKLIMIT = ((original_tick_limit - world.tick_usage) / split_tick_phases) + world.tick_usage;\
		--split_tick_phases;\
	} else {\
		CURRENT_TICKLIMIT = original_tick_limit;\
	}

// Used to smooth out costs to try and avoid oscillation.
#define MC_AVERAGE_FAST(average, current) (0.7 * (average) + 0.3 * (current))
#define MC_AVERAGE(average, current) (0.8 * (average) + 0.2 * (current))
#define MC_AVERAGE_SLOW(average, current) (0.9 * (average) + 0.1 * (current))

#define MC_AVG_FAST_UP_SLOW_DOWN(average, current) (average > current ? MC_AVERAGE_SLOW(average, current) : MC_AVERAGE_FAST(average, current))
#define MC_AVG_SLOW_UP_FAST_DOWN(average, current) (average < current ? MC_AVERAGE_SLOW(average, current) : MC_AVERAGE_FAST(average, current))

#define NEW_SS_GLOBAL(varname) if(varname != src){if(istype(varname)){Recover();qdel(varname);}varname = src;}

#define MC_LOOP_RTN_NEWSTAGES 1
#define MC_LOOP_RTN_GRACEFUL_EXIT 2

//SubSystem flags (Please design any new flags so that the default is off, to make adding flags to subsystems easier)

//subsystem does not initialize.
#define SS_NO_INIT 1

//subsystem does not fire.
//	(like can_fire = 0, but keeps it from getting added to the processing subsystems list)
//	(Requires a MC restart to change)
#define SS_NO_FIRE 2

/** Subsystem only runs on spare cpu (after all non-background subsystems have ran that tick) */
/// SS_BACKGROUND has its own priority bracket, this overrides SS_TICKER's priority bump
#define SS_BACKGROUND 4

/// If this subsystem doesn't initialize, it should not report as a hard error in CI.
/// This should be used for subsystems that are flaky for complicated reasons, such as
/// the Lua subsystem, which relies on auxtools, which is unstable.
/// It should not be used simply to silence CI.
#define SS_OK_TO_FAIL_INIT (1 << 6)

//subsystem does not tick check, and should not run unless there is enough time (or its running behind (unless background))
#define SS_NO_TICK_CHECK 8

//Treat wait as a tick count, not DS, run every wait ticks.
//	(also forces it to run first in the tick (unless SS_BACKGROUND))
//	(implies all run levels because of how it works)
//	This is designed for basically anything that works as a mini-mc (like SStimer)
#define SS_TICKER 16

//keep the subsystem's timing on point by firing early if it fired late last fire because of lag
//	ie: if a 20ds subsystem fires say 5 ds late due to lag or what not, its next fire would be in 15ds, not 20ds.
#define SS_KEEP_TIMING 32

//Calculate its next fire after its fired.
//	(IE: if a 5ds wait SS takes 2ds to run, its next fire should be 5ds away, not 3ds like it normally would be)
//	This flag overrides SS_KEEP_TIMING
#define SS_POST_FIRE_TIMING 64

// Don't display in processes panel.
#define SS_NO_DISPLAY 128

//SUBSYSTEM STATES
#define SS_IDLE 0		//aint doing shit.
#define SS_QUEUED 1		//queued to run
#define SS_RUNNING 2	//actively running
#define SS_PAUSED 3		//paused by mc_tick_check
#define SS_SLEEPING 4	//fire() slept.
#define SS_PAUSING 5 	//in the middle of pausing

// Subsystem init stages
#define INITSTAGE_EARLY 1 //! Early init stuff that doesn't need to wait for mapload
#define INITSTAGE_MAIN 2 //! Main init stage
#define INITSTAGE_MAX 2 //! Highest initstage.

// Subsystem init-states, used for the initialization MC panel.
#define SS_INITSTATE_NONE 0
#define SS_INITSTATE_STARTED 1
#define SS_INITSTATE_DONE 2

#define SS_PRIORITY_DEFAULT 25

#define SUBSYSTEM_DEF(X) GLOBAL_REAL(SS##X, /datum/controller/subsystem/##X);\
/datum/controller/subsystem/##X/New(){\
	NEW_SS_GLOBAL(SS##X);\
	PreInit();\
}\
/datum/controller/subsystem/##X

#define PROCESSING_SUBSYSTEM_DEF(X) GLOBAL_REAL(SS##X, /datum/controller/subsystem/processing/##X);\
/datum/controller/subsystem/processing/##X/New(){\
	NEW_SS_GLOBAL(SS##X);\
	PreInit();\
}\
/datum/controller/subsystem/processing/##X/fire() {..() /*just so it shows up on the profiler*/} \
/datum/controller/subsystem/processing/##X

#define MOB_AI_SUBSYSTEM_DEF(X) GLOBAL_REAL(SS##X, /datum/controller/subsystem/mob_ai/##X);\
/datum/controller/subsystem/mob_ai/##X/New(){\
	NEW_SS_GLOBAL(SS##X);\
	PreInit();\
}\
/datum/controller/subsystem/mob_ai/##X/fire() {..() /*just so it shows up on the profiler*/} \
/datum/controller/subsystem/mob_ai/##X
