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
	var/obj/item/computer_hardware/ai_slot/A = computer?.hardware_by_slot(MC_AI)
	if(A?.stored_pai)
		to_chat(A.stored_pai.pai, SPAN_WARNING("pAI Access Lock systems engaged."))
	computer.pAI_lock = TRUE
	return TRUE

/datum/computer_file/program/pai_access_lock/service_deactivate()
	. = ..()
	var/obj/item/computer_hardware/ai_slot/A = computer?.hardware_by_slot(MC_AI)
	if(A?.stored_pai)
		to_chat(A.stored_pai.pai, SPAN_NOTICE("pAI Access Lock systems disabled."))
	computer.pAI_lock = FALSE

/datum/computer_file/program/pai_access_lock/program_hidden()
	var/obj/item/computer_hardware/ai_slot/A = computer?.hardware_by_slot(MC_AI)
	if(!istype(A) || !A.stored_pai)
		return TRUE
	return FALSE
