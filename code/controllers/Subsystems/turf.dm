var/datum/subsystem/turf/SSturf

var/global/list/turf/processing_turfs = list()

/datum/subsystem/turf
	name = "Turf"
	wait = 2 SECONDS
	flags = SS_NO_INIT

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

/datum/subsystem/turf/stat_entry()
	..("P:[processing_turfs.len]")
