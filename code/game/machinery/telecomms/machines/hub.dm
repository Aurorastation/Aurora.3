/*
	The HUB idles until it receives information. It then passes on that information
	depending on where it came from.

	This is the heart of the Telecommunications Network, sending information where it
	is needed. It mainly receives information from long-distance Relays and then sends
	that information to be processed. Afterwards it gets the uncompressed information
	from Servers/Buses and sends that back to the relay, to then be broadcasted.
*/

/obj/machinery/telecomms/hub
	name = "telecommunication hub"
	icon_state = "hub"
	desc = "A mighty piece of hardware used to send and receive massive amounts of data."
	telecomms_type = /obj/machinery/telecomms/hub
	density = TRUE
	anchored = TRUE
	idle_power_usage = 1600
	circuitboard = "/obj/item/circuitboard/telecomms/hub"
	long_range_link = TRUE
	netspeed = 40

/obj/machinery/telecomms/hub/receive_information(datum/signal/signal, obj/machinery/telecomms/machine_from)
	if(!is_freq_listening(signal))
		return

	if(istype(machine_from, /obj/machinery/telecomms/receiver))
		//If the signal is compressed, send it to the bus.
		relay_information(signal, /obj/machinery/telecomms/bus, TRUE) // ideally relay the copied information to bus units
	else
		// Get a list of relays that we're linked to, then send the signal to their levels.
		relay_information(signal, /obj/machinery/telecomms/relay, TRUE)
		relay_information(signal, /obj/machinery/telecomms/broadcaster, TRUE) // Send it to a broadcaster.
