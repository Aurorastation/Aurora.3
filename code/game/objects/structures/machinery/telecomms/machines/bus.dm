/*
	The bus mainframe idles and waits for hubs to relay them signals. They act
	as junctions for the network.

	They transfer uncompressed subspace packets to processor units, and then take
	the processed packet to a server for logging.

	Link to a subspace hub if it can't send to a server.
*/
/obj/structure/machinery/telecomms/bus
	name = "bus mainframe"
	icon_state = "bus"
	desc = "A mighty piece of hardware used to send massive amounts of data quickly."
	telecomms_type = /obj/structure/machinery/telecomms/bus
	idle_power_usage = 1 KILO WATTS
	active_power_usage = 3 KILO WATTS
	circuitboard = "/obj/item/circuitboard/telecomms/bus"
	netspeed = 40
	var/change_frequency = 0

/obj/structure/machinery/telecomms/bus/receive_information(datum/signal/subspace/signal, obj/structure/machinery/telecomms/machine_from)
	if(!istype(signal) || !is_freq_listening(signal))
		return

	if(change_frequency && !(signal.frequency in ANTAG_FREQS))
		signal.frequency = change_frequency

	if(!istype(machine_from, /obj/structure/machinery/telecomms/processor) && machine_from != src) // Signal must be ready (stupid assuming machine), let's send it
		// send to one linked processor unit
		if(relay_information(signal, /obj/structure/machinery/telecomms/processor))
			return

		signal.data["slow"] += rand(1, 5) // Failed, relay it anyway, a little slower

	// Try sending it!
	var/list/try_send = list(signal.server_type, /obj/structure/machinery/telecomms/hub, /obj/structure/machinery/telecomms/broadcaster, /obj/structure/machinery/telecomms/bus)
	var/i = 0
	for(var/send in try_send)
		if(i)
			signal.data["slow"] += rand(0,1)
		i++
		if(relay_information(signal, send))
			break
