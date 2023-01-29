/obj/item/modular_computer/handheld/wristbound/preset/cheap/install_default_hardware()
	..()
	processor_unit = new /obj/item/computer_hardware/processor_unit/small(src)
	hard_drive = new /obj/item/computer_hardware/hard_drive/micro(src)
	network_card = new /obj/item/computer_hardware/network_card(src)
	battery_module = new /obj/item/computer_hardware/battery_module/nano(src)
	tesla_link = new /obj/item/computer_hardware/tesla_link/charging_cable(src)
	flashlight = new /obj/item/computer_hardware/flashlight(src)
	battery_module.charge_to_full()

/obj/item/modular_computer/handheld/wristbound/preset/cheap/generic
	enrolled = 0

/obj/item/modular_computer/handheld/wristbound/preset/advanced/install_default_hardware()
	..()
	processor_unit = new /obj/item/computer_hardware/processor_unit/small(src)
	hard_drive = new /obj/item/computer_hardware/hard_drive/small(src)
	network_card = new /obj/item/computer_hardware/network_card(src)
	nano_printer = new /obj/item/computer_hardware/nano_printer(src)
	card_slot = new /obj/item/computer_hardware/card_slot(src)
	battery_module = new /obj/item/computer_hardware/battery_module/hotswap(src)
	tesla_link = new /obj/item/computer_hardware/tesla_link/charging_cable(src)
	flashlight = new /obj/item/computer_hardware/flashlight(src)
	battery_module.charge_to_full()

/obj/item/modular_computer/handheld/wristbound/preset/advanced
	enrolled = DEVICE_COMPANY

/obj/item/modular_computer/handheld/wristbound/preset/advanced/generic
	enrolled = 0

/obj/item/modular_computer/handheld/wristbound/preset/advanced/civilian
	_app_preset_type = /datum/modular_computer_app_presets/civilian

/obj/item/modular_computer/handheld/wristbound/preset/advanced/cargo
	icon_state = "wristbound_cargo"
	_app_preset_type = /datum/modular_computer_app_presets/supply

/obj/item/modular_computer/handheld/wristbound/preset/advanced/engineering
	icon_state = "wristbound_engineering"
	_app_preset_type = /datum/modular_computer_app_presets/engineering

/obj/item/modular_computer/handheld/wristbound/preset/advanced/medical
	icon_state = "wristbound_medical"
	_app_preset_type = /datum/modular_computer_app_presets/medical

/obj/item/modular_computer/handheld/wristbound/preset/advanced/security
	icon_state = "wristbound_security"
	_app_preset_type = /datum/modular_computer_app_presets/security

/obj/item/modular_computer/handheld/wristbound/preset/advanced/security/investigations
	_app_preset_type = /datum/modular_computer_app_presets/security/investigations

/obj/item/modular_computer/handheld/wristbound/preset/advanced/research
	icon_state = "wristbound_science"
	_app_preset_type = /datum/modular_computer_app_presets/research

/obj/item/modular_computer/handheld/wristbound/preset/advanced/command
	icon_state = "wristbound_command"
	_app_preset_type = /datum/modular_computer_app_presets/command

/obj/item/modular_computer/handheld/wristbound/preset/advanced/command/ce
	_app_preset_type = /datum/modular_computer_app_presets/engineering/ce

/obj/item/modular_computer/handheld/wristbound/preset/advanced/command/rd
	_app_preset_type = /datum/modular_computer_app_presets/research/rd

/obj/item/modular_computer/handheld/wristbound/preset/advanced/command/cmo
	_app_preset_type = /datum/modular_computer_app_presets/medical/cmo

/obj/item/modular_computer/handheld/wristbound/preset/advanced/command/xo
	_app_preset_type = /datum/modular_computer_app_presets/command/hop

/obj/item/modular_computer/handheld/wristbound/preset/advanced/command/hos
	_app_preset_type = /datum/modular_computer_app_presets/security/hos

/obj/item/modular_computer/handheld/wristbound/preset/advanced/command/captain
	_app_preset_type = /datum/modular_computer_app_presets/command/captain

/obj/item/modular_computer/handheld/wristbound/preset/advanced/representative
	_app_preset_type = /datum/modular_computer_app_presets/representative
	enrolled = DEVICE_PRIVATE

// Wristbound PDA presets

/obj/item/modular_computer/handheld/wristbound/preset/pda
	enrolled = DEVICE_PRIVATE

/obj/item/modular_computer/handheld/wristbound/preset/pda/install_default_hardware()
	..()
	processor_unit = new /obj/item/computer_hardware/processor_unit/small(src)
	hard_drive = new /obj/item/computer_hardware/hard_drive/small(src)
	network_card = new /obj/item/computer_hardware/network_card(src)
	battery_module = new /obj/item/computer_hardware/battery_module(src)
	card_slot = new /obj/item/computer_hardware/card_slot(src)
	card_slot.stored_item = new /obj/item/pen
	tesla_link = new /obj/item/computer_hardware/tesla_link/charging_cable(src)
	flashlight = new /obj/item/computer_hardware/flashlight(src)
	battery_module.charge_to_full()

/obj/item/modular_computer/handheld/wristbound/preset/pda/civilian
	_app_preset_type = /datum/modular_computer_app_presets/civilian

/obj/item/modular_computer/handheld/wristbound/preset/pda/civilian/bartender/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/fountain

/obj/item/modular_computer/handheld/wristbound/preset/pda/civilian/librarian/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/fountain
	silence_notifications()

/obj/item/modular_computer/handheld/wristbound/preset/pda/civilian/janitor
	_app_preset_type = /datum/modular_computer_app_presets/civilian/janitor

