SUBSYSTEM_DEF(mob_ai)
	name = "Mobs - AI"
	flags = SS_NO_INIT
	priority = SS_PRIORITY_MOB
	runlevels = RUNLEVELS_PLAYING

	var/list/processing = list()
	var/list/currentrun = list()

	///A list of mutex locks, to avoid reentry and starting new processings on mobs that were already processing from the previous run
	var/list/datum/weakref/mutexes = list() //Yes i know they're opinionably not mutexes as there's only one process shut up

/datum/controller/subsystem/mob_ai/stat_entry(msg)
	msg = "P:[processing.len]"
	return ..()

/datum/controller/subsystem/mob_ai/fire(resumed = FALSE)
	if (!resumed)
		src.currentrun = processing.Copy()

	var/list/currentrun = src.currentrun

	//Remove the mobs that have a mutex from being reprocessed again, this run
	for(var/datum/weakref/locked_mob in mutexes)
		var/mob/possible_locked_mob = locked_mob.resolve()

		//The mob got QDEL'd, or otherwise somehow disappeared
		if(!possible_locked_mob)
			mutexes -= locked_mob
			continue

		currentrun -= possible_locked_mob

	while (currentrun.len)
		var/mob/M = currentrun[currentrun.len]
		currentrun.len--

		if (QDELETED(M))
			processing -= M
			continue

		if (M.ckey)
			// cliented mobs are not allowed to think
			LOG_DEBUG("SSmob_ai: Type '[M.type]' was still thinking despite having a client!")
			MOB_STOP_THINKING(M)
			continue

		if (!M.frozen && !M.stat)
			INVOKE_ASYNC(src, PROC_REF(async_think), M)

		if (MC_TICK_CHECK)
			return

/**
 * Invoke .think() on a mob in an asyncronous manner, ensuring to properly set the mutex for it, so it's not reprocessed until it's finished
 *
 * It's up to the caller to check that the mob does not have a mutex set, before calling this proc
 */
/datum/controller/subsystem/mob_ai/proc/async_think(mob/mob_to_process)
	var/datum/weakref/mob_weakref = WEAKREF(mob_to_process)

	mutexes += mob_weakref

	mob_to_process.think()

	mutexes -= mob_weakref

/mob
	var/thinking_enabled = FALSE

/**
 * Perform AI logic for a mob, called by the AI subsystem
 *
 * For the love of god, *DO NOT* set a waitfor false or similar things here, this proc is under a mutex and if it returns before having done its work,
 * it will mess things up!
 */
/mob/proc/think()
	return

/mob/proc/on_think_disabled()
	walk_to(src, 0)
	SSmove_manager.stop_looping(src)

/mob/proc/on_think_enabled()
	return

/datum/controller/subsystem/mob_ai/ExplosionStart()
	can_fire = FALSE

/datum/controller/subsystem/mob_ai/ExplosionEnd()
	can_fire = TRUE
