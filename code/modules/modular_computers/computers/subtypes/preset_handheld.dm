/obj/item/modular_computer/handheld/custom_loadout/cheap/install_default_hardware()
	preset_components = list(
		MC_CPU = /obj/item/computer_hardware/processor_unit/small,
		MC_HDD = /obj/item/computer_hardware/hard_drive/micro,
		MC_NET = /obj/item/computer_hardware/network_card,
		MC_BAT = /obj/item/computer_hardware/battery_module,
		MC_PWR = /obj/item/computer_hardware/tesla_link/charging_cable,
		MC_FLSH = /obj/item/computer_hardware/flashlight,
		MC_CARD = /obj/item/computer_hardware/card_slot
	)
	..()

/obj/item/modular_computer/handheld/custom_loadout/advanced/install_default_hardware()
	preset_components = list(
		MC_CPU = /obj/item/computer_hardware/processor_unit/small,
		MC_HDD = /obj/item/computer_hardware/hard_drive/small,
		MC_NET = /obj/item/computer_hardware/network_card,
		MC_PRNT = /obj/item/computer_hardware/nano_printer,
		MC_CARD = /obj/item/computer_hardware/card_slot,
		MC_BAT = /obj/item/computer_hardware/battery_module/hotswap,
		MC_PWR = /obj/item/computer_hardware/tesla_link/charging_cable,
		MC_FLSH = /obj/item/computer_hardware/flashlight
	)
	..()


// Cargo Delivery
/obj/item/modular_computer/handheld/custom_loadout/advanced/cargo_delivery
	_app_preset_type = /datum/modular_computer_app_presets/cargo_delivery
	enrolled = DEVICE_PRIVATE

// Tablet PDA presets
/obj/item/modular_computer/handheld/preset
	enrolled = DEVICE_PRIVATE

/obj/item/modular_computer/handheld/preset/install_default_hardware()
	preset_components = list(
		MC_CPU = /obj/item/computer_hardware/processor_unit/small,
		MC_HDD = /obj/item/computer_hardware/hard_drive/small,
		MC_NET = /obj/item/computer_hardware/network_card,
		MC_CARD = /obj/item/computer_hardware/card_slot,
		MC_BAT = /obj/item/computer_hardware/battery_module,
		MC_PWR = /obj/item/computer_hardware/tesla_link/charging_cable,
		MC_FLSH = /obj/item/computer_hardware/flashlight
	)
	..()
	var/obj/item/computer_hardware/card_slot/card_slot = hardware_by_slot(MC_CARD)
	card_slot.stored_item = new /obj/item/pen

/obj/item/modular_computer/handheld/preset/civilian
	_app_preset_type = /datum/modular_computer_app_presets/civilian

/obj/item/modular_computer/handheld/preset/civilian/bartender/Initialize()
	. = ..()
	var/obj/item/computer_hardware/card_slot/card_slot = hardware_by_slot(MC_CARD)
	card_slot.stored_item = new /obj/item/pen/fountain

/obj/item/modular_computer/handheld/preset/civilian/librarian/Initialize()
	. = ..()
	var/obj/item/computer_hardware/card_slot/card_slot = hardware_by_slot(MC_CARD)
	card_slot.stored_item = new /obj/item/pen/fountain
	silence_notifications()

/obj/item/modular_computer/handheld/preset/civilian/janitor
	_app_preset_type = /datum/modular_computer_app_presets/civilian/janitor

/obj/item/modular_computer/handheld/preset/civilian/chaplain/Initialize()
	. = ..()
	var/obj/item/computer_hardware/card_slot/card_slot = hardware_by_slot(MC_CARD)
	card_slot.stored_item = new /obj/item/pen/fountain

/obj/item/modular_computer/handheld/preset/civilian/lawyer/Initialize()
	. = ..()
	var/obj/item/computer_hardware/card_slot/card_slot = hardware_by_slot(MC_CARD)
	card_slot.stored_item = new /obj/item/pen/fountain

// Engineering

/obj/item/modular_computer/handheld/preset/engineering
	_app_preset_type = /datum/modular_computer_app_presets/engineering

