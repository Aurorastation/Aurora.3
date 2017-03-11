//Used to process objects. Fires once every two seconds.

var/datum/subsystem/processing/SSprocessing
/datum/subsystem/processing
	name = "Processing"
	priority = 25
	flags = SS_BACKGROUND|SS_POST_FIRE_TIMING|SS_NO_INIT

	var/stat_tag = "P" //Used for logging
	var/list/processing = list()
	var/list/currentrun = list()

/datum/subsystem/processing/New()
	NEW_SS_GLOBAL(SSprocessing)

/datum/subsystem/processing/stat_entry()
	..("[stat_tag]:[processing.len]")

/datum/subsystem/processing/fire(resumed = 0)
	if (!resumed)
		currentrun = processing.Copy()
	//cache for sanic speed (lists are references anyways)
	var/list/current_run = currentrun

	while(current_run.len)
		var/datum/thing = current_run[current_run.len]
		current_run.len--
		if(thing)
			if (thing.process() == PROCESS_KILL)
				stop_processing(thing)
		else
			processing -= thing
		if (MC_TICK_CHECK)
			return

// Helper so PROCESS_KILL works.
/datum/subsystem/processing/proc/stop_processing(datum/D)
	STOP_PROCESSING(SSprocessing, D)

/datum/var/isprocessing = 0
/datum/proc/process()
	return PROCESS_KILL
