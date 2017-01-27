/obj/item/modular_computer/console/preset/install_default_hardware()
	..()
	processor_unit = new/obj/item/weapon/computer_hardware/processor_unit(src)
	tesla_link = new/obj/item/weapon/computer_hardware/tesla_link(src)
	hard_drive = new/obj/item/weapon/computer_hardware/hard_drive/super(src)
	network_card = new/obj/item/weapon/computer_hardware/network_card/wired(src)

/obj/item/modular_computer/console/preset/install_default_programs()
	..()


// Engineering
/obj/item/modular_computer/console/preset/engineering/
	_app_preset_name = "engineering"
	enrolled = 1

// Medical
/obj/item/modular_computer/console/preset/medical/
	_app_preset_name = "medical"
	enrolled = 1

// Research
/obj/item/modular_computer/console/preset/research/
	_app_preset_name = "research"
	enrolled = 1

/obj/item/modular_computer/console/preset/research/install_default_hardware()
	..()
	ai_slot = new/obj/item/weapon/computer_hardware/ai_slot(src)

// Command
/obj/item/modular_computer/console/preset/command/
	_app_preset_name = "command"
	enrolled = 1

/obj/item/modular_computer/console/preset/command/install_default_hardware()
	..()
	nano_printer = new/obj/item/weapon/computer_hardware/nano_printer(src)
	card_slot = new/obj/item/weapon/computer_hardware/card_slot(src)

// Security
/obj/item/modular_computer/console/preset/security/
	_app_preset_name = "security"
	enrolled = 1

// Civilian
/obj/item/modular_computer/console/preset/civilian/
	_app_preset_name = "civilian"
	enrolled = 1

ERT
/obj/item/modular_computer/console/preset/ert/install_default_hardware()
	..()
	ai_slot = new/obj/item/weapon/computer_hardware/ai_slot(src)
	nano_printer = new/obj/item/weapon/computer_hardware/nano_printer(src)
	card_slot = new/obj/item/weapon/computer_hardware/card_slot(src)

/obj/item/modular_computer/console/preset/ert/
	_app_preset_name = "ert"
	enrolled = 2
	computer_emagged = TRUE

// Mercenary
/obj/item/modular_computer/console/preset/mercenary/
	_app_preset_name = "merc"
	computer_emagged = TRUE
	enrolled = 2

/obj/item/modular_computer/console/preset/mercenary/install_default_hardware()
	..()
	ai_slot = new/obj/item/weapon/computer_hardware/ai_slot(src)
	nano_printer = new/obj/item/weapon/computer_hardware/nano_printer(src)
	card_slot = new/obj/item/weapon/computer_hardware/card_slot(src)
