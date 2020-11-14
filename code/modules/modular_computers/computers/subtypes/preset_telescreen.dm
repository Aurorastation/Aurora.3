/obj/item/modular_computer/telescreen/preset
	preset_components = list(
		MC_CPU = /obj/item/computer_hardware/processor_unit,
		MC_HDD = /obj/item/computer_hardware/hard_drive,
		MC_NET = /obj/item/computer_hardware/network_card,
		MC_PWR = /obj/item/computer_hardware/tesla_link
	)

/obj/item/modular_computer/telescreen/preset/generic
	_app_preset_type = /datum/modular_computer_app_presets/wall_generic
	enrolled = 1

/obj/item/modular_computer/telescreen/preset/trashcompactor
	_app_preset_type = /datum/modular_computer_app_presets/trashcompactor
	enrolled = 1
