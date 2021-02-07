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
	_app_preset_type = /datum/modular_computer_app_presets/civilian

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

/obj/item/modular_computer/handheld/wristbound/preset/advanced/cargo
	_app_preset_type = /datum/modular_computer_app_presets/cargo_delivery
	icon_state = "wristbound-cargo"

/obj/item/modular_computer/handheld/wristbound/preset/advanced/engineering
	_app_preset_type = /datum/modular_computer_app_presets/engineering
	icon_state = "wristbound-e"

/obj/item/modular_computer/handheld/wristbound/preset/advanced/medical
	_app_preset_type = /datum/modular_computer_app_presets/medical
	icon_state = "wristbound-m"

/obj/item/modular_computer/handheld/wristbound/preset/advanced/security
	_app_preset_type = /datum/modular_computer_app_presets/security
	icon_state = "wristbound-s"

/obj/item/modular_computer/handheld/wristbound/preset/advanced/security/investigations
	_app_preset_type = /datum/modular_computer_app_presets/security/investigations

/obj/item/modular_computer/handheld/wristbound/preset/advanced/research
	_app_preset_type = /datum/modular_computer_app_presets/research
	icon_state = "wristbound-tox"

/obj/item/modular_computer/handheld/wristbound/preset/advanced/research/robotics
	_app_preset_type = /datum/modular_computer_app_presets/research/robotics

/obj/item/modular_computer/handheld/wristbound/preset/advanced/command
	_app_preset_type = /datum/modular_computer_app_presets/command
	icon_state = "wristbound-h"
/obj/item/modular_computer/handheld/wristbound/preset/advanced/command/ce
	_app_preset_type = /datum/modular_computer_app_presets/engineering/ce
	icon_state = "wristbound-ce"

/obj/item/modular_computer/handheld/wristbound/preset/advanced/command/rd
	_app_preset_type = /datum/modular_computer_app_presets/research/rd
	icon_state = "wristbound-rd"

/obj/item/modular_computer/handheld/wristbound/preset/advanced/command/cmo
	_app_preset_type = /datum/modular_computer_app_presets/medical/cmo
	icon_state = "wristbound-cmo"

/obj/item/modular_computer/handheld/wristbound/preset/advanced/command/hop
	_app_preset_type = /datum/modular_computer_app_presets/command/hop
	icon_state = "wristbound-hop"

/obj/item/modular_computer/handheld/wristbound/preset/advanced/command/hos
	_app_preset_type = /datum/modular_computer_app_presets/security/hos

/obj/item/modular_computer/handheld/wristbound/preset/advanced/command/captain
	_app_preset_type = /datum/modular_computer_app_presets/command/captain
	icon_state = "wristbound-c"

/obj/item/modular_computer/handheld/wristbound/preset/advanced/generic
	_app_preset_type = /datum/modular_computer_app_presets/civilian

/obj/item/modular_computer/handheld/wristbound/preset/advanced/representative
	_app_preset_type = /datum/modular_computer_app_presets/representative
	enrolled = DEVICE_PRIVATE

// Wristbound PDA presets

/obj/item/modular_computer/handheld/wristbound/preset/pda
	var/icon_add // this is the "bar" part in "pda-bar"
	enrolled = DEVICE_PRIVATE

/obj/item/modular_computer/handheld/wristbound/preset/pda/set_icon()
	if(icon_add)
		icon_state += "-[icon_add]"
	..()

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

/obj/item/modular_computer/handheld/wristbound/preset/pda/civilian/lawyer
	icon_add = "h"

/obj/item/modular_computer/handheld/wristbound/preset/pda/civilian/lawyer/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/fountain

/obj/item/modular_computer/handheld/wristbound/preset/pda/civilian/clown
	_app_preset_type = /datum/modular_computer_app_presets/civilian/clown
	icon_add = "clown"

/obj/item/modular_computer/handheld/wristbound/preset/pda/civilian/clown/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/crayon

/obj/item/modular_computer/handheld/wristbound/preset/pda/civilian/mime
	_app_preset_type = /datum/modular_computer_app_presets/civilian/mime
	icon_add = "mime"


// Engineering

