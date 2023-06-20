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

