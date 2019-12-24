

/obj/item/modular_computer/silicon/preset/install_default_hardware()
	. = ..()
	processor_unit = new/obj/item/computer_hardware/processor_unit(src)
	hard_drive = new/obj/item/computer_hardware/hard_drive(src)
	network_card = new/obj/item/computer_hardware/network_card(src)
