/datum/computer_file/program/ntnetmonitor
	filename = "ntmonitor"
	filedesc = "NTNet Diagnostics and Monitoring"
	program_icon_state = "comm_monitor"
	program_key_icon_state = "green_key"
	extended_desc = "This program monitors stationwide NTNet network, provides access to logging systems, and allows for configuration changes"
	size = 12
	requires_ntnet = TRUE
	required_access_run = ACCESS_NETWORK
	required_access_download = ACCESS_HEADS
	usage_flags = PROGRAM_CONSOLE | PROGRAM_SILICON_AI
	color = LIGHT_COLOR_GREEN

	available_on_ntnet = TRUE
	tgui_id = "NTMonitor"

/datum/computer_file/program/ntnetmonitor/ui_data(mob/user)
	if(!GLOB.ntnet_global)
		return
	var/list/data = initial_data()

	data["ntnetstatus"] = GLOB.ntnet_global.check_function()
	data["ntnetrelays"] = GLOB.ntnet_global.relays.len
	data["idsstatus"] = GLOB.ntnet_global.intrusion_detection_enabled
	data["idsalarm"] = GLOB.ntnet_global.intrusion_detection_alarm

	data["config_softwaredownload"] = GLOB.ntnet_global.setting_softwaredownload
	data["config_peertopeer"] = GLOB.ntnet_global.setting_peertopeer
	data["config_communication"] = GLOB.ntnet_global.setting_communication
	data["config_systemcontrol"] = GLOB.ntnet_global.setting_systemcontrol

	data["ntnetlogs"] = GLOB.ntnet_global.logs
	data["ntnetmessages"] = GLOB.ntnet_global.messages
	data["ntnetmaxlogs"] = GLOB.ntnet_global.setting_maxlogcount

	return data

/datum/computer_file/program/ntnetmonitor/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return

	switch(action)
		if("resetIDS")
			. = TRUE
			if(GLOB.ntnet_global)
				GLOB.ntnet_global.resetIDS()
		if("toggleIDS")
			. = TRUE
			if(GLOB.ntnet_global)
				GLOB.ntnet_global.toggleIDS()
		if("purgelogs")
			. = TRUE
			if(GLOB.ntnet_global)
				GLOB.ntnet_global.purge_logs()
		if("updatemaxlogs")
			. = TRUE
			var/mob/user = usr
			var/logcount = text2num(input(user,"Enter amount of logs to keep in memory ([MIN_NTNET_LOGS]-[MAX_NTNET_LOGS]):"))
			if(GLOB.ntnet_global)
				GLOB.ntnet_global.update_max_log_count(logcount)
		if("toggle_function")
			. = TRUE
			if(!GLOB.ntnet_global)
				return FALSE
			GLOB.ntnet_global.toggle_function(params["toggle_function"])
