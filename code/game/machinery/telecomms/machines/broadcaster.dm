/*
	The broadcaster sends processed messages to all radio devices in the game. They
	do not have to be headsets; intercoms and station-bounced radios suffice.

	They receive their message from a server after the message has been logged.
*/

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
	overmap_range = 2
	var/list/recent_broadcasts

/obj/machinery/telecomms/broadcaster/Initialize(mapload)
	. = ..()
	LAZYINITLIST(recent_broadcasts)

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

	signal.levels = broadcast_levels(signal)

	var/signal_message = "[signal.frequency]:[signal.data["message"]]:[signal.data["realname"]]"
	if(signal_message in recent_broadcasts)
		return
	LAZYADD(recent_broadcasts, signal_message)

	if(signal.data["slow"] > 0)
		addtimer(CALLBACK(signal, /datum/signal/subspace/proc/broadcast), signal.data["slow"]) // network lag
	else
		signal.broadcast()

	/* --- Do a snazzy animation! --- */
	flick("broadcaster_send", src)

	spawn(10)
		recent_broadcasts -= signal_message
