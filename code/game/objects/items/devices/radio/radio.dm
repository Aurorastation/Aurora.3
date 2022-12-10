// Access check is of the type "req_one_access".
// These have been carefully selected to avoid allowing anyone with generic departmental access to see channels they should not.
var/global/list/default_internal_channels = list(
	num2text(PUB_FREQ) = list(),
	num2text(ENT_FREQ) = list(),
	num2text(AI_FREQ)  = list(access_equipment),
	num2text(ERT_FREQ) = list(access_cent_specops),
	num2text(COMM_FREQ)= list(access_heads),
	num2text(ENG_FREQ) = list(access_engine_equip, access_atmospherics),
	num2text(MED_FREQ) = list(access_medical_equip),
	num2text(MED_I_FREQ)=list(access_medical_equip),
	num2text(SEC_FREQ) = list(access_security),
	num2text(SEC_I_FREQ)=list(access_security),
	num2text(PEN_FREQ) = list(access_armory),
	num2text(SCI_FREQ) = list(access_tox,access_robotics,access_xenobiology,access_xenobotany),
	num2text(SUP_FREQ) = list(access_cargo),
	num2text(SRV_FREQ) = list(access_janitor, access_hydroponics)
)

var/global/list/default_medbay_channels = list(
	num2text(PUB_FREQ) = list(),
	num2text(MED_FREQ) = list(access_medical_equip),
	num2text(MED_I_FREQ) = list(access_medical_equip)
)

//
// Radios
//

/obj/item/device/radio
	icon = 'icons/obj/radio.dmi'
	name = "station bounced radio"
	var/radio_desc = ""
	suffix = "\[3\]"
	icon_state = "walkietalkie"
	item_state = "radio"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	throw_speed = 2
	throw_range = 9
	w_class = ITEMSIZE_SMALL
	matter = list(DEFAULT_WALL_MATERIAL = 75, MATERIAL_GLASS = 25)
	var/const/FREQ_LISTENING = TRUE
	var/list/internal_channels
	var/clicksound = /decl/sound_category/button_sound //played sound on usage
	var/clickvol = 10 //volume

	var/obj/item/cell/cell = /obj/item/cell/device
	var/last_radio_sound = -INFINITY

	// If FALSE, broadcasting and listening don't matter and this radio does nothing
	VAR_PRIVATE/on = TRUE

	VAR_PRIVATE/frequency = PUB_FREQ // Current frequency the radio is set to
	var/default_frequency = PUB_FREQ // frequency the radio defaults to on reset / startup

	// Whether the radio transmits dialogue it hears nearby onto its radio channel
	VAR_PRIVATE/broadcasting = FALSE
	// Whether the radio is currently receiving radio messages from its frequencies
	VAR_PRIVATE/listening = TRUE

	//the below vars are used to track listening and broadcasting should they be forced off for whatever reason but "supposed" to be active
	//eg player sets the radio to listening, but an emp or whatever turns it off, its still supposed to be activated but was forced off,
	//when it wears off it sets listening to should_be_listening

	///used for tracking what broadcasting should be in the absence of things forcing it off, eg its set to broadcast but gets emp'd temporarily
	var/should_be_broadcasting = FALSE
	///used for tracking what listening should be in the absence of things forcing it off, eg its set to listen but gets emp'd temporarily
	var/should_be_listening = TRUE

	/// Both the range around the radio in which mobs can hear what it receives and the range the radio can hear
	var/canhear_range = 3

	var/last_transmission
	var/traitor_frequency = 0 //tune to frequency to unlock traitor supplies
	var/mob/living/announcer/announcer = null // used in autosay, held by the radio for re-use
	var/datum/wires/radio/wires = null
	var/b_stat = 0

	var/list/channels = list() //see communications.dm for full list. First non-common, non-entertainment channel is a "default" for :h
	var/subspace_transmission = FALSE
	var/syndie = FALSE //Holder to see if it's a syndicate encrypted radio
	var/independent = FALSE // if TRUE, can say/hear on the Special Channel!!! (TBD)

	var/datum/radio_frequency/radio_connection
	var/list/datum/radio_frequency/secure_radio_connections = list()

