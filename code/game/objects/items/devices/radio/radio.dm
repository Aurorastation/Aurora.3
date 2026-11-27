// Access check is of the type "req_one_access".
// These have been carefully selected to avoid allowing anyone with generic departmental access to see channels they should not.
var/global/list/default_internal_channels = list(
	num2text(PUB_FREQ) = list(),
	num2text(ENT_FREQ) = list(),
	num2text(EXP_FREQ) = list(),
	num2text(AI_FREQ)  = list(/datum/access/away/equipment::id),
	num2text(ERT_FREQ) = list(/datum/access/centcomm/cent_specops::id),
	num2text(COMM_FREQ)= list(/datum/access/horizon/heads::id),
	num2text(ENG_FREQ) = list(/datum/access/horizon/engine_equip::id, /datum/access/horizon/atmospherics::id),
	num2text(MED_FREQ) = list(/datum/access/horizon/medical_equip::id),
	num2text(MED_I_FREQ)=list(/datum/access/horizon/medical_equip::id),
	num2text(SEC_FREQ) = list(/datum/access/horizon/security::id),
	num2text(SEC_I_FREQ)=list(/datum/access/horizon/security::id),
	num2text(PEN_FREQ) = list(/datum/access/horizon/armory::id),
	num2text(SCI_FREQ) = list(/datum/access/horizon/tox::id,/datum/access/horizon/robotics::id,/datum/access/horizon/xenobiology::id,/datum/access/horizon/xenobotany::id),
	num2text(SUP_FREQ) = list(/datum/access/horizon/cargo::id),
	num2text(SRV_FREQ) = list(/datum/access/horizon/janitor::id, /datum/access/horizon/hydroponics::id)
)

var/global/list/default_medbay_channels = list(
	num2text(PUB_FREQ) = list(),
	num2text(MED_FREQ) = list(/datum/access/horizon/medical_equip::id),
	num2text(MED_I_FREQ) = list(/datum/access/horizon/medical_equip::id)
)

var/global/list/default_expedition_channels = list(
	num2text(PUB_FREQ) = list(),
	num2text(EXP_FREQ) = list(),
	num2text(HAIL_FREQ) = list()
)

var/global/list/default_interrogation_channels = list(
	num2text(INT_FREQ) = list()
)

//
// Radios
//

/obj/item/radio
	name = "shortwave radio"
	icon = 'icons/obj/radio.dmi'
	icon_state = "walkietalkie"
	item_state = "radio"
	obj_flags = OBJ_FLAG_CONDUCTABLE
	slot_flags = SLOT_BELT
	throw_speed = 2
	throw_range = 9
	w_class = WEIGHT_CLASS_SMALL
	matter = list(MATERIAL_ALUMINIUM = 75, MATERIAL_GLASS = 25)
	suffix = "\[3\]"
	var/radio_desc = ""
	var/const/FREQ_LISTENING = TRUE
	/// Automatically set on initialize, only update if bypass_default_internal is set to TRUE
	var/list/internal_channels
	/// played sound on usage
	var/clicksound = SFX_BUTTON
	/// volume of clicksound
	var/clickvol = 10

	/// Only handheld shortwaves opt into this. Other radio families override it.
	var/uses_device_cell = TRUE
	var/datum/device_power_supply/power_supply
	/// A standard 250 charge device cell lasts forty minutes.
	var/power_usage_per_second = 250 / (40 * 60)
	/// Optional wearable radio used as this shortwave's microphone and speaker.
	var/datum/weakref/connected_audio_accessory
	var/route_audio_to_accessory = FALSE
	var/last_radio_sound = -INFINITY

	/// Whether to show screen overlays or not.
	var/shortwave_overlays = TRUE
	/// Optional icon state or mutable appearance shown when on; art can be supplied by subtypes.
	var/overlay_power_on = "shortwave-on"
	var/overlay_power_emissive = "shortwave-emis"

	/// If FALSE, broadcasting and listening don't matter and this radio does nothing
	VAR_PRIVATE/on = TRUE

	/// Current frequency the radio is set to
	VAR_PRIVATE/frequency = PUB_FREQ
	/// frequency the radio defaults to on reset / startup
	var/default_frequency = PUB_FREQ

	/// Whether the radio transmits dialogue it hears nearby onto its radio channel
	VAR_PRIVATE/broadcasting = FALSE
	/// Whether the radio is currently receiving radio messages from its frequencies
	VAR_PRIVATE/listening = TRUE

	//the below vars are used to track listening and broadcasting should they be forced off for whatever reason but "supposed" to be active
	//eg player sets the radio to listening, but an emp or whatever turns it off, its still supposed to be activated but was forced off,
	//when it wears off it sets listening to should_be_listening

	/// used for tracking what broadcasting should be in the absence of things forcing it off, eg its set to broadcast but gets emp'd temporarily
	var/should_be_broadcasting = FALSE
	/// used for tracking what listening should be in the absence of things forcing it off, eg its set to listen but gets emp'd temporarily
	var/should_be_listening = TRUE

	/// Both the range around the radio in which mobs can hear what it receives and the range the radio can hear
	var/canhear_range = 3
	/// Runechat above the radio
	var/runechat_on_receive = FALSE

	var/last_transmission
	/// tune to frequency to unlock traitor supplies
	var/traitor_frequency = 0
	var/datum/wires/radio/wires = null
	var/show_modify_on_examine = TRUE
	var/b_stat = 0

	/// see communications.dm for full list. First non-common, non-entertainment channel is a "default" for :h
	var/list/channels = list()
	var/subspace_transmission = FALSE
	/// Holder to see if it's a syndicate encrypted radio
	var/syndie = FALSE
	/// if TRUE, can say/hear on the Special Channel!!! (TBD)
	var/independent = FALSE

	var/datum/radio_frequency/radio_connection
	var/list/datum/radio_frequency/secure_radio_connections = list()

