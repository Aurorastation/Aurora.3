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

/obj/machinery/telecomms/processor/antagonist_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Attacking/damaging this machine will cause communications over its linked frequency(s) to become increasingly garbled."

/obj/machinery/telecomms/processor/receive_information(datum/signal/subspace/signal, obj/machinery/telecomms/machine_from)
	if(!is_freq_listening(signal))
		return

	// Processor set to COMPRESS
	if(!process_mode)
		// Data scrambling increased from 35-65 to MAXIMUM GIBBERISH
		signal.data["compression"] = 100

	// Processor set to UNCOMPRESS
	else if (signal.data["compression"])
		// Ion storm? Blow out any intelligibility.
		if(ion_storm)
			signal.data["compression"] = 100
		// Taken any damage? Start gently scrambling things.
		else if(integrity < 100)
			signal.data["compression"] = rand(0, round((100-integrity)))
		// Uncompress signal to complete clarity
		else signal.data["compression"] = 0

	if(istype(machine_from, /obj/machinery/telecomms/bus))
		relay_direct_information(signal, machine_from) // send the signal back to the machine
	else // no bus detected - send the signal to servers instead
		signal.data["slow"] += rand(5, 10) // slow the signal down
		relay_information(signal, signal.server_type)

#undef COMPRESS
#undef UNCOMPRESS
