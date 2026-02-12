/obj/item/modular_computer/handheld/communicator/install_default_hardware()
	processor_unit = new /obj/item/computer_hardware/processor_unit/small(src)
	hard_drive = new /obj/item/computer_hardware/hard_drive/small(src) // Todo: Proprietary drive which only holds the communicator app?
	network_card = new /obj/item/computer_hardware/network_card(src)
	battery_module = new /obj/item/computer_hardware/battery_module(src)
	tesla_link = new /obj/item/computer_hardware/tesla_link/charging_cable(src)
	battery_module.charge_to_full()

/obj/item/modular_computer/handheld/communicator
	enrolled = DEVICE_PRIVATE
	_app_preset_type = /datum/modular_computer_app_presets/communicator
