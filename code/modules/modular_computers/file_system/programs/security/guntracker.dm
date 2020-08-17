/datum/computer_file/program/guntracker
	filename = "guntracker"
	filedesc = "Firearm Control"
	extended_desc = "Official NTsec program for the tracking and remote control of wireless-enabled firearms."
	program_icon_state = "security"
	color = LIGHT_COLOR_ORANGE
	size = 8
	requires_ntnet = TRUE
	available_on_ntnet = TRUE
	required_access_download = access_armory
//	required_access_run = access_armory
	usage_flags = PROGRAM_CONSOLE

/datum/computer_file/program/guntracker/ui_interact(var/mob/user)

/datum/computer_file/program/guntracker/ui_interact(var/mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if(!ui)
		ui = new /datum/vueui/modularcomputer(user, src, "security-guntracker", 600, 400, "Firearm Control")
	ui.open()
	ui.auto_update_content = TRUE

/datum/computer_file/program/guntracker/vueui_transfer(oldobj)
	. = FALSE
	var/uis = SSvueui.transfer_uis(oldobj, src, "security-guntracker", 600, 400, "Firearm Control")
	for(var/tui in uis)
		var/datum/vueui/ui = tui
		ui.auto_update_content = TRUE
		. = TRUE

/datum/computer_file/program/guntracker/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	data = . || data || list()

	var/turf/T = get_turf(computer.loc)
	var/list/wireless_firing_pins_data = list()
	for(var/obj/item/device/firing_pin/wireless/P in wireless_firing_pins)
		if(!P.gun)
			continue
		var/turf/Ts = get_turf(P)
		if(ARE_Z_CONNECTED(T.z, Ts.z))
			var/list/guntracker_info = list(
				"gun_name" = capitalize_first_letters(P.gun.name),
				"registered_info" = P.registered_user,
				"ref" = "\ref[P]",
				"automatic_state" = (P.lockstatus == WIRELESS_PIN_AUTOMATIC),
				"disabled_state" = (P.lockstatus == WIRELESS_PIN_DISABLED),
				"stun_state" = (P.lockstatus == WIRELESS_PIN_STUN),
				"lethal_state" = (P.lockstatus == WIRELESS_PIN_LETHAL)
				)
			wireless_firing_pins_data[++wireless_firing_pins_data.len] = guntracker_info

	data["wireless_firing_pins"] = sortByKey(wireless_firing_pins_data, "registered_info")

	return data

/datum/computer_file/program/guntracker/Topic(href, href_list)
	if(..())
		return

	if((usr.contents.Find(src) || (in_range(src, usr) && isturf(computer.loc))) || issilicon(usr))
		usr.set_machine(src)

		if(href_list["togglepin1"]) // Sets the wireless-control firing pin to automatic
			var/obj/item/device/firing_pin/wireless/P = locate(href_list["togglepin1"])
			if(P)
				P.unlock(WIRELESS_PIN_AUTOMATIC)

		if(href_list["togglepin2"]) // Sets the wireless-control firing pin to disabled
			var/obj/item/device/firing_pin/wireless/P = locate(href_list["togglepin2"])
			if(P)
				P.unlock(WIRELESS_PIN_DISABLED)

		if(href_list["togglepin3"]) // Sets the wireless-control firing pin to stun-only
			var/obj/item/device/firing_pin/wireless/P = locate(href_list["togglepin3"])
			if(P)
				P.unlock(WIRELESS_PIN_STUN)

		if(href_list["togglepin4"]) // Sets the wireless-control firing pin to unrestricted
			var/obj/item/device/firing_pin/wireless/P = locate(href_list["togglepin4"])
			if(P)
				P.unlock(WIRELESS_PIN_LETHAL)

	return