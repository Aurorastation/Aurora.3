/*
	Telecommunications machines handle communications over radio and subspace networks, primarily for radio communication
	but also for a variety of other networked machines.

	Signals are received by the closest active and viable receiver, i.e. one listening on their frequency and powered. Only one receiver processes any given signal normally.
	Hubs take incoming signals from receivers and passes them to the bus for processing, and take completed messages from the server to broadcast
	Buses move signals from hub to processor, and then to the signal's designated server (usually the Tcomms server)
	Processors decompress compressed signals (and vice versa), sending the processed signal back to the bus.
	Servers log the processed radio messages and perform any NTSL functions on the messages before sending them to be broadcast via the hub.
	Broadcasters take completed messages and send them to all available devices within their broadcasting range.

	All-in-Ones, as the name suggests, provide all of this functionality (to some extent) in a compact package, capable of receiving and broadcasting signals to their own connected z-level(s).
	AIOs by default only receive and broadcast communications on their own bespoke frequency and the hailing frequency.

	The routing that radio-frequency machines take is relatively simple:

	Inbound Signal -> Receiver -> Hub -> Bus -> Processor -> Bus -> Server -> Hub -> Broadcaster
*/

/obj/machinery/telecomms
	icon = 'icons/obj/machinery/telecomms.dmi'
	density = TRUE
	anchored = TRUE
	idle_power_usage = 600 // WATTS
	active_power_usage = 2 KILOWATTS

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

	var/integrity = 100 			// basically HP, loses integrity by heat
	var/produces_heat = TRUE		//whether the machine will produce heat when on.
	var/delay = 10 					// how many process() ticks to delay per heat
	var/circuitboard = null 		// string pointing to a circuitboard type
	var/hide = FALSE				// Is it a hidden machine?

	// Overmap ranges in terms of map tile distance, used by receivers, relays, and broadcasters (and AIOs)
	var/overmap_range = 0

	///Looping sounds for any servers
//	var/datum/looping_sound/server/soundloop


/obj/machinery/telecomms/Initialize(mapload)
	. = ..()
//	soundloop = new(list(src), on)
	SSmachinery.all_telecomms += src

	if(mapload)
		return INITIALIZE_HINT_LATELOAD

/obj/machinery/telecomms/LateInitialize()
	if(current_map.use_overmap && !linked)
		var/my_sector = map_sectors["[z]"]
		if (istype(my_sector, /obj/effect/overmap/visitable))
			attempt_hook_up(my_sector)

	if(autolinkers.len)
		for(var/obj/machinery/telecomms/T in SSmachinery.all_telecomms)
			if(T != src && (T.z in GetConnectedZlevels(z)))
				add_automatic_link(T)

/obj/machinery/telecomms/Destroy()
//	QDEL_NULL(soundloop)
	SSmachinery.all_telecomms -= src
	for(var/obj/machinery/telecomms/comm in SSmachinery.all_telecomms)
		remove_link(comm)
	links = list()
	return ..()

// This proc returns distance, so -1 is our error value
/obj/machinery/telecomms/proc/receive_range(datum/signal/subspace/sig)
	if(!use_power || !istype(sig) || !is_freq_listening(sig))
		return -1

	return get_signal_dist(sig)

/obj/machinery/telecomms/proc/broadcast_levels(datum/signal/subspace/sig)
	if(!use_power || !istype(sig) || !is_freq_listening(sig))
		return

	. = GetConnectedZlevels(z)
	if(current_map.use_overmap && linked)
		for(var/obj/effect/overmap/visitable/V in range(overmap_range, linked))
			. |= V.map_z

// Used in auto linking
/obj/machinery/telecomms/proc/add_automatic_link(var/obj/machinery/telecomms/T)
	if(src == T)
		return

	for(var/autolinker_id in autolinkers)
		if(autolinker_id in T.autolinkers)
			add_new_link(T)
			return

/obj/machinery/telecomms/update_icon()
	var/state = construct_op ? "[initial(icon_state)]_o" : initial(icon_state)
	if(!use_power)
		state += "_off"

	icon_state = state

