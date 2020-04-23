// These programs are associated with engineering.

/datum/computer_file/program/power_monitor
	filename = "powermonitor"
	filedesc = "Power Monitoring"
	nanomodule_path = /datum/nano_module/power_monitor
	program_icon_state = "power_monitor"
	extended_desc = "This program connects to sensors around the station to provide information about electrical systems"
	ui_header = "power_norm.gif"
	required_access_run = access_engine
	required_access_download = access_ce
	requires_ntnet = TRUE
	network_destination = "power monitoring system"
	size = 9
	var/has_alert = FALSE
	color = LIGHT_COLOR_ORANGE

/datum/computer_file/program/power_monitor/process_tick()
	..()
	var/datum/nano_module/power_monitor/NMA = NM
	if(istype(NMA) && NMA.has_alarm())
		if(!has_alert)
			program_icon_state = "power_monitor_warn"
			ui_header = "power_warn.gif"
			update_computer_icon()
			has_alert = TRUE
	else
		if(has_alert)
			program_icon_state = "power_monitor"
			ui_header = "power_norm.gif"
			update_computer_icon()
			has_alert = FALSE

/datum/computer_file/program/alarm_monitor
	filename = "alarmmonitor"
	filedesc = "Alarm Monitoring"
	nanomodule_path = /datum/nano_module/alarm_monitor/engineering
	ui_header = "alarm_green.gif"
	program_icon_state = "alert-green"
	extended_desc = "This program provides visual interface for station's alarm system."
	requires_ntnet = TRUE
	network_destination = "alarm monitoring network"
	size = 5
	var/has_alert = FALSE
	color = LIGHT_COLOR_CYAN

/datum/computer_file/program/alarm_monitor/process_tick()
	..()
	var/datum/nano_module/alarm_monitor/NMA = NM
	if(istype(NMA) && NMA.has_major_alarms())
		if(!has_alert)
			program_icon_state = "alert-red"
			ui_header = "alarm_red.gif"
			update_computer_icon()
			has_alert = TRUE
	else
		if(has_alert)
			program_icon_state = "alert-green"
			ui_header = "alarm_green.gif"
			update_computer_icon()
			has_alert = FALSE
	return TRUE

/datum/computer_file/program/atmos_control
	filename = "atmoscontrol"
	filedesc = "Atmosphere Control"
	nanomodule_path = /datum/nano_module/atmos_control
	program_icon_state = "atmos_control"
	extended_desc = "This program allows remote control of air alarms around the station. This program can not be run on tablet computers."
	required_access_run = access_atmospherics
	required_access_download = access_ce
	requires_ntnet = TRUE
	network_destination = "atmospheric control system"
	requires_ntnet_feature = NTNET_SYSTEMCONTROL
	usage_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP | PROGRAM_SILICON
	size = 17
	color = LIGHT_COLOR_CYAN

/datum/computer_file/program/rcon_console
	filename = "rcon"
	filedesc = "RCON Remote Control"
	nanomodule_path = /datum/nano_module/rcon
	program_icon_state = "generic"
	extended_desc = "This program allows remote control of power distribution systems around the station. This program can not be run on tablet computers."
	required_access_run = access_engine
	required_access_download = access_ce
	requires_ntnet = TRUE
	network_destination = "RCON remote control system"
	requires_ntnet_feature = NTNET_SYSTEMCONTROL
	usage_flags = PROGRAM_CONSOLE | PROGRAM_SILICON
	size = 19
	color = LIGHT_COLOR_GREEN

// Night-Mode Toggle for CE
/datum/computer_file/program/lighting_control
	filename = "lightctrl"
	filedesc = "Lighting Controller"
	nanomodule_path = /datum/nano_module/lighting_ctrl
	program_icon_state = "comm_monitor"
	extended_desc = "This program allows mass-control of the station's lighting systems. This program cannot be run on tablet computers."
	required_access_run = access_heads
	required_access_download = access_ce
	requires_ntnet = TRUE
	network_destination = "APC Coordinator"
	requires_ntnet_feature = NTNET_SYSTEMCONTROL
	usage_flags = PROGRAM_CONSOLE | PROGRAM_SILICON
	size = 9
	color = LIGHT_COLOR_GREEN