/obj/item/modular_computer/handheld/pda/install_default_hardware()
	..()
	processor_unit = new /obj/item/computer_hardware/processor_unit/small(src)
	hard_drive = new /obj/item/computer_hardware/hard_drive/small(src)
	network_card = new /obj/item/computer_hardware/network_card(src)
	battery_module = new /obj/item/computer_hardware/battery_module(src)
	card_slot = new /obj/item/computer_hardware/card_slot(src)
	card_slot.stored_item = new pen_type(src)
	tesla_link = new /obj/item/computer_hardware/tesla_link/charging_cable(src)
	flashlight = new /obj/item/computer_hardware/flashlight(src)
	battery_module.charge_to_full()

/obj/item/modular_computer/handheld/pda
	_app_preset_type = /datum/modular_computer_app_presets/civilian

// Civilian

/obj/item/modular_computer/handheld/pda/civilian
	_app_preset_type = /datum/modular_computer_app_presets/civilian
	pen_type = /obj/item/pen/fountain

/obj/item/modular_computer/handheld/pda/civilian/bartender
	pen_type = /obj/item/pen

/obj/item/modular_computer/handheld/pda/civilian/librarian
	icon_add = "libb"

/obj/item/modular_computer/handheld/pda/civilian/librarian/Initialize()
	. = ..()
	silence_notifications()

/obj/item/modular_computer/handheld/pda/civilian/janitor
	_app_preset_type = /datum/modular_computer_app_presets/civilian/janitor
	pen_type = /obj/item/pen

/obj/item/modular_computer/handheld/pda/civilian/lawyer
	icon_add = "h"

/obj/item/modular_computer/handheld/pda/civilian/clown
	_app_preset_type = /datum/modular_computer_app_presets/civilian/clown
	icon_add = "clown"
	pen_type = /obj/item/pen/crayon

/obj/item/modular_computer/handheld/pda/civilian/mime
	_app_preset_type = /datum/modular_computer_app_presets/civilian/mime
	icon_add = "mime"

// Engineering

/obj/item/modular_computer/handheld/pda/engineering
	_app_preset_type = /datum/modular_computer_app_presets/engineering
	icon_add = "e"
	pen_type = /obj/item/pen/silver

/obj/item/modular_computer/handheld/pda/engineering/atmos
	_app_preset_type = /datum/modular_computer_app_presets/engineering/atmos

/obj/item/modular_computer/handheld/pda/engineering/ce
	_app_preset_type = /datum/modular_computer_app_presets/engineering/ce
	icon_add = "ce"

// Supply
/obj/item/modular_computer/handheld/pda/supply
	_app_preset_type = /datum/modular_computer_app_presets/supply
	icon_add = "sup"
	pen_type = /obj/item/pen/silver

/obj/item/modular_computer/handheld/pda/supply/miner
	_app_preset_type = /datum/modular_computer_app_presets/civilian

/obj/item/modular_computer/handheld/pda/supply/qm
	icon_add = "q"
	pen_type = /obj/item/pen/fountain/silver

// Medical

/obj/item/modular_computer/handheld/pda/medical
	_app_preset_type = /datum/modular_computer_app_presets/medical
	icon_add = "m"
	pen_type = /obj/item/pen/white

/obj/item/modular_computer/handheld/pda/medical/psych
	pen_type = /obj/item/pen/fountain/white

/obj/item/modular_computer/handheld/pda/medical/cmo
	_app_preset_type = /datum/modular_computer_app_presets/medical/cmo
	icon_add = "cmo"

// Science

/obj/item/modular_computer/handheld/pda/research
	_app_preset_type = /datum/modular_computer_app_presets/research
	icon_add = "tox"
	pen_type = /obj/item/pen/white

/obj/item/modular_computer/handheld/pda/research/robotics
	_app_preset_type = /datum/modular_computer_app_presets/research/robotics

/obj/item/modular_computer/handheld/pda/research/rd
	_app_preset_type = /datum/modular_computer_app_presets/research/rd
	icon_add = "rd"

// Security

/obj/item/modular_computer/handheld/pda/security
	_app_preset_type = /datum/modular_computer_app_presets/security
	icon_add = "s"

/obj/item/modular_computer/handheld/pda/security/detective
	_app_preset_type = /datum/modular_computer_app_presets/security/investigations

/obj/item/modular_computer/handheld/pda/security/hos
	_app_preset_type = /datum/modular_computer_app_presets/security/hos
	icon_add = "hos"

// Command / Misc

/obj/item/modular_computer/handheld/pda/command
	_app_preset_type = /datum/modular_computer_app_presets/command
	icon_add = "h"
	pen_type = /obj/item/pen/fountain/head

/obj/item/modular_computer/handheld/pda/command/cciaa
	_app_preset_type = /datum/modular_computer_app_presets/command
	icon_add = "h"

/obj/item/modular_computer/handheld/pda/command/hop
	_app_preset_type = /datum/modular_computer_app_presets/command/hop
	icon_add = "hop"

/obj/item/modular_computer/handheld/pda/command/captain
	_app_preset_type = /datum/modular_computer_app_presets/command/captain
	icon_add = "c"
	pen_type = /obj/item/pen/fountain/captain

/obj/item/modular_computer/handheld/pda/command/bst
	icon_add = "h"
	hidden = TRUE

/obj/item/modular_computer/handheld/pda/command/bst/attack_hand()
	if(!usr)
		return
	if(!istype(usr, /mob/living/carbon/human/bst))
		to_chat(usr, SPAN_ALERT("Your hand seems to go right through the [src]. It's like it doesn't exist."))
		return
	else
		..()

/obj/item/modular_computer/handheld/pda/ert
	_app_preset_type = /datum/modular_computer_app_presets/ert
	icon_add = "s"
	hidden = TRUE

/obj/item/modular_computer/handheld/pda/syndicate
	_app_preset_type = /datum/modular_computer_app_presets/merc
	icon_add = "syn"
	computer_emagged = TRUE

/obj/item/modular_computer/handheld/pda/syndicate/install_default_hardware()
	..()
	network_card = new /obj/item/computer_hardware/network_card/signaler(src)

/obj/item/modular_computer/handheld/pda/civilian/clear
	icon_add = "transp"

/obj/item/modular_computer/handheld/pda/civilian/merchant
	hidden = TRUE