/obj/item/modular_computer/silicon/ai
	hardware_flag = PROGRAM_SILICON_AI

/obj/item/modular_computer/silicon/ai/install_default_hardware()
	preset_components[MC_NET] = /obj/item/computer_hardware/network_card/wired
	. = ..()

/obj/item/modular_computer/silicon/ai/install_default_programs()
	. = ..()
	var/obj/item/computer_hardware/hard_drive/hard_drive = hardware_by_slot(MC_HDD)
	if(!hard_drive)
		return
	hard_drive.store_file(new /datum/computer_file/program/records(src))
	hard_drive.store_file(new /datum/computer_file/program/rcon_console(src))
	hard_drive.store_file(new /datum/computer_file/program/suit_sensors(src))
	hard_drive.store_file(new /datum/computer_file/program/power_monitor(src))

/obj/item/modular_computer/silicon/robot
	hardware_flag = PROGRAM_SILICON_ROBOT

/obj/item/modular_computer/silicon/pai
	hardware_flag = PROGRAM_SILICON_PAI

/obj/item/modular_computer/silicon/pai/install_default_hardware()
	preset_components[MC_HDD] = /obj/item/computer_hardware/hard_drive/small
	. = ..()

/obj/item/modular_computer/silicon/pai/install_default_programs()
	. = ..()
	var/obj/item/computer_hardware/hard_drive/hard_drive = hardware_by_slot(MC_HDD)
	if(!hard_drive)
		return
	hard_drive.store_file(new /datum/computer_file/program/pai_directives(src))
	hard_drive.store_file(new /datum/computer_file/program/pai_radio(src))
	hard_drive.store_file(new /datum/computer_file/program/pai_flashlight(src))