/obj/item/device/radio/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = SSradio.add_object(src, frequency, RADIO_CHAT)

/obj/item/device/radio/Initialize()
	. = ..()

	wires = new(src)
	internal_channels = default_internal_channels.Copy()
	become_hearing_sensitive(ROUNDSTART_TRAIT)

	if(frequency < RADIO_LOW_FREQ || frequency > RADIO_HIGH_FREQ)
		frequency = sanitize_frequency(frequency, RADIO_LOW_FREQ, RADIO_HIGH_FREQ)

	for (var/ch_name in channels)
		secure_radio_connections[ch_name] = SSradio.add_object(src, radiochannels[ch_name],  RADIO_CHAT)

	set_listening(listening)
	set_broadcasting(broadcasting)
	set_frequency(default_frequency)
	set_on(on)

/obj/item/device/radio/Destroy()
	SSradio.remove_object_all(src)
	QDEL_NULL(announcer)
	QDEL_NULL(wires)
	return ..()

/obj/item/device/radio/proc/is_on()
	return on

/obj/item/device/radio/proc/get_frequency()
	return frequency

/obj/item/device/radio/proc/get_broadcasting()
	return broadcasting

/obj/item/device/radio/proc/get_listening()
	return listening

/**
 * setter for the listener var, adds or removes this radio from the global radio list if we are also on
 *
 * * new_listening - the new value we want to set listening to
 * * actual_setting - whether or not the radio is supposed to be listening, sets should_be_listening to the new listening value if true, otherwise just changes listening
 */
/obj/item/device/radio/proc/set_listening(new_listening, actual_setting = TRUE)

	listening = new_listening
	if(actual_setting)
		should_be_listening = listening

	if(listening && on)
		SSradio.add_object(src, frequency, RADIO_CHAT)
	else if(!listening)
		SSradio.remove_object_all(src)

/**
 * setter for broadcasting that makes us not hearing sensitive if not broadcasting and hearing sensitive if broadcasting
 * hearing sensitive in this case only matters for the purposes of listening for words said in nearby tiles, talking into us directly bypasses hearing
 *
 * * new_broadcasting- the new value we want to set broadcasting to
 * * actual_setting - whether or not the radio is supposed to be broadcasting, sets should_be_broadcasting to the new value if true, otherwise just changes broadcasting
 */
/obj/item/device/radio/proc/set_broadcasting(new_broadcasting, actual_setting = TRUE)

	broadcasting = new_broadcasting
	if(actual_setting)
		should_be_broadcasting = broadcasting

	if(broadcasting && on) //we dont need hearing sensitivity if we arent broadcasting, because talk_into doesnt care about hearing
		become_hearing_sensitive(INNATE_TRAIT)
	else if(!broadcasting)
		lose_hearing_sensitivity(INNATE_TRAIT)

///setter for the on var that sets both broadcasting and listening to off or whatever they were supposed to be
/obj/item/device/radio/proc/set_on(new_on)

	on = new_on

	if(on)
		set_broadcasting(should_be_broadcasting)//set them to whatever theyre supposed to be
		set_listening(should_be_listening)
	else
		set_broadcasting(FALSE, actual_setting = FALSE)//fake set them to off
		set_listening(FALSE, actual_setting = FALSE)

/obj/item/device/radio/attack_self(mob/user as mob)
	user.set_machine(src)
	interact(user)

/obj/item/device/radio/interact(mob/user)
	if(!user)
		return 0

	if(b_stat)
		wires.Interact(user)

	return ui_interact(user)

