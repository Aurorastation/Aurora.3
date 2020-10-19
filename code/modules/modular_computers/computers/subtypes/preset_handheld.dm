/obj/item/modular_computer/handheld/custom_loadout/cheap/install_default_hardware()
	..()
	processor_unit = new /obj/item/computer_hardware/processor_unit/small(src)
	hard_drive = new /obj/item/computer_hardware/hard_drive/micro(src)
	network_card = new /obj/item/computer_hardware/network_card(src)
	battery_module = new /obj/item/computer_hardware/battery_module(src)
	card_slot = new /obj/item/computer_hardware/card_slot(src)
	tesla_link = new /obj/item/computer_hardware/tesla_link/charging_cable(src)
	battery_module.charge_to_full()

/obj/item/modular_computer/handheld/custom_loadout/advanced/install_default_hardware()
	..()
	processor_unit = new /obj/item/computer_hardware/processor_unit/small(src)
	hard_drive = new /obj/item/computer_hardware/hard_drive/small(src)
	network_card = new /obj/item/computer_hardware/network_card(src)
	nano_printer = new /obj/item/computer_hardware/nano_printer(src)
	card_slot = new /obj/item/computer_hardware/card_slot(src)
	battery_module = new /obj/item/computer_hardware/battery_module(src)
	battery_module.charge_to_full()


// Cargo Delivery
/obj/item/modular_computer/handheld/custom_loadout/advanced/cargo_delivery
	_app_preset_type = /datum/modular_computer_app_presets/cargo_delivery
	enrolled = 1

// Tablet PDA presets
/obj/item/modular_computer/handheld/pda
	var/icon_add // this is the "bar" part in "pda-bar"
	enrolled = 2

/obj/item/modular_computer/handheld/pda/Initialize()
	. = ..()
	icon = 'icons/obj/pda.dmi'
	icon_state = "pda"
	if(icon_add)
		icon_state += "-[icon_add]"
	icon_state_unpowered = icon_state
	icon_state_broken = icon_state

/obj/item/modular_computer/handheld/pda/install_default_hardware()
	..()
	processor_unit = new /obj/item/computer_hardware/processor_unit/small(src)
	hard_drive = new /obj/item/computer_hardware/hard_drive/micro(src)
	network_card = new /obj/item/computer_hardware/network_card(src)
	battery_module = new /obj/item/computer_hardware/battery_module(src)
	card_slot = new /obj/item/computer_hardware/card_slot(src)
	card_slot.stored_item = new /obj/item/pen
	battery_module.charge_to_full()

// Civilian

/obj/item/modular_computer/handheld/pda/civilian
	_app_preset_type = /datum/modular_computer_app_presets/civilian

/obj/item/modular_computer/handheld/pda/civilian/bartender
	icon_add = "bar"

/obj/item/modular_computer/handheld/pda/civilian/bartender/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/fountain

/obj/item/modular_computer/handheld/pda/civilian/chef
	icon_add = "chef"

/obj/item/modular_computer/handheld/pda/civilian/botanist
	icon_add = "hydro"

/obj/item/modular_computer/handheld/pda/civilian/librarian
	icon_add = "libb"

/obj/item/modular_computer/handheld/pda/civilian/librarian/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/fountain
	// desc = "A portable microcomputer by Thinktronic Systems, LTD. This is model is a WGW-11 series e-reader."
	// note = "Congratulations, your station has chosen the Thinktronic 5290 WGW-11 Series E-reader and Personal Data Assistant!"
	// message_silent = 1 //Quiet in the library!
	// news_silent = 0		// Librarian is above the law!  (That and alt job title is reporter)

/obj/item/modular_computer/handheld/pda/civilian/janitor
	icon_add = "j"
	_app_preset_type = /datum/modular_computer_app_presets/civilian/janitor
	// default_cartridge = /obj/item/cartridge/janitor

/obj/item/modular_computer/handheld/pda/civilian/chaplain
	icon_add = "holy"

/obj/item/modular_computer/handheld/pda/civilian/chaplain/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/fountain

/obj/item/modular_computer/handheld/pda/civilian/lawyer
	icon_add = "lawyer"

/obj/item/modular_computer/handheld/pda/civilian/lawyer/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/fountain

/obj/item/modular_computer/handheld/pda/civilian/clown
	_app_preset_type = /datum/modular_computer_app_presets/civilian/clown
	icon_add = "clown"

/obj/item/modular_computer/handheld/pda/civilian/clown/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/crayon

/obj/item/modular_computer/handheld/pda/civilian/mime
	_app_preset_type = /datum/modular_computer_app_presets/civilian/mime
	icon_add = "mime"

