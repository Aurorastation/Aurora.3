// Subtype of /datum/signal with additional processing information.
/datum/signal/subspace
	transmission_method = TRANSMISSION_SUBSPACE
	var/server_type = /obj/machinery/telecomms/server
	var/datum/signal/subspace/original
	var/origin_level
	var/list/levels
	var/obj/effect/overmap/visitable/sector

/datum/signal/subspace/New(obj/source, frequency, message = "", data = null)
	src.source = source
	src.frequency = frequency
	var/turf/T = get_turf(source)
	if(isturf(T))
		origin_level = T.z

	if(data)
		src.data = data
	else
		src.data = list(
			"compression" = rand(35, 65),
			"message" = message
			)

	if(current_map.use_overmap && istype(source))
		sector = map_sectors["[source.z]"]

/datum/signal/subspace/proc/copy()
	var/datum/signal/subspace/copy = new
	copy.original = src
	copy.source = source
	copy.levels = levels
	copy.origin_level = origin_level
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
	if(!source.loc)
		// It's an announcer message, just send it to the horizon's receiver
		for(var/obj/machinery/telecomms/receiver/R in SSmachinery.all_receivers)
			if(R.z in current_map.station_levels)
				R.receive_signal(src)
				return TRUE

	var/closest_range = 999999
	var/list/candidates = list()
	var/obj/machinery/telecomms/selected_receiver
	var/t_range = -1

	for(var/obj/machinery/telecomms/R in SSmachinery.all_receivers)
		t_range = R.receive_range(src)
		if(t_range <= -1)
			continue

		if(t_range < closest_range)
			candidates = list(R)
			closest_range = t_range
		else if(t_range == closest_range)
			candidates |= R

	if(!length(candidates))
		return

	if(length(candidates) > 1)
		// Unlikely we ever have two receivers at the same distance listening to one frequency, but still
		closest_range = 128 // get_dist returns 127 max
		t_range = -1
		for(var/obj/machinery/telecomms/R in candidates)
			t_range = get_dist(R, source)
			if(t_range < closest_range)
				selected_receiver = R
				closest_range = t_range
				continue

	else
		selected_receiver = candidates[1]

	selected_receiver.receive_signal(src)
	return TRUE

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
	if(isturf(T))
		origin_level = T.z
		levels = list(T.z)
		if(current_map.use_overmap)
			sector = map_sectors["[T.z]"]
	else // if the source is in nullspace, it's probably an autosay
		levels = current_map.station_levels
		origin_level = levels[1]
		sector = map_sectors["[levels[1]]"]

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

	var/message = copytext(data["message"], 1, MAX_MESSAGE_LEN)
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

			// Cool antag radios can hear all Horizon comms
			for (var/antag_freq in list(SYND_FREQ, RAID_FREQ, NINJ_FREQ))
				for (var/obj/item/device/radio/syndicate_radios in SSradio.get_devices(antag_freq, RADIO_CHAT))
					if(syndicate_radios.can_receive(antag_freq, signal_reaches_every_z_level))
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
			else
				if(frequency in AWAY_FREQS_ASSIGNED)
					SSfeedback.msg_ship += blackbox_msg
				else
					SSfeedback.messages += blackbox_msg