/obj/item/device/radio/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]

	data["mic_status"] = broadcasting
	data["speaker"] = listening
	data["freq"] = format_frequency(frequency)
	data["default_freq"] = format_frequency(default_frequency)
	data["rawfreq"] = num2text(frequency)

	data["mic_cut"] = (wires.IsIndexCut(WIRE_TRANSMIT) || wires.IsIndexCut(WIRE_SIGNAL))
	data["spk_cut"] = (wires.IsIndexCut(WIRE_RECEIVE) || wires.IsIndexCut(WIRE_SIGNAL))

	var/list/chanlist = list_channels(user)
	if(islist(chanlist) && chanlist.len)
		data["chan_list"] = chanlist
		data["chan_list_len"] = chanlist.len

	if(syndie)
		data["useSyndMode"] = 1

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "radio_basic.tmpl", "[name]", 400, 430)
		ui.set_initial_data(data)
		ui.open()

/obj/item/device/radio/proc/setupRadioDescription(var/additional_radio_desc)
	var/radio_text = ""
	var/found_first_department = FALSE
	for(var/i = 1 to channels.len)
		var/channel = channels[i]
		var/key = get_radio_key_from_channel(channel)
		if(!length(key) && !found_first_department && channel != CHANNEL_COMMON && channel != CHANNEL_ENTERTAINMENT)
			// if we don't have a key and it's the 'shortcut' channel, put the department key instead
			key = get_radio_key_from_channel("department")
			found_first_department = TRUE

		radio_text += "[key] - [channel]"
		if(i != channels.len)
			radio_text += ", "

	radio_desc = radio_text
	if(additional_radio_desc)
		radio_desc += additional_radio_desc

/obj/item/device/radio/proc/list_channels(var/mob/user)
	return list_internal_channels(user)

/obj/item/device/radio/proc/list_secure_channels(var/mob/user)
	var/dat[0]

	for(var/ch_name in channels)
		var/chan_stat = channels[ch_name]
		var/listening = !!(chan_stat & FREQ_LISTENING) != 0

		dat.Add(list(list("chan" = ch_name, "display_name" = ch_name, "secure_channel" = 1, "sec_channel_listen" = !listening, "chan_span" = frequency_span_class(radiochannels[ch_name]))))

	return dat

/obj/item/device/radio/proc/list_internal_channels(var/mob/user)
	var/dat[0]
	for(var/internal_chan in internal_channels)
		if(has_channel_access(user, internal_chan))
			dat.Add(list(list("chan" = internal_chan, "display_name" = get_frequency_name(text2num(internal_chan)), "chan_span" = frequency_span_class(text2num(internal_chan)))))

	return dat

/obj/item/device/radio/proc/has_channel_access(var/mob/user, var/freq)
	if(!user)
		return 0

	if(!(freq in internal_channels))
		return 0

	return user.has_internal_radio_channel_access(internal_channels[freq])

/mob/proc/has_internal_radio_channel_access(var/list/req_one_accesses)
	var/obj/item/card/id/I = GetIdCard()
	return has_access(list(), req_one_accesses, I ? I.GetAccess() : list())

/mob/abstract/observer/has_internal_radio_channel_access(var/list/req_one_accesses)
	return can_admin_interact()

/obj/item/device/radio/proc/text_wires()
	if (b_stat)
		return wires.GetInteractWindow()
	return


