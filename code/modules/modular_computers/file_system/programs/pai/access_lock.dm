/datum/computer_file/program/pai_access_lock
	filename = "pai_access_lock"
	filedesc = "pAI Access Lock"
	extended_desc = "This service toggles whether a pAI can interface with this device."
	size = 0
	program_type = PROGRAM_SERVICE
	available_on_ntnet = FALSE
	unsendable = TRUE
	undeletable = TRUE
	usage_flags = PROGRAM_ALL

/datum/computer_file/program/pai_access_lock/service_activate()
	. = ..()
	if(computer.personal_ai)
		to_chat(computer.personal_ai.pai, SPAN_WARNING("pAI Access Lock systems engaged."))
	computer.pAI_lock = TRUE

/datum/computer_file/program/pai_access_lock/service_deactivate()
	. = ..()
	if(computer.personal_ai)
		to_chat(computer.personal_ai.pai, SPAN_NOTICE("pAI Access Lock systems disabled."))
	computer.pAI_lock = FALSE

/datum/computer_file/program/pai_access_lock/program_hidden()
	if(!computer.personal_ai)
		return TRUE
	return FALSE