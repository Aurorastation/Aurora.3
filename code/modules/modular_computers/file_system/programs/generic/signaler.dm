/datum/computer_file/program/signaler
	filename = "signaler"
	filedesc = "Remote Signaller"
	program_icon_state = "generic"
	program_key_icon_state = "green_key"
	extended_desc = "This program can be used to send wide-range signals of various frequencies."
	size = 2
	available_on_ntnet = TRUE
	usage_flags = PROGRAM_ALL

	var/obj/item/radio/integrated/signal/radio
	var/doorcode

/datum/computer_file/program/signaler/New(var/obj/item/modular_computer/comp)
	..(comp)
	if(computer && computer.computer_emagged && computer.doorcode)
		doorcode = computer.doorcode

/datum/computer_file/program/signaler/can_run(mob/user, loud, access_to_check, check_type)
	. = ..()
	if(!get_radio())
		computer.output_error("Cannot open [filedesc]: missing signaler hardware.", 0)
		return FALSE

/datum/computer_file/program/signaler/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new /datum/vueui/modularcomputer(user, src, "mcomputer-signaler", 400, 300, "Remote Signaller")
	ui.open()

/datum/computer_file/program/signaler/vueui_transfer(oldobj)
	SSvueui.transfer_uis(oldobj, src, "mcomputer-signaler", 400, 300, "Remote Signaller")
	return TRUE

/datum/computer_file/program/signaler/proc/get_radio()
	if(istype(computer, /obj/item/modular_computer/silicon))
		var/obj/item/modular_computer/silicon/true_computer = computer
		if(!istype(true_computer.computer_host, /mob/living/silicon/pai))
			return
		var/mob/living/silicon/pai/host = true_computer.computer_host
		return host.sradio
	else
		if(!computer || !computer.network_card?.sradio)
			return

		return computer.network_card.sradio

// Gathers data for ui
/datum/computer_file/program/signaler/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	data = . || data || list()
	// Gather data for computer header
	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata
		. = data

	radio = get_radio()
	if(!radio)
		return

	VUEUI_SET_CHECK(data["code"], radio.code, ., data)
	VUEUI_SET_CHECK(data["frequency"], format_frequency(radio.frequency), ., data)
	VUEUI_SET_CHECK(data["emagged"], computer.computer_emagged, ., data)
	if(computer.computer_emagged)
		if(doorcode == "RESET")
			VUEUI_SET_CHECK(data["doorcode"], computer.doorcode, ., data)
		VUEUI_SET_CHECK(doorcode, data["doorcode"], ., data)


/datum/computer_file/program/signaler/Topic(href, href_list)
	. = ..()

	radio = get_radio()
	if(!radio)
		return

	if(href_list["send"])
		radio.send_signal("ACTIVATE")
		computer.output_message("[icon2html(host, viewers(get_turf(src)))] *beep* *beep*", 1)
		return TRUE

	else if(href_list["freq"])
		var/new_frequency = (radio.frequency + href_list["freq"])
		if(new_frequency < PUBLIC_LOW_FREQ || new_frequency > PUBLIC_HIGH_FREQ)
			new_frequency = sanitize_frequency(new_frequency)
		radio.set_frequency(new_frequency)
		return TRUE

	else if(href_list["code"])
		radio.code += href_list["code"]
		radio.code = Clamp(1, round(radio.code), 100)
		return TRUE

	else if(href_list["toggledoor"])
		for(var/obj/machinery/door/blast/M in SSmachinery.machinery)
			if(M.id == href_list["toggledoor"])
				if(M.density)
					M.open()
				else
					M.close()
		return TRUE

	else if(href_list["resetcode"])
		if(computer?.doorcode)
			doorcode = "RESET"
			SSvueui.check_uis_for_change(src)
		return TRUE
