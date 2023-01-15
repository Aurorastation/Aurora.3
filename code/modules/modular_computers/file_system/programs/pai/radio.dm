/datum/computer_file/program/pai_radio
	filename = "pai_radio"
	filedesc = "Radio Configuration"
	program_icon_state = "generic"
	program_key_icon_state = "green_key"
	extended_desc = "This program is used to configure the integrated pAI radio."
	size = 0

	usage_flags = PROGRAM_SILICON_PAI

/datum/computer_file/program/pai_radio/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new /datum/vueui/modularcomputer(user, src, "mcomputer-pai-radio", 450, 400, "pAI Radio Configuration")
	ui.open()

/datum/computer_file/program/pai_radio/vueui_transfer(oldobj)
	SSvueui.transfer_uis(oldobj, src, "mcomputer-pai-radio", 450, 400, "pAI Radio Configuration")
	return TRUE

// Gaters data for ui
/datum/computer_file/program/pai_radio/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	data = . || data || list()
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
	VUEUI_SET_CHECK_IFNOTSET(data["radio_range"], host.radio.canhear_range, ., data)
	host.radio.canhear_range = data["radio_range"]

	var/list/pai_channels = list()
	for(var/ch_name in host.radio.channels)
		var/list/channel_info = list(
			"name" = ch_name,
			"listening" = (host.radio.channels[ch_name] & host.radio.FREQ_LISTENING)
		)
		pai_channels[++pai_channels.len] = channel_info
	data["channels"] = pai_channels

	return data

/datum/computer_file/program/pai_radio/Topic(href, href_list)
	. = ..()

	if(!istype(computer, /obj/item/modular_computer/silicon))
		return
	var/obj/item/modular_computer/silicon/true_computer = computer
	if(!istype(true_computer.computer_host, /mob/living/silicon/pai))
		return
	var/mob/living/silicon/pai/host = true_computer.computer_host

	host.radio.Topic(href, href_list)
	SSvueui.check_uis_for_change(src)
