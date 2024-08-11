/// Special software that allows for the configuration of software, and the device's status as a personal/company device.

/datum/computer_file/program/clientmanager
	filename = "clientmanager"
	filedesc = "NTOS Client Manager"
	extended_desc = "This program allows configuration of the computer's software."
	program_icon_state = "generic"
	program_key_icon_state = "green_key"
	color = LIGHT_COLOR_GREEN
	unsendable = TRUE
	undeletable = TRUE
	size = 2
	available_on_ntnet = FALSE
	requires_ntnet = FALSE

	tgui_id = "NTOSClientManager"

/datum/computer_file/program/clientmanager/ui_static_data(mob/user)
	var/list/data = list()
	data["enrollment"] = computer.enrolled
	data["available_presets"] = list()
	for(var/datum/modular_computer_app_presets/p in GLOB.ntnet_global.available_software_presets)
		if(p.available)
			data["available_presets"][p.display_name] = p.description
	return data

/datum/computer_file/program/clientmanager/ui_data(mob/user)
	var/list/data = list()
	data["ntnet_status"] = GLOB.ntnet_global.check_function(NTNET_SOFTWAREDOWNLOAD)
	return data

/datum/computer_file/program/clientmanager/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	if(action == "enroll")
		. = TRUE
		if(!GLOB.ntnet_global.check_function(NTNET_SOFTWAREDOWNLOAD))
			to_chat(ui.user, SPAN_WARNING("Cannot connect to NTNet download servers. Please try again later."))
			return
		if(params["enroll_type"] & DEVICE_COMPANY)
			enroll_company_device(params["enroll_preset"])
		else
			enroll_private_device()

/// Sets up the device as a generic, personal device, with only basic programs (file manager, downloads, chat client)
/datum/computer_file/program/clientmanager/proc/enroll_private_device()
	if(!computer)
		return
	computer.enrolled = DEVICE_PRIVATE // private devices
	computer.hard_drive.store_file(new /datum/computer_file/program/filemanager(computer))
	computer.hard_drive.store_file(new /datum/computer_file/program/ntnetdownload(computer))
	computer.hard_drive.store_file(new /datum/computer_file/program/chat_client(computer))
	update_static_data_for_all_viewers()

/// Enrolls the device as a given software preset, and sets it as a company device
/datum/computer_file/program/clientmanager/proc/enroll_company_device(var/preset)
	if(!computer)
		return

	for (var/datum/modular_computer_app_presets/prs in GLOB.ntnet_global.available_software_presets)
		if(prs.display_name == preset && prs.available == 1)
			var/list/prs_programs = prs.return_install_programs(computer)
			for (var/datum/computer_file/program/prog in prs_programs)
				if(!prog.is_supported_by_hardware(computer.hardware_flag, FALSE))
					continue
				computer.hard_drive.store_file(prog)
			computer.enrolled = DEVICE_COMPANY // enroll as company device after finding matching preset and storing software
			break
	update_static_data_for_all_viewers()
