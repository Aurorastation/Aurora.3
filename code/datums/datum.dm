/datum
	var/tmp/list/active_timers
	var/tmp/datum/weakref/weakref
	var/tmp/isprocessing = 0

	/**
	 * Tick count time when this object was destroyed.
	 *
	 * If this is non zero then the object has been garbage collected and is awaiting either
	 * a hard del by the GC subsystme, or to be autocollected (if it has no references)
	 */
	var/tmp/gcDestroyed

	/// Status traits attached to this datum. associative list of the form: list(trait name (string) = list(source1, source2, source3,...))
	var/list/status_traits
	/// Components attached to this datum
	/// Lazy associated list in the structure of `type:component/list of components`
	var/list/datum_components
	/// Any datum registered to receive signals from this datum is in this list
	/// Lazy associated list in the structure of `signal:registree/list of registrees`
	var/list/comp_lookup
	/// Lazy associated list in the structure of `signals:proctype` that are run when the datum receives that signal
	var/list/list/datum/callback/signal_procs
	/// Is this datum capable of sending signals?
	/// Set to true when a signal has been registered
	var/signal_enabled = FALSE
	/// A cached version of our \ref
	/// The brunt of \ref costs are in creating entries in the string tree (a tree of immutable strings)
	/// This avoids doing that more then once per datum by ensuring ref strings always have a reference to them after they're first pulled
	var/cached_ref

#ifdef REFERENCE_TRACKING
	var/running_find_references
	var/last_find_references = 0
	#ifdef REFERENCE_TRACKING_DEBUG
	///Stores info about where refs are found, used for sanity checks and testing
	var/list/found_refs
	#endif
#endif

// Default implementation of clean-up code.
// This should be overridden to remove all references pointing to the object being destroyed.
// Return the appropriate QDEL_HINT; in most cases this is QDEL_HINT_QUEUE.
/datum/proc/Destroy(force=FALSE)
	SHOULD_CALL_PARENT(TRUE)

	weakref = null
	GLOB.destroyed_event.raise_event(src)
	var/ui_key = SOFTREF(src)
	if(LAZYISIN(SSnanoui.open_uis, ui_key))
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

	// Handle components & signals
	signal_enabled = FALSE

	#ifdef REFERENCE_TRACKING
	#ifdef REFERENCE_TRACKING_DEBUG
	found_refs = null
	#endif
	#endif

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

	return QDEL_HINT_QUEUE

/**
 * This proc is called on a datum on every "cycle" if it is being processed by a subsystem. The time between each cycle is determined by the subsystem's "wait" setting.
 * You can start and stop processing a datum using the START_PROCESSING and STOP_PROCESSING defines.
 *
 * Since the wait setting of a subsystem can be changed at any time, it is important that any rate-of-change that you implement in this proc is multiplied by the seconds_per_tick that is sent as a parameter,
 * Additionally, any "prob" you use in this proc should instead use the SPT_PROB define to make sure that the final probability per second stays the same even if the subsystem's wait is altered.
 * Examples where this must be considered:
 * - Implementing a cooldown timer, use `mytimer -= seconds_per_tick`, not `mytimer -= 1`. This way, `mytimer` will always have the unit of seconds
 * - Damaging a mob, do `L.adjustFireLoss(20 * seconds_per_tick)`, not `L.adjustFireLoss(20)`. This way, the damage per second stays constant even if the wait of the subsystem is changed
 * - Probability of something happening, do `if(SPT_PROB(25, seconds_per_tick))`, not `if(prob(25))`. This way, if the subsystem wait is e.g. lowered, there won't be a higher chance of this event happening per second
 *
 * If you override this do not call parent, as it will return PROCESS_KILL. This is done to prevent objects that dont override process() from staying in the processing list
 */
/datum/proc/process(seconds_per_tick)
	set waitfor = FALSE
	return PROCESS_KILL

/datum/proc/can_vv_get(var_name)
	return TRUE

/datum/proc/vv_edit_var(var_name, var_value) //called whenever a var is edited
	if(var_name == NAMEOF(src, vars))
		return FALSE
	if(!can_vv_get(var_name))
		return FALSE
	vars[var_name] = var_value
	return TRUE
