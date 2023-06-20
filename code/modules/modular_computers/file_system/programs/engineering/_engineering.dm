/datum/computer_file/program/alarm_monitor
	filename = "alarmmonitor"
	filedesc = "Alarm Monitoring"
	program_key_icon_state = "cyan_key"
	nanomodule_path = /datum/nano_module/alarm_monitor/engineering
	ui_header = "alarm_green.gif"
	program_icon_state = "alert:0"
	extended_desc = "This program provides visual interface for station's alarm system."
	requires_ntnet = TRUE
	network_destination = "alarm monitoring network"
	usage_flags = PROGRAM_ALL
	size = 5
	var/has_alert = FALSE
	color = LIGHT_COLOR_CYAN

/datum/computer_file/program/alarm_monitor/process_tick()
	..()
	var/datum/nano_module/alarm_monitor/NMA = NM
	if(istype(NMA) && NMA.has_major_alarms())
		if(!has_alert)
			program_icon_state = "alert:2"
			ui_header = "alarm_red.gif"
			update_computer_icon()
			has_alert = TRUE
	else
		if(has_alert)
			program_icon_state = "alert:0"
			ui_header = "alarm_green.gif"
			update_computer_icon()
			has_alert = FALSE
	return TRUE

// Night-Mode Toggle for CE
/datum/computer_file/program/lighting_control
	filename = "lightctrl"
	filedesc = "Lighting Controller"
	nanomodule_path = /datum/nano_module/lighting_ctrl
	program_icon_state = "power_monitor"
	program_key_icon_state = "yellow_key"
	extended_desc = "This program allows mass-control of the station's lighting systems. This program cannot be run on tablet computers."
	required_access_run = access_heads
	required_access_download = access_ce
	requires_ntnet = TRUE
	network_destination = "APC Coordinator"
	requires_ntnet_feature = NTNET_SYSTEMCONTROL
	usage_flags = PROGRAM_CONSOLE | PROGRAM_STATIONBOUND
	size = 9
	color = LIGHT_COLOR_GREEN
	tgui_theme = "hephaestus"