/obj/item/radio/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(show_modify_on_examine && (distance <= 1))
		if (b_stat)
			. += SPAN_NOTICE("\The [src] can be attached and modified!")
		else
			. += SPAN_NOTICE("\The [src] can not be modified or attached!")

	if(radio_desc)
		. += "The following channels are available:"
		. += radio_desc

	if(uses_device_cell && distance <= 1)
		. += "It is switched <b>[power_supply?.powered ? "on" : "off"]</b>."
		if(power_supply?.cell)
			. += "Its power cell has <b>[round(power_supply.cell.percent())]%</b> charge remaining."
		else
			. += SPAN_WARNING("It has no power cell installed.")

/obj/item/radio/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "The radio key .i will allow you to speak into a nearby intercom, .r will speak into a radio in your right hand, and .l will speak into your left. The microphone does not need to be enabled for this to work."
	if(uses_device_cell)
		. += "ALT-click to turn the radio on or off. While holding it, click it with your empty hand to remove its device power cell."
		. += "Use a headset, wristbound radio, or clip-on radio on the shortwave to connect or disconnect it as the shortwave's microphone and speaker."

/obj/item/radio/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	if(new_frequency)
		frequency = new_frequency
		radio_connection = SSradio.add_object(src, new_frequency, RADIO_CHAT)

/// By default copies default_internal_channels. Override on child for radios that need snowflake.
/obj/item/radio/proc/set_internal_channels()
	return default_internal_channels.Copy()

/obj/item/radio/Initialize()
	. = ..()
	if(uses_device_cell)
		power_supply = new(src, /obj/item/cell/device, FALSE)

	wires = new(src)
	internal_channels = set_internal_channels()

	if(frequency < RADIO_LOW_FREQ || frequency > RADIO_HIGH_FREQ)
		frequency = sanitize_frequency(frequency, RADIO_LOW_FREQ, RADIO_HIGH_FREQ)

	for (var/ch_name in channels)
		secure_radio_connections[ch_name] = SSradio.add_object(src, radiochannels[ch_name],  RADIO_CHAT)

	set_listening(listening)
	set_broadcasting(broadcasting)
	set_frequency(default_frequency)
	set_on(uses_device_cell ? FALSE : on)
	if(uses_device_cell)
		START_PROCESSING(SSprocessing, src)

/obj/item/radio/Destroy()
	SSradio.remove_object_all(src)
	disconnect_audio_accessory()
	STOP_PROCESSING(SSprocessing, src)
	QDEL_NULL(power_supply)
	QDEL_NULL(wires)
	return ..()

/obj/item/radio/update_icon()
	if(!shortwave_overlays)
		return ..()
	ClearOverlays()
	if(is_on())
		var/mutable_appearance/powered_overlay = mutable_appearance(icon, overlay_power_on)
		if(powered_overlay)
			AddOverlays(powered_overlay)
		var/mutable_appearance/emissive_overlay = mutable_appearance(icon, overlay_power_emissive);
		if(emissive_overlay)
			AddOverlays(emissive_appearance(emissive_overlay.icon, emissive_overlay.icon_state))

