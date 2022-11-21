//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/*
	The broadcaster sends processed messages to all radio devices in the game. They
	do not have to be headsets; intercoms and station-bounced radios suffice.

	They receive their message from a server after the message has been logged.
*/

var/list/recentmessages = list() // global list of recent messages broadcasted : used to circumvent massive radio spam
var/message_delay = 0 // To make sure restarting the recentmessages list is kept in sync

/obj/machinery/telecomms/broadcaster
	name = "subspace broadcaster"
	icon_state = "broadcaster"
	desc = "A dish-shaped machine used to broadcast processed subspace signals."
	telecomms_type = /obj/machinery/telecomms/broadcaster
	density = TRUE
	anchored = TRUE
	idle_power_usage = 25
	produces_heat = FALSE
	delay = 7
	circuitboard = "/obj/item/circuitboard/telecomms/broadcaster"

/obj/machinery/telecomms/broadcaster/receive_information(datum/signal/subspace/signal, obj/machinery/telecomms/machine_from)
	// Don't broadcast rejected signals
	if(!istype(signal))
		return
	if(signal.data["reject"])
		return
	if(!signal.data["message"])
		return

	// Prevents massive radio spam
	signal.mark_done()
	var/datum/signal/subspace/original = signal.original
	if(original && ("compression" in signal.data))
		original.data["compression"] = signal.data["compression"]

	var/turf/T = get_turf(src)
	if (T)
		signal.levels |= T.z

	var/signal_message = "[signal.frequency]:[signal.data["message"]]:[signal.data["realname"]]"
	if(signal_message in recentmessages)
		return
	recentmessages.Add(signal_message)

	if(signal.data["slow"] > 0)
		sleep(signal.data["slow"]) // simulate the network lag if necessary

	signal.broadcast()

	if(!message_delay)
		message_delay = 1
		spawn(10)
			message_delay = 0
			recentmessages = list()

	/* --- Do a snazzy animation! --- */
	flick("broadcaster_send", src)

/obj/machinery/telecomms/broadcaster/Destroy()
	// In case message_delay is left on 1, otherwise it won't reset the list and people can't say the same thing twice anymore.
	if(message_delay)
		message_delay = 0
	return ..()


/*
	Basically just an empty shell for receiving and broadcasting radio messages. Not
	very flexible, but it gets the job done.
*/

/obj/machinery/telecomms/allinone
	name = "telecommunications mainframe"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "comm_server"
	desc = "A compact machine used for portable subspace telecommuniations processing."
	density = 1
	anchored = 1
	use_power = POWER_USE_OFF
	idle_power_usage = 0
	produces_heat = 0
	var/intercept = FALSE // if TRUE, broadcasts all messages to syndicate channel
	var/list/listening_freqs = list()


/obj/machinery/telecomms/allinone/Initialize()
	. = ..()

	if(!listening_freqs || intercept)
		listening_freqs = ANTAG_FREQS	//Covers any updates to ANTAG_FREQS

	desc += " It has an effective broadcast range of [overmap_range] grids on the overmap."

/obj/machinery/telecomms/allinone/receive_signal(datum/signal/subspace/signal)
	if(!istype(signal) || signal.transmission_method != TRANSMISSION_SUBSPACE)
		return

	if(!on || !(z in signal.levels) || !is_freq_listening(signal))
		return

	if(!check_receive_sector(signal) && !intercept) //Too far on the overmap to receive. Antag (intercept) don't care about sector checks.
		return

	if(!(signal.frequency in listening_freqs) && !intercept)
		return

	// Decompress the signal, mark it received
	signal.data["compression"] = 0
	signal.mark_done()
	if(signal.data["slow"] > 0)
		sleep(signal.data["slow"]) // simulate the network lag if necessary

	signal.broadcast()
/obj/machinery/telecomms/allinone/ship
	listening_freqs = list(SHIP_FREQ)

//This goes on the station map so away ships can maintain radio contact.
//Regular telecomms machines cannot listen to broadcasts coming from non-station z-levels. If we did this, comms would be receiving a substantial amount of duplicated messages.
/obj/machinery/telecomms/allinone/ship/station_relay
	name = "external signal receiver"
	icon = 'icons/obj/machines/telecomms.dmi'
	icon_state = "ntnet"
	desc = "This device allows nearby third-party ships to maintain radio contact with their crew that are aboard the %STATIONNAME."
	desc_info = "This device does not need to be linked to other telecommunications equipment; it will receive and broadcast on its own. It only needs to be powered."
	use_power = POWER_USE_IDLE
	idle_power_usage = 25

