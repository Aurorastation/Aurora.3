/*
	The receiver idles and receives messages from subspace-compatible radio equipment;
	primarily headsets. Received messages are then passed to the network hub, or failing that,
	the network bus for further processing and broadcast.
*/

/obj/machinery/telecomms/receiver
	name = "subspace receiver"
	icon_state = "broadcast receiver"
	desc = "This machine has a dish-like shape and green lights. It is designed to detect and process subspace radio activity."
	telecomms_type = /obj/machinery/telecomms/receiver
	produces_heat = FALSE
	overmap_range = 2
	circuitboard = "/obj/item/circuitboard/telecomms/receiver"

/obj/machinery/telecomms/receiver/Initialize(mapload)
	. = ..()
	desc += " It has an effective reception range of [overmap_range] grids on the overmap."

/obj/machinery/telecomms/receiver/receive_signal(datum/signal/subspace/signal)
	if(!use_power || !istype(signal) || !is_freq_listening(signal) || !check_range(signal))
		return

	if(!relay_information(signal, /obj/machinery/telecomms/hub, TRUE))
		relay_information(signal, /obj/machinery/telecomms/bus, TRUE)
