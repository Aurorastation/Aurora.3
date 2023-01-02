// GLOBAL_LIST_EMPTY(all_observable_events)
/singleton/observ
	var/name = "Unnamed Event"          // The name of this event, used mainly for debug/VV purposes. The list of event managers can be reached through the "Debug Controller" verb, selecting the "Observation" entry.
	var/expected_type = /datum          // The expected event source for this event. register() will CRASH() if it receives an unexpected type.
	var/list/event_sources = list()     // Associative list of event sources, each with their own associative list. This associative list contains an instance/list of procs to call when the event is raised.
	var/list/global_listeners = list()  // Associative list of instances that listen to all events of this type (as opposed to events belonging to a specific source) and the proc to call.

/singleton/observ/New()
	all_observable_events += src
	..()

/singleton/observ/proc/is_listening(event_source, datum/listener, proc_call)
	// Return whether there are global listeners unless the event source is given.
	if (!event_source)
		return !!global_listeners.len

	// Return whether anything is listening to a source, if no listener is given.
	if (!listener)
		return global_listeners.len || event_sources[event_source]

	// Return false if nothing is associated with that source.
	if (!event_sources[event_source])
		return FALSE

	// Get and check the listeners for the reuqested event.
	var/listeners = event_sources[event_source]
	if (!listeners[listener])
		return FALSE

	// Return true unless a specific callback needs checked.
	if (!proc_call)
		return TRUE

	// Check if the specific callback exists.
	var/list/callback = listeners[listener]
	if (!callback)
		return FALSE

	return (proc_call in callback)

/singleton/observ/proc/has_listeners(event_source)
	return is_listening(event_source)

/singleton/observ/proc/register(datum/event_source, datum/listener, proc_call)
	// Sanity checking.
	if (!(event_source && listener && proc_call))
		return FALSE
	if (istype(event_source, /singleton/observ))
		return FALSE

	// Crash if the event source is the wrong type.
	if (!istype(event_source, expected_type))
		CRASH("Unexpected type. Expected [expected_type], was [event_source.type]")

	// Setup the listeners for this source if needed.
	var/list/listeners = event_sources[event_source]
	if (!listeners)
		listeners = list()
		event_sources[event_source] = listeners

	// Make sure the callbacks are a list.
	var/list/callbacks = listeners[listener]
	if (!callbacks)
		callbacks = list()
		listeners[listener] = callbacks

	// If the proc_call is already registered skip
	if(proc_call in callbacks)
		return FALSE

	// Add the callback, and return true.
	callbacks += proc_call
	return TRUE

/singleton/observ/proc/unregister(event_source, datum/listener, proc_call)
	// Sanity.
	if (!event_source || !listener || !event_sources[event_source])
		return FALSE

	// Return false if nothing is listening for this event.
	var/list/listeners = event_sources[event_source]
	if (!listeners)
		return FALSE

	// Remove all callbacks if no specific one is given.
	if (!proc_call)
		if(listeners.Remove(listener))
			// Perform some cleanup and return true.
			if (!listeners.len)
				event_sources -= event_source
			return TRUE
		return FALSE

	// See if the listener is registered.
	var/list/callbacks = listeners[listener]
	if (!callbacks)
		return FALSE

	// See if the callback exists.
	if(!callbacks.Remove(proc_call))
		return FALSE

	if (!callbacks.len)
		listeners -= listener
	if (!listeners.len)
		event_sources -= event_source
	return TRUE

/singleton/observ/proc/register_global(datum/listener, proc_call)
	// Sanity.
	if (!(listener && proc_call))
		return FALSE

	// Make sure the callbacks are setup.
	var/list/callbacks = global_listeners[listener]
	if (!callbacks)
		callbacks = list()
		global_listeners[listener] = callbacks

	// Add the callback and return true.
	callbacks |= proc_call
	return TRUE

/singleton/observ/proc/unregister_global(datum/listener, proc_call)
	// Return false unless the listener is set as a global listener.
	if (!(listener && global_listeners[listener]))
		return FALSE

	// Remove all callbacks if no specific one is given.
	if (!proc_call)
		global_listeners -= listener
		return TRUE

	// See if the listener is registered.
	var/list/callbacks = global_listeners[listener]
	if (!callbacks)
		return FALSE

	// See if the callback exists.
	if(!callbacks.Remove(proc_call))
		return FALSE

	if (!callbacks.len)
		global_listeners -= listener
	return TRUE

/singleton/observ/proc/raise_event()
	// Sanity
	if (!args.len)
		return FALSE

	if (global_listeners.len)
		// Call the global listeners.
		for (var/listener in global_listeners)
			var/list/callbacks = global_listeners[listener]
			for (var/proc_call in callbacks)

				// If the callback crashes, record the error and remove it.
				try
					call(listener, proc_call)(arglist(args))
				catch (var/exception/e)
					error("[e.name] - [e.file] - [e.line]")
					error(e.desc)
					unregister_global(listener, proc_call)

	// Call the listeners for this specific event source, if they exist.
	var/source = args[1]
	if (source && event_sources[source])
		var/list/listeners = event_sources[source]
		for (var/listener in listeners)
			var/list/callbacks = listeners[listener]
			for (var/proc_call in callbacks)

				// If the callback crashes, record the error and remove it.
				try
					call(listener, proc_call)(arglist(args))
				catch (var/exception/e)
					error("[e.name] - [e.file] - [e.line]")
					error(e.desc)
					unregister(source, listener, proc_call)

	return TRUE
