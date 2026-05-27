/*
	The receiver idles and receives messages from subspace-compatible radio equipment;
	primarily headsets. Received messages are then passed to the network hub, or failing that,
	the network bus for further processing and broadcast.
*/

/obj/structure/machinery/telecomms/receiver
	name = "subspace receiver"
	icon_state = "broadcast receiver"
	desc = "This machine has a dish-like shape and green lights. It is designed to detect and process subspace radio activity."
	telecomms_type = /obj/structure/machinery/telecomms/receiver
	produces_heat = FALSE
	overmap_range = 3
	circuitboard = "/obj/item/circuitboard/telecomms/receiver"

/obj/structure/machinery/telecomms/receiver/Initialize(mapload)
	. = ..()
	SSmachinery.all_receivers += src
	desc += " It has an effective reception range of [overmap_range] grids on the overmap."

/obj/structure/machinery/telecomms/receiver/Destroy()
	SSmachinery.all_receivers -= src
	return ..()

/obj/structure/machinery/telecomms/receiver/receive_signal(datum/signal/subspace/signal)
	if(!relay_information(signal, /obj/structure/machinery/telecomms/hub, TRUE))
		relay_information(signal, /obj/structure/machinery/telecomms/bus, TRUE)
