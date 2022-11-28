/*
	The broadcaster sends processed messages to all radio devices in the game. They
	do not have to be headsets; intercoms and station-bounced radios suffice.

	They receive their message from a server after the message has been logged.
*/

var/list/recentmessages // global list of recent messages broadcasted : used to circumvent massive radio spam

/obj/machinery/telecomms/broadcaster
	name = "subspace broadcaster"
	icon_state = "broadcaster"
	desc = "A dish-shaped machine used to broadcast processed subspace signals."
	telecomms_type = /obj/machinery/telecomms/broadcaster
	idle_power_usage = 100 // WATTS
	active_power_usage = 3 KILOWATTS
	produces_heat = FALSE
	delay = 7
	circuitboard = "/obj/item/circuitboard/telecomms/broadcaster"

/obj/machinery/telecomms/broadcaster/Initialize(mapload)
	. = ..()
	LAZYINITLIST(recentmessages)

/obj/machinery/telecomms/broadcaster/receive_information(datum/signal/subspace/signal, obj/machinery/telecomms/machine_from)
	// Don't broadcast rejected signals
	if(!istype(signal))
		return
	if(signal.data["reject"])
		return
	if(!signal.data["message"])
		return

	// Prevents massive radio spam
	signal.mark_done()
	var/datum/signal/subspace/original = signal.original
	if(original && ("compression" in signal.data))
		original.data["compression"] = signal.data["compression"]

	signal.levels = GetConnectedZlevels(z)

	var/signal_message = "[signal.frequency]:[signal.data["message"]]:[signal.data["realname"]]"
	if(signal_message in recentmessages)
		return
	LAZYADD(recentmessages, signal_message)

	if(signal.data["slow"] > 0)
		addtimer(CALLBACK(signal, /datum/signal/subspace/proc/broadcast), signal.data["slow"]) // network lag
	else
		signal.broadcast()

	/* --- Do a snazzy animation! --- */
	flick("broadcaster_send", src)

/obj/machinery/telecomms/broadcaster/process()
	LAZYCLEARLIST(recentmessages)

/obj/machinery/telecomms/broadcaster/Destroy()
	LAZYCLEARLIST(recentmessages)
	return ..()
