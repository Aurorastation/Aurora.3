/datum/computer_file/program/guntracker
	filename = "guntracker"
	filedesc = "Firearms System Control Panel"
	extended_desc = "Official Zavodskoi program for the tracking and remote control of wireless-enabled firearms."
	program_icon_state = "security"
	program_key_icon_state = "yellow_key"
	color = LIGHT_COLOR_ORANGE
	size = 8
	requires_ntnet = TRUE
	available_on_ntnet = TRUE
	required_access_download = ACCESS_HOS
	required_access_run = ACCESS_ARMORY
	usage_flags = PROGRAM_CONSOLE | PROGRAM_SILICON_AI
	tgui_id = "GunTracker"
	var/list/wireless_firing_pins_data

/datum/computer_file/program/guntracker/ui_data(mob/user)

	var/list/data = list()

	// Gather data for computer header
	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata
		. = data

	var/turf/T = get_turf(computer.loc)

	LAZYINITLIST(wireless_firing_pins_data)
	LAZYCLEARLIST(wireless_firing_pins_data)

	for(var/i in GLOB.wireless_firing_pins)
		var/obj/item/device/firing_pin/wireless/P = i
		if(!istype(P) || !P.gun)
			continue
		var/turf/Ts = get_turf(P)
		if(AreConnectedZLevels(T.z, Ts.z))
			var/list/guntracker_info = list(
				"gun_name" = capitalize_first_letters(P.gun.name),
				"registered_info" = P.registered_user ? P.registered_user : "Unregistered",
				"ref" = "[REF(P)]",
				"lock_status" = P.lock_status
				)
			wireless_firing_pins_data += list(guntracker_info)

	data["wireless_firing_pins"] = wireless_firing_pins_data

	return data

/datum/computer_file/program/guntracker/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	//Try and get the pin if a pin is passed
	var/obj/item/device/firing_pin/wireless/P
	if(params["pin"])
		P = locate(params["pin"]) in GLOB.wireless_firing_pins

	if(!istype(P))
		return

	switch(action)
		if("set_auto")
			P.set_mode(WIRELESS_PIN_AUTOMATIC)
			. = TRUE
		if("set_disable")
			P.set_mode(WIRELESS_PIN_DISABLED)
			. = TRUE
		if("set_stun")
			P.set_mode(WIRELESS_PIN_STUN)
			. = TRUE
		if("set_lethal")
			P.set_mode(WIRELESS_PIN_LETHAL)
			. = TRUE
