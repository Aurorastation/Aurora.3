/datum/proc/initial_data()
	return list()

/obj/item/modular_computer/initial_data()
	return list("_PC" = get_header_data())

/datum/computer_file/program/initial_data()
	return list("_PC" = get_header_data())
