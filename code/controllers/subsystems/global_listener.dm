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