/obj/machinery/telecomms/allinone/ship/station_relay/Initialize()
	. = ..()
	desc = replacetext(desc, "%STATIONNAME", current_map.station_name)

/**

	Here is the big, bad function that broadcasts a message given the appropriate
	parameters.

	@param connection:
		The datum generated in radio.dm, stored in signal.data["connection"].

	@param M:
		Reference to the mob/speaker, stored in signal.data["mob"]

	@param vmask:
		Boolean value if the mob is "hiding" its identity via voice mask, stored in
		signal.data["vmask"]

	@param vmessage:
		If specified, will display this as the message; such as "chimpering"
		for monkies if the mob is not understood. Stored in signal.data["vmessage"].

	@param radio:
		Reference to the radio broadcasting the message, stored in signal.data["radio"]

	@param message:
		The actual string message to display to mobs who understood mob M. Stored in
		signal.data["message"]

	@param name:
		The name to display when a mob receives the message. signal.data["name"]

	@param job:
		The name job to display for the AI when it receives the message. signal.data["job"]

	@param realname:
		The "real" name associated with the mob. signal.data["realname"]

	@param vname:
		If specified, will use this name when mob M is not understood. signal.data["vname"]

	@param data:
		If specified:
				1 -- Will only broadcast to intercoms
				2 -- Will only broadcast to intercoms and station-bounced radios
				3 -- Broadcast to syndicate frequency
				4 -- AI can't track down this person. Useful for imitation broadcasts where you can't find the actual mob

	@param compression:
		If 0, the signal is audible
		If nonzero, the signal may be partially inaudible or just complete gibberish.

	@param level:
		The list of Z levels that the sending radio is broadcasting to. Having 0 in the list broadcasts on all levels

	@param freq
		The frequency of the signal

**/

// Subtype of /datum/signal with additional processing information.
/datum/signal/subspace
	transmission_method = TRANSMISSION_SUBSPACE
	var/server_type = /obj/machinery/telecomms/server
	var/datum/signal/subspace/original
	var/list/levels
	var/obj/effect/overmap/visitable/sector

/datum/signal/subspace/New(data)
	src.data = data || list()
	if(current_map.use_overmap)
		sector = map_sectors["[source.z]"]

/datum/signal/subspace/proc/copy()
	var/datum/signal/subspace/copy = new
	copy.original = src
	copy.source = source
	copy.levels = levels
	copy.frequency = frequency
	copy.server_type = server_type
	copy.transmission_method = transmission_method
	copy.sector = sector
	copy.data = data.Copy()
	return copy

/datum/signal/subspace/proc/mark_done()
	var/datum/signal/subspace/current = src
	while (current)
		current.data["done"] = TRUE
		current = current.original

/datum/signal/subspace/proc/send_to_receivers()
	for(var/obj/machinery/telecomms/receiver/R in telecomms_list)
		R.receive_signal(src)
	for(var/obj/machinery/telecomms/allinone/R in telecomms_list)
		R.receive_signal(src)

/datum/signal/subspace/proc/broadcast()
	set waitfor = FALSE

// Vocal transmissions (i.e. using saycode).
// Despite "subspace" in the name, these transmissions can also be RADIO
// (intercoms and SBRs) or SUPERSPACE (CentCom).
/datum/signal/subspace/vocal
	var/datum/weakref/speaker
	var/datum/language/language

/datum/signal/subspace/vocal/New(obj/source, frequency, datum/weakref/speaker, datum/language/language, message, say_verb)
	src.source = source
	src.frequency = frequency
	src.language = language
	src.speaker = speaker

	var/turf/T = get_turf(source)
	levels = list(T.z)
	if(current_map.use_overmap)
		sector = map_sectors["[source.z]"]

	var/mob/M = speaker.resolve()

	data = list(
		"name" = M.name,
		"job" = M.job,
		"message" = message,
		"compression" = rand(35, 65),
		"language" = language,
		"say_verb" = say_verb
	)

/datum/signal/subspace/vocal/copy()
	var/datum/signal/subspace/vocal/copy = new(source, frequency, speaker, language)
	copy.original = src
	copy.data = data.Copy()
	copy.levels = levels
	return copy