/obj/item/radio/proc/is_on()
	return on

/obj/item/radio/proc/get_frequency()
	return frequency

/obj/item/radio/proc/get_broadcasting()
	return broadcasting

/obj/item/radio/proc/get_listening()
	return listening

/obj/item/radio/proc/get_connected_audio_wearer()
	if(!validate_audio_accessory_distance())
		return
	var/obj/item/radio/headset/accessory = connected_audio_accessory?.resolve()
	if(!istype(accessory) || !ishuman(accessory.loc))
		return
	var/mob/living/carbon/human/wearer = accessory.loc
	if(wearer.l_ear != accessory && wearer.r_ear != accessory && wearer.wrists != accessory)
		return
	if(get_atom_on_turf(src) != wearer)
		return
	return wearer

/// Disconnect audio accessories which are no longer close enough to have a physical connection.
/obj/item/radio/proc/validate_audio_accessory_distance()
	if(!connected_audio_accessory)
		return TRUE

	var/obj/item/radio/headset/accessory = connected_audio_accessory.resolve()
	if(!istype(accessory))
		disconnect_audio_accessory()
		return FALSE

	var/turf/radio_turf = get_turf(src)
	var/turf/accessory_turf = get_turf(accessory)
	if(!radio_turf || !accessory_turf || radio_turf.z != accessory_turf.z || get_dist(radio_turf, accessory_turf) > 1)
		disconnect_audio_accessory()
		return FALSE

	return TRUE

/obj/item/radio/proc/connect_audio_accessory(obj/item/radio/headset/accessory, mob/user)
	if(!uses_device_cell)
		return FALSE
	if(connected_audio_accessory?.resolve() == accessory)
		disconnect_audio_accessory()
		to_chat(user, SPAN_NOTICE("You disconnect \the [accessory] from \the [src]."))
		return TRUE

	accessory.disconnect_shortwave()
	disconnect_audio_accessory()
	connected_audio_accessory = WEAKREF(accessory)
	accessory.linked_shortwave = WEAKREF(src)
	route_audio_to_accessory = TRUE
	canhear_range = accessory.canhear_range
	to_chat(user, SPAN_NOTICE("You connect \the [accessory] to \the [src]."))
	SStgui.update_uis(src)
	return TRUE

/obj/item/radio/proc/disconnect_audio_accessory(preserve_route = FALSE)
	var/obj/item/radio/headset/accessory = connected_audio_accessory?.resolve()
	connected_audio_accessory = null
	if(accessory?.linked_shortwave?.resolve() == src)
		accessory.linked_shortwave = null
	if(!preserve_route)
		route_audio_to_accessory = FALSE
	canhear_range = route_audio_to_accessory ? 0 : initial(canhear_range)
	SStgui.update_uis(src)

/obj/item/radio/get_cell()
	return power_supply?.cell

/obj/item/radio/process(seconds_per_tick)
	validate_audio_accessory_distance()
	if(!uses_device_cell || !power_supply?.powered)
		return
	power_supply.use(power_usage_per_second * seconds_per_tick)

/obj/item/radio/AltClick(mob/user)
	if(!uses_device_cell || !user.Adjacent(src))
		return ..()
	power_supply.toggle_power(user)

/obj/item/radio/attack_hand(mob/user)
	if(uses_device_cell && user.get_inactive_hand() == src && power_supply?.cell)
		power_supply.eject_cell(user)
		return
	return ..()

/obj/item/radio/on_device_power_change(powered, mob/user)
	set_on(powered)
	if(user)
		balloon_alert(user, "switched [powered ? "on" : "off"]")
	else if(!powered)
		audible_message(SPAN_WARNING("\The [src] emits a low-power chirp and switches off."), hearing_distance = 1)
	update_icon()
	SStgui.update_uis(src)

/obj/item/radio/on_device_cell_changed()
	update_icon()
	SStgui.update_uis(src)

/**
 * setter for the listener var, adds or removes this radio from the global radio list if we are also on
 *
 * * new_listening - the new value we want to set listening to
 * * actual_setting - whether or not the radio is supposed to be listening, sets should_be_listening to the new listening value if true, otherwise just changes listening
 */
