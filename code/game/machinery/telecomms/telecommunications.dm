//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/*
	Hello, friends, this is Doohl from sexylands. You may be wondering what this
	monstrous code file is. Sit down, boys and girls, while I tell you the tale.


	The machines defined in this file were designed to be compatible with any radio
	signals, provided they use subspace transmission. Currently they are only used for
	headsets, but they can eventually be outfitted for real COMPUTER networks. This
	is just a skeleton, ladies and gentlemen.

	Look at radio.dm for the prequel to this code.
*/

var/global/list/obj/machinery/telecomms/telecomms_list = list()

/obj/machinery/telecomms
	icon = 'icons/obj/machines/telecomms.dmi'

	var/list/links = list() // list of machines this machine is linked to
	/*
		Associative lazylist of the telecomms_type of linked telecomms machines and a list of said machines
		eg list(telecomms_type1 = list(everything linked to us with that type), telecomms_type2 = list(everything linked to us with THAT type, etc.))

	*/
	var/list/links_by_telecomms_type
	var/traffic = 0 // value increases as traffic increases
	var/netspeed = 5 // how much traffic to lose per tick (50 gigabytes/second * netspeed)
	var/list/autolinkers = list() // list of text/number values to link with
	var/id = "NULL" // identification string
	var/telecomms_type = null // Relevant typepath of the machine (important to use machine's base path rather than server/preset or w.e)
	var/network = "NULL" // the network of the machinery

	var/list/freq_listening = list() // list of frequencies to tune into: if none, will listen to all

	var/toggled = TRUE 	// Is it toggled on
	var/on = TRUE
	var/integrity = 100 // basically HP, loses integrity by heat
	var/produces_heat = TRUE	//whether the machine will produce heat when on.
	var/delay = 10 // how many process() ticks to delay per heat
	var/long_range_link = FALSE // Can you link it across Z levels or on the otherside of the map? (Relay & Hub)
	var/circuitboard = null // string pointing to a circuitboard type
	var/hide = FALSE				// Is it a hidden machine?

	var/overmap_range = 2 //OVERMAP: Number of sectors out we can communicate

	///Looping sounds for any servers
//	var/datum/looping_sound/server/soundloop

/obj/machinery/telecomms/proc/get_service_area()
	. = list(z)
	var/turf/above = GetAbove(src)
	var/turf/below = GetBelow(src)
	if(above) . += above.z
	if(below) . += below.z

/obj/machinery/telecomms/proc/check_service_area(list/levels)
	var/valid_levels = get_service_area()
	for(var/check_z in levels)
		if(check_z in valid_levels)
			return TRUE
	return FALSE

// relay signal to all linked machinery that are of type [filter]. If signal has been sent [amount] times, stop sending
/obj/machinery/telecomms/proc/relay_information(datum/signal/subspace/signal, filter, copysig, amount = 20)

	if(!on)
		return

	if(!filter || !ispath(filter, /obj/machinery/telecomms))
		CRASH("null or non /obj/machinery/telecomms typepath given as the filter argument! given typepath: [filter]")

	var/send_count = 0

	signal.data["slow"] += rand(0, round((100-integrity))) // apply some lag based on integrity

	// Loop through all linked machines and send the signal or copy.
	for(var/obj/machinery/telecomms/filtered_machine in links_by_telecomms_type?[filter])
		if(!filtered_machine.on)
			continue

		if(amount && send_count >= amount)
			break

		if(z != filtered_machine.loc.z && !long_range_link && !filtered_machine.long_range_link)
			continue

		send_count++

		if(filtered_machine.is_freq_listening(signal))
			filtered_machine.traffic++

		if(copysig)
			filtered_machine.receive_information(signal.copy(), src)
		else
			filtered_machine.receive_information(signal, src)

	if(send_count > 0 && is_freq_listening(signal))
		traffic++

	return send_count

// send signal directly to a machine
/obj/machinery/telecomms/proc/relay_direct_information(datum/signal/signal, obj/machinery/telecomms/machine)
	machine.receive_information(signal, src)

// receive information from linked machinery
/obj/machinery/telecomms/proc/receive_information(datum/signal/signal, obj/machinery/telecomms/machine_from)
	return

/obj/machinery/telecomms/proc/is_freq_listening(datum/signal/signal)
	// return TRUE if found, FALSE if not found
	return signal && (!freq_listening.len || (signal.frequency in freq_listening))

