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

	tgui_id = "NTOSConfig"

/datum/computer_file/program/computerconfig/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	if(action == "brightness" && computer.flashlight)
		var/new_brightness = Clamp(0, params["new_brightness"]/10, 1)
		computer.flashlight.tweak_brightness(new_brightness)
		. = TRUE

	if(action == "audmessage")
		computer.message_output_range = clamp(params["new_range"], 0, initial(computer.message_output_range) + 3)
		. = TRUE

/datum/computer_file/program/computerconfig/ui_static_data(mob/user)
	var/list/data = ..() || list()
	data["disk_size"] = computer.hard_drive.max_capacity
	data["disk_used"] = computer.hard_drive.used_capacity
	data["card_slot"] = !!computer.card_slot
	data["registered"] = computer.registered_id ? computer.registered_id.registered_name : ""

	data["max_message_range"] = initial(computer.message_output_range) + 3

	data["hardware"] = list()
	for(var/obj/item/computer_hardware/H in computer.get_all_components())
		var/list/hardware_data = list()
		for(var/v in list("name", "desc", "enabled", "critical", "power_usage"))
			if(v == "power_usage")
				var/watt_usage = H.vars[v] * (CELLRATE / 2)
				hardware_data[v] = watt_usage
			else
				hardware_data[v] = H.vars[v]
		if(hardware_data.len)
			data["hardware"] += list(hardware_data)

	return data

/datum/computer_file/program/computerconfig/ui_data(mob/user)
	var/list/data = list()
	data["power_usage"] = computer.last_power_usage * (CELLRATE / 2)
	data["message_range"] = computer.message_output_range

	data["battery"] = computer.battery_module ? list("rating" = computer.battery_module.battery_rating, "percent" = computer.battery_module.battery.percent()) : null

	if(computer.flashlight)
		var/brightness = Clamp(0, round(computer.flashlight.power, 0.1) * 10, 10)
		data["brightness"] = brightness

	return data
