// This is special hardware configuration program.
// It is to be used only with modular computers.
// It allows you to toggle components of your device.

/datum/computer_file/program/computerconfig
	filename = "compconfig"
	filedesc = "Computer Configuration Tool"
	extended_desc = "This program allows configuration of computer's hardware"
	program_icon_state = "generic"
	color = LIGHT_COLOR_GREEN
	unsendable = 1
	undeletable = 1
	size = 4
	available_on_ntnet = 0
	requires_ntnet = 0

/datum/computer_file/program/computerconfig/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new /datum/vueui/modularcomputer(user, src, "mcomputer-system-config", 575, 700, "NTOS Configuration Utility")
	ui.open()

/datum/computer_file/program/computerconfig/vueui_transfer(oldobj)
	SSvueui.transfer_uis(oldobj, src, "mcomputer-system-config", 575, 700, "NTOS Configuration Utility")
	return TRUE

// Gaters data for ui
/datum/computer_file/program/computerconfig/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	data = . || data || list()
	// Gather data for computer header
	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata
		. = data
	
	if(!computer)
		return

	var/list/hardware = computer.get_all_components()
	VUEUI_SET_CHECK(data["disk_size"], computer.hard_drive.max_capacity, ., data)
	VUEUI_SET_CHECK(data["disk_used"], computer.hard_drive.used_capacity, ., data)
	VUEUI_SET_CHECK(data["power_usage"], computer.last_power_usage, ., data)
	if(!computer.battery_module)
		VUEUI_SET_CHECK(data["battery"], 0, ., data)
	else
		LAZYINITLIST(data["battery"])
		VUEUI_SET_CHECK(data["battery"]["rating"], computer.battery_module.battery.maxcharge, ., data)
		VUEUI_SET_CHECK(data["battery"]["percent"], round(computer.battery_module.battery.percent()), ., data)

	LAZYINITLIST(data["hardware"])
	for(var/obj/item/computer_hardware/H in hardware)
		LAZYINITLIST(data["hardware"][H.name])
		for(var/v in list("name", "desc", "enabled", "critical", "power_usage"))
			VUEUI_SET_CHECK(data["hardware"][H.name][v], H.vars[v], ., data)