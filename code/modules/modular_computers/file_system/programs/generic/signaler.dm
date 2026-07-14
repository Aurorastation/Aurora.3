#define NTOS_SIGNALER_CHANNEL_COUNT 8
#define NTOS_SIGNALER_RECEIVE_CHANNELS 2
#define NTOS_SIGNALER_DEFAULT_FREQUENCY 1457
#define NTOS_SIGNALER_DEFAULT_CODE 30
#define NTOS_SIGNALER_MAX_LABEL_LENGTH 24

/datum/computer_file/program/signaler
	filename = "signaler"
	filedesc = "Signal Manager"
	extended_desc = "This program configures signaler-capable network cards for receiving and sending signals on custom frequencies."
	program_icon_state = "generic"
	program_key_icon_state = "green_key"
	color = LIGHT_COLOR_GREEN
	size = 1
	requires_ntnet = FALSE
	available_on_ntnet = TRUE
	usage_flags = PROGRAM_ALL_REGULAR
	tgui_id = "NTOSSignaler"

	var/list/signal_configurations = list()

/datum/computer_file/program/signaler/New(obj/item/modular_computer/comp)
	. = ..()
	ensure_signal_configurations()

/datum/computer_file/program/signaler/clone(var/rename = FALSE, var/computer)
	ensure_signal_configurations()
	var/datum/computer_file/program/signaler/signaler_clone = ..(rename, computer)
	signaler_clone.signal_configurations = list()
	for(var/list/configuration in signal_configurations)
		signaler_clone.signal_configurations += list(configuration.Copy())
	return signaler_clone

/datum/computer_file/program/signaler/run_program(var/mob/user)
	if(!..())
		return FALSE
	sync_receive_radios()
	return TRUE

/datum/computer_file/program/signaler/ui_data(mob/user)
	ensure_signal_configurations()
	sync_receive_radios()

	var/list/data = initial_data()
	data["hardware_ready"] = !!get_signaler_card()
	data["hardware_status"] = get_hardware_status()
	data["min_frequency"] = RADIO_LOW_FREQ
	data["max_frequency"] = RADIO_HIGH_FREQ
	data["receive_channels"] = NTOS_SIGNALER_RECEIVE_CHANNELS
	data["silent"] = silent
	data["channels"] = list()

	for(var/i = 1 to NTOS_SIGNALER_CHANNEL_COUNT)
		var/list/configuration = signal_configurations[i]
		data["channels"] += list(list(
			"index" = i,
			"label" = configuration["label"],
			"frequency" = configuration["frequency"],
			"code" = configuration["code"],
			"receiving" = i <= NTOS_SIGNALER_RECEIVE_CHANNELS,
			"receiving_enabled" = configuration["receiving_enabled"],
			"last_received_code" = configuration["last_received_code"],
			"last_received_time" = configuration["last_received_time"]
		))

	return data

/datum/computer_file/program/signaler/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	if(action == "toggle_silent")
		silent = !silent
		. = TRUE
		return

	ensure_signal_configurations()
	var/channel_index = clamp(round(text2num(params["index"])), 1, NTOS_SIGNALER_CHANNEL_COUNT)
	var/list/configuration = signal_configurations[channel_index]
	if(!configuration)
		return TRUE

	switch(action)
		if("rename")
			var/new_label = tgui_input_text(usr, "Enter a new label for this [channel_index <= NTOS_SIGNALER_RECEIVE_CHANNELS ? "receiver" : "signaler"].", "Rename Signal", configuration["label"], NTOS_SIGNALER_MAX_LABEL_LENGTH)
			if(isnull(new_label))
				return TRUE
			new_label = sanitize(new_label, NTOS_SIGNALER_MAX_LABEL_LENGTH)
			configuration["label"] = length(new_label) ? new_label : default_label(channel_index)
			. = TRUE
		if("frequency")
			configuration["frequency"] = clean_frequency(text2num(params["frequency"]))
			if(channel_index <= NTOS_SIGNALER_RECEIVE_CHANNELS)
				sync_receive_radios()
			. = TRUE
		if("toggle_receive")
			if(channel_index <= NTOS_SIGNALER_RECEIVE_CHANNELS)
				configuration["receiving_enabled"] = !configuration["receiving_enabled"]
				if(!configuration["receiving_enabled"])
					configuration["last_received_code"] = null
					configuration["last_received_time"] = null
				sync_receive_radios()
			. = TRUE
		if("code")
			if(channel_index > NTOS_SIGNALER_RECEIVE_CHANNELS)
				configuration["code"] = clamp(round(text2num(params["code"])), 1, 100)
			. = TRUE
		if("reset")
			configuration["frequency"] = NTOS_SIGNALER_DEFAULT_FREQUENCY
			configuration["code"] = NTOS_SIGNALER_DEFAULT_CODE
			if(channel_index <= NTOS_SIGNALER_RECEIVE_CHANNELS)
				configuration["receiving_enabled"] = FALSE
				configuration["last_received_code"] = null
				configuration["last_received_time"] = null
				sync_receive_radios()
			. = TRUE
		if("send")
			if(channel_index > NTOS_SIGNALER_RECEIVE_CHANNELS)
				send_signal(channel_index, usr)
			. = TRUE

