/obj/item/modular_computer/handheld/communicator/install_default_hardware()
	processor_unit = new /obj/item/computer_hardware/processor_unit/small(src)
	hard_drive = new /obj/item/computer_hardware/hard_drive/micro/communicator(src)
	network_card = new /obj/item/computer_hardware/network_card(src)
	battery_module = new /obj/item/computer_hardware/battery_module(src)
	tesla_link = new /obj/item/computer_hardware/tesla_link/charging_cable(src)
	battery_module.charge_to_full()

/obj/item/modular_computer/handheld/communicator
	enrolled = DEVICE_PRIVATE
	_app_preset_type = /datum/modular_computer_app_presets/communicator

/// A sealed drive that accepts the communicator application and its autorun record only.
/obj/item/computer_hardware/hard_drive/micro/communicator
	name = "proprietary communicator drive"
	desc = "A sealed solid-state drive containing communicator firmware. It rejects unrelated software."
	max_capacity = 32

/obj/item/computer_hardware/hard_drive/micro/communicator/install_default_programs()
	return

/obj/item/computer_hardware/hard_drive/micro/communicator/store_file(datum/computer_file/file)
	if(!istype(file, /datum/computer_file/program/communicator) && !(istype(file, /datum/computer_file/data) && file.filename == "autorun"))
		return FALSE
	return ..()

/obj/item/computer_hardware/hard_drive/micro/communicator/try_store_file(datum/computer_file/file)
	if(!istype(file, /datum/computer_file/program/communicator) && !(istype(file, /datum/computer_file/data) && file.filename == "autorun"))
		return FALSE
	return ..()

/obj/item/computer_hardware/hard_drive/micro/communicator/remove_file(datum/computer_file/file, force = FALSE)
	if(!force)
		return FALSE
	return ..()

/obj/item/computer_hardware/hard_drive/micro/communicator/reset_drive()
	return FALSE

/obj/item/modular_computer/handheld/communicator/landline/install_default_hardware()
	processor_unit = new /obj/item/computer_hardware/processor_unit/small(src)
	hard_drive = new /obj/item/computer_hardware/hard_drive/micro/communicator(src)
	network_card = new /obj/item/computer_hardware/network_card/wired(src)
	tesla_link = new /obj/item/computer_hardware/tesla_link(src)