/obj/item/device/radio/proc/text_sec_channel(var/chan_name, var/chan_stat)
	var/list = !!(chan_stat&FREQ_LISTENING)!=0
	return {"
			<B>[chan_name]</B><br>
			Speaker: <A href='byond://?src=\ref[src];ch_name=[chan_name];listen=[!list]'>[list ? "Engaged" : "Disengaged"]</A><BR>
			"}

/obj/item/device/radio/CanUseTopic()
	if(!on)
		return STATUS_CLOSE
	return ..()

/obj/item/device/radio/CouldUseTopic(var/mob/user)
	..()
	if(clicksound && iscarbon(user))
		playsound(loc, clicksound, clickvol)

/obj/item/device/radio/Topic(href, href_list)
	if(..())
		return TRUE

	usr.set_machine(src)
	if (href_list["track"])
		var/mob/target = locate(href_list["track"])
		var/mob/living/silicon/ai/A = locate(href_list["track2"])
		if(A && target)
			A.ai_actual_track(target)
		. = TRUE

	else if (href_list["freq"])
		var/new_frequency = (frequency + text2num(href_list["freq"]))
		if ((new_frequency < PUBLIC_LOW_FREQ || new_frequency > PUBLIC_HIGH_FREQ))
			new_frequency = sanitize_frequency(new_frequency)
		set_frequency(new_frequency)
		if(hidden_uplink)
			if(hidden_uplink.check_trigger(usr, frequency, traitor_frequency))
				usr << browse(null, "window=radio")
		. = TRUE
	else if (href_list["talk"])
		set_broadcasting(!broadcasting)
		. = TRUE
	else if (href_list["listen"])
		var/chan_name = href_list["ch_name"]
		if (!chan_name)
			set_listening(!listening)
		else
			if (channels[chan_name] & FREQ_LISTENING)
				channels[chan_name] &= ~FREQ_LISTENING
			else
				channels[chan_name] |= FREQ_LISTENING
		. = TRUE
	else if(href_list["spec_freq"])
		var freq = href_list["spec_freq"]
		if(has_channel_access(usr, freq))
			set_frequency(text2num(freq))
		. = TRUE
	else if(href_list["reset_freq"])
		if(default_frequency)
			set_frequency(default_frequency)
			. = TRUE

	if(href_list["nowindow"]) // here for pAIs, maybe others will want it, idk
		return TRUE

	if(.)
		SSnanoui.update_uis(src)
		update_icon()

/obj/item/device/radio/proc/autosay(var/message, var/from, var/channel) //BS12 EDIT
	var/datum/radio_frequency/connection = null
	if(channel && channels && channels.len > 0)
		if(channel == "department")
			for(var/freq in channels)
				if(freq == "Common" || freq == "Entertainment")
					continue
				channel = freq
				break
			if(channel == "department") // didn't find one, use first one
				channel = channels[1]
		connection = secure_radio_connections[channel]
	else
		connection = radio_connection
		channel = null

	if (!istype(connection))
		return

	if(!istype(announcer))
		announcer = new()

	announcer.PrepareBroadcast(from)
	var/datum/weakref/speaker_weakref = WEAKREF(announcer)
	var/datum/signal/subspace/vocal/signal = new(src, frequency, speaker_weakref, announcer.default_language, message, "states")
	signal.send_to_receivers()
	announcer.ResetAfterBroadcast()

// Interprets the message mode when talking into a radio, possibly returning a connection datum
/obj/item/device/radio/proc/handle_message_mode(mob/living/M as mob, message, message_mode)
	// If a channel isn't specified, send to common.
	if(!message_mode || message_mode == "headset")
		return radio_connection

	// Otherwise, if a channel is specified, look for it.
	if(channels && channels.len > 0)
		if(message_mode == "department") // Department radio shortcut
			for(var/freq in channels)
				if(freq == "Common" || freq == "Entertainment")
					continue
				message_mode = freq
				break
			if(message_mode == "department") // didn't find one, use first one
				message_mode = channels[1]
		if (channels[message_mode]) // only broadcast if the channel is set on
			return secure_radio_connections[message_mode]

	// If we were to send to a channel we don't have, drop it.
	return null

/obj/item/device/radio/talk_into(mob/living/M, message, channel, var/say_verb = "says", var/datum/language/speaking = null, var/ignore_restrained)
	if(!on)
		return FALSE
	if(!M || !message)
		return FALSE
	if(wires.IsIndexCut(WIRE_TRANSMIT)) // The device has to have all its wires and shit intact
		return FALSE

	if (iscarbon(M))
		var/mob/living/carbon/C = M
		if ((CE_UNDEXTROUS in C.chem_effects) || C.stunned >= 10)
			to_chat(M, SPAN_WARNING("You can't move your arms enough to activate the radio..."))
			return
		if(iszombie(M))
			to_chat(M, SPAN_WARNING("Try as you might, you cannot will your decaying body into operating \the [src]."))
			return FALSE

	if(istype(M))
		if(M.restrained() && !ignore_restrained)
			to_chat(M, SPAN_WARNING("You can't speak into \the [src.name] while restrained."))
			return FALSE
		M.trigger_aiming(TARGET_CAN_RADIO)

	if(!radio_connection)
		set_frequency(frequency)

	if(loc == M)
		playsound(loc, 'sound/effects/walkietalkie.ogg', 5, 0, -1, required_asfx_toggles = ASFX_RADIO)

	/*
		Roughly speaking, radios attempt to make a subspace transmission (which
		is received, processed, and rebroadcast by the telecomms satellite) and
		if that fails, they send a mundane radio transmission.
		Headsets cannot send/receive mundane transmissions, only subspace.
		Syndicate radios can hear transmissions on all well-known frequencies.
		CentCom radios can hear the CentCom frequency no matter what.
	*/

	// Get the frequency
	var/datum/radio_frequency/connection = handle_message_mode(M, message, channel)
	if (!istype(connection))
		return FALSE

	// Determine the identify information attached to the signal
	var/datum/weakref/speaker_weakref = WEAKREF(M)
	var/datum/signal/subspace/vocal/signal = new(src, connection.frequency, speaker_weakref, speaking, message, say_verb)

	// All radios attempt to use the subspace system
	. = signal.send_to_receivers()

	// If it's subspace only, that's all we can do
	if(subspace_transmission)
		return

	// Non-subspace radios will check in a couple of seconds, and if the signal was never received, we send a mundane broadcast
	addtimer(CALLBACK(src, .proc/backup_transmission, signal), 2 SECONDS)

/obj/item/device/radio/proc/backup_transmission(datum/signal/subspace/vocal/signal)
	var/turf/T = get_turf(src)
	if (signal.data["done"] && (T.z in signal.levels))
		return

	// If we're here, the signal was never processed. Proceed with mundane broadcast:
	signal.data["compression"] = 0
	signal.transmission_method = TRANSMISSION_RADIO
	signal.levels = list(T.z)
	signal.broadcast()

/obj/item/device/radio/hear_talk(mob/M as mob, msg, var/verb = "says", var/datum/language/speaking = null)
	if (!broadcasting || get_dist(src, M) > canhear_range)
		return

	return talk_into(M, msg, null, verb, speaking, ignore_restrained = TRUE)

/obj/item/device/radio/proc/can_receive(input_frequency, list/levels)
	// check if the radio can receive on the given frequency
	if (levels != RADIO_NO_Z_LEVEL_RESTRICTION)
		var/turf/position = get_turf(src)
		if (!position || !(position.z in levels))
			return FALSE

	if (within_jamming_range(src))
		return FALSE

	if ((input_frequency in ANTAG_FREQS) && !syndie) //Checks to see if it's allowed on that frequency, based on the encryption keys
		return FALSE

	if (input_frequency == frequency)
		return TRUE

	for (var/ch_name in channels)
		var/datum/radio_frequency/RF = secure_radio_connections[ch_name]
		if (RF.frequency == input_frequency && (channels[ch_name] & FREQ_LISTENING))
			return TRUE

	return FALSE

/obj/item/device/radio/proc/send_hear(freq, level)
	if(!can_receive(freq, level))
		return

	return get_hearers_in_view(canhear_range, src)


/obj/item/device/radio/examine(mob/user)
	. = ..()
	if ((in_range(src, user) || loc == user))
		if (b_stat)
			user.show_message("<span class='notice'>\The [src] can be attached and modified!</span>")
		else
			user.show_message("<span class='notice'>\The [src] can not be modified or attached!</span>")
	return

/obj/item/device/radio/attackby(obj/item/W as obj, mob/user as mob)
	..()
	user.set_machine(src)
	if (!( W.isscrewdriver() ))
		return
	b_stat = !( b_stat )
	if(!istype(src, /obj/item/device/radio/beacon))
		if (b_stat)
			user.show_message("<span class='notice'>\The [src] can now be attached and modified!</span>")
		else
			user.show_message("<span class='notice'>\The [src] can no longer be modified or attached!</span>")
		updateDialog()
			//Foreach goto(83)
		add_fingerprint(user)
		return
	else return

/obj/item/device/radio/emp_act(severity)
	set_broadcasting(FALSE)
	set_listening(FALSE)
	for (var/ch_name in channels)
		channels[ch_name] = 0
	..()

//
// Vesselbound Synthetic Radio
//

/obj/item/device/radio/borg
	var/mob/living/silicon/robot/myborg = null // Cyborg which owns this radio. Used for power checks
	var/obj/item/device/encryptionkey/keyslot = null//Borg radios can handle a single encryption key
	var/shut_up = 1
	icon = 'icons/obj/robot_component.dmi' // Cyborgs radio icons should look like the component.
	icon_state = "radio"
	canhear_range = 0
	subspace_transmission = 1
	name = "integrated radio"
	var/radio_sound = null

/obj/item/device/radio/borg/Destroy()
	myborg = null
	return ..()

/obj/item/device/radio/borg/list_channels(var/mob/user)
	return list_secure_channels(user)

/obj/item/device/radio/borg/talk_into(mob/living/M, message, channel, verb, datum/language/speaking, var/ignore_restrained)
	. = ..()
	if (isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		var/datum/robot_component/C = R.components["radio"]
		R.cell_use_power(C.active_usage)

/obj/item/device/radio/borg/attackby(obj/item/W as obj, mob/user as mob)
//	..()
	user.set_machine(src)
	if (!( W.isscrewdriver() || (istype(W, /obj/item/device/encryptionkey/ ))))
		return

	if(W.isscrewdriver())
		if(keyslot)


			for(var/ch_name in channels)
				SSradio.remove_object(src, radiochannels[ch_name])
				secure_radio_connections[ch_name] = null


			if(keyslot)
				var/turf/T = get_turf(user)
				if(T)
					keyslot.forceMove(T)
					keyslot = null

			recalculateChannels()
			to_chat(user, "You pop out the encryption key in the radio!")

		else
			to_chat(user, "This radio doesn't have any encryption keys!")

	if(istype(W, /obj/item/device/encryptionkey/))
		if(keyslot)
			to_chat(user, "The radio can't hold another key!")
			return

		if(!keyslot)
			user.drop_from_inventory(W,src)
			keyslot = W

		recalculateChannels()

	return

/obj/item/device/radio/borg/proc/recalculateChannels()
	channels = list(CHANNEL_COMMON = TRUE, CHANNEL_ENTERTAINMENT = TRUE)
	syndie = FALSE

	var/mob/living/silicon/robot/D = loc
	if(D.module)
		for(var/ch_name in D.module.channels)
			if(ch_name in channels)
				continue
			channels[ch_name] += D.module.channels[ch_name]
	if(keyslot)
		for(var/ch_name in keyslot.channels)
			if(ch_name in channels)
				continue
			channels += ch_name
			channels[ch_name] += keyslot.channels[ch_name]

		if(keyslot.syndie)
			syndie = TRUE

		if(keyslot.independent)
			independent = TRUE

	for(var/ch_name in src.channels)
		if(!SSradio)
			sleep(30) // Waiting for the SSradio to be created.
		if(!SSradio)
			name = "broken radio"
			return
		secure_radio_connections[ch_name] = SSradio.add_object(src, radiochannels[ch_name], RADIO_CHAT)

	setupRadioDescription()
	return

/obj/item/device/radio/borg/Topic(href, href_list)
	if(..())
		return 1
	if (href_list["mode"])
		var/enable_subspace_transmission = text2num(href_list["mode"])
		if(enable_subspace_transmission != subspace_transmission)
			subspace_transmission = !subspace_transmission
			if(subspace_transmission)
				to_chat(usr, "<span class='notice'>Subspace Transmission is enabled</span>")
			else
				to_chat(usr, "<span class='notice'>Subspace Transmission is disabled</span>")

			if(subspace_transmission == 0)//Simple as fuck, clears the channel list to prevent talking/listening over them if subspace transmission is disabled
				channels = list()
			else
				recalculateChannels()
		. = 1
	if (href_list["shutup"]) // Toggle loudspeaker mode, AKA everyone around you hearing your radio.
		var/do_shut_up = text2num(href_list["shutup"])
		if(do_shut_up != shut_up)
			shut_up = !shut_up
			if(shut_up)
				canhear_range = 0
				to_chat(usr, "<span class='notice'>Loadspeaker disabled.</span>")
			else
				canhear_range = 3
				to_chat(usr, "<span class='notice'>Loadspeaker enabled.</span>")
		. = 1

	if(.)
		SSnanoui.update_uis(src)

/obj/item/device/radio/borg/interact(mob/user as mob)
	if(!on)
		return

	. = ..()

/obj/item/device/radio/borg/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]

	data["mic_status"] = broadcasting
	data["speaker"] = listening
	data["freq"] = format_frequency(frequency)
	data["default_freq"] = format_frequency(default_frequency)
	data["rawfreq"] = num2text(frequency)

	var/list/chanlist = list_channels(user)
	if(islist(chanlist) && chanlist.len)
		data["chan_list"] = chanlist
		data["chan_list_len"] = chanlist.len

	if(syndie)
		data["useSyndMode"] = 1

	data["has_loudspeaker"] = 1
	data["loudspeaker"] = !shut_up
	data["has_subspace"] = 1
	data["subspace"] = subspace_transmission

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "radio_basic.tmpl", "[name]", 400, 430)
		ui.set_initial_data(data)
		ui.open()

