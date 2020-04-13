/datum
	var/tmp/list/active_timers
	var/tmp/datum/weakref/weakref
	var/tmp/isprocessing = 0
	var/tmp/gcDestroyed //Time when this object was destroyed.

// Default implementation of clean-up code.
// This should be overridden to remove all references pointing to the object being destroyed.
// Return the appropriate QDEL_HINT; in most cases this is QDEL_HINT_QUEUE.
/datum/proc/Destroy(force=FALSE)
	SHOULD_CALL_PARENT(1)

	weakref = null
	destroyed_event.raise_event(src)
	SSnanoui.close_uis(src)
	tag = null
	var/list/timers = active_timers
	active_timers = null
	if (timers)
		for (var/thing in timers)
			var/datum/timedevent/timer = thing
			if (timer.spent)
				continue
			qdel(timer)

	return QDEL_HINT_QUEUE

/datum/proc/process()
	return PROCESS_KILL
