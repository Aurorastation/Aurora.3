/// Nothing preventing download
#define DL_OK			0
/// Can't download due to insufficient access
#define DL_ERR_ACCESS	1
/// Can't download due to incompatible / missing hardware
#define DL_ERR_HARDWARE	2
/// Can't download without being emagged
#define DL_ERR_SYNDIE	3

/datum/computer_file/program/ntnetdownload
	filename = "ntndownloader"
	filedesc = "NTNet Software Download Tool"
	program_icon_state = "generic"
	program_key_icon_state = "green_key"
	extended_desc = "This program allows the download of software from official NT repositories."
	color = LIGHT_COLOR_GREEN
	unsendable = TRUE
	undeletable = TRUE
	size = 2
	requires_ntnet = TRUE
	requires_ntnet_feature = NTNET_SOFTWAREDOWNLOAD
	available_on_ntnet = 0
	ui_header = "downloader_finished.gif"
	tgui_id = "NTOSDownloader"

	var/list/download_queue = list()
	var/list/download_files = list()
	var/queue_size = 0
	var/active_download = null
	var/last_update = 0
	var/speed = 0

/datum/computer_file/program/ntnetdownload/ui_static_data(mob/user)
	var/list/data = list()
	for(var/datum/computer_file/program/P in GLOB.ntnet_global.available_software)
		if(hard_drive.find_file_by_name(P.filename))
			continue

		if(P.filename in download_queue)
			continue

		data["available"] += list(list(
			"filename" = P.filename,
			"name" = P.filedesc,
			"desc" = P.extended_desc,
			"size" = P.size,
			"stat" = get_download_status(P, user)
		))

	data["disk_size"] = hard_drive.max_capacity
	data["disk_used"] = hard_drive.used_capacity
	return data

/datum/computer_file/program/ntnetdownload/ui_data(mob/user)
	var/list/data = list()
	data["queue_size"] = queue_size
	data["speed"] = speed
	data["active_download"] = active_download
	data["queue"] = list()
	for(var/name in download_queue)
		var/datum/computer_file/program/PRG = download_files[name]
		data["queue"] += list(list(
			"name" = PRG ? PRG.filedesc : name,
			"filename" = name,
			"progress" = download_queue[name],
			"size" = PRG?.size
		))
	return data

/datum/computer_file/program/ntnetdownload/proc/get_download_status(datum/computer_file/program/P, mob/user)
	if(!computer_emagged)
		if(!P.available_on_ntnet)
			return DL_ERR_SYNDIE
		if(!P.can_download(user) && P.requires_access_to_download)
			return DL_ERR_ACCESS

	return P.is_supported_by_hardware(computer.hardware_flag) ? DL_OK : DL_ERR_HARDWARE

/datum/computer_file/program/ntnetdownload/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	if(action == "download")
		var/datum/computer_file/program/PRG = GLOB.ntnet_global.find_ntnet_file_by_name(params["filename"])
		if(istype(PRG))
			add_to_queue(PRG, usr)
		. = TRUE

	if(action == "cancel")
		cancel_from_queue(params["filename"])
		. = TRUE

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

	if(!length(download_queue))
		last_update = world.time

	download_files[PRG.filename] = PRG.clone(FALSE, computer)
	queue_size += PRG.size
	download_queue[PRG.filename] = 0
	computer.update_static_data_for_all_viewers()
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
	computer.update_static_data_for_all_viewers()

/datum/computer_file/program/ntnetdownload/proc/finish_from_queue(var/name)
	if(!download_files[name])
		return

	var/datum/computer_file/program/PRG = download_files[name]
	var/hacked_download = PRG.available_on_syndinet && !PRG.available_on_ntnet
	generate_network_log("Completed download of file [hacked_download ? "**ENCRYPTED**" : PRG.filename].[PRG.filetype].")
	if(!computer?.hard_drive?.store_file(PRG))
		download_queue[name] = -1
		computer.update_static_data_for_all_viewers()
		return

	download_queue -= name
	download_files -= name
	queue_size -= PRG.size
	computer.update_static_data_for_all_viewers()

/datum/computer_file/program/ntnetdownload/process_tick()
	if(!queue_size)
		var/old_header = ui_header
		ui_header = "downloader_finished.gif"
		if(old_header != ui_header)
			computer.update_static_data_for_all_viewers()
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


#undef DL_OK
#undef DL_ERR_ACCESS
#undef DL_ERR_HARDWARE
#undef DL_ERR_SYNDIE