/obj/item/modular_computer/handheld/wristbound/preset/pda/engineering
	_app_preset_type = /datum/modular_computer_app_presets/engineering
	icon_add = "e"

/obj/item/modular_computer/handheld/wristbound/preset/pda/engineering/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/silver

/obj/item/modular_computer/handheld/wristbound/preset/pda/engineering/atmos
	_app_preset_type = /datum/modular_computer_app_presets/engineering/atmos

/obj/item/modular_computer/handheld/wristbound/preset/pda/engineering/ce
	_app_preset_type = /datum/modular_computer_app_presets/engineering/ce
	icon_add = "ce"

// Supply
/obj/item/modular_computer/handheld/wristbound/preset/pda/supply
	_app_preset_type = /datum/modular_computer_app_presets/supply
	icon_add = "sup"

/obj/item/modular_computer/handheld/wristbound/preset/pda/supply/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/silver

/obj/item/modular_computer/handheld/wristbound/preset/pda/supply/miner
	_app_preset_type = /datum/modular_computer_app_presets/civilian

/obj/item/modular_computer/handheld/wristbound/preset/pda/supply/qm
	icon_add = "qm"

/obj/item/modular_computer/handheld/wristbound/preset/pda/supply/qm/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/fountain

// Medical

/obj/item/modular_computer/handheld/wristbound/preset/pda/medical
	_app_preset_type = /datum/modular_computer_app_presets/medical
	icon_add = "m"

/obj/item/modular_computer/handheld/wristbound/preset/pda/medical/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/white

/obj/item/modular_computer/handheld/wristbound/preset/pda/medical/psych/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/fountain/white

/obj/item/modular_computer/handheld/wristbound/preset/pda/medical/cmo
	_app_preset_type = /datum/modular_computer_app_presets/medical/cmo
	icon_add = "cmo"

// Science

/obj/item/modular_computer/handheld/wristbound/preset/pda/research
	_app_preset_type = /datum/modular_computer_app_presets/research
	icon_add = "tox"

/obj/item/modular_computer/handheld/wristbound/preset/pda/research/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/white

/obj/item/modular_computer/handheld/wristbound/preset/pda/research/rd
	_app_preset_type = /datum/modular_computer_app_presets/research/rd
	icon_add = "rd"

// Security

/obj/item/modular_computer/handheld/wristbound/preset/pda/security
	_app_preset_type = /datum/modular_computer_app_presets/security
	icon_add = "s"
/obj/item/modular_computer/handheld/wristbound/preset/pda/security/detective
	_app_preset_type = /datum/modular_computer_app_presets/security/investigations

/obj/item/modular_computer/handheld/wristbound/preset/pda/security/hos
	_app_preset_type = /datum/modular_computer_app_presets/security/hos
	icon_add = "hos"

// Command / Misc

/obj/item/modular_computer/handheld/wristbound/preset/pda/command
	_app_preset_type = /datum/modular_computer_app_presets/command
	icon_add = "h"

/obj/item/modular_computer/handheld/wristbound/preset/pda/command/Initialize()
	. = ..()
	card_slot.stored_item = new /obj/item/pen/fountain/head

/obj/item/modular_computer/handheld/wristbound/preset/pda/command/cciaa
	_app_preset_type = /datum/modular_computer_app_presets/command

/obj/item/modular_computer/handheld/wristbound/preset/pda/command/hop
	_app_preset_type = /datum/modular_computer_app_presets/command/hop
	icon_add = "hop"

/obj/item/modular_computer/handheld/wristbound/preset/pda/command/captain
	_app_preset_type = /datum/modular_computer_app_presets/command/captain
	icon_add = "c"

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
	icon_add = "h"
	hidden = TRUE

/obj/item/modular_computer/handheld/wristbound/preset/pda/syndicate
	_app_preset_type = /datum/modular_computer_app_presets/merc
	icon_add = "syn"
	computer_emagged = TRUE
	hidden = TRUE

/obj/item/modular_computer/handheld/wristbound/preset/pda/syndicate/install_default_hardware()
	..()
	network_card = new /obj/item/computer_hardware/network_card/signaler(src)
