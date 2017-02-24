/datum/computer_file/program/suit_sensors
	filename = "sensormonitor"
	filedesc = "Suit Sensors Monitoring"
	nanomodule_path = /datum/nano_module/crew_monitor
	program_icon_state = "crew"
	extended_desc = "This program connects to life signs monitoring system to provide basic information on crew health."
	required_access_run = access_medical
	required_access_download = access_cmo
	requires_ntnet = 1
	network_destination = "crew lifesigns monitoring system"
	size = 11
	usage_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP
	color = LIGHT_COLOR_CYAN
