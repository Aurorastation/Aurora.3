var/datum/controller/subsystem/listener/SSlistener

/datum/controller/subsystem/listener
	name = "Global Listener"
	flags = SS_NO_INIT | SS_NO_FIRE

	var/list/listeners = list()

/datum/controller/subsystem/listener/New()
	NEW_SS_GLOBAL(SSlistener)

/datum/controller/subsystem/listener/Recover()
	listeners = SSlistener.listeners

/datum/controller/subsystem/listener/stat_entry()
	..("L:[listeners.len]")

/datum/controller/subsystem/listener/proc/register(listener/L)
	LAZYINITLIST(listeners[L.channel])
	listeners[L.channel][L] = TRUE

/datum/controller/subsystem/listener/proc/unregister(listener/L)
	if (listeners[L.channel])
		listeners[L.channel] -= L
	
	if (!LAZYLEN(listeners[L.channel]))
		listeners -= L.channel

/proc/get_listeners_by_type(id, type)
	if (!type)
		CRASH("Cannot get listeners of type null.")

	. = list()
	var/listener/L
	var/datum/D
	for (var/thing in GET_LISTENERS(id))
		L = thing
		D = L.target
		if (istype(D, type) && !QDELETED(D))
			. += D