//OVERMAP: Since telecomms is subspace, limit how far it goes. This prevents double-broadcasts across the entire overmap, and gives the ability to intrude on comms range of other ships
/obj/machinery/telecomms/proc/check_receive_sector(datum/signal/subspace/signal)
	if(isAdminLevel(z)) //Messages to and from centcomm levels are not sector-restricted.
		return TRUE
	for(var/check_z in signal.levels)
		if(isAdminLevel(check_z))
			return TRUE

	if(current_map.use_overmap)
		if(!linked) //If we're using overmap and not associated with a sector, doesn't work.
			return FALSE
		var/obj/effect/overmap/visitable/S = signal.sector
		if(istype(S)) //If our signal isn't sending a sector, it's something associated with telecomms_process_active(), which has their own limits.
			if(S != linked) //If we're not the same ship, check range
				if(get_dist(S, linked) > overmap_range && !(S in view(overmap_range, linked)))
					return FALSE
	return TRUE

/obj/machinery/telecomms/Initialize(mapload)
	. = ..()
//	soundloop = new(list(src), on)
	telecomms_list += src

	if(current_map.use_overmap && !linked)
		var/my_sector = map_sectors["[z]"]
		if (istype(my_sector, /obj/effect/overmap/visitable))
			attempt_hook_up(my_sector)

	if(mapload && autolinkers.len)
		return INITIALIZE_HINT_LATELOAD

/obj/machinery/telecomms/LateInitialize()
	for(var/obj/machinery/telecomms/T in (long_range_link ? telecomms_list : orange(20, src)))
		add_automatic_link(T)

/obj/machinery/telecomms/Destroy()
//	QDEL_NULL(soundloop)
	telecomms_list -= src
	for(var/obj/machinery/telecomms/comm in telecomms_list)
		remove_link(comm)
	links = list()
	return ..()

// Used in auto linking
/obj/machinery/telecomms/proc/add_automatic_link(var/obj/machinery/telecomms/T)
	var/turf/position = get_turf(src)
	var/turf/T_position = get_turf(T)

	if((position.z != T_position.z) && !(long_range_link && T.long_range_link))
		return

	if(src == T)
		return

	for(var/autolinker_id in autolinkers)
		if(autolinker_id in T.autolinkers)
			add_new_link(T)
			return

/obj/machinery/telecomms/update_icon()
	var/state = construct_op ? "[initial(icon_state)]_o" : initial(icon_state)
	if(!on)
		state += "_off"

	icon_state = state

/obj/machinery/telecomms/proc/update_power()
	if(toggled)
		if(stat & (BROKEN|NOPOWER|EMPED) || integrity <= 0) // if powered, on. if not powered, off. if too damaged, off
			on = FALSE
//			soundloop.stop(src)
		else
			on = TRUE
//			soundloop.start(src)
	else
		on = FALSE
//		soundloop.stop(src)

/obj/machinery/telecomms/process()
	update_power()

	// Check heat and generate some
	checkheat()

	// Update the icon
	update_icon()

	if(traffic > 0)
		traffic -= netspeed

/obj/machinery/telecomms/emp_act(severity)
	if(prob(100/severity))
		if(!(stat & EMPED))
			stat |= EMPED
			var/duration = (300 * 10)/severity
			spawn(rand(duration - 20, duration + 20)) // Takes a long time for the machines to reboot.
				stat &= ~EMPED
	..()

/obj/machinery/telecomms/proc/checkheat()
	// Checks heat from the environment and applies any integrity damage
	var/datum/gas_mixture/environment = loc.return_air()
	var/damage_chance = 0                           // Percent based chance of applying 1 integrity damage this tick
	switch(environment.temperature)
		if((T0C + 40) to (T0C + 70))                // 40C-70C, minor overheat, 10% chance of taking damage
			damage_chance = 10
		if((T0C + 70) to (T0C + 130))				// 70C-130C, major overheat, 25% chance of taking damage
			damage_chance = 25
		if((T0C + 130) to (T0C + 200))              // 130C-200C, dangerous overheat, 50% chance of taking damage
			damage_chance = 50
		if((T0C + 200) to INFINITY)					// More than 200C, INFERNO. Takes damage every tick.
			damage_chance = 100
	if (damage_chance && prob(damage_chance))
		integrity = between(0, integrity - 1, 100)


	if(delay > 0)
		delay--
	else if(on)
		produce_heat()
		delay = initial(delay)