/obj/item/device/radio/proc/config(op)
	if(SSradio)
		for (var/ch_name in channels)
			SSradio.remove_object(src, radiochannels[ch_name])
	secure_radio_connections = list()
	channels = op
	if(SSradio)
		for (var/ch_name in op)
			secure_radio_connections[ch_name] = SSradio.add_object(src, radiochannels[ch_name],  RADIO_CHAT)
	return

//
// Radio Variants
//

/obj/item/device/radio/map_preset
	channels = list()

/obj/item/device/radio/map_preset/Initialize()
	if(!current_map.use_overmap)
		return ..()

	var/turf/T = get_turf(src)
	var/obj/effect/overmap/visitable/V = map_sectors["[T.z]"]
	if(istype(V) && V.comms_support)
		frequency = assign_away_freq(V.name)
		channels += list(
			V.name = TRUE,
			CHANNEL_HAILING = TRUE
		)
		if(V.comms_name)
			name = "[V.comms_name] shortwave radio"

	return ..()

// Radio (Off)
/obj/item/device/radio/off/Initialize()
	. = ..()
	set_listening(FALSE)

// Medical
/obj/item/device/radio/med
	icon_state = "walkietalkie-med"

// Medical (Off)
/obj/item/device/radio/med/off/Initialize()
	. = ..()
	set_listening(FALSE)

