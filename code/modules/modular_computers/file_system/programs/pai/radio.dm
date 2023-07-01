/datum/computer_file/program/pai_radio
	filename = "pai_radio"
	filedesc = "Radio Configuration"
	program_icon_state = "generic"
	program_key_icon_state = "green_key"
	extended_desc = "This program is used to configure the integrated pAI radio."
	size = 0

	usage_flags = PROGRAM_SILICON_PAI
	tgui_id = "pAIRadio"

// Gaters data for ui
/datum/computer_file/program/pai_radio/ui_data(mob/user)
	var/list/data = list()
	// Gather data for computer header
	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata

	if(!istype(computer, /obj/item/modular_computer/silicon))
		return
	var/obj/item/modular_computer/silicon/true_computer = computer
	if(!istype(true_computer.computer_host, /mob/living/silicon/pai))
		return
	var/mob/living/silicon/pai/host = true_computer.computer_host

	data["listening"] = host.radio.get_broadcasting()
	data["frequency"] = format_frequency(host.radio.get_frequency())
	data["radio_range"] = host.radio.canhear_range

	var/list/pai_channels = list()
	for(var/ch_name in host.radio.channels)
		var/list/channel_info = list(
			"name" = ch_name,
			"listening" = (host.radio.channels[ch_name] & host.radio.FREQ_LISTENING)
		)
		pai_channels += list(channel_info)
	data["channels"] = pai_channels

	return data

/datum/computer_file/program/pai_radio/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(!istype(computer, /obj/item/modular_computer/silicon))
		return
	var/obj/item/modular_computer/silicon/true_computer = computer
	if(!istype(true_computer.computer_host, /mob/living/silicon/pai))
		return
	var/mob/living/silicon/pai/host = true_computer.computer_host

	if(action == "radio_range") //fuck nanoUI and fuck vueui two-way bullshit, and fuck topic hooking
		host.radio.canhear_range = params["radio_range"]
	else
		host.radio.Topic(action, params)
	. = TRUE
