//Used to process objects. Fires once every two seconds.
SUBSYSTEM_DEF(processing)
	name = "Processing"
	priority = SS_PRIORITY_PROCESSING
	flags = SS_BACKGROUND|SS_POST_FIRE_TIMING|SS_NO_INIT

	var/stat_tag = "P" //Used for logging
	var/list/processing = list()
	var/list/currentrun = list()

/datum/controller/subsystem/processing/stat_entry(msg)
	msg = "[stat_tag]:[processing.len]"
	return ..()

/datum/controller/subsystem/processing/fire(resumed = 0)
	if (!resumed)
		currentrun = processing.Copy()
	//cache for sanic speed (lists are references anyways)
	var/list/current_run = currentrun

	while(current_run.len)
		var/datum/thing = current_run[current_run.len]
		current_run.len--
		if(!QDELETED(thing))
			if (thing.process(wait, times_fired) == PROCESS_KILL)
				stop_processing(thing)
		else
			processing -= thing
		if (MC_TICK_CHECK)
			return

// Helper so PROCESS_KILL works.
/datum/controller/subsystem/processing/proc/stop_processing(datum/D)
	STOP_PROCESSING(src, D)

/datum/controller/subsystem/processing/ExplosionStart()
	can_fire = FALSE

/datum/controller/subsystem/processing/ExplosionEnd()
	can_fire = TRUE
