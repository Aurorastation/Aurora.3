
// for /datum/var/datum_flags
#define DF_USE_TAG 1
#define DF_VAR_EDITED 2


/datum
	/**
	  * Tick count time when this object was destroyed.
	  *
	  * If this is non zero then the object has been garbage collected and is awaiting either
	  * a hard del by the GC subsystme, or to be autocollected (if it has no references)
	  */
	var/gc_destroyed

	/// Active timers with this datum as the target
	var/list/active_timers
	/// Status traits attached to this datum
	var/list/status_traits
	
	/// Components attached to this datum
	/// Lazy associated list in the structure of `type:component/list of components`
	var/list/datum_components
	/// Any datum registered to receive signals from this datum is in this list
	/// Lazy associated list in the structure of `signal:registree/list of registrees`
	var/list/comp_lookup
	/// Lazy associated list in the structure of `signals:proctype` that are run when the datum receives that signal
	var/list/list/datum/callback/signal_procs

	var/signal_enabled = FALSE
	
	/// Datum level flags
	var/datum_flags = NONE

	/// A weak reference to another datum
	var/datum/weakref/weakref
	var/tmp/gcDestroyed //Time when this object was destroyed.
	var/tmp/isprocessing = 0

#ifdef TESTING
	var/running_find_references
	var/last_find_references = 0
#endif

#ifdef DATUMVAR_DEBUGGING_MODE
	var/list/cached_vars
#endif

/**
  * Called when a href for this datum is clicked
  *
  * Sends a COMSIG_TOPIC signal
  */
/datum/Topic(href, href_list[])
	..()
	SEND_SIGNAL(src, COMSIG_TOPIC, usr, href_list)

/**
  * Default implementation of clean-up code.
  * 
  * This should be overridden to remove all references pointing to the object being destroyed, if
  * you do override it, make sure to call the parent and return it's return value by default
  * 
  * Return an appropriate QDEL_HINT to modify handling of your deletion;
  * in most cases this is QDEL_HINT_QUEUE.
  *
  * The base case is responsible for doing the following
  * * Erasing timers pointing to this datum
  * * Erasing compenents on this datum
  * * Notifying datums listening to signals from this datum that we are going away
  *
  * Returns QDEL_HINT_QUEUE
  */ 
/datum/proc/Destroy(force=FALSE, ...)
	tag = null
	datum_flags &= ~DF_USE_TAG //In case something tries to REF us
	weakref = null	//ensure prompt GCing of weakref.

	var/list/timers = active_timers
	active_timers = null
	for(var/thing in timers)
		var/datum/timedevent/timer = thing
		if (timer.spent)
			continue
		qdel(timer)

	//BEGIN: ECS SHIT
	signal_enabled = FALSE

	var/list/dc = datum_components
	if(dc)
		var/all_components = dc[/datum/component]
		if(length(all_components))
			for(var/I in all_components)
				var/datum/component/C = I
				qdel(C, FALSE, TRUE)
		else
			var/datum/component/C = all_components
			qdel(C, FALSE, TRUE)
		dc.Cut()

	var/list/lookup = comp_lookup
	if(lookup)
		for(var/sig in lookup)
			var/list/comps = lookup[sig]
			if(length(comps))
				for(var/i in comps)
					var/datum/component/comp = i
					comp.UnregisterSignal(src, sig)
			else
				var/datum/component/comp = comps
				comp.UnregisterSignal(src, sig)
		comp_lookup = lookup = null

	for(var/target in signal_procs)
		UnregisterSignal(target, signal_procs[target])
	//END: ECS SHIT

	return QDEL_HINT_QUEUE

/datum/proc/process()
	return PROCESS_KILL