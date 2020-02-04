/datum/computer_file/program/exosuit_monitor
	filename = "exosuitmonitor"
	filedesc = "Exosuit monitoring and control"
	nanomodule_path = /datum/nano_module/exosuit_control
	program_icon_state = "mecha"
	extended_desc = "This program allows remote monitoring and administration of exosuits with tracking beacons installed."
	required_access_run = access_robotics
	required_access_download = access_rd
	usage_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP
	requires_ntnet = TRUE
	size = 8
	color = LIGHT_COLOR_PURPLE
