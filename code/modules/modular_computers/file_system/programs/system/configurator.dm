// This is special hardware configuration program.
// It is to be used only with modular computers.
// It allows you to toggle components of your device.

/datum/computer_file/program/computerconfig
	filename = "hardwareconfig"
	filedesc = "Hardware Configuration Tool"
	extended_desc = "This program allows configuration of the computer's hardware."
	program_icon_state = "generic"
	program_key_icon_state = "green_key"
	color = LIGHT_COLOR_GREEN
	unsendable = TRUE
	undeletable = TRUE
	size = 2
	available_on_ntnet = FALSE
	requires_ntnet = FALSE

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
	VUEUI_SET_CHECK(data["power_usage"], computer.last_power_usage * (CELLRATE / 2), ., data)
	VUEUI_SET_CHECK(data["card_slot"], computer.card_slot, ., data)
	if(computer.registered_id)
		VUEUI_SET_CHECK(data["registered"], computer.registered_id.registered_name, ., data)
	else
		VUEUI_SET_CHECK(data["registered"], 0, ., data)
	if(!computer.battery_module)
		VUEUI_SET_CHECK(data["battery"], 0, ., data)
	else
		LAZYINITLIST(data["battery"])
		VUEUI_SET_CHECK(data["battery"]["rating"], computer.battery_module.battery.maxcharge, ., data)
		VUEUI_SET_CHECK(data["battery"]["percent"], round(computer.battery_module.battery.percent()), ., data)

	if(computer.flashlight)
		var/brightness = Clamp(0, round(computer.flashlight.power) * 10, 10)
		VUEUI_SET_CHECK_IFNOTSET(data["brightness"], brightness, ., data)

		if(data["brightness"])
			var/new_brightness = Clamp(0, data["brightness"]/10, 1)
			computer.flashlight.tweak_brightness(new_brightness)

	VUEUI_SET_CHECK_IFNOTSET(data["message_range"], computer.message_output_range, ., data)
	VUEUI_SET_CHECK_IFNOTSET(data["max_message_range"], initial(computer.message_output_range) + 3, ., data)

	if(data["message_range"])
		computer.message_output_range = clamp(data["message_range"], 0, initial(computer.message_output_range) + 3)

	LAZYINITLIST(data["hardware"])
	for(var/obj/item/computer_hardware/H in hardware)
		LAZYINITLIST(data["hardware"][H.name])
		for(var/v in list("name", "desc", "enabled", "critical", "power_usage"))
			if(v == "power_usage")
				var/watt_usage = H.vars[v] * (CELLRATE / 2)
				VUEUI_SET_CHECK(data["hardware"][H.name][v], watt_usage, ., data)
			else
				VUEUI_SET_CHECK(data["hardware"][H.name][v], H.vars[v], ., data)
