var/datum/subsystem/processing/turf/SSturf
/datum/subsystem/processing/turf
	name = "Turf"
	flags = SS_NO_INIT

/datum/subsystem/processing/turf/New()
	NEW_SS_GLOBAL(SSturf)

/datum/subsystem/processing/turf/stop_processing(datum/D)
	STOP_PROCESSING(SSturf, D)