/obj/item/radio/proc/set_listening(new_listening, actual_setting = TRUE)

	listening = new_listening
	if(actual_setting)
		should_be_listening = listening

	if(listening && on)
		for(var/channel_name in channels)
			if(channels[channel_name])
				secure_radio_connections[channel_name] = SSradio.add_object(src, radiochannels[channel_name], RADIO_CHAT)
		radio_connection = SSradio.add_object(src, frequency, RADIO_CHAT)
	else if(!listening)
		SSradio.remove_object_all(src)
		radio_connection = null

/**
 * setter for broadcasting that makes us not hearing sensitive if not broadcasting and hearing sensitive if broadcasting
 * hearing sensitive in this case only matters for the purposes of listening for words said in nearby tiles, talking into us directly bypasses hearing
 *
 * * new_broadcasting- the new value we want to set broadcasting to
 * * actual_setting - whether or not the radio is supposed to be broadcasting, sets should_be_broadcasting to the new value if true, otherwise just changes broadcasting
 */
/obj/item/radio/proc/set_broadcasting(new_broadcasting, actual_setting = TRUE)

	broadcasting = new_broadcasting
	if(actual_setting)
		should_be_broadcasting = broadcasting

	if(broadcasting && on) //we dont need hearing sensitivity if we arent broadcasting, because talk_into doesnt care about hearing
		become_hearing_sensitive(INNATE_TRAIT)
	else if(!broadcasting)
		lose_hearing_sensitivity(INNATE_TRAIT)

///setter for the on var that sets both broadcasting and listening to off or whatever they were supposed to be
/obj/item/radio/proc/set_on(new_on)

	on = new_on

	if(on)
		set_broadcasting(should_be_broadcasting)//set them to whatever theyre supposed to be
		set_listening(should_be_listening)
	else
		set_broadcasting(FALSE, actual_setting = FALSE)//fake set them to off
		set_listening(FALSE, actual_setting = FALSE)
	update_icon()

/obj/item/radio/attack_self(mob/user as mob)
	user.set_machine(src)
	interact(user)

/obj/item/radio/interact(mob/user)
	if(!user)
		return 0

	if(b_stat)
		wires.interact(user)

	return ui_interact(user)

/obj/item/radio/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Radio", "[name]")
		ui.open()

/obj/item/radio/ui_data(mob/user)
	var/list/data = list()
	data["mic_status"] = broadcasting
	data["speaker"] = listening
	data["freq"] = frequency
	data["default_freq"] = default_frequency
	data["rawfreq"] = frequency
	data["powered"] = uses_device_cell ? power_supply?.powered : on
	data["uses_cell"] = uses_device_cell
	data["has_cell"] = !!power_supply?.cell
	data["charge"] = power_supply?.cell ? power_supply.cell.percent() : 0
	var/obj/item/radio/headset/audio_accessory = connected_audio_accessory?.resolve()
	data["audio_accessory"] = audio_accessory ? audio_accessory.name : null
	data["route_to_accessory"] = route_audio_to_accessory
	data["audio_accessory_available"] = !!get_connected_audio_wearer()

	data["mic_cut"] = (wires.is_cut(WIRE_TRANSMIT) || wires.is_cut(WIRE_SIGNAL))
	data["spk_cut"] = (wires.is_cut(WIRE_RECEIVE) || wires.is_cut(WIRE_SIGNAL))

	var/list/chl = list_channels(user)
	if(LAZYLEN(chl))
		data["channels"] = chl

	if(syndie)
		data["syndie"] = TRUE

	return data

/obj/item/radio/ui_static_data(mob/user)
	var/list/data = list()

	data["min_freq"] = PUBLIC_LOW_FREQ
	data["max_freq"] = PUBLIC_HIGH_FREQ

	return data

