/obj/item/modular_computer/silicon/preset
	enrolled = 2

/obj/item/modular_computer/silicon/preset/install_default_hardware()
	. = ..()
	processor_unit = new /obj/item/computer_hardware/processor_unit(src)
	hard_drive = new /obj/item/computer_hardware/hard_drive(src)
	network_card = new /obj/item/computer_hardware/network_card/advanced(src)

/obj/item/modular_computer/silicon/preset/install_default_programs()
	hard_drive.store_file(new /datum/computer_file/program/filemanager())
	hard_drive.store_file(new /datum/computer_file/program/ntnetdownload())
	hard_drive.remove_file(hard_drive.find_file_by_name("clientmanager"))