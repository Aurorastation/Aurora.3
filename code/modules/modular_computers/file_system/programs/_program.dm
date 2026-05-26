/obj/item/modular_computer/proc/initial_data()
	return list("_PC" = get_header_data())

/datum/computer_file/program/proc/initial_data()
	return list("_PC" = get_header_data())

/datum/topic_manager/program
	var/datum/program

/datum/topic_manager/program/New(var/datum/program)
	..()
	src.program = program

/datum/topic_manager/program/Destroy()
	program = null
	return ..()

// Calls forwarded to PROGRAM itself should begin with "PRG_"
// Calls forwarded to COMPUTER running the program should begin with "PC_"
/datum/topic_manager/program/Topic(href, href_list)
	return program && program.Topic(href, href_list)