/datum/computer_file/program/signaler/proc/ensure_signal_configurations()
	for(var/i = 1 to min(length(signal_configurations), NTOS_SIGNALER_CHANNEL_COUNT))
		var/list/configuration = signal_configurations[i]
		if(!configuration)
			continue
		if(isnull(configuration["receiving_enabled"]))
			configuration["receiving_enabled"] = FALSE

	for(var/i = length(signal_configurations) + 1 to NTOS_SIGNALER_CHANNEL_COUNT)
		signal_configurations += list(list(
			"label" = default_label(i),
			"frequency" = NTOS_SIGNALER_DEFAULT_FREQUENCY,
			"code" = NTOS_SIGNALER_DEFAULT_CODE,
			"receiving_enabled" = FALSE,
			"last_received_code" = null,
			"last_received_time" = null
		))

/datum/computer_file/program/signaler/proc/default_label(var/channel_index)
	if(channel_index <= NTOS_SIGNALER_RECEIVE_CHANNELS)
		return "Receiver [channel_index]"
	return "Signal [channel_index - NTOS_SIGNALER_RECEIVE_CHANNELS]"

/datum/computer_file/program/signaler/proc/clean_frequency(var/frequency)
	if(!isnum(frequency))
		frequency = NTOS_SIGNALER_DEFAULT_FREQUENCY
	frequency = sanitize_frequency(frequency, RADIO_LOW_FREQ, RADIO_HIGH_FREQ)
	if(frequency > RADIO_HIGH_FREQ)
		frequency = RADIO_HIGH_FREQ - 1
	return frequency

/datum/computer_file/program/signaler/proc/get_signaler_card()
	if(!computer?.network_card)
		return null
	var/obj/item/computer_hardware/network_card/network_card = computer.network_card
	if(!network_card.enabled || !network_card.check_functionality() || !network_card.sradio)
		return null
	return network_card

/datum/computer_file/program/signaler/proc/get_hardware_status()
	if(!computer?.network_card)
		return "No network card detected."
	var/obj/item/computer_hardware/network_card/network_card = computer.network_card
	if(!network_card.sradio)
		return "Installed network card does not support signaling."
	if(!network_card.enabled)
		return "Signaler network card is disabled."
	if(!network_card.check_functionality())
		return "Signaler network card is damaged."
	return "Ready."

/datum/computer_file/program/signaler/proc/sync_receive_radios()
	var/obj/item/computer_hardware/network_card/network_card = get_signaler_card()
	if(!network_card)
		return FALSE

	for(var/i = 1 to NTOS_SIGNALER_RECEIVE_CHANNELS)
		var/obj/item/integrated_signaler/signal/radio = network_card.get_signaler_radio(i)
		var/list/configuration = signal_configurations[i]
		if(radio && configuration)
			if(configuration["receiving_enabled"])
				radio.set_frequency(configuration["frequency"])
				radio.set_listening(TRUE)
			else
				radio.set_listening(FALSE)

	return TRUE

/datum/computer_file/program/signaler/proc/send_signal(var/channel_index, var/mob/user)
	var/obj/item/computer_hardware/network_card/network_card = get_signaler_card()
	if(!network_card)
		computer?.output_error(FONT_SMALL(SPAN_WARNING("Hardware Error - Signaler network card unavailable.")))
		return FALSE

	var/list/configuration = signal_configurations[channel_index]
	if(!configuration)
		return FALSE

	var/obj/item/integrated_signaler/signal/radio = network_card.get_signaler_radio(0)
	if(!radio)
		return FALSE

	var/old_frequency = radio.frequency
	var/old_code = radio.code

	radio.set_frequency(configuration["frequency"])
	radio.code = configuration["code"]
	var/sent = radio.send_signal("ACTIVATE", user)
	radio.code = old_code
	radio.set_frequency(old_frequency)

	if(sent)
		computer?.output_notice("Signal sent on [format_frequency(configuration["frequency"])]/[configuration["code"]].", 0)
	else
		computer?.output_error(FONT_SMALL(SPAN_WARNING("Unable to send signal. The transmitter may be cooling down or jammed.")))

	return sent

/datum/computer_file/program/signaler/proc/receive_signal(var/channel_index, var/datum/signal/signal)
	if(channel_index < 1 || channel_index > NTOS_SIGNALER_RECEIVE_CHANNELS)
		return FALSE

	ensure_signal_configurations()
	var/list/configuration = signal_configurations[channel_index]
	if(!configuration)
		return FALSE
	if(!configuration["receiving_enabled"])
		return FALSE

	configuration["last_received_code"] = signal.encryption
	configuration["last_received_time"] = worldtime2text()

	if(computer)
		var/received_message = "Signal received on [configuration["label"]]: [isnull(signal.encryption) ? "no code" : signal.encryption]."
		if(silent)
			computer.output_notice(received_message, 0)
		else
			playsound(get_turf(computer), 'sound/machines/twobeep.ogg', 20, 1)
			computer.audible_message("[icon2html(computer, viewers(1, get_turf(computer)))] [computer] beeps, \"[received_message]\"")

	SStgui.update_uis(src)
	return TRUE

#undef NTOS_SIGNALER_CHANNEL_COUNT
#undef NTOS_SIGNALER_RECEIVE_CHANNELS
#undef NTOS_SIGNALER_DEFAULT_FREQUENCY
#undef NTOS_SIGNALER_DEFAULT_CODE
#undef NTOS_SIGNALER_MAX_LABEL_LENGTH
