/datum/computer_file/program/uplink
	filename = "uplink"
	filedesc = "Syndicate Uplink"
	nanomodule_path = /datum/nano_module/uplink
	program_icon_state = "hostile"
	extended_desc = "Uplink to Syndicate command and control."
	size = 25
	available_on_ntnet = 0
	available_on_syndinet = 1
	color = LIGHT_COLOR_RED

/datum/nano_module/uplink
	name = "Syndicate Uplink"
	available_to_ai = FALSE
	var/obj/item/device/uplink/hidden/attached_uplink

/datum/nano_module/uplink/New()
	. = ..()
	if(istype(host, /obj/item/modular_computer))
		var/obj/item/modular_computer/console = host
		if(console.hidden_uplink)
			attached_uplink = console.hidden_uplink

/datum/nano_module/uplink/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui=null, force_open = 1, state = default_state)
	var/list/data = host.initial_data()

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "synd_uplink.tmpl", "Syndicate Uplink", 900, 800, state = state)
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/uplink/Topic(href, href_list)
	if(..())
		return 1

	var/mob/user = usr
	var/datum/nanoui/ui = SSnanoui.get_open_ui(user, src, "main")

	if(href_list["uplink"])
		if(attached_uplink)
			attached_uplink.trigger(usr)
			ui.close()
		else
			to_chat(usr, span("warning", "No attached uplink detected at this console!"))