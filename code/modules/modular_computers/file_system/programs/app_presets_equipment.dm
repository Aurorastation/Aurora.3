
/datum/modular_computer_app_presets/wall_generic
	name = "wallgeneric"
	display_name = "Wall - Generic"
	description = "A generic preset for the wall console."
	available = FALSE

/datum/modular_computer_app_presets/wall_generic/New()
	. = ..()
	program_list += COMPUTER_APP_PRESET_SYSTEM
	program_list += list(/datum/computer_file/program/manifest,
						/datum/computer_file/program/chat_client,
						/datum/computer_file/program/civilian/cargoorder,
						/datum/computer_file/program/camera_monitor,
						/datum/computer_file/program/alarm_monitor/engineering
						)


/datum/modular_computer_app_presets/ai
	name = "ai"
	display_name = "AI"
	description = "A preset for the AI consoles."
	available = FALSE

/datum/modular_computer_app_presets/ai/New()
	. = ..()
	program_list += COMPUTER_APP_PRESET_SYSTEM


/datum/modular_computer_app_presets/command/teleporter
	name = "command_teleporter"
	display_name = "Command - Teleporter"
	description = "Contains the most common command programs and has a special teleporter control program loaded."
	available = FALSE

/datum/modular_computer_app_presets/command/teleporter/New()
	. = ..()
	program_list += /datum/computer_file/program/teleporter

/datum/modular_computer_app_presets/command/account
	name = "command_accounting"
	display_name = "Command - Accounting"
	description = "Contains all the programs you would need to become a god-tier accountant."
	available = FALSE

/datum/modular_computer_app_presets/command/account/New()
	. = ..()
	program_list += list(/datum/computer_file/program/civilian/cargocontrol,
						/datum/computer_file/program/account_db
						)

/datum/modular_computer_app_presets/command/account/centcomm
	name = "command_accounting_centcomm"
	display_name = "Command - Accounting - CentComm"
	description = "Contains all the programs you would need to become a god-tier accountant."
	available = FALSE

/datum/modular_computer_app_presets/command/account/centcomm/New()
	. = ..()

	//Remove the default accounting program and add the centcomm version
	program_list -= /datum/computer_file/program/account_db
	program_list += /datum/computer_file/program/account_db/centcomm

/datum/modular_computer_app_presets/trashcompactor
	name = "trashcompactor"
	display_name = "Trash Compactor"
	description = "A preset for the Trash Compactor Wall Console."
	available = FALSE

/datum/modular_computer_app_presets/trashcompactor/New()
	. = ..()
	program_list += /datum/computer_file/program/crushercontrol

/datum/modular_computer_app_presets/cargo_delivery
	name = "cargo_delivery"
	display_name = "Cargo Delivery"
	description = "Contains the Delivery App."
	available = FALSE

/datum/modular_computer_app_presets/cargo_delivery/New()
	. = ..()
	program_list += COMPUTER_APP_PRESET_SYSTEM + COMPUTER_APP_PRESET_HORIZON_CIVILIAN
	program_list += /datum/computer_file/program/civilian/cargodelivery
