/**
 * Register to listen for a signal from the passed in target
 *
 * This sets up a listening relationship such that when the target object emits a signal
 * the source datum this proc is called upon, will receive a callback to the given proctype
 * Use PROC_REF(procname), TYPE_PROC_REF(type,procname) or GLOBAL_PROC_REF(procname) macros to validate the passed in proc at compile time.
 * PROC_REF for procs defined on current type or its ancestors, TYPE_PROC_REF for procs defined on unrelated type and GLOBAL_PROC_REF for global procs.
 * Return values from procs registered must be a bitfield
 *
 * Arguments:
 * * datum/target The target to listen for signals from
 * * signal_type A signal name
 * * proctype The proc to call back when the signal is emitted
 * * override If a previous registration exists you must explicitly set this
 */
/datum/proc/RegisterSignal(datum/target, signal_type, proctype, override = FALSE)
	if(QDELETED(src) || QDELETED(target))
		return

	if (islist(signal_type))
		var/static/list/known_failures = list()
		var/list/signal_type_list = signal_type
		var/message = "([target.type]) is registering [signal_type_list.Join(", ")] as a list, the older method. Change it to RegisterSignals."

		if (!(message in known_failures))
			known_failures[message] = TRUE
			stack_trace("[target] [message]")

		RegisterSignals(target, signal_type, proctype, override)
		return

	var/list/procs = (_signal_procs ||= list())
	var/list/target_procs = (procs[target] ||= list())
	var/list/lookup = (target._listen_lookup ||= list())

	var/exists = target_procs[signal_type]
	target_procs[signal_type] = proctype

	if(exists)
		if(!override)
			var/override_message = "[signal_type] overridden. Use override = TRUE to suppress this warning.\nTarget: [target] ([target.type]) Existing Proc: [exists] New Proc: [proctype]"
			log_signal(override_message)
			stack_trace(override_message)
		return

	var/list/looked_up = lookup[signal_type]

	if(isnull(looked_up)) // Nothing has registered here yet
		lookup[signal_type] = src
	else if(!islist(looked_up)) // One other thing registered here
		lookup[signal_type] = list(looked_up, src)
	else // Many other things have registered here
		looked_up += src

/// Registers multiple signals to the same proc.
/datum/proc/RegisterSignals(datum/target, list/signal_types, proctype, override = FALSE)
	for (var/signal_type in signal_types)
		RegisterSignal(target, signal_type, proctype, override)

/**
 * Stop listening to a given signal from target
 *
 * Breaks the relationship between target and source datum, removing the callback when the signal fires
 *
 * Doesn't care if a registration exists or not
 *
 * Arguments:
 * * datum/target Datum to stop listening to signals from
 * * sig_typeor_types Signal string key or list of signal keys to stop listening to specifically
 */
/datum/proc/UnregisterSignal(datum/target, sig_type_or_types)
	var/list/lookup = target._listen_lookup
	var/list/procs = _signal_procs

	// If neither side has anything, bail.
	if(!lookup && (!procs || !procs[target]))
		return

    if(!islist(sig_type_or_types))
    	sig_type_or_types = list(sig_type_or_types)

    var/list/target_procs = procs ? procs[target] : null

	for(var/sig in sig_type_or_types)
    	var/has_proc = target_procs && target_procs[sig]

		// Always try to clean the emitter side if lookup exists
		if(lookup && (sig in lookup))
			var/current = lookup[sig]

			switch(length(current))
            	if(2)
					// 2-element list: remove src, collapse to single datum
					var/list/new_list = current - src
					if(new_list.len)
						lookup[sig] = new_list.len == 1 ? new_list[1] : new_list
					else
						// if somehow both gone, just drop the key
						lookup -= sig
				if(1)
					// Single-length list (weird state, but handle it)
					if(islist(current) && (src in current))
						lookup -= sig
				if(0)
					// Non-list: either src or somebody else
					if(current == src)
						lookup -= sig
				else
					// >2 listeners
					current -= src

			if(lookup && !lookup.len)
				target._listen_lookup = null

		// Listener side cleanup, only if we actually had a proc
		if(has_proc)
			target_procs -= sig

	// Final tidy: if target_procs is empty, remove that target from _signal_procs
	if(target_procs && !target_procs.len)
    	procs -= target

/**
 * Internal proc to handle most all of the signaling procedure
 *
 * Will runtime if used on datums with an empty lookup list
 *
 * Use the [SEND_SIGNAL] define instead
 */
/datum/proc/_SendSignal(sigtype, list/arguments)
	var/target = _listen_lookup?[sigtype]

	// No listeners at all for this signal
	if(!target)
		return NONE

	. = NONE

	// SINGLE LISTENER
	if(!islist(target))
		var/datum/listening_datum = target
		if(!listening_datum)
			return NONE

		var/list/proc_map = listening_datum?._signal_procs?[src]

		if(!proc_map)
			// Listener has completely forgotten this source;
			// clean the emitter side and log.
			stack_trace("Signal mismatch (single): [src] has [sigtype] for [listening_datum], but listener has no _signal_procs entry")
			if(_listen_lookup[sigtype] == listening_datum)
				_listen_lookup -= sigtype
			return NONE

		var/proc_name = proc_map[sigtype]
		if(!proc_name)
			// Listener still has a table for this source, but not this signal.
			stack_trace("Signal mismatch (single): [src] has [sigtype] for [listening_datum], but listener has no matching proc entry")
			if(_listen_lookup[sigtype] == listening_datum)
				_listen_lookup -= sigtype
			return NONE

		// Happy path
		return NONE | call(listening_datum, proc_name)(arglist(arguments))

	// MULTIPLE LISTENERS
	var/list/listeners = target
	var/list/queued_calls = list()

	for(var/i in 1 to listeners.len)
		var/datum/listening_datum = listeners[i]
		if(!listening_datum)
			continue

		var/list/proc_map = listening_datum?._signal_procs?[src]
		if(!proc_map)
			// Listener forgot this source, but the source still remembers the listener.
			stack_trace("Signal mismatch: [src] has [sigtype] in _listen_lookup but [listening_datum] has no _signal_procs entry for it")
			// Self-heal: remove stale listener from src's listener list.
			listeners.Cut(i, i + 1)
			i--
			continue

		var/proc_name = proc_map[sigtype]
		if(!proc_name)
			// Listener still has a table for this source, but not this signal.
			stack_trace("Signal mismatch: [src] has [sigtype] in _listen_lookup but [listening_datum] has no proc entry for it")
			listeners.Cut(i, i + 1)
			i--
			continue

		queued_calls += list(listening_datum, proc_name)

	for(var/i in 1 to queued_calls.len step 2)
		. |= call(queued_calls[i], queued_calls[i + 1])(arglist(arguments))
