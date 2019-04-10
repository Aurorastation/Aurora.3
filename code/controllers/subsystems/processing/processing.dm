//Used to process objects. Fires once every two seconds.

var/datum/controller/subsystem/processing/SSprocessing
/datum/controller/subsystem/processing
	name = "Processing"
	priority = SS_PRIORITY_PROCESSING
	flags = SS_BACKGROUND|SS_POST_FIRE_TIMING|SS_NO_INIT

	var/stat_tag = "P" //Used for logging
	var/list/processing = list()
	var/list/currentrun = list()

/datum/controller/subsystem/processing/New()
	NEW_SS_GLOBAL(SSprocessing)

/datum/controller/subsystem/processing/stat_entry()
	..("[stat_tag]:[processing.len]")

/datum/controller/subsystem/processing/fire(resumed = 0)
	if (!resumed)
		currentrun = processing.Copy()
	//cache for sanic speed (lists are references anyways)
	var/list/current_run = currentrun

	while(current_run.len)
		var/datum/thing = current_run[current_run.len]
		current_run.len--
		if(!QDELETED(thing))
			if (thing.process() == PROCESS_KILL)
				stop_processing(thing)
		else
			processing -= thing
		if (MC_TICK_CHECK)
			return

// Helper so PROCESS_KILL works.
/datum/controller/subsystem/processing/proc/stop_processing(datum/D)
	STOP_PROCESSING(src, D)
