/datum/computer_file/program/communicator
	filename = "ntnrc_comm"
	filedesc = "Communicator"
	//program_icon_state = todo
	//program_key_icon_state = todo // Stationary communicators
	extended_desc = "todo"
	//size = todo
	requires_ntnet = TRUE
	requires_ntnet_feature = NTNET_COMMUNICATION
	program_type = PROGRAM_TYPE_ALL
	network_destination = "todo"
	//color = todo
	tgui_id = "Communicator"

	var/datum/ntnet_user/program_user

	var/ringtone = "beep"
	var/ringer_on = TRUE

/datum/computer_file/program/communicator/Destroy()
	service_deactivate()
	program_user = null // todo: qdel_null to avoid harddel? What about other devices talking to the user?
	return ..()

/datum/computer_file/program/communicator/ui_data(mob/user)
	var/alist/data = alist()

	return data

/datum/computer_file/program/communicator/ui_static_data(mob/user)
	var/alist/data = alist()

	return data
