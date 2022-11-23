/*
	The server logs all traffic and signal data. Once it records the signal, it sends
	it to the subspace broadcaster.

	Store a maximum of 400 logs and then deletes them.
*/

// Simple log entry datum

/datum/comm_log_entry
	var/input_type = "Speech File"
	var/name = "data packet (#)"
	var/parameters = list()

/obj/machinery/telecomms/server
	name = "telecommunication server"
	icon_state = "comm_server"
	desc = "A machine used to store data and network statistics."
	telecomms_type = /obj/machinery/telecomms/server
	density = TRUE
	anchored = TRUE
	idle_power_usage = 300
	circuitboard = "/obj/item/circuitboard/telecomms/server"
	var/list/log_entries = list()
	var/totaltraffic = 0 // gigabytes (if > 1024, divide by 1024 -> terrabytes)

	var/rawcode = ""	// the code to compile (raw text)
	var/datum/ntsl2_program/tcomm/Program // NTSL2++ datum responsible for script execution
	var/autoruncode = 0		// 1 if the code is set to run every time a signal is picked up

/obj/machinery/telecomms/server/Initialize()
	. = ..()
	Program = SSntsl2.new_program_tcomm(src)

/obj/machinery/telecomms/server/receive_information(datum/signal/subspace/vocal/signal, obj/machinery/telecomms/machine_from)
	// can't log non-vocal signals
	if(!istype(signal) || !signal.data["message"] || !is_freq_listening(signal))
		return

	if(traffic > 0)
		totaltraffic += traffic

	// Delete particularly old logs
	if (log_entries.len >= 400)
		log_entries.Cut(1, 2)

	var/datum/comm_log_entry/log = new
	var/mob/speaker = signal.speaker.resolve()

	if(!istype(speaker))
		return

	log.parameters["mobtype"] = speaker.type
	log.parameters["name"] = signal.data["name"]
	log.parameters["job"] = signal.data["job"]
	log.parameters["message"] = signal.data["message"]

	// If the signal is still compressed, make the log entry gibberish
	var/compression = signal.data["compression"]
	if (compression > 0)
		log.input_type = "Corrupt File"
		log.parameters["name"] = Gibberish(signal.data["name"], compression + 50)
		log.parameters["job"] = Gibberish(signal.data["job"], compression + 50)
		log.parameters["message"] = Gibberish(signal.data["message"], compression + 50)

	// Give the log a name and store it
	var/identifier = num2text ( rand(-1000, 1000) + world.time )
	log.name = "data packet ([md5(identifier)])"
	log_entries.Add(log)

	if(istype(Program))
		Program.process_message(signal, CALLBACK(src, .proc/program_receive_information, signal))

	finish_receive_information(signal)

/obj/machinery/telecomms/server/proc/program_receive_information(datum/signal/signal)
	Program.retrieve_messages(CALLBACK(src, .proc/finish_receive_information, signal))

/obj/machinery/telecomms/server/proc/finish_receive_information(datum/signal/signal)
	var/can_send = relay_information(signal, /obj/machinery/telecomms/hub)
	if(!can_send)
		relay_information(signal, /obj/machinery/telecomms/broadcaster)

/obj/machinery/telecomms/server/process()
	. = ..()
	if(istype(Program))
		Program.retrieve_messages()
