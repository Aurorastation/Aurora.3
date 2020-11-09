/decl/observ
	var/name = "Unnamed Event"
	var/expected_type = /datum
	var/list/listeners_assoc

/decl/observ/New()
	listeners_assoc = list()
	..()

/decl/observ/proc/is_listening(var/eventSource, var/datum/procOwner, var/proc_call)
	var/listeners = listeners_assoc[eventSource]
	if(!listeners)
		return FALSE

	var/stored_proc_call = listeners[procOwner]
	return stored_proc_call && (!proc_call || stored_proc_call == proc_call)

/decl/observ/proc/has_listeners(var/eventSource)
	var/list/listeners = listeners_assoc[eventSource]
	return LAZYLEN(listeners)

/decl/observ/proc/register(var/eventSource, var/datum/procOwner, var/proc_call)
	if(!(eventSource && procOwner && procOwner))
		return FALSE
	if(istype(eventSource, /decl/observ))
		return FALSE

	if(!istype(eventSource, expected_type))
		CRASH("Unexpected type. Expected [expected_type], was [eventSource]")

	LAZYINITLIST(listeners_assoc[eventSource])
	listeners_assoc[eventSource][procOwner] = proc_call
	REGISTER_EVENT(destroyed, procOwner, src, /decl/observ/proc/unregister)
	return TRUE

/decl/observ/proc/unregister(var/eventSource, var/datum/procOwner)
	if(!(eventSource && procOwner))
		return FALSE
	if(istype(eventSource, /decl/observ))
		return FALSE

	var/list/listeners = listeners_assoc[eventSource]
	if(!listeners)
		return FALSE

	listeners -= procOwner
	if (!listeners.len)
		listeners_assoc -= eventSource
	UNREGISTER_EVENT(destroyed, procOwner, src)
	return TRUE

/decl/observ/proc/raise_event(...)
	if(!args.len)
		return
	var/listeners = listeners_assoc[args[1]]
	if(!listeners)
		return
	for(var/listener in listeners)
		call(listener, listeners[listener])(arglist(args))
