/datum/subsystem/object
	name = "Objects"
	wait = 2 SECONDS
	priority = SS_PRIORITY_OBJECTS
	init_order = SS_INIT_OBJECTS

	var/tmp/list/queue = list()

/datum/subsystem/object/New()
	if (!processing_objects)
		processing_objects = list()

/datum/subsystem/object/fire(resumed = FALSE)
	if (!resumed)
		queue = processing_objects.Copy()

	while (queue.len)
		var/datum/O = queue[queue.len]
		queue.len--

		if (QDELETED(O))
			processing_objects -= O
			continue

		O:process()
		
		if (MC_TICK_CHECK)
			return

/datum/subsystem/object/stat_entry()
	..("[processing_objects.len] objects")

/datum/subsystem/object/Initialize(timeofday)
	while (objects_init_list.len)
		var/atom/movable/object = objects_init_list[objects_init_list.len]
		objects_init_list.len--
		if (QDELETED(object))
			continue

		object.initialize()

	objects_initialized = TRUE
	..()
