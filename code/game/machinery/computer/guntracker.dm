/obj/machinery/computer/guntracker
	name = "firearm control console"
	desc = "A console that can be used to track wireless-enabled firearms, and remotely control their activation."
	icon_screen = "explosive"
	light_color = LIGHT_COLOR_ORANGE
	req_access = list(access_armory)
	circuit = /obj/item/circuitboard/guntracker
	var/id = 0.0
	var/temp = null
	var/status = 0
	var/timeleft = 60
	var/stop = 0.0
	var/screen = 0 // 0 - No Access Denied, 1 - Access allowed

/obj/machinery/computer/guntracker/attack_ai(var/mob/user)
	return attack_hand(user)

/obj/machinery/computer/guntracker/attack_hand(var/mob/user)
	if(..())
		return
	ui_interact(user)

/obj/machinery/computer/guntracker/ui_interact(var/mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if(!ui)
		ui = new /datum/vueui/modularcomputer(user, src, "security-guntracker", 800, 400, "Firearm Control")
	ui.open()
	ui.auto_update_content = TRUE

/obj/machinery/computer/guntracker/vueui_transfer(oldobj)
	. = FALSE
	var/uis = SSvueui.transfer_uis(oldobj, src, "security-guntracker", 800, 400, "Firearm Control")
	for(var/tui in uis)
		var/datum/vueui/ui = tui
		ui.auto_update_content = TRUE
		. = TRUE

/obj/machinery/computer/guntracker/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	data = . || data || list()

	data["screen"] = screen
	var/turf/T = get_turf(src)
	var/list/wireless_firing_pins_data = list()
	for(var/obj/item/device/firing_pin/wireless/P in wireless_firing_pins)
		if(!P.gun)
			continue
		var/turf/Ts = get_turf(P)
		if(ARE_Z_CONNECTED(T.z, Ts.z))
			var/list/guntracker_info = list(
				"gun_name" = P.gun.name,
				"registered_info" = P.registered_user,
				"ref" = "\ref[P]",
				"area" = get_area(P),
				"automatic_state" = (P.lockstatus == 1),
				"disabled_state" = (P.lockstatus == 2),
				"stun_state" = (P.lockstatus == 3),
				"lethal_state" = (P.lockstatus == 4)
				)
			wireless_firing_pins_data[++wireless_firing_pins_data.len] = guntracker_info

	data["wireless_firing_pins"] = sortByKey(wireless_firing_pins_data, "registered_user")

	return data

/obj/machinery/computer/guntracker/Topic(href, href_list)
	if(..())
		return
	if((usr.contents.Find(src) || (in_range(src, usr) && isturf(loc))) || issilicon(usr))
		usr.set_machine(src)

		if(href_list["togglepin1"])
			var/obj/item/device/firing_pin/wireless/P = locate(href_list["togglepin1"])
			if(P)
				P.unlock(1)

		if(href_list["togglepin2"])
			var/obj/item/device/firing_pin/wireless/P = locate(href_list["togglepin2"])
			if(P)
				P.unlock(2)

		if(href_list["togglepin3"])
			var/obj/item/device/firing_pin/wireless/P = locate(href_list["togglepin3"])
			if(P)
				P.unlock(3)

		if(href_list["togglepin4"])
			var/obj/item/device/firing_pin/wireless/P = locate(href_list["togglepin4"])
			if(P)
				P.unlock(4)

		if(href_list["lock"])
			if(allowed(usr))
				screen = !screen
			else
				to_chat(usr, "Unauthorized Access.")
	return