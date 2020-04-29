/datum/computer_file/program/ntnetmonitor
	filename = "ntmonitor"
	filedesc = "NTNet Diagnostics and Monitoring"
	program_icon_state = "comm_monitor"
	extended_desc = "This program monitors stationwide NTNet network, provides access to logging systems, and allows for configuration changes"
	size = 12
	requires_ntnet = TRUE
	required_access_run = access_network
	required_access_download = access_heads
	usage_flags = PROGRAM_CONSOLE
	color = LIGHT_COLOR_GREEN
	
	available_on_ntnet = TRUE
	nanomodule_path = /datum/nano_module/computer_ntnetmonitor

/datum/nano_module/computer_ntnetmonitor
	name = "NTNet Diagnostics and Monitoring"
	available_to_ai = TRUE

/datum/nano_module/computer_ntnetmonitor/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	if(!ntnet_global)
		return
	var/list/data = host.initial_data()

	data["ntnetstatus"] = ntnet_global.check_function()
	data["ntnetrelays"] = ntnet_global.relays.len
	data["idsstatus"] = ntnet_global.intrusion_detection_enabled
	data["idsalarm"] = ntnet_global.intrusion_detection_alarm

	data["config_softwaredownload"] = ntnet_global.setting_softwaredownload
	data["config_peertopeer"] = ntnet_global.setting_peertopeer
	data["config_communication"] = ntnet_global.setting_communication
	data["config_systemcontrol"] = ntnet_global.setting_systemcontrol

	data["ntnetlogs"] = ntnet_global.logs
	data["ntnetmaxlogs"] = ntnet_global.setting_maxlogcount


	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "ntnet_monitor.tmpl", "NTNet Diagnostics and Monitoring Tool", 575, 700, state = state)
		if(host.update_layout())
			ui.auto_update_layout = TRUE
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/nano_module/computer_ntnetmonitor/Topic(href, href_list)
	if(..())
		return TRUE
	if(href_list["resetIDS"])
		. = TRUE
		if(ntnet_global)
			ntnet_global.resetIDS()
		return TRUE
	if(href_list["toggleIDS"])
		. = TRUE
		if(ntnet_global)
			ntnet_global.toggleIDS()
		return TRUE
	if(href_list["toggleWireless"])
		. = TRUE
		if(!ntnet_global)
			return TRUE

		// NTNet is disabled. Enabling can be done without user prompt
		if(ntnet_global.setting_disabled)
			ntnet_global.setting_disabled = FALSE
			return TRUE

		// NTNet is enabled and user is about to shut it down. Let's ask them if they really want to do it, as wirelessly connected computers won't connect without NTNet being enabled (which may prevent people from turning it back on)
		var/mob/user = usr
		if(!user)
			return TRUE
		var/response = alert(user, "Really disable NTNet wireless? If your computer is connected wirelessly you won't be able to turn it back on! This will affect all connected wireless devices.", "NTNet shutdown", "Yes", "No")
		if(response == "Yes")
			ntnet_global.setting_disabled = TRUE
		return TRUE
	if(href_list["purgelogs"])
		. = TRUE
		if(ntnet_global)
			ntnet_global.purge_logs()
	if(href_list["updatemaxlogs"])
		. = TRUE
		var/mob/user = usr
		var/logcount = text2num(input(user,"Enter amount of logs to keep in memory ([MIN_NTNET_LOGS]-[MAX_NTNET_LOGS]):"))
		if(ntnet_global)
			ntnet_global.update_max_log_count(logcount)
	if(href_list["toggle_function"])
		. = TRUE
		if(!ntnet_global)
			return TRUE
		ntnet_global.toggle_function(href_list["toggle_function"])