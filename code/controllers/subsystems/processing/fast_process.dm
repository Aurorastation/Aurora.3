/var/datum/controller/subsystem/processing/fast/SSfast_process

// Not really much to it, literally just a faster-ticking SSprocessing.

/datum/controller/subsystem/processing/fast
	name = "Processing (Fast)"
	wait = 5

/datum/controller/subsystem/processing/fast/New()
	NEW_SS_GLOBAL(SSfast_process)
