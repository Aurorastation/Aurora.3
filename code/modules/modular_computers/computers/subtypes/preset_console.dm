/obj/item/modular_computer/console/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover,/obj/item/projectile))
		if(prob(80))
	//Holoscreens are non solid, and the frames of the computers are thin. So projectiles will usually
	//pass through
			return TRUE
	else if(istype(mover) && mover.checkpass(PASSTABLE))
	//Animals can run under them, lots of empty space
		return TRUE
	return ..()

/obj/item/modular_computer/console/preset/install_default_hardware()
	..()
	processor_unit = new /obj/item/computer_hardware/processor_unit(src)
	tesla_link = new /obj/item/computer_hardware/tesla_link(src)
	hard_drive = new /obj/item/computer_hardware/hard_drive/super(src)
	network_card = new /obj/item/computer_hardware/network_card/wired(src)
	nano_printer = new /obj/item/computer_hardware/nano_printer(src)

/obj/item/modular_computer/console/preset/install_default_programs()
	..()

// Engineering
/obj/item/modular_computer/console/preset/engineering
	name = "engineering console"
	_app_preset_type = /datum/modular_computer_app_presets/engineering
	enrolled = 1

/obj/item/modular_computer/console/preset/engineering/ce
	name = "engineering console"
	_app_preset_type = /datum/modular_computer_app_presets/engineering/ce
	enrolled = 1

// Medical
/obj/item/modular_computer/console/preset/medical
	name = "medical console"
	_app_preset_type = /datum/modular_computer_app_presets/medical
	enrolled = 1

/obj/item/modular_computer/console/preset/medical/cmo
	name = "medical console"
	_app_preset_type = /datum/modular_computer_app_presets/medical/cmo
	enrolled = 1

// Research
/obj/item/modular_computer/console/preset/research
	name = "research console"
	_app_preset_type = /datum/modular_computer_app_presets/research
	enrolled = 1

/obj/item/modular_computer/console/preset/research/install_default_hardware()
	..()
	ai_slot = new /obj/item/computer_hardware/ai_slot(src)

// Command
/obj/item/modular_computer/console/preset/command
	name = "command console"
	_app_preset_type = /datum/modular_computer_app_presets/command
	enrolled = 1

/obj/item/modular_computer/console/preset/command/install_default_hardware()
	..()
	nano_printer = new /obj/item/computer_hardware/nano_printer(src)
	nano_printer.max_paper = 25
	nano_printer.stored_paper = 20
	card_slot = new /obj/item/computer_hardware/card_slot(src)

/obj/item/modular_computer/console/preset/command/captain
	name = "captain's console"
	_app_preset_type = /datum/modular_computer_app_presets/command/captain
	enrolled = 1

/obj/item/modular_computer/console/preset/command/hop
	name = "command console"
	_app_preset_type = /datum/modular_computer_app_presets/command/hop
	enrolled = 1

/obj/item/modular_computer/console/preset/command/account
	name = "account console"
	_app_preset_type = /datum/modular_computer_app_presets/command/account
	enrolled = 1

/obj/item/modular_computer/console/preset/command/account/centcomm
	name = "centcomm accounts database"
	_app_preset_type = /datum/modular_computer_app_presets/command/account/centcomm

// Security
/obj/item/modular_computer/console/preset/security
	name = "security console"
	_app_preset_type = /datum/modular_computer_app_presets/security
	enrolled = 1

/obj/item/modular_computer/console/preset/security/investigations
	name = "investigations console"
	_app_preset_type = /datum/modular_computer_app_presets/security/investigations
	enrolled = 1

/obj/item/modular_computer/console/preset/security/armory
	name = "armory console"
	_app_preset_type = /datum/modular_computer_app_presets/security/armory
	enrolled = 1

/obj/item/modular_computer/console/preset/security/hos
	name = "head of security's console"
	_app_preset_type = /datum/modular_computer_app_presets/security/hos
	enrolled = 1

/obj/item/modular_computer/console/preset/command/teleporter
	name = "teleporter control console"
	desc = "A computer that has a special teleporter control program loaded."
	_app_preset_type = /datum/modular_computer_app_presets/command/teleporter

/obj/item/modular_computer/console/preset/command/teleporter/ninja
	name = "teleporter control console"
	desc = "A computer that has a special teleporter control program loaded."
	_app_preset_type = /datum/modular_computer_app_presets/command/teleporter/ninja

// Civilian
/obj/item/modular_computer/console/preset/civilian
	name = "civilian console"
	_app_preset_type = /datum/modular_computer_app_presets/civilian
	enrolled = 1

// Supply
/obj/item/modular_computer/console/preset/supply
	name = "supply console"
	_app_preset_type = /datum/modular_computer_app_presets/supply
	enrolled = 1

/obj/item/modular_computer/console/preset/supply/install_default_hardware()
	..()
	nano_printer.max_paper = 25
	nano_printer.stored_paper = 20
	card_slot = new /obj/item/computer_hardware/card_slot(src)

/obj/item/modular_computer/console/preset/supply/machinist
	name = "machinist console"
	_app_preset_type = /datum/modular_computer_app_presets/supply/machinist
	enrolled = 1

/obj/item/modular_computer/console/preset/supply/machinist/install_default_hardware()
	..()
	ai_slot = new /obj/item/computer_hardware/ai_slot(src)

// ERT
/obj/item/modular_computer/console/preset/ert/install_default_hardware()
	..()
	ai_slot = new /obj/item/computer_hardware/ai_slot(src)
	nano_printer.max_paper = 25
	nano_printer.stored_paper = 20
	card_slot = new /obj/item/computer_hardware/card_slot(src)

/obj/item/modular_computer/console/preset/ert
	_app_preset_type = /datum/modular_computer_app_presets/ert
	enrolled = 2
	computer_emagged = TRUE

// Mercenary
/obj/item/modular_computer/console/preset/mercenary
	_app_preset_type = /datum/modular_computer_app_presets/merc
	computer_emagged = TRUE
	enrolled = 2

/obj/item/modular_computer/console/preset/mercenary/install_default_hardware()
	..()
	ai_slot = new /obj/item/computer_hardware/ai_slot(src)
	card_slot = new /obj/item/computer_hardware/card_slot(src)


// Merchant
/obj/item/modular_computer/console/preset/merchant
	_app_preset_type = /datum/modular_computer_app_presets/merchant
	enrolled = 2

/obj/item/modular_computer/console/preset/merchant/install_default_hardware()
	..()
	ai_slot = new/obj/item/computer_hardware/ai_slot(src)
	card_slot = new/obj/item/computer_hardware/card_slot(src)

/obj/item/modular_computer/console/preset/merchant/nka
	_app_preset_type = /datum/modular_computer_app_presets/merchant/nka

/obj/item/modular_computer/console/preset/merchant/guild
	_app_preset_type = /datum/modular_computer_app_presets/merchant/guild

// AI
/obj/item/modular_computer/console/preset/ai
	_app_preset_type = /datum/modular_computer_app_presets/ai
	enrolled = 2