/obj/item/radio/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE
	if(uses_device_cell && !power_supply?.powered && action != "toggle_power" && action != "toggle_audio_route")
		return FALSE

	if(action == "start_track")
		var/mob/target = locate(params["target"])
		var/mob/living/silicon/ai/A = locate(params["ai"])
		if(A && target)
			A.ai_actual_track(target)
		. = TRUE

	else if (action == "set_freq")
		var/new_freq = text2num(params["freq"])
		if ((new_freq < PUBLIC_LOW_FREQ || new_freq > PUBLIC_HIGH_FREQ))
			new_freq = sanitize_frequency(new_freq)
		set_frequency(new_freq)
		if(hidden_uplink)
			if(hidden_uplink.check_trigger(usr, frequency, traitor_frequency))
				ui.close()
		. = TRUE
	else if (action == "toggle_talk")
		set_broadcasting(!broadcasting)
		. = TRUE
	else if(action == "toggle_power")
		if(uses_device_cell)
			power_supply.toggle_power(usr)
		. = TRUE
	else if(action == "toggle_audio_route")
		route_audio_to_accessory = !route_audio_to_accessory
		if(route_audio_to_accessory)
			var/obj/item/radio/headset/audio_accessory = connected_audio_accessory?.resolve()
			canhear_range = audio_accessory ? audio_accessory.canhear_range : 0
		else
			canhear_range = initial(canhear_range)
		. = TRUE
	else if (action == "toggle_listen")
		var/channel_name = num2text(params["channel_name"])
		if(channel_name == "0")
			set_listening(!listening)
		else
			channel_name = reverseradiochannels[channel_name]
			if (channels[channel_name] & FREQ_LISTENING)
				channels[channel_name] &= ~FREQ_LISTENING
			else
				channels[channel_name] |= FREQ_LISTENING
		. = TRUE
	else if (action == "spec_freq")
		var/freq = params["freq"]
		if(has_channel_access(usr, num2text(freq)))
			set_frequency(freq)
		. = TRUE
	else if (action == "reset_freq")
		if(default_frequency)
			set_frequency(default_frequency)
			. = TRUE

	if (params["nowindow"])
		return TRUE

	if(.)
		update_icon()
		if(clicksound && iscarbon(usr))
			playsound(loc, clicksound, clickvol)

/obj/item/radio/proc/setupRadioDescription(var/additional_radio_desc)
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

/obj/item/radio/proc/list_channels(var/mob/user)
	return list_internal_channels(user)

/obj/item/radio/proc/list_secure_channels(var/mob/user)
	var/dat[0]

	for(var/ch_name in channels)
		var/chan_stat = channels[ch_name]
		var/listening = chan_stat & FREQ_LISTENING

		dat.Add(list(list("chan" = radiochannels[ch_name], "display_name" = ch_name, "secure_channel" = 1, "sec_channel_listen" = listening, "chan_span" = frequency_span_class(radiochannels[ch_name]))))

	return dat

/obj/item/radio/proc/list_internal_channels(var/mob/user)
	var/dat[0]
	for(var/internal_chan in internal_channels)
		if(has_channel_access(user, internal_chan))
			dat.Add(list(list("chan" = text2num(internal_chan), "display_name" = get_frequency_name(text2num(internal_chan)), "chan_span" = frequency_span_class(text2num(internal_chan)))))

	return dat

/obj/item/radio/proc/has_channel_access(var/mob/user, var/freq)
	if(!user)
		return 0

	if(!(freq in internal_channels))
		return 0

	return user.has_internal_radio_channel_access(internal_channels[freq])

/mob/proc/has_internal_radio_channel_access(var/list/req_one_accesses)
	var/obj/item/card/id/I = GetIdCard()
	return has_access(list(), req_one_accesses, I ? I.GetAccess() : list())

/mob/abstract/ghost/observer/has_internal_radio_channel_access(var/list/req_one_accesses)
	return can_admin_interact()

/obj/item/radio/proc/text_wires()
	if (b_stat)
		return wires.get_status()
	return


