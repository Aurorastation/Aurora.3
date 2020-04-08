/obj/item/modular_computer/wristbound/preset/custom_loadout/cheap/install_default_hardware()
	..()
	processor_unit = new /obj/item/computer_hardware/processor_unit/small(src)
	hard_drive = new /obj/item/computer_hardware/hard_drive/micro(src)
	network_card = new /obj/item/computer_hardware/network_card(src)
	battery_module = new /obj/item/computer_hardware/battery_module/nano(src)
	battery_module.charge_to_full()

/obj/item/modular_computer/wristbound/preset/custom_loadout/advanced/install_default_hardware()
	..()
	processor_unit = new /obj/item/computer_hardware/processor_unit/small(src)
	hard_drive = new /obj/item/computer_hardware/hard_drive/small(src)
	network_card = new /obj/item/computer_hardware/network_card(src)
	nano_printer = new /obj/item/computer_hardware/nano_printer(src)
	card_slot = new /obj/item/computer_hardware/card_slot(src)
	battery_module = new /obj/item/computer_hardware/battery_module(src)
	battery_module.charge_to_full()


// Cargo Delivery
/obj/item/modular_computer/wristbound/preset/custom_loadout/advanced/cargo_delivery
	icon_state = "wristbound_supply"
	_app_preset_type = /datum/modular_computer_app_presets/cargo_delivery
	enrolled = TRUE