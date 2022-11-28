/*
	The processor is a very simple machine that decompresses subspace signals and
	transfers them back to the original bus. It is essential in producing audible
	data.

	Link to servers if bus is not present
*/

#define COMPRESS   0
#define UNCOMPRESS 1

/obj/machinery/telecomms/processor
	name = "processor unit"
	icon_state = "processor"
	desc = "This machine is used to process large quantities of information."
	telecomms_type = /obj/machinery/telecomms/processor
	delay = 5
	circuitboard = "/obj/item/circuitboard/telecomms/processor"
	var/process_mode = UNCOMPRESS

/obj/machinery/telecomms/processor/receive_information(datum/signal/subspace/signal, obj/machinery/telecomms/machine_from)
	if(!is_freq_listening(signal))
		return

	if(!process_mode)
		signal.data["compression"] = 100 // even more compressed signal
	else if (signal.data["compression"])
		signal.data["compression"] = 0 // uncompress subspace signal

	if(istype(machine_from, /obj/machinery/telecomms/bus))
		relay_direct_information(signal, machine_from) // send the signal back to the machine
	else // no bus detected - send the signal to servers instead
		signal.data["slow"] += rand(5, 10) // slow the signal down
		relay_information(signal, signal.server_type)

#undef COMPRESS
#undef UNCOMPRESS
