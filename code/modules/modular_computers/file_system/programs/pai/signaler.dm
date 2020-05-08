/datum/computer_file/program/pai_signaler
	filename = "signaler"
	filedesc = "Remote Signaller"
	program_icon_state = "generic"
	extended_desc = "This program can be used to send wide-range signals of various frequencies."
	size = 3
	available_on_ntnet = 1
	usage_flags = PROGRAM_SILICON_PAI

/datum/computer_file/program/pai_signaler/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new /datum/vueui/modularcomputer(user, src, "mcomputer-pai-signaler", 400, 150, "pAI Signaller")
	ui.open()

/datum/computer_file/program/pai_signaler/vueui_transfer(oldobj)
	SSvueui.transfer_uis(oldobj, src, "mcomputer-pai-signaler", 400, 150, "pAI Signaller")
	return TRUE

// Gaters data for ui
/datum/computer_file/program/pai_signaler/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
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

	VUEUI_SET_CHECK(data["code"], host.sradio.code, ., data)
	VUEUI_SET_CHECK(data["frequency"], format_frequency(host.sradio.frequency), ., data)


/datum/computer_file/program/pai_signaler/Topic(href, href_list)
	. = ..()
	
	if(!istype(computer, /obj/item/modular_computer/silicon))
		return
	var/obj/item/modular_computer/silicon/true_computer = computer
	if(!istype(true_computer.computer_host, /mob/living/silicon/pai))
		return
	var/mob/living/silicon/pai/host = true_computer.computer_host

	if(href_list["send"])
		host.sradio.send_signal("ACTIVATE")
		for(var/mob/O in hearers(1, host.loc))
			O.show_message(text("\icon[] *beep* *beep*", host), 3, "*beep* *beep*", 2)
		return 1

	else if(href_list["freq"])
		var/new_frequency = (host.sradio.frequency + href_list["freq"])
		if(new_frequency < PUBLIC_LOW_FREQ || new_frequency > PUBLIC_HIGH_FREQ)
			new_frequency = sanitize_frequency(new_frequency)
		host.sradio.set_frequency(new_frequency)
		return 1

	else if(href_list["code"])
		host.sradio.code += href_list["code"]
		host.sradio.code = round(host.sradio.code)
		host.sradio.code = min(100, host.sradio.code)
		host.sradio.code = max(1, host.sradio.code)
		return 1