/obj/machinery/telecomms/proc/produce_heat()
	if (!produces_heat)
		return

	if (!use_power)
		return

	if(!(stat & (NOPOWER|BROKEN)))
		var/turf/simulated/L = loc
		if(istype(L))
			var/datum/gas_mixture/env = L.return_air()

			var/transfer_moles = 0.25 * env.total_moles

			var/datum/gas_mixture/removed = env.remove(transfer_moles)

			if(removed)

				var/heat_produced = idle_power_usage	//obviously can't produce more heat than the machine draws from it's power source
				if (traffic <= 0)
					heat_produced *= 0.30	//if idle, produce less heat.

				removed.add_thermal_energy(heat_produced)

			env.merge(removed)
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


/*
	The relay idles until it receives information. It then passes on that information
	depending on where it came from.

	The relay is needed in order to send information pass Z levels. It must be linked
	with a HUB, the only other machine that can send/receive pass Z levels.
*/

/obj/machinery/telecomms/relay
	name = "telecommunication relay"
	icon_state = "relay"
	desc = "A mighty piece of hardware used to send massive amounts of data far away."
	telecomms_type = /obj/machinery/telecomms/relay
	density = TRUE
	anchored = TRUE
	idle_power_usage = 600
	produces_heat = FALSE
	circuitboard = "/obj/item/circuitboard/telecomms/relay"
	netspeed = 5
	long_range_link = TRUE
	var/broadcasting = TRUE
	var/receiving = TRUE

/obj/machinery/telecomms/relay/receive_information(datum/signal/subspace/signal, obj/machinery/telecomms/machine_from)
	// Add our levels and send it back
	if(can_send(signal))
		signal.levels |= get_service_area()

// Checks to see if it can send/receive.

/obj/machinery/telecomms/relay/proc/can(datum/signal/signal)
	if(!on)
		return 0
	if(!is_freq_listening(signal))
		return 0
	return 1

/obj/machinery/telecomms/relay/proc/can_send(datum/signal/signal)
	if(!can(signal))
		return 0
	return broadcasting

/obj/machinery/telecomms/relay/proc/can_receive(datum/signal/signal)
	if(!can(signal))
		return 0
	return receiving

/*
	The bus mainframe idles and waits for hubs to relay them signals. They act
	as junctions for the network.

	They transfer uncompressed subspace packets to processor units, and then take
	the processed packet to a server for logging.

	Link to a subspace hub if it can't send to a server.
*/

/obj/machinery/telecomms/bus
	name = "bus mainframe"
	icon_state = "bus"
	desc = "A mighty piece of hardware used to send massive amounts of data quickly."
	telecomms_type = /obj/machinery/telecomms/bus
	density = TRUE
	anchored = TRUE
	idle_power_usage = 1000
	circuitboard = "/obj/item/circuitboard/telecomms/bus"
	netspeed = 40
	var/change_frequency = 0

/obj/machinery/telecomms/bus/receive_information(datum/signal/subspace/signal, obj/machinery/telecomms/machine_from)
	if(!istype(signal) || !is_freq_listening(signal))
		return

	if(change_frequency && !(signal.frequency in ANTAG_FREQS))
		signal.frequency = change_frequency

	if(!istype(machine_from, /obj/machinery/telecomms/processor) && machine_from != src) // Signal must be ready (stupid assuming machine), let's send it
		// send to one linked processor unit
		if(relay_information(signal, /obj/machinery/telecomms/processor))
			return

		signal.data["slow"] += rand(1, 5) // Failed, relay it anyway, a little slower

	// Try sending it!
	var/list/try_send = list(signal.server_type, /obj/machinery/telecomms/hub, /obj/machinery/telecomms/broadcaster, /obj/machinery/telecomms/bus)
	var/i = 0
	for(var/send in try_send)
		if(i)
			signal.data["slow"] += rand(0,1)
		i++
		if(relay_information(signal, send))
			break

/*
	The processor is a very simple machine that decompresses subspace signals and
	transfers them back to the original bus. It is essential in producing audible
	data.

	Link to servers if bus is not present
*/

/obj/machinery/telecomms/processor
	name = "processor unit"
	icon_state = "processor"
	desc = "This machine is used to process large quantities of information."
	telecomms_type = /obj/machinery/telecomms/processor
	density = TRUE
	anchored = TRUE
	idle_power_usage = 600
	delay = 5
	circuitboard = "/obj/item/circuitboard/telecomms/processor"
	var/process_mode = 1 // 1 = Uncompress Signals, 0 = Compress Signals

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


/*
	The server logs all traffic and signal data. Once it records the signal, it sends
	it to the subspace broadcaster.

	Store a maximum of 400 logs and then deletes them.
*/


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

// Simple log entry datum

/datum/comm_log_entry
	var/input_type = "Speech File"
	var/name = "data packet (#)"
	var/parameters = list()

// NTSL2++ code