// THE MEAT for making radios hear vocal transmissions.
/datum/signal/subspace/vocal/broadcast()
	set waitfor = FALSE

	var/message = copytext(data["message"], 1, MAX_BROADCAST_LEN)
	if(!message || message == "")
		return

	var/list/signal_reaches_every_z_level = levels

	if(0 in levels)
		signal_reaches_every_z_level = RADIO_NO_Z_LEVEL_RESTRICTION

	var/list/radios = list()
	switch (transmission_method)
		if (TRANSMISSION_SUBSPACE)
			// Reach any radios on the levels
			var/list/all_radios_of_our_frequency = SSradio.get_devices(frequency, RADIO_CHAT)
			radios = all_radios_of_our_frequency.Copy()

			for (var/obj/item/device/radio/subspace_radio in radios)
				if(!subspace_radio.can_receive(frequency, signal_reaches_every_z_level))
					radios -= subspace_radio

			// Syndicate radios can hear all well-known radio channels
			if(num2text(frequency) in reverseradiochannels)
				for (var/obj/item/device/radio/syndicate_radios in SSradio.get_devices(SYND_FREQ, RADIO_CHAT))
					if(syndicate_radios.can_receive(SYND_FREQ, RADIO_NO_Z_LEVEL_RESTRICTION))
						radios |= syndicate_radios

		if (TRANSMISSION_RADIO)
			// Only radios not in subspace mode
			for (var/obj/item/device/radio/non_subspace_radio in SSradio.get_devices(frequency, RADIO_CHAT))
				if(!non_subspace_radio.subspace_transmission && non_subspace_radio.can_receive(frequency, levels))
					radios += non_subspace_radio

		if (TRANSMISSION_SUPERSPACE)
			// Independent radios
			for (var/obj/item/device/radio/indie_radio in SSradio.get_devices(frequency, RADIO_CHAT))
				if(indie_radio.independent && indie_radio.can_receive(frequency, levels))
					radios += indie_radio

	var/list/receive = get_hearers_in_radio_ranges(radios)

	// Cut out admins which have radio chatter disabled
	for (var/mob/R in receive)
		if(R.client && R.client.holder && !(R.client.prefs.toggles & CHAT_RADIO))
			receive -= R

	// Add observers who have ghost radio enabled
	for (var/mob/abstract/observer/M in player_list)
		if(M.client && (M.client.prefs?.toggles & CHAT_GHOSTRADIO))
			receive |= M

	/* --- Some miscellaneous variables to format the string output --- */
	var/freq_text = get_frequency_name(frequency)

	var/part_b_extra = ""
	if(data == 3) // intercepted radio message
		part_b_extra = " <i>(Intercepted)</i>"
	var/part_a = "<span class='[frequency_span_class(frequency)]'>%ACCENT%<b>\[[freq_text]\][part_b_extra]</b> <span class='name'>" // goes in the actual output

	// --- Some more pre-message formatting ---
	var/part_b = "</span> <span class='message'></span>" // Tweaked for security headsets -- TLE
	var/part_c = "</span>"


	// --- Filter the message; place it in quotes apply a verb ---
	var/mob/M = speaker.resolve()

	var/quotedmsg = null
	if(M)
		quotedmsg = M.say_quote(message)
	else
		quotedmsg = "says, \"[message]\""

	var/compression = data["compression"]

	for (var/mob/hearer in receive)
		if(!hearer)
			crash_with("null found in the hearers list returned by the spatial grid")
			continue

		hearer.hear_radio(message, data["say_verb"], language, part_a, part_b, part_c, M, !!compression)

	// --- This following recording is intended for research and feedback in the use of department radio channels ---

	var/part_blackbox_b = "</span><b> \[[freq_text]\]</b> <span class='message'>" // Tweaked for security headsets -- TLE
	var/blackbox_msg = "[part_a][data["name"]][part_blackbox_b][quotedmsg][part_c]"

	if(istype(SSfeedback))
		switch(frequency)
			if(PUB_FREQ)
				SSfeedback.msg_common += blackbox_msg
			if(SCI_FREQ)
				SSfeedback.msg_science += blackbox_msg
			if(COMM_FREQ)
				SSfeedback.msg_command += blackbox_msg
			if(MED_FREQ)
				SSfeedback.msg_medical += blackbox_msg
			if(ENG_FREQ)
				SSfeedback.msg_engineering += blackbox_msg
			if(SEC_FREQ)
				SSfeedback.msg_security += blackbox_msg
			if(DTH_FREQ)
				SSfeedback.msg_deathsquad += blackbox_msg
			if(SYND_FREQ)
				SSfeedback.msg_syndicate += blackbox_msg
			if(RAID_FREQ)
				SSfeedback.msg_raider += blackbox_msg
			if(NINJ_FREQ)
				SSfeedback.msg_ninja += blackbox_msg
			if(BLSP_FREQ)
				SSfeedback.msg_bluespace += blackbox_msg
			if(BURG_FREQ)
				SSfeedback.msg_burglar += blackbox_msg
			if(SUP_FREQ)
				SSfeedback.msg_cargo += blackbox_msg
			if(SRV_FREQ)
				SSfeedback.msg_service += blackbox_msg
			if(SHIP_FREQ)
				SSfeedback.msg_ship += blackbox_msg
			else
				SSfeedback.messages += blackbox_msg