/obj/item/modular_computer/handheld/preset/engineering/Initialize()
	. = ..()
	var/obj/item/computer_hardware/card_slot/card_slot = hardware_by_slot(MC_CARD)
	card_slot.stored_item = new /obj/item/pen/silver

/obj/item/modular_computer/handheld/preset/engineering/atmos
	_app_preset_type = /datum/modular_computer_app_presets/engineering/atmos

/obj/item/modular_computer/handheld/preset/engineering/ce
	_app_preset_type = /datum/modular_computer_app_presets/engineering/ce

// Supply
/obj/item/modular_computer/handheld/preset/supply
	_app_preset_type = /datum/modular_computer_app_presets/supply

/obj/item/modular_computer/handheld/preset/supply/Initialize()
	. = ..()
	var/obj/item/computer_hardware/card_slot/card_slot = hardware_by_slot(MC_CARD)
	card_slot.stored_item = new /obj/item/pen/silver

/obj/item/modular_computer/handheld/preset/supply/qm/Initialize()
	. = ..()
	var/obj/item/computer_hardware/card_slot/card_slot = hardware_by_slot(MC_CARD)
	card_slot.stored_item = new /obj/item/pen/fountain

// Medical

/obj/item/modular_computer/handheld/preset/medical
	_app_preset_type = /datum/modular_computer_app_presets/medical

/obj/item/modular_computer/handheld/preset/medical/Initialize()
	. = ..()
	var/obj/item/computer_hardware/card_slot/card_slot = hardware_by_slot(MC_CARD)
	card_slot.stored_item = new /obj/item/pen/white

/obj/item/modular_computer/handheld/preset/medical/psych/Initialize()
	. = ..()
	var/obj/item/computer_hardware/card_slot/card_slot = hardware_by_slot(MC_CARD)
	card_slot.stored_item = new /obj/item/pen/fountain/white

/obj/item/modular_computer/handheld/preset/medical/cmo
	_app_preset_type = /datum/modular_computer_app_presets/medical/cmo

// Science

/obj/item/modular_computer/handheld/preset/research
	_app_preset_type = /datum/modular_computer_app_presets/research

/obj/item/modular_computer/handheld/preset/research/Initialize()
	. = ..()
	var/obj/item/computer_hardware/card_slot/card_slot = hardware_by_slot(MC_CARD)
	card_slot.stored_item = new /obj/item/pen/white

/obj/item/modular_computer/handheld/preset/research/rd
	_app_preset_type = /datum/modular_computer_app_presets/research/rd

// Security

/obj/item/modular_computer/handheld/preset/security
	_app_preset_type = /datum/modular_computer_app_presets/security

/obj/item/modular_computer/handheld/preset/security/detective
	_app_preset_type = /datum/modular_computer_app_presets/security/investigations

/obj/item/modular_computer/handheld/preset/security/hos
	_app_preset_type = /datum/modular_computer_app_presets/security/hos

// Command / Misc

/obj/item/modular_computer/handheld/preset/command
	_app_preset_type = /datum/modular_computer_app_presets/command

/obj/item/modular_computer/handheld/preset/command/Initialize()
	. = ..()
	var/obj/item/computer_hardware/card_slot/card_slot = hardware_by_slot(MC_CARD)
	card_slot.stored_item = new /obj/item/pen/fountain/head

/obj/item/modular_computer/handheld/preset/command/cciaa
	_app_preset_type = /datum/modular_computer_app_presets/command

/obj/item/modular_computer/handheld/preset/command/hop
	_app_preset_type = /datum/modular_computer_app_presets/command/hop

/obj/item/modular_computer/handheld/preset/command/captain
	_app_preset_type = /datum/modular_computer_app_presets/command/captain

/obj/item/modular_computer/handheld/preset/command/captain/Initialize()
	. = ..()
	var/obj/item/computer_hardware/card_slot/card_slot = hardware_by_slot(MC_CARD)
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
	preset_components[MC_NET] = /obj/item/computer_hardware/network_card/signaler
	..()
