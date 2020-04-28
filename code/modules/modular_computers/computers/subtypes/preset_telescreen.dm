/obj/item/modular_computer/telescreen/preset/install_default_hardware()
	..()
	processor_unit = new/obj/item/computer_hardware/processor_unit(src)
	tesla_link = new/obj/item/computer_hardware/tesla_link(src)
	hard_drive = new/obj/item/computer_hardware/hard_drive(src)
	network_card = new/obj/item/computer_hardware/network_card(src)

/obj/item/modular_computer/telescreen/preset/generic
	_app_preset_type = /datum/modular_computer_app_presets/wall_generic
	enrolled = TRUE

/obj/item/modular_computer/telescreen/preset/trashcompactor
	_app_preset_type = /datum/modular_computer_app_presets/trashcompactor
	enrolled = TRUE