/proc/Broadcast_SimpleMessage(var/source, var/frequency, var/text, var/data, var/mob/M, var/compression, var/level)

  /* ###### Prepare the radio connection ###### */

	if(!M)
		var/mob/living/carbon/human/H = new
		M = H

	var/datum/radio_frequency/connection = SSradio.return_frequency(frequency)

	var/display_freq = connection.frequency

	var/list/receive = list()


	// --- Broadcast only to intercom devices ---

	if(data == 1)
		for (var/obj/item/device/radio/intercom/R in connection.devices["[RADIO_CHAT]"])
			var/turf/position = get_turf(R)
			if(position && position.z == level)
				receive |= R.send_hear(display_freq, level)


	// --- Broadcast only to intercoms and station-bounced radios ---

	else if(data == 2)
		for (var/obj/item/device/radio/R in connection.devices["[RADIO_CHAT]"])

			if(istype(R, /obj/item/device/radio/headset))
				continue
			var/turf/position = get_turf(R)
			if(position && position.z == level)
				receive |= R.send_hear(display_freq)


	// --- Broadcast to antag radios! ---

	else if(data == 3)
		for(var/freq in ANTAG_FREQS)
			var/datum/radio_frequency/antag_connection = SSradio.return_frequency(freq)
			for (var/obj/item/device/radio/R in antag_connection.devices["[RADIO_CHAT]"])
				var/turf/position = get_turf(R)
				if(position && position.z == level)
					receive |= R.send_hear(freq)


	// --- Broadcast to ALL radio devices ---

	else
		for (var/obj/item/device/radio/R in connection.devices["[RADIO_CHAT]"])
			var/turf/position = get_turf(R)
			if(position && position.z == level)
				receive |= R.send_hear(display_freq)


  /* ###### Organize the receivers into categories for displaying the message ###### */

	// Understood the message:
	var/list/heard_normal 	= list() // normal message

	// Did not understand the message:
	var/list/heard_garbled	= list() // garbled message (ie "f*c* **u, **i*er!")
	var/list/heard_gibberish= list() // completely screwed over message (ie "F%! (O*# *#!<>&**%!")

	for (var/mob/R in receive)

	  /* --- Loop through the receivers and categorize them --- */

		if (R.client)
			if(R.client.prefs)
				if(!(R.client.prefs.toggles & CHAT_RADIO)) //Adminning with 80 people on can be fun when you're trying to talk and all you can hear is radios.
					continue
			else
				log_debug("Client prefs found to be null in /proc/Broadcast_SimpleMessage() for mob [R] and client [R.ckey], this should be investigated.")


		// --- Check for compression ---
		if(compression > 0)

			heard_gibberish += R
			continue

		// --- Can understand the speech ---

		if (R.say_understands(M))

			heard_normal += R

		// --- Can't understand the speech ---

		else
			// - Just display a garbled message -

			heard_garbled += R


  /* ###### Begin formatting and sending the message ###### */
	if (length(heard_normal) || length(heard_garbled) || length(heard_gibberish))

	  /* --- Some miscellaneous variables to format the string output --- */
		var/part_a = "<span class='[frequency_span_class(display_freq)]'><span class='name'>" // goes in the actual output
		var/freq_text = get_frequency_name(display_freq)

		// --- Some more pre-message formatting ---

		var/part_b_extra = ""
		if(data == 3) // intercepted radio message
			part_b_extra = " <i>(Intercepted)</i>"

		var/part_b = "</span><b> \[[freq_text]\][part_b_extra]</b> <span class='message'>" // Tweaked for security headsets -- TLE
		var/part_blackbox_b = "</span><b> \[[freq_text]\]</b> <span class='message'>" // Tweaked for security headsets -- TLE
		var/part_c = "</span></span>"

		var/blackbox_msg = "[part_a][source][part_blackbox_b]\"[text]\"[part_c]"

		//BR.messages_admin += blackbox_admin_msg
		if(istype(blackbox))
			switch(display_freq)
				if(PUB_FREQ)
					SSfeedback.msg_common += blackbox_msg
				if(SCI_FREQ)
					SSfeedback.msg_science += blackbox_msg
				if(COMM_FREQ)
					SSfeedback.msg_command += blackbox_msg
				if(MED_FREQ)
					SSfeedback.msg_medical += blackbox_msg
				if(ENG_FREQ)
					SSfeedback.msg_engineering += blackbox_msg
				if(SEC_FREQ)
					SSfeedback.msg_security += blackbox_msg
				if(DTH_FREQ)
					SSfeedback.msg_deathsquad += blackbox_msg
				if(SYND_FREQ)
					SSfeedback.msg_syndicate += blackbox_msg
				if(RAID_FREQ)
					SSfeedback.msg_raider += blackbox_msg
				if(NINJ_FREQ)
					SSfeedback.msg_ninja += blackbox_msg
				if(BLSP_FREQ)
					SSfeedback.msg_bluespace += blackbox_msg
				if(BURG_FREQ)
					SSfeedback.msg_burglar += blackbox_msg
				if(SUP_FREQ)
					SSfeedback.msg_cargo += blackbox_msg
				if(SRV_FREQ)
					SSfeedback.msg_service += blackbox_msg
				if(SHIP_FREQ)
					SSfeedback.msg_ship += blackbox_msg
				else
					SSfeedback.messages += blackbox_msg

		//End of research and feedback code.

	 /* ###### Send the message ###### */

		/* --- Process all the mobs that heard the voice normally (understood) --- */

		if (length(heard_normal))
			var/rendered = "[part_a][source][part_b]\"[text]\"[part_c]"

			for (var/mob/R in heard_normal)
				R.show_message(rendered, 2)

		/* --- Process all the mobs that heard a garbled voice (did not understand) --- */
			// Displays garbled message (ie "f*c* **u, **i*er!")

		if (length(heard_garbled))
			var/quotedmsg = "\"[stars(text)]\""
			var/rendered = "[part_a][source][part_b][quotedmsg][part_c]"

			for (var/mob/R in heard_garbled)
				R.show_message(rendered, 2)


		/* --- Complete gibberish. Usually happens when there's a compressed message --- */

		if (length(heard_gibberish))
			var/quotedmsg = "\"[Gibberish(text, compression + 50)]\""
			var/rendered = "[part_a][Gibberish(source, compression + 50)][part_b][quotedmsg][part_c]"

			for (var/mob/R in heard_gibberish)
				R.show_message(rendered, 2)

