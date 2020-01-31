// This is special hardware configuration program.
// It is to be used only with modular computers.
// It allows you to toggle components of your device.

/datum/computer_file/program/clientmanager
	filename = "clientmanager"
	filedesc = "NTOS Client Manager"
	extended_desc = "This program allows configuration of the computer's software."
	program_icon_state = "generic"
	color = LIGHT_COLOR_GREEN
	unsendable = TRUE
	undeletable = TRUE
	size = 4
	available_on_ntnet = FALSE
	requires_ntnet = FALSE

/datum/computer_file/program/clientmanager/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new /datum/vueui/modularcomputer(user, src, "mcomputer-system-manager", 575, 700, "NTOS Client Manager")
	ui.open()

/datum/computer_file/program/clientmanager/vueui_transfer(oldobj)
	SSvueui.transfer_uis(oldobj, src, "mcomputer-system-manager", 575, 700, "NTOS Client Manager")
	return TRUE

// Gaters data for ui
/datum/computer_file/program/clientmanager/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	data = . || data || list()
	// Gather data for computer header
	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata
		. = data
	if(!computer)
		return
	VUEUI_SET_CHECK_IFNOTSET(data["device_type"], 0, ., data)
	VUEUI_SET_CHECK_IFNOTSET(data["device_preset"], "", ., data)

	VUEUI_SET_CHECK(data["enrollment_status"], computer.enrolled, ., data)
	VUEUI_SET_CHECK(data["ntnet_status"], ntnet_global.check_function(NTNET_SOFTWAREDOWNLOAD), ., data)
	
	LAZYINITLIST(data["presets"])
	for (var/datum/modular_computer_app_presets/p in ntnet_global.available_software_presets)
		if(p.available)
			LAZYINITLIST(data["presets"][p.name])
			VUEUI_SET_CHECK(data["presets"][p.name]["name"], p.display_name, ., data)
			VUEUI_SET_CHECK(data["presets"][p.name]["description"], p.description, ., data)


/datum/computer_file/program/clientmanager/Topic(href, href_list)
	if(..())
		return TRUE

	if(href_list["enroll"])
		if(ntnet_global.check_function(NTNET_SOFTWAREDOWNLOAD))
			if(href_list["enroll"]["type"] == 1)
				enroll_company_device(href_list["enroll"]["preset"])
				return TRUE
			if(href_list["enroll"]["type"] == 2)
				enroll_private_device()
				return TRUE
	return FALSE

//Set´s up the computer with the file manager and the downloader and removes the lock
/datum/computer_file/program/clientmanager/proc/enroll_private_device()
	if(!computer)
		return FALSE
	computer.enrolled = 2 // private devices
	computer.hard_drive.store_file(new /datum/computer_file/program/filemanager())
	computer.hard_drive.store_file(new /datum/computer_file/program/ntnetdownload())
	computer.hard_drive.store_file(new /datum/computer_file/program/chatclient())
	return TRUE

//Set´s up the programs from the preset
/datum/computer_file/program/clientmanager/proc/enroll_company_device(var/preset)
	if(!computer)
		return FALSE

	for (var/datum/modular_computer_app_presets/prs in ntnet_global.available_software_presets)
		if(prs.name == preset && prs.available == 1)
			var/list/prs_programs = prs.return_install_programs()
			for (var/datum/computer_file/program/prog in prs_programs)
				computer.hard_drive.store_file(prog)
			computer.enrolled = 1 // enroll as company device after finding matching preset and storing software
			return TRUE
	return FALSE