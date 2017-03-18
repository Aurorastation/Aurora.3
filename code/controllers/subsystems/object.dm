// Global variables to speed up object initialization.
// Boolean to indicate whether objects should initialize themselves in their New() or wait for the game ticker to do it.
// Check world.dm for the object list.
var/global/objects_initialized = FALSE

/datum/controller/subsystem/object
	name = "Objects"
	priority = SS_PRIORITY_OBJECTS
	init_order = SS_INIT_OBJECTS

	var/tmp/list/queue = list()

/datum/controller/subsystem/object/New()
	LAZYINITLIST(processing_objects)

/datum/controller/subsystem/object/fire(resumed = FALSE)
	if (!resumed)
		queue = processing_objects.Copy()

	while (queue.len)
		var/datum/O = queue[queue.len]
		queue.len--

		if (QDELETED(O))
			log_debug("SSobjects: QDELETED object [DEBUG_REF(O)] found in processing queue!")
			processing_objects -= O
			continue

		O.process()
		
		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/object/stat_entry()
	..("[processing_objects.len] objects")

/datum/controller/subsystem/object/Initialize(timeofday)
	while (objects_init_list.len)
		var/atom/movable/object = objects_init_list[objects_init_list.len]
		objects_init_list.len--
		
		if (QDELETED(object))
			continue

		object.initialize(TRUE)

		CHECK_TICK

	global.objects_initialized = TRUE
	..()
