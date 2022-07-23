/datum/computer_file/program/guntracker
	filename = "guntracker"
	filedesc = "Firearm Control"
	extended_desc = "Official NTsec program for the tracking and remote control of wireless-enabled firearms."
	program_icon_state = "security"
	program_key_icon_state = "yellow_key"
	color = LIGHT_COLOR_ORANGE
	size = 8
	requires_ntnet = TRUE
	available_on_ntnet = TRUE
	required_access_download = access_hos
	required_access_run = access_armory
	usage_flags = PROGRAM_CONSOLE
	var/list/wireless_firing_pins_data

/datum/computer_file/program/guntracker/ui_interact(var/mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if(!ui)
		ui = new /datum/vueui/modularcomputer(user, src, "mcomputer-security-guntracker", 600, 400, "Firearm Control System")
		ui.auto_update_content = TRUE
	ui.open()

/datum/computer_file/program/guntracker/vueui_transfer(oldobj)
	. = FALSE
	var/uis = SSvueui.transfer_uis(oldobj, src, "mcomputer-security-guntracker", 600, 400, "Firearm Control System")
	for(var/tui in uis)
		var/datum/vueui/ui = tui
		ui.auto_update_content = TRUE
		. = TRUE

/datum/computer_file/program/guntracker/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	data = . || data || list()

	// Gather data for computer header
	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata
		. = data

	var/turf/T = get_turf(computer.loc)

	LAZYINITLIST(wireless_firing_pins_data)
	LAZYCLEARLIST(wireless_firing_pins_data)

	for(var/i in wireless_firing_pins)
		var/obj/item/device/firing_pin/wireless/P = i
		if(!istype(P) || !P.gun)
			continue
		var/turf/Ts = get_turf(P)
		if(AreConnectedZLevels(T.z, Ts.z))
			var/list/guntracker_info = list(
				"gun_name" = capitalize_first_letters(P.gun.name),
				"registered_info" = P.registered_user ? P.registered_user : "Unregistered",
				"ref" = "\ref[P]",
				"lock_status" = P.lock_status
				)
			wireless_firing_pins_data[++wireless_firing_pins_data.len] = guntracker_info

	data["wireless_firing_pins"] = wireless_firing_pins_data

	return data

/datum/computer_file/program/guntracker/Topic(href, href_list)
	if(..())
		return TRUE

	//Try and get the pin if a pin is passed
	var/obj/item/device/firing_pin/wireless/P = null
	if(href_list["pin"])
		P = locate(href_list["pin"]) in wireless_firing_pins

	if(!istype(P))
		return

	switch(href_list["action"])
		if("setauto")
			P.set_mode(WIRELESS_PIN_AUTOMATIC)
		if("setdisable")
			P.set_mode(WIRELESS_PIN_DISABLED)
		if("setstun")
			P.set_mode(WIRELESS_PIN_STUN)
		if("setlethal")
			P.set_mode(WIRELESS_PIN_LETHAL)

	SSvueui.check_uis_for_change(src)
	return
