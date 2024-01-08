SUBSYSTEM_DEF(mob_ai)
	name = "Mobs - AI"
	flags = SS_NO_INIT
	priority = SS_PRIORITY_MOB
	runlevels = RUNLEVELS_PLAYING

	var/list/processing = list()
	var/list/currentrun = list()
	var/list/slept = list()

/datum/controller/subsystem/mob_ai/stat_entry(msg)
	msg = "P:[processing.len]"
	return ..()

/datum/controller/subsystem/mob_ai/fire(resumed = FALSE)
	if (!resumed)
		src.currentrun = processing.Copy()

	var/list/currentrun = src.currentrun
	while (currentrun.len)
		var/mob/M = currentrun[currentrun.len]
		currentrun.len--

		if (QDELETED(M))
			processing -= M

			if (MC_TICK_CHECK)
				return
			continue

		if (M.ckey)
			// cliented mobs are not allowed to think
			LOG_DEBUG("SSmob_ai: Type '[M.type]' was still thinking despite having a client!")
			MOB_STOP_THINKING(M)

			if (MC_TICK_CHECK)
				return
			continue

		var/time = world.time

		if (!M.frozen && !M.stat)
			M.think()

		if (time != world.time && !slept[M.type])
			slept[M.type] = TRUE
			var/diff = world.time - time
			LOG_DEBUG("SSmob_ai: Type '[M.type]' slept for [diff] ds in think()! Suppressing further warnings.")

		if (MC_TICK_CHECK)
			return

/mob
	var/tmp/thinking_enabled = FALSE

/mob/proc/think()
	return

/mob/proc/on_think_disabled()
	walk_to(src, 0)

/mob/proc/on_think_enabled()
	return

/datum/controller/subsystem/mob_ai/ExplosionStart()
	can_fire = FALSE

/datum/controller/subsystem/mob_ai/ExplosionEnd()
	can_fire = TRUE
