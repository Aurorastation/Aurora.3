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
	..("R:[listeners.len]")

/datum/controller/subsystem/listener/proc/register(datum/listener/L)
	LAZYINITLIST(listeners[L.channel])
	listeners[L.channel][L] = TRUE

/datum/controller/subsystem/listener/proc/unregister(datum/listener/L)
	if (listeners[L.channel])
		listeners[L.channel] -= L
