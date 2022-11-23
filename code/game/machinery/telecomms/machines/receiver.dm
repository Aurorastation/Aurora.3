/*
	The receiver idles and receives messages from subspace-compatible radio equipment;
	primarily headsets. They then just relay this information to all linked devices,
	which can would probably be network hubs.

	Link to Processor Units in case receiver can't send to bus units.
*/

/obj/machinery/telecomms/receiver
	name = "subspace receiver"
	icon_state = "broadcast receiver"
	desc = "This machine has a dish-like shape and green lights. It is designed to detect and process subspace radio activity."
	telecomms_type = /obj/machinery/telecomms/receiver
	density = TRUE
	anchored = TRUE
	idle_power_usage = 600
	produces_heat = FALSE
	circuitboard = "/obj/item/circuitboard/telecomms/receiver"

/obj/machinery/telecomms/receiver/receive_signal(datum/signal/subspace/signal)
	if(!on || !istype(signal) || !check_receive_level(signal) || !check_receive_sector(signal) || signal.transmission_method != TRANSMISSION_SUBSPACE)
		return

	if(!is_freq_listening(signal))
		return

	signal.levels = list()

	if(!relay_information(signal, /obj/machinery/telecomms/hub))
		relay_information(signal, /obj/machinery/telecomms/bus)

/obj/machinery/telecomms/receiver/proc/check_receive_level(datum/signal/subspace/signal)
	if (z in signal.levels)
		return TRUE

	for (var/attached_z in get_service_area())
		if (attached_z in signal.levels)
			return TRUE

	for (var/obj/machinery/telecomms/hub/H in links)
		for (var/obj/machinery/telecomms/relay/R in H.links)
			if(R.can_receive(signal) && (R.check_service_area(signal.levels)))
				return TRUE

	return FALSE