// Engineering

/obj/item/modular_computer/handheld/pda/engineering
	_app_preset_type = /datum/modular_computer_app_presets/engineering
	icon_add = "e"
	// default_cartridge = /obj/item/cartridge/engineering

/obj/item/modular_computer/handheld/pda/engineering/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/silver

/obj/item/modular_computer/handheld/pda/engineering/atmos
	_app_preset_type = /datum/modular_computer_app_presets/engineering/atmos
	icon_add = "atmo"
	// default_cartridge = /obj/item/cartridge/atmos

/obj/item/modular_computer/handheld/pda/engineering/ce
	_app_preset_type = /datum/modular_computer_app_presets/engineering/ce
	icon_add = "ce"
	// default_cartridge = /obj/item/cartridge/ce

// Supply
/obj/item/modular_computer/handheld/pda/supply
	_app_preset_type = /datum/modular_computer_app_presets/supply
	icon_add = "cargo"

/obj/item/modular_computer/handheld/pda/supply/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/silver

/obj/item/modular_computer/handheld/pda/supply/miner
	_app_preset_type = /datum/modular_computer_app_presets/civilian
	icon_add = "miner"

/obj/item/modular_computer/handheld/pda/supply/qm
	icon_add = "q"

/obj/item/modular_computer/handheld/pda/supply/qm/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/fountain

// Medical

/obj/item/modular_computer/handheld/pda/medical
	_app_preset_type = /datum/modular_computer_app_presets/medical
	icon_add = "m"

/obj/item/modular_computer/handheld/pda/medical/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/white

/obj/item/modular_computer/handheld/pda/medical/chemistry
	icon_add = "chem"

/obj/item/modular_computer/handheld/pda/medical/paramedic
	icon_add = "paramedic"

/obj/item/modular_computer/handheld/pda/medical/psych
	icon_add = "psych"

/obj/item/modular_computer/handheld/pda/medical/psych/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/fountain/white

/obj/item/modular_computer/handheld/pda/medical/cmo
	_app_preset_type = /datum/modular_computer_app_presets/medical/cmo
	icon_add = "cmo"

// Science

/obj/item/modular_computer/handheld/pda/research
	_app_preset_type = /datum/modular_computer_app_presets/research
	icon_add = "tox"

/obj/item/modular_computer/handheld/pda/research/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/white

/obj/item/modular_computer/handheld/pda/research/roboticist
	icon_add = "robot"

/obj/item/modular_computer/handheld/pda/research/xenobio
	icon_add = "xenobio"

/obj/item/modular_computer/handheld/pda/research/rd
	_app_preset_type = /datum/modular_computer_app_presets/research/rd
	icon_add = "rd"

// Security

/obj/item/modular_computer/handheld/pda/security
	_app_preset_type = /datum/modular_computer_app_presets/security
	icon_add = "s"

/obj/item/modular_computer/handheld/pda/security/detective
	_app_preset_type = /datum/modular_computer_app_presets/security/investigations
	icon_add = "det"

/obj/item/modular_computer/handheld/pda/security/warden
	icon_add = "warden"

/obj/item/modular_computer/handheld/pda/security/hos
	_app_preset_type = /datum/modular_computer_app_presets/security/hos
	icon_add = "hos"

// Command / Misc

/obj/item/modular_computer/handheld/pda/command
	_app_preset_type = /datum/modular_computer_app_presets/command
	icon_add = "h"

/obj/item/modular_computer/handheld/pda/command/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/fountain/head

/obj/item/modular_computer/handheld/pda/command/cciaa
	_app_preset_type = /datum/modular_computer_app_presets/command
	icon_add = "h"
	// detonate = 0

/obj/item/modular_computer/handheld/pda/command/hop
	_app_preset_type = /datum/modular_computer_app_presets/command/hop
	icon_add = "hop"
	// default_cartridge = /obj/item/cartridge/hop

/obj/item/modular_computer/handheld/pda/command/captain
	_app_preset_type = /datum/modular_computer_app_presets/command/captain
	icon_add = "c"
	// detonate = 0

/obj/item/modular_computer/handheld/pda/command/captain/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/fountain/captain

/obj/item/modular_computer/handheld/pda/command/bst
	icon_add = "h"
	// hidden = 1

/obj/item/modular_computer/handheld/pda/ert
	_app_preset_type = /datum/modular_computer_app_presets/ert
	icon_add = "h"
	// detonate = 0
	// hidden = 1

/obj/item/modular_computer/handheld/pda/civilian/clear
	icon_add = "transp"

/obj/item/modular_computer/handheld/pda/civilian/merchant
	icon_add = "chef"
	//hidden = 1