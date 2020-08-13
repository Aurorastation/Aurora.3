/obj/machinery/computer/smartguncontrol
	name = "smartgun control console"
	desc = "A console that can be used to track smartgun enabled firearms, and remotely control their activation."
	icon_screen = "explosive"
	light_color = LIGHT_COLOR_ORANGE
	req_access = list(access_armory)
	circuit = /obj/item/circuitboard/smartguncontrol
	var/id = 0.0
	var/temp = null
	var/status = 0
	var/timeleft = 60
	var/stop = 0.0
	var/screen = 0 // 0 - No Access Denied, 1 - Access allowed

/obj/machinery/computer/smartguncontrol/attack_ai(var/mob/user)
	return attack_hand(user)

/obj/machinery/computer/smartguncontrol/attack_hand(var/mob/user)
	if(..())
		return
	ui_interact(user)

/obj/machinery/computer/smartguncontrol/ui_interact(var/mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if(!ui)
		ui = new /datum/vueui/modularcomputer(user, src, "security-smartguncontrol", 400, 500, "Smartgun Control")
	ui.open()

/obj/machinery/computer/smartguncontrol/vueui_transfer(oldobj)
	. = FALSE
	var/uis = SSvueui.transfer_uis(oldobj, src, "security-smartguncontrol", 400, 500, "Smartgun Control")
	for(var/tui in uis)
		var/datum/vueui/ui = tui
		ui.auto_update_content = TRUE
		. = TRUE

/obj/machinery/computer/smartguncontrol/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	data = . || data || list()

	data["screen"] = screen
	var/turf/T = get_turf(src)
	var/list/smartguns_data = list()
	for(var/obj/item/device/firing_pin/security_pin/P in smartguns)
		if(!P.gun)
			continue
		var/turf/Ts = get_turf(P)
		if(ARE_Z_CONNECTED(T.z, Ts.z))
			var/list/smartgun_info = list(
				"gun_name" = P.gun.name,
				"registered_user" = P.registered_user,
				"lock_status" = P.lockstatus,
				"disable_status" = P.disablestatus,
				"ref" = "\ref[P]",
				"area" = get_area(P)
				)
			smartguns_data[++smartguns_data.len] = smartgun_info

	data["smartguns"] = sortByKey(smartguns_data, "registered_user")

	return data

/obj/machinery/computer/smartguncontrol/Topic(href, href_list)
	if(..())
		return
	if((usr.contents.Find(src) || (in_range(src, usr) && isturf(loc))) || issilicon(usr))
		usr.set_machine(src)

		if(href_list["togglepin"])
			var/obj/item/device/firing_pin/security_pin/P = locate(href_list["togglepin"])
			if(P)
				P.unlock()

		if(href_list["toggledisable"])
			var/obj/item/device/firing_pin/security_pin/P = locate(href_list["toggledisable"])
			if(P)
				P.disable()

		if(href_list["lock"])
			if(allowed(usr))
				screen = !screen
			else
				to_chat(usr, "Unauthorized Access.")
	return