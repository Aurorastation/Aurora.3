// Tablet PDA presets
/obj/item/modular_computer/handheld/preset
	enrolled = DEVICE_COMPANY

/obj/item/modular_computer/handheld/preset/install_default_hardware()
	..()
	processor_unit = new/obj/item/computer_hardware/processor_unit/small(src)
	hard_drive = new /obj/item/computer_hardware/hard_drive/small(src)
	network_card = new /obj/item/computer_hardware/network_card(src)
	battery_module = new /obj/item/computer_hardware/battery_module(src)
	card_slot = new /obj/item/computer_hardware/card_slot(src)
	card_slot.stored_item = new /obj/item/pen
	tesla_link = new /obj/item/computer_hardware/tesla_link/charging_cable(src)
	flashlight = new /obj/item/computer_hardware/flashlight(src)
	battery_module.charge_to_full()

/obj/item/modular_computer/handheld/preset/generic
	enrolled = 0

/obj/item/modular_computer/handheld/preset/civilian
	_app_preset_type = /datum/modular_computer_app_presets/civilian

/obj/item/modular_computer/handheld/preset/civilian/bartender/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/fountain

/obj/item/modular_computer/handheld/preset/civilian/librarian/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/fountain
	silence_notifications()

/obj/item/modular_computer/handheld/preset/civilian/janitor
	_app_preset_type = /datum/modular_computer_app_presets/civilian/janitor

/obj/item/modular_computer/handheld/preset/civilian/chaplain/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/fountain

/obj/item/modular_computer/handheld/preset/civilian/lawyer/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/fountain

// Engineering

/obj/item/modular_computer/handheld/preset/engineering
	_app_preset_type = /datum/modular_computer_app_presets/engineering

/obj/item/modular_computer/handheld/preset/engineering/set_icon()
	icon_state += "-brown"
	icon_state_unpowered = icon_state
	icon_state_broken = icon_state

/obj/item/modular_computer/handheld/preset/engineering/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/silver

/obj/item/modular_computer/handheld/preset/engineering/atmos
	_app_preset_type = /datum/modular_computer_app_presets/engineering/atmos

/obj/item/modular_computer/handheld/preset/engineering/ce
	_app_preset_type = /datum/modular_computer_app_presets/engineering/ce

// Supply
/obj/item/modular_computer/handheld/preset/supply
	_app_preset_type = /datum/modular_computer_app_presets/supply

/obj/item/modular_computer/handheld/preset/supply/set_icon()
	icon_state += "-brown"
	icon_state_unpowered = icon_state
	icon_state_broken = icon_state

/obj/item/modular_computer/handheld/preset/supply/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/silver

/obj/item/modular_computer/handheld/preset/supply/om/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/fountain

/obj/item/modular_computer/handheld/preset/supply/machinist
	_app_preset_type = /datum/modular_computer_app_presets/supply/machinist

// Cargo Delivery
/obj/item/modular_computer/handheld/preset/supply/cargo_delivery
	_app_preset_type = /datum/modular_computer_app_presets/cargo_delivery

// Medical

/obj/item/modular_computer/handheld/preset/medical
	_app_preset_type = /datum/modular_computer_app_presets/medical

/obj/item/modular_computer/handheld/preset/medical/set_icon()
	icon_state += "-green"
	icon_state_unpowered = icon_state
	icon_state_broken = icon_state

/obj/item/modular_computer/handheld/preset/medical/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/white

/obj/item/modular_computer/handheld/preset/medical/psych/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/fountain/white

/obj/item/modular_computer/handheld/preset/medical/cmo
	_app_preset_type = /datum/modular_computer_app_presets/medical/cmo

// Science

/obj/item/modular_computer/handheld/preset/research
	_app_preset_type = /datum/modular_computer_app_presets/research

/obj/item/modular_computer/handheld/preset/research/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/white

/obj/item/modular_computer/handheld/preset/research/rd
	_app_preset_type = /datum/modular_computer_app_presets/research/rd

// Security

/obj/item/modular_computer/handheld/preset/security
	_app_preset_type = /datum/modular_computer_app_presets/security

/obj/item/modular_computer/handheld/preset/security/set_icon()
	icon_state += "-blue"
	icon_state_unpowered = icon_state
	icon_state_broken = icon_state

/obj/item/modular_computer/handheld/preset/security/detective
	_app_preset_type = /datum/modular_computer_app_presets/security/investigations

/obj/item/modular_computer/handheld/preset/security/hos
	_app_preset_type = /datum/modular_computer_app_presets/security/hos

// Command / Misc

/obj/item/modular_computer/handheld/preset/command
	_app_preset_type = /datum/modular_computer_app_presets/command

/obj/item/modular_computer/handheld/preset/command/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/fountain/head

/obj/item/modular_computer/handheld/preset/command/cciaa
	_app_preset_type = /datum/modular_computer_app_presets/command

/obj/item/modular_computer/handheld/preset/command/xo
	_app_preset_type = /datum/modular_computer_app_presets/command/hop

/obj/item/modular_computer/handheld/preset/command/captain
	_app_preset_type = /datum/modular_computer_app_presets/command/captain

/obj/item/modular_computer/handheld/preset/command/captain/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/fountain/captain

/obj/item/modular_computer/handheld/preset/command/bst
	hidden = TRUE

/obj/item/modular_computer/handheld/preset/command/bst/attack_hand()
	if(!usr)
		return
	if(!istype(usr, /mob/living/carbon/human/bst))
		to_chat(usr, SPAN_ALERT("Your hand seems to go right through the [src]. It's like it doesn't exist."))
		return
	else
		..()

/obj/item/modular_computer/handheld/preset/ert
	_app_preset_type = /datum/modular_computer_app_presets/ert
	hidden = TRUE

/obj/item/modular_computer/handheld/preset/syndicate
	_app_preset_type = /datum/modular_computer_app_presets/merc
	computer_emagged = TRUE
	hidden = TRUE

/obj/item/modular_computer/handheld/preset/syndicate/install_default_hardware()
	..()
	network_card = new /obj/item/computer_hardware/network_card/signaler(src)
