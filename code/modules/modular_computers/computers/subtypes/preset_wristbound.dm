/obj/item/modular_computer/wristbound/preset/cheap/install_default_hardware()
	..()
	processor_unit = new /obj/item/computer_hardware/processor_unit/small(src)
	hard_drive = new /obj/item/computer_hardware/hard_drive/micro(src)
	network_card = new /obj/item/computer_hardware/network_card(src)
	battery_module = new /obj/item/computer_hardware/battery_module/nano(src)
	battery_module.charge_to_full()

/obj/item/modular_computer/wristbound/preset/advanced/install_default_hardware()
	..()
	processor_unit = new /obj/item/computer_hardware/processor_unit/small(src)
	hard_drive = new /obj/item/computer_hardware/hard_drive/small(src)
	network_card = new /obj/item/computer_hardware/network_card(src)
	nano_printer = new /obj/item/computer_hardware/nano_printer(src)
	card_slot = new /obj/item/computer_hardware/card_slot(src)
	battery_module = new /obj/item/computer_hardware/battery_module(src)
	battery_module.charge_to_full()

/obj/item/modular_computer/wristbound/preset/advanced/cargo
	icon_state = "wristbound_supply"
	_app_preset_type = /datum/modular_computer_app_presets/cargo_delivery
	enrolled = TRUE

/obj/item/modular_computer/wristbound/preset/advanced/engineering
	icon_state = "wristbound_engineering"
	_app_preset_type = /datum/modular_computer_app_presets/engineering
	enrolled = TRUE

/obj/item/modular_computer/wristbound/preset/advanced/medical
	icon_state = "wristbound_medical"
	_app_preset_type = /datum/modular_computer_app_presets/medical
	enrolled = TRUE

/obj/item/modular_computer/wristbound/preset/advanced/security
	icon_state = "wristbound_security"
	_app_preset_type = /datum/modular_computer_app_presets/security
	enrolled = TRUE

/obj/item/modular_computer/wristbound/preset/advanced/security/investigations
	_app_preset_type = /datum/modular_computer_app_presets/security/investigations

/obj/item/modular_computer/wristbound/preset/advanced/research
	icon_state = "wristbound_science"
	_app_preset_type = /datum/modular_computer_app_presets/research
	enrolled = TRUE

/obj/item/modular_computer/wristbound/preset/advanced/command
	icon_state = "wristbound_command"
	_app_preset_type = /datum/modular_computer_app_presets/command
	enrolled = TRUE

/obj/item/modular_computer/wristbound/preset/advanced/command/ce
	_app_preset_type = /datum/modular_computer_app_presets/engineering/ce

/obj/item/modular_computer/wristbound/preset/advanced/command/rd
	_app_preset_type = /datum/modular_computer_app_presets/research/rd

/obj/item/modular_computer/wristbound/preset/advanced/command/cmo
	_app_preset_type = /datum/modular_computer_app_presets/medical/cmo

/obj/item/modular_computer/wristbound/preset/advanced/command/hop
	_app_preset_type = /datum/modular_computer_app_presets/command/hop

/obj/item/modular_computer/wristbound/preset/advanced/command/hos
	_app_preset_type = /datum/modular_computer_app_presets/security/hos

/obj/item/modular_computer/wristbound/preset/advanced/command/captain
	_app_preset_type = /datum/modular_computer_app_presets/captain

/obj/item/modular_computer/wristbound/preset/advanced/generic
	_app_preset_type = /datum/modular_computer_app_presets/civilian

/obj/item/modular_computer/wristbound/preset/advanced/representative
	_app_preset_type = /datum/modular_computer_app_presets/representative
	enrolled = TRUE