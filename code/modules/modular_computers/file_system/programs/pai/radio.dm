/datum/computer_file/program/pai_radio
	filename = "pai_radio"
	filedesc = "Radio Configuration"
	program_icon_state = "generic"
	extended_desc = "This program is used to configure the integrated pAI radio."
	size = 0

	usage_flags = PROGRAM_SILICON_PAI

/datum/computer_file/program/pai_radio/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new /datum/vueui/modularcomputer(user, src, "mcomputer-pai-radio", 400, 150, "pAI Radio Configuration")
	ui.open()

/datum/computer_file/program/pai_radio/vueui_transfer(oldobj)
	SSvueui.transfer_uis(oldobj, src, "mcomputer-pai-radio", 400, 150, "pAI Radio Configuration")
	return TRUE

// Gaters data for ui
/datum/computer_file/program/pai_radio/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	data = . || data || list()
	// Gather data for computer header
	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata
		. = data
	
	if(!istype(computer, /obj/item/modular_computer/silicon))
		return
	var/obj/item/modular_computer/silicon/true_computer = computer
	if(!istype(true_computer.computer_host, /mob/living/silicon/pai))
		return
	var/mob/living/silicon/pai/host = true_computer.computer_host

	VUEUI_SET_CHECK(data["listening"], host.radio.broadcasting, ., data)
	VUEUI_SET_CHECK(data["frequency"], format_frequency(host.radio.frequency), ., data)

	LAZYINITLIST(data["channels"])
	for(var/ch_name in host.radio.channels)
		var/ch_stat = host.radio.channels[ch_name]
		VUEUI_SET_CHECK(data["channels"][ch_name], !!(ch_stat & host.radio.FREQ_LISTENING), ., data)
	
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
