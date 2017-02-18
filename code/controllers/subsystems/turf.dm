var/datum/subsystem/turf/SSturf

/datum/subsystem/turf
	name = "Turf"
	wait = 2 SECONDS
	flags = SS_NO_INIT

	var/list/turf/processing_turfs = list()
	var/tmp/list/queued_turfs = list()

/datum/subsystem/turf/New()
	NEW_SS_GLOBAL(SSturf)

/datum/subsystem/turf/fire(resumed = FALSE)
	if (!resumed)
		queued_turfs = processing_turfs.Copy()

	while (queued_turfs.len)
		var/turf/T = queued_turfs[queued_turfs.len]
		queued_turfs.len--

		if (T.process() == PROCESS_KILL)
			processing_turfs -= T

		if (MC_TICK_CHECK)
			return

	if (!processing_turfs.len)
		disable()

/datum/subsystem/turf/stat_entry()
	..("P:[processing_turfs.len]")

/datum/subsystem/turf/add_turf(turf/T)
	if (QDELETED(T))
		return
	processing_turfs |= T
	enable()

/datum/subsystem/turf/remove_turf(turf/T)
	processing_turfs -= T

/datum/subsystem/turf/Recover()
	if (istype(SSturf))
		src.processing_turfs = SSturf.processing_turfs
