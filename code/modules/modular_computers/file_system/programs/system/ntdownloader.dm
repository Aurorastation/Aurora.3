/datum/computer_file/program/ntnetdownload
	filename = "ntndownloader"
	filedesc = "NTNet Software Download Tool"
	program_icon_state = "generic"
	extended_desc = "This program allows the download of software from official NT repositories."
	color = LIGHT_COLOR_GREEN
	unsendable = TRUE
	undeletable = TRUE
	size = 4
	requires_ntnet = TRUE
	requires_ntnet_feature = NTNET_SOFTWAREDOWNLOAD
	available_on_ntnet = FALSE
	nanomodule_path = /datum/nano_module/program/computer_ntnetdownload
	ui_header = "downloader_finished.gif"
	var/datum/computer_file/program/downloaded_file
	var/hacked_download = FALSE
	var/download_completion = 0 //GQ of downloaded data.
	var/download_netspeed = 0
	var/download_last_update = 0 // For tracking download rates and completion.
	var/downloaderror = ""
	var/downstream_variance = 0.1

/datum/computer_file/program/ntnetdownload/proc/begin_file_download(var/filename, var/user)
	if(downloaded_file)
		return FALSE

	var/datum/computer_file/program/PRG = ntnet_global.find_ntnet_file_by_name(filename)

	if(!PRG || !istype(PRG))
		return FALSE

	// Attempting to download antag only program, but without having emagged computer. No.
	if(PRG.available_on_syndinet && !computer_emagged)
		return FALSE

	if(!computer?.hard_drive?.try_store_file(PRG))
		return FALSE

	if(computer.enrolled == TRUE && !computer_emagged)
		return FALSE

	ui_header = "downloader_running.gif"

	if(PRG in ntnet_global.available_station_software)
		generate_network_log("Began downloading file [PRG.filename].[PRG.filetype] from NTNet Software Repository.")
		hacked_download = FALSE
	else if(PRG in ntnet_global.available_antag_software)
		generate_network_log("Began downloading file **ENCRYPTED**.[PRG.filetype] from unspecified server.")
		hacked_download = TRUE
	else
		generate_network_log("Began downloading file [PRG.filename].[PRG.filetype] from unspecified server.")
		hacked_download = FALSE

	downloaded_file = PRG.clone()
	if(user)
		spawn()
			ui_interact(user)

/datum/computer_file/program/ntnetdownload/proc/abort_file_download()
	if(!downloaded_file)
		return
	generate_network_log("Aborted download of file [hacked_download ? "**ENCRYPTED**" : downloaded_file.filename].[downloaded_file.filetype].")
	downloaded_file = null
	download_completion = 0
	download_last_update = 0
	ui_header = "downloader_finished.gif"

/datum/computer_file/program/ntnetdownload/proc/complete_file_download()
	if(!downloaded_file)
		return
	generate_network_log("Completed download of file [hacked_download ? "**ENCRYPTED**" : downloaded_file.filename].[downloaded_file.filetype].")
	if(!computer?.hard_drive?.store_file(downloaded_file))
		// The download failed
		downloaderror = "I/O ERROR - Unable to save file. Check whether you have enough free space on your hard drive and whether your hard drive is properly connected. If the issue persists contact your system administrator for assistance."
	else
		playsound(get_turf(computer), 'sound/machines/ping.ogg', 40, 0)
		computer.output_message("\icon[computer] <b>[capitalize_first_letters(computer)]</b> pings, \"Software download completed successfully!\"", 1)
	downloaded_file = null
	download_completion = 0
	download_last_update = 0
	ui_header = "downloader_finished.gif"

/datum/computer_file/program/ntnetdownload/process_tick()
	if(!downloaded_file)
		return
	if(download_completion >= downloaded_file.size)
		complete_file_download()
		return
	// Download speed according to connectivity state. NTNet server is assumed to be on unlimited speed so we're limited by our local connectivity
	download_netspeed = 0
	// Speed defines are found in misc.dm
	switch(ntnet_status)
		if(1)
			download_netspeed = NTNETSPEED_LOWSIGNAL
			downstream_variance = 0.3
		if(2)
			download_netspeed = NTNETSPEED_HIGHSIGNAL
			downstream_variance = 0.2
		if(3)
			download_netspeed = NTNETSPEED_ETHERNET

	// We recovered connection or started a new download.
	// So we don't have any bytes yet. We'll get them next time!
	if (!download_last_update)
		download_last_update = world.time
		return

	var/delta = ((rand() - 0.5) * 2) * downstream_variance * download_netspeed
	//Download speed varies +/- 10% each proc. Adds a more realistic feel

	download_netspeed += delta
	download_netspeed = round(download_netspeed, 0.002)//3 decimal places

	var/delta_seconds = (world.time - download_last_update) / 10

	download_completion = min(download_completion + delta_seconds * download_netspeed, downloaded_file.size)

	// No connection, so cancel the download.
	// This is done at the end because of logic reasons.
	// Trust me, it's fine. - Skull132
	if (!download_netspeed)
		download_last_update = 0
	else
		download_last_update = world.time

