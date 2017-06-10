/datum/controller/subsystem/object
	name = "Objects"
	priority = SS_PRIORITY_OBJECTS
	flags = SS_POST_FIRE_TIMING | SS_BACKGROUND | SS_NO_INIT

	var/list/processing

	var/tmp/list/queue = list()

/datum/controller/subsystem/object/New()
	LAZYINITLIST(processing_objects)
	processing = processing_objects		// Ref for debugging.

/datum/controller/subsystem/object/fire(resumed = FALSE)
	if (!resumed)
		queue = processing_objects.Copy()

	while (queue.len)
		var/datum/O = queue[queue.len]
		queue.len--

		if (QDELETED(O))
			log_debug("SSobjects: QDELETED object [DEBUG_REF(O)] found in processing queue!")
			processing_objects -= O
			if (MC_TICK_CHECK)
				return
			continue

		O.process()
		
		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/object/stat_entry()
	..("[processing_objects.len] objects")
