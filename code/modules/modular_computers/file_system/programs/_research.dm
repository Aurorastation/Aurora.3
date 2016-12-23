/datum/computer_file/program/exosuit_monitor
	filename = "exosuitmonitor"
	filedesc = "Exosuit monitoring and control"
	nanomodule_path = /datum/nano_module/exosuit_control
	program_icon_state = "mecha"
	extended_desc = "This program allows remote monitoring and administration of exosuits with tracking beacons installed."
	required_access = access_robotics
	requires_ntnet = 1
	size = 8