/obj/item/modular_computer/handheld/wristbound/preset/pda/civilian/chaplain/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/fountain

/obj/item/modular_computer/handheld/wristbound/preset/pda/civilian/lawyer/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/fountain

// Engineering

/obj/item/modular_computer/handheld/wristbound/preset/pda/engineering
	_app_preset_type = /datum/modular_computer_app_presets/engineering
	icon_state = "wristbound_engineering"
	item_state = "wristbound_engineering"
	icon_state_unpowered = "wristbound_engineering"

/obj/item/modular_computer/handheld/wristbound/preset/pda/engineering/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/silver

/obj/item/modular_computer/handheld/wristbound/preset/pda/engineering/atmos
	_app_preset_type = /datum/modular_computer_app_presets/engineering/atmos

/obj/item/modular_computer/handheld/wristbound/preset/pda/engineering/ce
	_app_preset_type = /datum/modular_computer_app_presets/engineering/ce

// Supply
/obj/item/modular_computer/handheld/wristbound/preset/pda/supply
	_app_preset_type = /datum/modular_computer_app_presets/supply
	icon_state = "wristbound_cargo"
	item_state = "wristbound_cargo"
	icon_state_unpowered = "wristbound_cargo"

/obj/item/modular_computer/handheld/wristbound/preset/pda/supply/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/silver

/obj/item/modular_computer/handheld/wristbound/preset/pda/supply/om/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/fountain

/obj/item/modular_computer/handheld/wristbound/preset/pda/supply/miner
	_app_preset_type = /datum/modular_computer_app_presets/civilian

/obj/item/modular_computer/handheld/wristbound/preset/pda/supply/machinist
	_app_preset_type = /datum/modular_computer_app_presets/supply/machinist

// Medical

/obj/item/modular_computer/handheld/wristbound/preset/pda/medical
	_app_preset_type = /datum/modular_computer_app_presets/medical
	icon_state = "wristbound_medical"
	item_state = "wristbound_medical"
	icon_state_unpowered = "wristbound_medical"

/obj/item/modular_computer/handheld/wristbound/preset/pda/medical/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/white

/obj/item/modular_computer/handheld/wristbound/preset/pda/medical/psych/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/fountain/white

/obj/item/modular_computer/handheld/wristbound/preset/pda/medical/cmo
	_app_preset_type = /datum/modular_computer_app_presets/medical/cmo

// Science

/obj/item/modular_computer/handheld/wristbound/preset/pda/research
	_app_preset_type = /datum/modular_computer_app_presets/research
	icon_state = "wristbound_science"
	item_state = "wristbound_science"
	icon_state_unpowered = "wristbound_science"

/obj/item/modular_computer/handheld/wristbound/preset/pda/research/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/white

/obj/item/modular_computer/handheld/wristbound/preset/pda/research/rd
	_app_preset_type = /datum/modular_computer_app_presets/research/rd

// Security

/obj/item/modular_computer/handheld/wristbound/preset/pda/security
	_app_preset_type = /datum/modular_computer_app_presets/security
	icon_state = "wristbound_security"
	item_state = "wristbound_security"
	icon_state_unpowered = "wristbound_security"

/obj/item/modular_computer/handheld/wristbound/preset/pda/security/detective
	_app_preset_type = /datum/modular_computer_app_presets/security/investigations

/obj/item/modular_computer/handheld/wristbound/preset/pda/security/hos
	_app_preset_type = /datum/modular_computer_app_presets/security/hos

// Command / Misc

/obj/item/modular_computer/handheld/wristbound/preset/pda/command
	_app_preset_type = /datum/modular_computer_app_presets/command
	icon_state = "wristbound_command"
	item_state = "wristbound_command"
	icon_state_unpowered = "wristbound_command"

/obj/item/modular_computer/handheld/wristbound/preset/pda/command/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/fountain/head

/obj/item/modular_computer/handheld/wristbound/preset/pda/command/cciaa
	_app_preset_type = /datum/modular_computer_app_presets/command

/obj/item/modular_computer/handheld/wristbound/preset/pda/command/xo
	_app_preset_type = /datum/modular_computer_app_presets/command/hop

/obj/item/modular_computer/handheld/wristbound/preset/pda/command/captain
	_app_preset_type = /datum/modular_computer_app_presets/command/captain

/obj/item/modular_computer/handheld/wristbound/preset/pda/command/captain/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/fountain/captain

/obj/item/modular_computer/handheld/wristbound/preset/pda/command/bst
	hidden = TRUE

/obj/item/modular_computer/handheld/wristbound/preset/pda/command/bst/attack_hand()
	if(!usr)
		return
	if(!istype(usr, /mob/living/carbon/human/bst))
		to_chat(usr, SPAN_ALERT("Your hand seems to go right through the [src]. It's like it doesn't exist."))
		return
	else
		..()

/obj/item/modular_computer/handheld/wristbound/preset/pda/ert
	_app_preset_type = /datum/modular_computer_app_presets/ert
	icon_state = "wristbound_command"
	item_state = "wristbound_command"
	icon_state_unpowered = "wristbound_command"
	hidden = TRUE

/obj/item/modular_computer/handheld/wristbound/preset/pda/syndicate
	_app_preset_type = /datum/modular_computer_app_presets/merc
	icon_state = "wristbound_security"
	item_state = "wristbound_security"
	icon_state_unpowered = "wristbound_security"
	computer_emagged = TRUE
	hidden = TRUE

/obj/item/modular_computer/handheld/wristbound/preset/pda/syndicate/install_default_hardware()
	..()
	network_card = new /obj/item/computer_hardware/network_card/signaler(src)