/datum/computer_file/program/ntnetdownload/Topic(href, href_list)
	if(..())
		return TRUE
	if(href_list["PRG_downloadfile"])
		if(!downloaded_file)
			begin_file_download(href_list["PRG_downloadfile"], usr)
		return TRUE
	if(href_list["PRG_reseterror"])
		if(downloaderror)
			download_completion = 0
			download_netspeed = 0
			downloaded_file = null
			downloaderror = ""
		return TRUE
	return FALSE

/datum/nano_module/program/computer_ntnetdownload
	name = "Network Downloader"
	var/obj/item/modular_computer/my_computer

/datum/nano_module/program/computer_ntnetdownload/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	if(program)
		my_computer = program.computer

	if(!istype(my_computer))
		return

	var/list/data = list()
	var/datum/computer_file/program/ntnetdownload/prog = program
	// For now limited to execution by the downloader program
	if(!prog || !istype(prog))
		return
	if(program)
		data = list("_PC" = program.get_header_data())

	// This IF cuts on data transferred to client, so i guess it's worth it.
	if(prog.downloaderror) // Download errored. Wait until user resets the program.
		data["error"] = prog.downloaderror
	else if(prog.downloaded_file) // Download running. Wait please..
		if (ui)
			ui.set_auto_update(TRUE)
		data["downloadname"] = prog.downloaded_file.filename
		data["downloaddesc"] = prog.downloaded_file.filedesc
		data["downloadsize"] = prog.downloaded_file.size
		data["downloadspeed"] = prog.download_netspeed //Even if it does update every 2 seconds, this is bad coding on everyone's count. :ree:
		data["downloadcompletion"] = round(prog.download_completion, 0.01)
	else // No download running, pick file.
		if (ui)
			ui.set_auto_update(FALSE)//No need for auto updating on the software menu
		data["disk_size"] = my_computer.hard_drive.max_capacity
		data["disk_used"] = my_computer.hard_drive.used_capacity
		if(my_computer.enrolled == 2) //To lock installation of software on work computers until the IT Department is properly implemented - Then check for access on enrolled computers
			data += get_programlist(user)
		else
			data["downloadable_programs"] = list()
			data["locked"] = TRUE
	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "ntnet_downloader.tmpl", "NTNet Download Program", 575, 700, state = state)
		ui.auto_update_layout = TRUE
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)


/datum/nano_module/program/computer_ntnetdownload/proc/get_programlist(var/mob/user)
	var/list/all_entries[0]
	var/datum/computer_file/program/ntnetdownload/prog = program
	var/list/data = list()
	data["hackedavailable"] = FALSE
	for(var/datum/computer_file/program/P in ntnet_global.available_station_software)
		var/installed = FALSE
		for(var/datum/computer_file/program/Q in program.hard_drive.stored_files)
			if(istype(P, Q.type))
				installed = TRUE
				break

		if(!installed)
			// Only those programs our user can run will show in the list
			if(!P.can_download(user) && P.requires_access_to_download)
				continue
			
			if(!P.is_supported_by_hardware(program.computer.hardware_flag))
				continue

			all_entries.Add(list(list(
				"filename" = P.filename,
				"filedesc" = P.filedesc,
				"fileinfo" = P.extended_desc,
				"size" = P.size
				)))

	if(prog.computer_emagged) // If we are running on emagged computer we have access to some "bonus" software
		var/list/hacked_programs[0]
		for(var/datum/computer_file/program/P in ntnet_global.available_antag_software)
			var/installed = FALSE
			for(var/datum/computer_file/program/Q in program.hard_drive.stored_files)
				if(istype(P, Q.type))
					installed = TRUE
					break

			if(!installed)
				data["hackedavailable"] = TRUE
				hacked_programs.Add(list(list(
				"filename" = P.filename,
				"filedesc" = P.filedesc,
				"fileinfo" = P.extended_desc,
				"size" = P.size
				)))
				data["hacked_programs"] = hacked_programs


	data["downloadable_programs"] = all_entries
	return data