/obj/item/radio/proc/text_sec_channel(var/chan_name, var/chan_stat)
	var/list = !!(chan_stat&FREQ_LISTENING)!=0
	return {"
			<B>[chan_name]</B><br>
			Speaker: <A href='byond://?src=[REF(src)];ch_name=[chan_name];listen=[!list]'>[list ? "Engaged" : "Disengaged"]</A><BR>
			"}

/obj/item/radio/ui_status(mob/user, datum/ui_state/state)
	if(!on && !uses_device_cell)
		return UI_CLOSE
	return ..()

/obj/item/radio/proc/autosay(var/message, var/from, var/channel) //BS12 EDIT
	var/datum/radio_frequency/connection = null
	if(channel && channels && channels.len > 0)
		if(channel == "department")
			for(var/freq in channels)
				if(freq == "Common" || freq == "Entertainment" || freq == "Expeditionary")
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

	var/datum/signal/subspace/vocal/signal = new(src, connection.frequency, WEAKREF(src), get_default_language(), message, "states")
	signal.data["name"] = from
	signal.send_to_receivers()

// Interprets the message mode when talking into a radio, possibly returning a connection datum
/obj/item/radio/proc/handle_message_mode(atom/movable/M, message, message_mode)
	// If a channel isn't specified, send to common.
	if(!message_mode || message_mode == "headset")
		return radio_connection

	// Otherwise, if a channel is specified, look for it.
	if(channels && channels.len > 0)
		if(message_mode == "department") // Department radio shortcut
			for(var/freq in channels)
				if(freq == "Common" || freq == "Entertainment" || freq == "Expeditionary")
					continue
				message_mode = freq
				break
			if(message_mode == "department") // didn't find one, use first one
				message_mode = channels[1]
		if (channels[message_mode]) // only broadcast if the channel is set on
			return secure_radio_connections[message_mode]

	// If we were to send to a channel we don't have, drop it.
	return null

/obj/item/radio/talk_into(atom/movable/M, message, channel, var/say_verb = "says", var/datum/language/speaking = null, var/ignore_restrained, var/datum/say_message/say_message = null)
	if(!on)
		return FALSE
	if(!M || !message)
		return FALSE
	if(wires.is_cut(WIRE_TRANSMIT)) // The device has to have all its wires and shit intact
		return FALSE
	if(!speaking)
		speaking = M.get_default_language()

	if (iscarbon(M))
		var/mob/living/carbon/C = M
		if ((CE_UNDEXTROUS in C.chem_effects) || C.stunned >= 10)
			to_chat(M, SPAN_WARNING("You can't move your arms enough to activate the radio..."))
			return
		if(iszombie(M))
			to_chat(M, SPAN_WARNING("Try as you might, you cannot will your decaying body into operating \the [src]."))
			return FALSE

	if(ismob(M))
		var/mob/speaker_mob = M
		if(speaker_mob.restrained() && !ignore_restrained)
			to_chat(M, SPAN_WARNING("You can't speak into \the [src.name] while restrained."))
			return FALSE
		speaker_mob.trigger_aiming(TARGET_CAN_RADIO)

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
	var/datum/signal/subspace/vocal/signal = new(src, connection.frequency, speaker_weakref, speaking, message, say_verb, say_message)

	// All radios attempt to use the subspace system
	. = signal.send_to_receivers()

	// If it's subspace only, that's all we can do
	if(subspace_transmission)
		return

	// Non-subspace radios will check in a couple of seconds, and if the signal was never received, we send a mundane broadcast
	addtimer(CALLBACK(src, PROC_REF(backup_transmission), signal), 2 SECONDS)

/obj/item/radio/proc/backup_transmission(datum/signal/subspace/vocal/signal)
	if(!on)
		return
	var/turf/T = get_turf(src)
	if (signal.data["done"] && (T.z in signal.levels))
		return

	// If we're here, the signal was never processed. Proceed with mundane broadcast:
	signal.data["compression"] = 0
	signal.transmission_method = TRANSMISSION_RADIO
	signal.levels = GetConnectedZlevels(T.z)
	signal.broadcast()

/obj/item/radio/hear_talk(atom/movable/M, msg, var/verb = "says", var/datum/language/speaking = null, datum/say_message/say_message = null)
	if (say_message?.say_mode == SAYMODE_RADIO || !broadcasting || get_dist(src, M) > canhear_range)
		return

	return talk_into(M, msg, null, verb, speaking, ignore_restrained = TRUE, say_message = say_message)

/// Received speech is presented at the receiver, while the payload retains the original speaker.
/obj/item/radio/proc/on_receive_message(list/data, datum/say_message/msg, list/recipients)
	if(!on || !listening || !get_turf(src))
		return
	SEND_SIGNAL(src, COMSIG_RADIO_RECEIVE_MESSAGE, data)
	if(QDELETED(src) || !runechat_on_receive)
		return
	// Use this receiver's range and LOS, and retain the broadcast's preference/access filtering.
	var/list/local_listeners = get_hearers_in_radio_ranges(list(src)) & recipients
	// Radio transport bypasses pressure checks, but its local speaker still needs air.
	if(!(msg.single_language?.flags & PRESSUREPROOF))
		var/turf/origin = get_turf(src)
		var/datum/gas_mixture/source_air = origin.return_air()
		for(var/mob/listener in local_listeners.Copy())
			if(get_dist(src, listener) <= 1)
				continue
			if(SAFE_XGM_PRESSURE(source_air) < SOUND_MINIMUM_PRESSURE)
				local_listeners -= listener
				continue
			if(isghost(listener))
				continue
			var/turf/destination = get_turf(listener)
			var/datum/gas_mixture/listener_air = destination.return_air()
			if(SAFE_XGM_PRESSURE(listener_air) < SOUND_MINIMUM_PRESSURE)
				local_listeners -= listener
	present_say_message(msg, local_listeners)

/// Resolve a radio screen appearance, allowing subtypes to apply their own treatment.
/obj/item/radio/proc/get_radio_overlay(overlay)
	return resolve_radio_overlay(overlay)

/// Resolve raw art without subtype-specific screen effects, for independent layers such as scanlines.
/obj/item/radio/proc/resolve_radio_overlay(overlay)
	if(!overlay)
		return null
	if(istext(overlay))
		if(!(overlay in icon_states(icon)))
			return null
		return mutable_appearance(icon, overlay)
	return overlay

/obj/item/radio/proc/can_receive(input_frequency, list/levels)
	// check if the radio can receive on the given frequency
	if (!listening)
		return
	if(route_audio_to_accessory && !get_connected_audio_wearer())
		return FALSE

	if (levels != RADIO_NO_Z_LEVEL_RESTRICTION)
		var/turf/position = get_turf(src)
		if (!position || !(position.z in levels))
			return FALSE

	if (within_jamming_range(src))
		return FALSE

	if ((input_frequency in ANTAG_FREQS) && !syndie) //Checks to see if it's allowed on that frequency, based on the encryption keys
		return FALSE

	for (var/ch_name in channels)
		var/datum/radio_frequency/RF = secure_radio_connections[ch_name]
		if (RF.frequency == input_frequency)
			return channels[ch_name]

	if (input_frequency == frequency)
		return TRUE

	return FALSE

/obj/item/radio/proc/send_hear(freq, level)
	if(!can_receive(freq, level))
		return

	return get_hearers_in_view(canhear_range, src)

/obj/item/radio/attackby(obj/item/attacking_item, mob/user)
	if(uses_device_cell && istype(attacking_item, /obj/item/radio/headset))
		connect_audio_accessory(attacking_item, user)
		return
	if(uses_device_cell && istype(attacking_item, /obj/item/cell))
		power_supply.install_cell(attacking_item, user)
		return
	..()
	user.set_machine(src)
	if (!( attacking_item.tool_behaviour == TOOL_SCREWDRIVER ))
		return
	b_stat = !( b_stat )
	if(!istype(src, /obj/item/radio/beacon))
		if (b_stat)
			user.show_message(SPAN_NOTICE("\The [src] can now be attached and modified!"))
		else
			user.show_message(SPAN_NOTICE("\The [src] can no longer be modified or attached!"))
		updateDialog()
		add_fingerprint(user)
		return
	else return

/obj/item/radio/emp_act(severity)
	. = ..()
	if(uses_device_cell)
		power_supply.emp_act(severity)

	set_broadcasting(FALSE)
	set_listening(FALSE)
	for (var/ch_name in channels)
		channels[ch_name] = 0

//
// Vesselbound Synthetic Radio
//

/obj/item/radio/borg
	uses_device_cell = FALSE
	shortwave_overlays = FALSE
	var/mob/living/silicon/robot/myborg = null // Cyborg which owns this radio. Used for power checks
	var/obj/item/encryptionkey/keyslot = null//Borg radios can handle a single encryption key
	var/shut_up = 1
	icon = 'icons/obj/robot_component.dmi' // Cyborgs radio icons should look like the component.
	icon_state = "radio"
	canhear_range = 0
	subspace_transmission = 1
	name = "integrated radio"
	var/radio_sound = null

/obj/item/radio/borg/Destroy()
	myborg = null
	. = ..()

/obj/item/radio/borg/list_channels(var/mob/user)
	return list_secure_channels(user)

/obj/item/radio/borg/talk_into(atom/movable/M, message, channel, verb, datum/language/speaking, var/ignore_restrained, var/datum/say_message/say_message = null)
	. = ..()
	if (isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		var/datum/robot_component/C = R.components["radio"]
		R.cell_use_power(C.active_usage)

/obj/item/radio/borg/attackby(obj/item/attacking_item, mob/user)
//	..()
	user.set_machine(src)
	if (!( attacking_item.tool_behaviour == TOOL_SCREWDRIVER || (istype(attacking_item, /obj/item/encryptionkey/ ))))
		return

	if(attacking_item.tool_behaviour == TOOL_SCREWDRIVER)
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

	if(istype(attacking_item, /obj/item/encryptionkey/))
		if(keyslot)
			to_chat(user, "The radio can't hold another key!")
			return

		if(!keyslot)
			user.drop_from_inventory(attacking_item,src)
			keyslot = attacking_item

		recalculateChannels()

	return

/obj/item/radio/borg/proc/recalculateChannels()
	channels = list(CHANNEL_COMMON = TRUE, CHANNEL_ENTERTAINMENT = TRUE, CHANNEL_EXPED = TRUE)
	syndie = FALSE

	if(isrobot(loc))
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

/obj/item/radio/borg/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE
	if (action == "mode")
		subspace_transmission = !subspace_transmission
		to_chat(usr, SPAN_NOTICE("Subspace Transmission [subspace_transmission ? "enabled" : "disabled"]."))
		if(subspace_transmission)
			recalculateChannels()
		else
			channels = list()
		. = TRUE
	if (action == "shutup") // Toggle loudspeaker mode, AKA everyone around you hearing your radio.
		shut_up = !shut_up
		canhear_range = shut_up ? 0 : 3
		to_chat(usr, SPAN_NOTICE("Loudspeaker [shut_up ? "disabled" : "enabled"]."))
		. = TRUE

/obj/item/radio/borg/ui_data(mob/user)
	var/list/data = ..()

	data["loudspeaker"] = !shut_up
	data["subspace"] = subspace_transmission

	return data

/obj/item/radio/borg/ui_static_data(mob/user)
	var/list/data = ..()
	data["has_loudspeaker"] = TRUE
	data["has_subspace"] = TRUE
	return data

/obj/item/radio/proc/config(op)
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

/obj/item/radio/map_preset
	channels = list()

/obj/item/radio/map_preset/Initialize(mapload, comms_group_id)
	if(!SSatlas.current_map.use_overmap)
		return ..()

	var/turf/T = get_turf(src)
	var/obj/effect/overmap/visitable/V = get_map_sector(T.z)
	if(!istype(V) || !V.comms_support)
		return ..()

	// We choose which comm group we belong here
	var/list/sector_comms_groups = V.comms_groups
	var/datum/comms_group/comms_group

	if(comms_group_id)
		comms_group = sector_comms_groups[comms_group_id]

	else if(length(sector_comms_groups) == 1)
		// since the group has one member we get the datum from it
		comms_group = sector_comms_groups[sector_comms_groups[1]]

	if(!comms_group)
		stack_trace("[src] at ([loc.x], [loc.y], [loc.z]) couldn't select a comms group. Received comms_group_id: [comms_group_id]")
		return ..()

	// Assign frequency here
	var/freq_name = comms_group.freq_name ? comms_group.freq_name : V.name // if frequency name isn't provided, we default to sector name
	frequency = assign_away_freq(freq_name)
	default_frequency = frequency
	channels += list(
		freq_name = TRUE,
		CHANNEL_HAILING = TRUE
	)

	// Assign name here
	if(comms_group.comms_name)
		name = "[comms_group.comms_name] [name]"

	return ..()

/obj/item/radio/map_preset/set_internal_channels()
	return list(
		num2text(default_frequency) = list(),
		num2text(HAIL_FREQ) = list()
	)

/obj/item/radio/hailing
	default_frequency = HAIL_FREQ

/obj/item/radio/hailing/set_internal_channels()
	return list(
		num2text(HAIL_FREQ) = list()
	)

/obj/item/radio/hailing/Initialize()
	channels = list(
		CHANNEL_HAILING = TRUE
	)
	return ..()

// Medical
/obj/item/radio/med
	icon_state = "walkietalkie-med"

// Security
/obj/item/radio/sec
	icon_state = "walkietalkie-sec"

// Engineering
/obj/item/radio/eng
	icon_state = "walkietalkie-eng"

// Science
/obj/item/radio/sci
	icon_state = "walkietalkie-sci"

// Phone
/obj/item/radio/phone
	uses_device_cell = FALSE
	shortwave_overlays = FALSE
	icon = 'icons/obj/radio.dmi'
	icon_state = "red_phone"
	name = "phone"
	var/radio_sound = null

/obj/item/radio/phone/Initialize()
	. = ..()
	set_broadcasting(FALSE)
	set_listening(TRUE)

// Medical Phone
/obj/item/radio/phone/medbay/Initialize()
	. = ..()
	set_frequency(MED_I_FREQ)
	internal_channels = default_medbay_channels.Copy()

// All-channel Radio
/obj/item/radio/all_channels/Initialize()
	channels = ALL_RADIO_CHANNELS.Copy()
	. = ..()
