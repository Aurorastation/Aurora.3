/obj/item/modular_computer/silicon/ai
	hardware_flag = PROGRAM_SILICON_AI

/obj/item/modular_computer/silicon/ai/install_default_hardware()
	. = ..()
	network_card = new /obj/item/computer_hardware/network_card/wired(src)

/obj/item/modular_computer/silicon/ai/install_default_programs()
	. = ..()
	hard_drive.store_file(new /datum/computer_file/program/records(src))
	hard_drive.store_file(new /datum/computer_file/program/rcon_console(src))
	hard_drive.store_file(new /datum/computer_file/program/suit_sensors(src))
	hard_drive.store_file(new /datum/computer_file/program/power_monitor(src))

/obj/item/modular_computer/silicon/robot
	hardware_flag = PROGRAM_SILICON_ROBOT

/obj/item/modular_computer/silicon/pai
	hardware_flag = PROGRAM_SILICON_PAI

/obj/item/modular_computer/silicon/ai/install_default_hardware()
	. = ..()
	hard_drive = new /obj/item/computer_hardware/hard_drive/small(src)

/obj/item/modular_computer/silicon/pai/install_default_programs()
	. = ..()
	hard_drive.store_file(new /datum/computer_file/program/pai_directives(src))
	hard_drive.store_file(new /datum/computer_file/program/pai_radio(src))
	hard_drive.store_file(new /datum/computer_file/program/pai_flashlight(src))