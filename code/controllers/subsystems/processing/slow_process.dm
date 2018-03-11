/var/datum/controller/subsystem/processing/slow/SSslow_process

// Not really much to it, literally just a slower-ticking SSprocessing.

/datum/controller/subsystem/processing/slow
    name = "Processing (Slow)"
    wait = 60

/datum/controller/subsystem/processing/slow/New()
    NEW_SS_GLOBAL(SSslow_process)