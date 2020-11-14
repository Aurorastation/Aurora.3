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

/obj/item/modular_computer/console/preset
	preset_components = list(
		MC_CPU = /obj/item/computer_hardware/processor_unit,
		MC_HDD = /obj/item/computer_hardware/hard_drive/super,
		MC_NET = /obj/item/computer_hardware/network_card/wired,
		MC_PRNT = /obj/item/computer_hardware/nano_printer,
		MC_PWR = /obj/item/computer_hardware/tesla_link
	)

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
	preset_components[MC_AI] = /obj/item/computer_hardware/ai_slot
	..()

// Command
/obj/item/modular_computer/console/preset/command
	name = "command console"
	_app_preset_type = /datum/modular_computer_app_presets/command
	enrolled = 1

/obj/item/modular_computer/console/preset/command/install_default_hardware()
	preset_components[MC_CARD] = /obj/item/computer_hardware/card_slot
	..()
	var/obj/item/computer_hardware/nano_printer/NP = hardware_by_slot(MC_PRNT)
	if(NP)
		NP.max_paper = 25
		NP.stored_paper = 20

/obj/item/modular_computer/console/preset/command/captain
	name = "captain's console"
	_app_preset_type = /datum/modular_computer_app_presets/command/captain
	enrolled = 1

/obj/item/modular_computer/console/preset/command/hop
	name = "command console"
	_app_preset_type = /datum/modular_computer_app_presets/command/hop
	enrolled = 1

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
	preset_components[MC_CARD] = /obj/item/computer_hardware/card_slot
	..()
	var/obj/item/computer_hardware/nano_printer/NP = hardware_by_slot(MC_PRNT)
	if(NP)
		NP.max_paper = 25
		NP.stored_paper = 20

// ERT
/obj/item/modular_computer/console/preset/ert/install_default_hardware()
	preset_components[MC_CARD] = /obj/item/computer_hardware/card_slot
	preset_components[MC_AI] = /obj/item/computer_hardware/ai_slot
	..()
	var/obj/item/computer_hardware/nano_printer/NP = hardware_by_slot(MC_PRNT)
	if(NP)
		NP.max_paper = 25
		NP.stored_paper = 20

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
	preset_components[MC_CARD] = /obj/item/computer_hardware/card_slot
	preset_components[MC_AI] = /obj/item/computer_hardware/ai_slot
	..()


// Merchant
/obj/item/modular_computer/console/preset/merchant
	_app_preset_type = /datum/modular_computer_app_presets/merchant
	enrolled = 2

/obj/item/modular_computer/console/preset/merchant/install_default_hardware()
	preset_components[MC_CARD] = /obj/item/computer_hardware/card_slot
	preset_components[MC_AI] = /obj/item/computer_hardware/ai_slot
	..()


// AI
/obj/item/modular_computer/console/preset/ai
	_app_preset_type = /datum/modular_computer_app_presets/ai
	enrolled = 2
