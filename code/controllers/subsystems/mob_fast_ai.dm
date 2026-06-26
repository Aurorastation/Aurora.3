/**
 * This is the fast AI subsystem, used for mobs that are doing something visible and thus have priority over other mobs processing
 *
 * You should promote mobs to fast thinking if eg. they are fighting players or similar, and de-promote them once they resume their normal routine
 */
MOB_AI_SUBSYSTEM_DEF(mob_fast_ai)
	name = "Mobs - Fast AI"
#ifdef UNIT_TEST
	flags = SS_NO_FIRE | SS_BACKGROUND | SS_NO_INIT
#else
	flags = SS_KEEP_TIMING | SS_BACKGROUND | SS_NO_INIT
#endif
	priority = FIRE_PRIORITY_NPC_ACTIONS
	wait = 5