// Security
/obj/item/device/radio/sec
	icon_state = "walkietalkie-sec"

// Security (Off)
/obj/item/device/radio/sec/off/Initialize()
	. = ..()
	set_listening(FALSE)

// Engineering
/obj/item/device/radio/eng
	icon_state = "walkietalkie-eng"

// Engineering (Off)
/obj/item/device/radio/eng/off/Initialize()
	. = ..()
	set_listening(FALSE)

// Science
/obj/item/device/radio/sci
	icon_state = "walkietalkie-sci"

// Science (Off)
/obj/item/device/radio/sci/off/Initialize()
	. = ..()
	set_listening(FALSE)

// Phone
/obj/item/device/radio/phone
	icon = 'icons/obj/radio.dmi'
	icon_state = "red_phone"
	name = "phone"
	var/radio_sound = null

/obj/item/device/radio/phone/Initialize()
	. = ..()
	set_broadcasting(FALSE)
	set_listening(TRUE)

// Medical Phone
/obj/item/device/radio/phone/medbay/Initialize()
	. = ..()
	set_frequency(MED_I_FREQ)
	internal_channels = default_medbay_channels.Copy()

// All-channel Radio
/obj/item/device/radio/all_channels/Initialize()
	channels = ALL_RADIO_CHANNELS.Copy()
	. = ..()
