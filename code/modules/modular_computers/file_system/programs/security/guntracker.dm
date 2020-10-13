/datum/computer_file/program/guntracker
	filename = "guntracker"
	filedesc = "Firearm Control"
	extended_desc = "Official NTsec program for the tracking and remote control of wireless-enabled firearms."
	program_icon_state = "security"
	color = LIGHT_COLOR_ORANGE
	size = 8
	requires_ntnet = TRUE
	available_on_ntnet = TRUE
	required_access_download = access_hos
	required_access_run = access_armory
	usage_flags = PROGRAM_CONSOLE

/datum/computer_file/program/guntracker/ui_interact(var/mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if(!ui)
		ui = new /datum/vueui/modularcomputer(user, src, "mcomputer-security-guntracker", 600, 400, "Firearm Control System")
	ui.open()
	ui.auto_update_content = TRUE

/datum/computer_file/program/guntracker/vueui_transfer(oldobj)
	. = FALSE
	var/uis = SSvueui.transfer_uis(oldobj, src, "mcomputer-security-guntracker", 600, 400, "Firearm Control")
	for(var/tui in uis)
		var/datum/vueui/ui = tui
		ui.auto_update_content = TRUE
		. = TRUE

/datum/computer_file/program/guntracker/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	data = . || data || list()

	// Gather data for computer header
	data["_PC"] = get_header_data(data["_PC"])

	var/turf/T = get_turf(computer.loc)
	var/list/wireless_firing_pins_data = list()
	for(var/i in wireless_firing_pins)
		var/obj/item/device/firing_pin/wireless/P = i
		if(!P.gun)
			continue
		var/turf/Ts = get_turf(P)
		if(ARE_Z_CONNECTED(T.z, Ts.z))
			var/list/guntracker_info = list(
				"gun_name" = capitalize_first_letters(P.gun.name),
				"registered_info" = P.registered_user ? P.registered_user : "Unregistered",
				"ref" = "\ref[P]",
				"lockstatus" = P.lockstatus
				)
			wireless_firing_pins_data[++wireless_firing_pins_data.len] = guntracker_info

	data["wireless_firing_pins"] = sortByKey(wireless_firing_pins_data, "registered_info")

	return data

/datum/computer_file/program/guntracker/Topic(href, href_list)
	if(..())
		return

	//Try and get the pin if a pin is passed
	var/obj/item/device/firing_pin/wireless/P = null
	if(href_list["pin"])
		P = locate(href_list["pin"]) in wireless_firing_pins

	switch(href_list["action"])
		if("setauto")
			if(P)
				P.set_mode(WIRELESS_PIN_AUTOMATIC)
				SSvueui.check_uis_for_change(src)
		if("setdisable")
			if(P)
				P.set_mode(WIRELESS_PIN_DISABLED)
				SSvueui.check_uis_for_change(src)
		if("setstun")
			if(P)
				P.set_mode(WIRELESS_PIN_STUN)
				SSvueui.check_uis_for_change(src)
		if("setlethal")
			if(P)
				P.set_mode(WIRELESS_PIN_LETHAL)
				SSvueui.check_uis_for_change(src)
	return
