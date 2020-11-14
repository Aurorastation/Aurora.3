/obj/item/modular_computer/laptop/preset
	anchored = FALSE
	screen_on = FALSE
	icon_state = "laptop-closed"
	preset_components = list(
		MC_CPU = /obj/item/computer_hardware/processor_unit,
		MC_HDD = /obj/item/computer_hardware/hard_drive,
		MC_NET = /obj/item/computer_hardware/network_card,
		MC_BAT = /obj/item/computer_hardware/battery_module,
		MC_PRNT = /obj/item/computer_hardware/nano_printer,
		MC_PWR = /obj/item/computer_hardware/tesla_link/charging_cable
	)

// Engineering
/obj/item/modular_computer/laptop/preset/engineering
	name = "engineering laptop"
	desc = "A portable computer belonging to the engineering department. It appears to have been used as a door stop at one point or another."
	_app_preset_type = /datum/modular_computer_app_presets/engineering
	enrolled = 1

/obj/item/modular_computer/laptop/preset/engineering/ce
	name = "chief engineer's laptop"
	desc = "A portable computer belonging to the chief engineer."
	_app_preset_type = /datum/modular_computer_app_presets/engineering/ce

// Medical
/obj/item/modular_computer/laptop/preset/medical
	name = "medical laptop"
	desc = "A portable computer belonging to the medical department."
	_app_preset_type = /datum/modular_computer_app_presets/medical
	enrolled = 1

/obj/item/modular_computer/laptop/preset/medical/cmo
	name = "chief medical officer's laptop"
	desc = "A portable computer belonging to the chief medical officer."
	_app_preset_type = /datum/modular_computer_app_presets/medical/cmo

// Research
/obj/item/modular_computer/laptop/preset/research
	name = "research laptop"
	desc = "A portable computer belonging to the research department."
	_app_preset_type = /datum/modular_computer_app_presets/research
	enrolled = 1

/obj/item/modular_computer/laptop/preset/research/install_default_hardware()
	preset_components[MC_AI] = /obj/item/computer_hardware/ai_slot
	..()

/obj/item/modular_computer/laptop/preset/research/rd
	name = "research director's laptop"
	desc = "A portable computer belonging to the research director. The edges are stained and partially melted."
	_app_preset_type = /datum/modular_computer_app_presets/research/rd

// Command
/obj/item/modular_computer/laptop/preset/command
	name = "command laptop"
	_app_preset_type = /datum/modular_computer_app_presets/command
	enrolled = 1

/obj/item/modular_computer/laptop/preset/command/install_default_hardware()
	preset_components[MC_CARD] = /obj/item/computer_hardware/card_slot
	..()

/obj/item/modular_computer/laptop/preset/command/hop
	name = "head of personnel's laptop"
	desc = "A portable computer beloning to the head of personnel. The fan is filled with dog hair."
	_app_preset_type = /datum/modular_computer_app_presets/command/hop

/obj/item/modular_computer/laptop/preset/command/captain
	name = "captain's laptop"
	desc = "A portable computer belonging to the captain."
	_app_preset_type = /datum/modular_computer_app_presets/command/captain

// Security
/obj/item/modular_computer/laptop/preset/security
	name = "security laptop"
	desc = "A portable computer belonging to the security department."
	_app_preset_type = /datum/modular_computer_app_presets/security
	enrolled = 1

/obj/item/modular_computer/laptop/preset/security/hos
	name = "head of security's laptop"
	desc = "A portable computer belonging to the head of security. It smells faintly of gunpowder."
	_app_preset_type = /datum/modular_computer_app_presets/security/hos

// Civilian
/obj/item/modular_computer/laptop/preset/civilian
	_app_preset_type = /datum/modular_computer_app_presets/civilian
	enrolled = 1

// Supply
/obj/item/modular_computer/laptop/preset/supply
	name = "supply laptop"
	desc = "A portable computer belonging to cargo."
	_app_preset_type = /datum/modular_computer_app_presets/supply
	enrolled = 1

// Representative
/obj/item/modular_computer/laptop/preset/representative
	name = "representative's laptop"
	desc = "A portable computer belonging to the representative's office."
	_app_preset_type = /datum/modular_computer_app_presets/representative
	enrolled = 1