//Use this to test if an obj can communicate with a Telecommunications Network

/atom/proc/test_telecomms()
	var/datum/signal/signal = src.telecomms_process()
	var/turf/position = get_turf(src)
	return (position.z in signal.data["level"] && signal.data["done"])

/atom/proc/telecomms_process(var/do_sleep = 1)

	// First, we want to generate a new radio signal
	var/datum/signal/signal = new
	signal.transmission_method = TRANSMISSION_SUBSPACE
	var/turf/pos = get_turf(src)

	// --- Finally, tag the actual signal with the appropriate values ---
	signal.data = list(
		"slow" = 0, // how much to sleep() before broadcasting - simulates net lag
		"message" = "TEST",
		"compression" = rand(45, 50), // If the signal is compressed, compress our message too.
		"traffic" = 0, // dictates the total traffic sum that the signal went through
		"type" = 4, // determines what type of radio input it is: test broadcast
		"reject" = 0,
		"done" = 0,
		"level" = pos.z // The level it is being broadcasted at.
	)
	signal.frequency = PUB_FREQ// Common channel

  //#### Sending the signal to all subspace receivers ####//
	for(var/obj/machinery/telecomms/receiver/R in telecomms_list)
		R.receive_signal(signal)

	if(do_sleep)
		sleep(rand(10,25))

	//world.log <<  "Level: [signal.data["level"]] - Done: [signal.data["done"]]"

	return signal

/proc/telecomms_process_active(var/level = 5)

	// First, we want to generate a new radio signal
	var/datum/signal/signal = new
	signal.transmission_method = TRANSMISSION_SUBSPACE

	// --- Finally, tag the actual signal with the appropriate values ---
	signal.data = list(
		"slow" = 0, // how much to sleep() before broadcasting - simulates net lag
		"message" = "TEST",
		"compression" = rand(45, 50), // If the signal is compressed, compress our message too.
		"traffic" = 0, // dictates the total traffic sum that the signal went through
		"type" = 4, // determines what type of radio input it is: test broadcast
		"reject" = 0,
		"done" = 0,
		"level" = level // The level it is being broadcasted at.
	)
	signal.frequency = PUB_FREQ// Common channel

  //#### Sending the signal to all subspace receivers ####//
	for(var/obj/machinery/telecomms/receiver/R in telecomms_list)
		R.receive_signal(signal)

	return signal