/obj/machinery/telecomms/process()
	if(!use_power) return PROCESS_KILL
	if(inoperable(EMPED))
		toggle_power(additional_flags = EMPED)
		return PROCESS_KILL

	// Check heat and generate some
	check_heat()
	traffic = max(0, traffic - netspeed)

	if(traffic > 0)
		toggle_power(POWER_USE_ACTIVE)
	else if(use_power != POWER_USE_IDLE)
		toggle_power(POWER_USE_IDLE)

/obj/machinery/telecomms/toggle_power(power_set, additional_flags = 0)
	. = ..()
	if(use_power)
		START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
	else
		STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

/obj/machinery/telecomms/emp_act(severity)
	. = ..()
	if(stat & EMPED || !prob(100/severity))
		return
	stat |= EMPED
	addtimer(CALLBACK(src, PROC_REF(post_emp_act)), (300 SECONDS) / severity)

/obj/machinery/telecomms/proc/post_emp_act()
	stat &= ~EMPED
	toggle_power(POWER_USE_IDLE)

/obj/machinery/telecomms/proc/check_heat()
	// Checks heat from the environment and applies any integrity damage
	if(!loc) return
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
	else if(use_power)
		produce_heat()
		delay = initial(delay)

/obj/machinery/telecomms/proc/produce_heat()
	if (!produces_heat || !use_power || inoperable(EMPED))
		return

	var/turf/simulated/L = loc
	if(!istype(L))
		return

	var/datum/gas_mixture/env = L.return_air()
	var/transfer_moles = 0.25 * env.total_moles
	var/datum/gas_mixture/removed = env.remove(transfer_moles)

	if(!removed)
		return

	var/heat_produced = get_power_usage()	//obviously can't produce more heat than the machine draws from it's power source
	if (use_power < POWER_USE_ACTIVE)
		heat_produced *= 0.30	//if idle, produce less heat.

	removed.add_thermal_energy(heat_produced)
	env.merge(removed)

// relay signal to all linked machinery that are of type [filter]. If signal has been sent [amount] times, stop sending
/obj/machinery/telecomms/proc/relay_information(datum/signal/subspace/signal, filter, copysig, amount = 20)
	if(!use_power)
		return

	if(!filter || !ispath(filter, /obj/machinery/telecomms))
		CRASH("null or non /obj/machinery/telecomms typepath given as the filter argument! given typepath: [filter]")

	var/send_count = 0

	if(integrity < 100)
		signal.data["slow"] += rand(0, round((100-integrity))) // apply some lag based on integrity

	// Loop through all linked machines and send the signal or copy.
	for(var/obj/machinery/telecomms/filtered_machine in links_by_telecomms_type?[filter])
		if(!filtered_machine.use_power || !(z in GetConnectedZlevels(filtered_machine.z)))
			continue

		if(amount && send_count >= amount)
			break

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
	if(use_power)
		machine.receive_information(signal, src)

// receive information from linked machinery
/obj/machinery/telecomms/proc/receive_information(datum/signal/signal, obj/machinery/telecomms/machine_from)
	return

/obj/machinery/telecomms/proc/is_freq_listening(datum/signal/signal)
	// return TRUE if found, FALSE if not found
	return signal && (!freq_listening.len || (signal.frequency in freq_listening))

// Reception range of telecomms machines is limited via overmap_range
// Returns distance, not a boolean value, so don't do !get_reception or so help me god
/obj/machinery/telecomms/proc/get_signal_dist(datum/signal/subspace/signal)
	if(!current_map.use_overmap || !istype(linked) || !istype(signal.sector))
		if(z == signal.origin_level || (signal.origin_level in GetConnectedZlevels(z)))
			return 1
		else
			return -1

	if (signal.sector == linked)
		return 0

	var/overmap_dist = get_dist(signal.sector, linked)
	if (overmap_dist > overmap_range)
		return -1
	return overmap_dist
