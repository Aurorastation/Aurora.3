/datum/computer_file/program/robotics
	filename = "robotics"
	filedesc = "Robotics Interface"
	program_icon_state = "ai-fixer-empty"
	program_key_icon_state = "teal_key"
	extended_desc = "A program made to interface with positronics."
	size = 14
	requires_access_to_run = PROGRAM_ACCESS_LIST_ONE
	required_access_run = list(ACCESS_RESEARCH, ACCESS_ROBOTICS)
	required_access_download = list(ACCESS_RESEARCH, ACCESS_ROBOTICS)
	available_on_ntnet = FALSE
	tgui_id = "RoboticsComputer"

/datum/computer_file/program/robotics/ui_data(mob/user)
	. = ..()
	var/list/data = list()

	return data
