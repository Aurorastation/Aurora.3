/datum/computer_file/program/ntnetdownload
	filename = "ntndownloader"
	filedesc = "NTNet Software Download Tool"
	program_icon_state = "generic"
	extended_desc = "This program allows the download of software from official NT repositories."
	color = LIGHT_COLOR_GREEN
	unsendable = TRUE
	undeletable = TRUE
	size = 2
	requires_ntnet = TRUE
	requires_ntnet_feature = NTNET_SOFTWAREDOWNLOAD
	available_on_ntnet = 0
	ui_header = "downloader_finished.gif"
	var/list/download_queue = list()
	var/list/download_files = list()
	var/queue_size = 0
	var/active_download = null
	var/last_update = 0
	var/speed = 0


/datum/computer_file/program/ntnetdownload/ui_interact(mob/user, var/datum/topic_state/state = default_state)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new /datum/vueui/modularcomputer(user, src, "mcomputer-system-downloader", 575, 700, "NTNet Download Program", state = state)
	ui.open()

/datum/computer_file/program/ntnetdownload/vueui_transfer(oldobj)
	SSvueui.transfer_uis(oldobj, src, "mcomputer-system-downloader", 575, 700, "NTNet Download Program")
	return TRUE

// Gaters data for ui
/datum/computer_file/program/ntnetdownload/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	data = . || data || list("queue" = download_queue)

	if(!istype(computer))
		return

	// Gather data for computer header
	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata
		. = data

	// Let's send all installed programs
	LAZYINITLIST(data["installed"])
	for(var/datum/computer_file/program/I in hard_drive.stored_files)
		LAZYINITLIST(data["installed"][I.filename])
		VUEUI_SET_CHECK(data["installed"][I.filename]["name"], I.filedesc, ., data)
		VUEUI_SET_CHECK(data["installed"][I.filename]["size"], I.size, ., data)

	// Now lets send all available programs with their status.
	// Statuses (rest): 0 - ALL OK, 1 - can't download due to access, 2 - unsuported hardware, 3 - sindies only
	LAZYINITLIST(data["available"])
	for(var/datum/computer_file/program/P in ntnet_global.available_software)
		LAZYINITLIST(data["available"][P.filename])
		VUEUI_SET_CHECK(data["available"][P.filename]["name"], P.filedesc, ., data)
		VUEUI_SET_CHECK(data["available"][P.filename]["desc"], P.extended_desc, ., data)
		VUEUI_SET_CHECK(data["available"][P.filename]["size"], P.size, ., data)
		if(computer_emagged)
			if(!P.is_supported_by_hardware(computer.hardware_flag))
				VUEUI_SET_CHECK(data["available"][P.filename]["rest"], 2, ., data)
			else
				VUEUI_SET_CHECK(data["available"][P.filename]["rest"], 0, ., data)
		else
			if(!P.available_on_ntnet)
				VUEUI_SET_CHECK(data["available"][P.filename]["rest"], 3, ., data)
			else if(!P.can_download(user) && P.requires_access_to_download)
				VUEUI_SET_CHECK(data["available"][P.filename]["rest"], 1, ., data)
			else if(!P.is_supported_by_hardware(computer.hardware_flag))
				VUEUI_SET_CHECK(data["available"][P.filename]["rest"], 2, ., data)
			else
				VUEUI_SET_CHECK(data["available"][P.filename]["rest"], 0, ., data)

	VUEUI_SET_CHECK(data["disk_size"], hard_drive.max_capacity, ., data)
	VUEUI_SET_CHECK(data["disk_used"], hard_drive.used_capacity, ., data)
	VUEUI_SET_CHECK(data["queue_size"], queue_size, ., data)
	VUEUI_SET_CHECK(data["speed"], speed, ., data)

	for(var/name in download_queue)
		VUEUI_SET_CHECK(data["queue"][name], download_queue[name], ., data)


/datum/computer_file/program/ntnetdownload/Topic(href, href_list)
	if(..())
		return 1

	var/datum/vueui/ui = href_list["vueui"]
	if(!istype(ui))
		return

	if(href_list["download"])
		var/datum/computer_file/program/PRG = ntnet_global.find_ntnet_file_by_name(href_list["download"])

		if(!istype(PRG))
			return 1
		return add_to_queue(PRG, ui.user)

	if(href_list["cancel"])
		return cancel_from_queue(href_list["cancel"])

/datum/computer_file/program/ntnetdownload/proc/add_to_queue(var/datum/computer_file/program/PRG, var/mob/user)
	// Attempting to download antag only program, but without having emagged computer. No.
	if(PRG.available_on_syndinet && !computer_emagged)
		return FALSE

	if(!hard_drive.can_store_file(queue_size + PRG.size))
		to_chat(user, SPAN_WARNING("You can't download this program as queued items exceed hard drive capacity."))
		return TRUE

	if(!computer?.hard_drive?.try_store_file(PRG))
		return FALSE

	if(!computer_emagged && !PRG.can_download(user) && PRG.requires_access_to_download)
		return TRUE

	if(!PRG.is_supported_by_hardware(computer.hardware_flag))
		return FALSE

	if(PRG.available_on_ntnet)
		generate_network_log("Began downloading file [PRG.filename].[PRG.filetype] from NTNet Software Repository.")
	else if (PRG.available_on_syndinet)
		generate_network_log("Began downloading file **ENCRYPTED**.[PRG.filetype] from unspecified server.")
	else
		generate_network_log("Began downloading file [PRG.filename].[PRG.filetype] from unspecified server.")


	download_files[PRG.filename] = PRG.clone(FALSE, computer)
	queue_size += PRG.size
	download_queue[PRG.filename] = 0
	for(var/i in SSvueui.get_open_uis(src))
		var/datum/vueui/ui = i
		ui.data["queue"][PRG.filename] = 0
		ui.push_change()
	return TRUE

/datum/computer_file/program/ntnetdownload/proc/cancel_from_queue(var/name)
	if(!download_files[name])
		return
	var/datum/computer_file/program/PRG = download_files[name]
	var/hacked_download = PRG.available_on_syndinet && !PRG.available_on_ntnet
	generate_network_log("Aborted download of file [hacked_download ? "**ENCRYPTED**" : PRG.filename].[PRG.filetype].")
	download_queue -= name
	download_files -= name
	queue_size -= PRG.size
	for(var/i in SSvueui.get_open_uis(src))
		var/datum/vueui/ui = i
		ui.data["queue"] -= name
		ui.push_change()

/datum/computer_file/program/ntnetdownload/proc/finish_from_queue(var/name)
	if(!download_files[name])
		return

	var/datum/computer_file/program/PRG = download_files[name]
	var/hacked_download = PRG.available_on_syndinet && !PRG.available_on_ntnet
	generate_network_log("Completed download of file [hacked_download ? "**ENCRYPTED**" : PRG.filename].[PRG.filetype].")
	if(!computer?.hard_drive?.store_file(PRG))
		download_queue[name] = -1
		for(var/i in SSvueui.get_open_uis(src))
			var/datum/vueui/ui = i
			ui.data["queue"] = -1
			ui.push_change()
		return

	download_queue -= name
	download_files -= name
	queue_size -= PRG.size
	for(var/i in SSvueui.get_open_uis(src))
		var/datum/vueui/ui = i
		ui.data["queue"] -= name
		ui.push_change()


/datum/computer_file/program/ntnetdownload/process_tick()
	if(!queue_size)
		ui_header = "downloader_finished.gif"
		return
	ui_header = "downloader_running.gif"

	if(download_queue[active_download] == null)
		for(var/name in download_queue)
			if(download_queue[name] >= 0)
				active_download = name
				break
		if(download_queue[active_download] == null)
			return

	var/datum/computer_file/active_download_file = download_files[active_download]
	if(download_queue[active_download] >= 0)
		if (!last_update)
			last_update = world.time
			return
		speed = 0
		var/variance = 0.1
		switch(ntnet_status)
			if(1)
				speed = NTNETSPEED_LOWSIGNAL
				variance = 0.3
			if(2)
				speed = NTNETSPEED_HIGHSIGNAL
				variance = 0.2
			if(3)
				speed = NTNETSPEED_ETHERNET

		var/delta = ((rand() - 0.5) * 2) * variance * speed
		//Download speed varies +/- 10% each proc. Adds a more realistic feels
		speed += delta
		speed = round(speed, 0.002)//3 decimal places

		var/delta_seconds = (world.time - last_update) / 10

		download_queue[active_download] = min(download_queue[active_download] + delta_seconds * speed, active_download_file.size)

		// No connection, so cancel the download.
		// This is done at the end because of logic reasons.
		// Trust me, it's fine. - Skull132
		if (!speed)
			last_update = 0
		else
			last_update = world.time


	if(download_queue[active_download] >= active_download_file.size)
		finish_from_queue(active_download)
		playsound(get_turf(computer), 'sound/machines/ping.ogg', 40, 0)
		computer.output_message("[icon2html(computer, viewers(get_turf(computer)), computer.icon_state)] <b>[capitalize_first_letters(computer.name)]</b> pings: \"[active_download_file.filedesc ? active_download_file.filedesc : active_download_file.filename] downloaded successfully!\"", 1)
		active_download = null

	SSvueui.check_uis_for_change(src)
