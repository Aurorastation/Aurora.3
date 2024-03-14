
/datum/modular_computer_app_presets/wall_generic
	name = "wallgeneric"
	display_name = "Wall - Generic"
	description = "A generic preset for the wall console."
	available = FALSE

/datum/modular_computer_app_presets/wall_generic/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		COMPUTER_APP_PRESET_SYSTEM,
		new /datum/computer_file/program/manifest(comp),
		new /datum/computer_file/program/chat_client(comp),
		new /datum/computer_file/program/civilian/cargoorder(comp),
		new /datum/computer_file/program/camera_monitor(comp),
		new /datum/computer_file/program/alarm_monitor/engineering(comp)
	)
	return flatten_list(_prg_list)

/datum/modular_computer_app_presets/ai
	name = "ai"
	display_name = "AI"
	description = "A preset for the AI consoles."
	available = FALSE

/datum/modular_computer_app_presets/ai/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		COMPUTER_APP_PRESET_SYSTEM,
	)
	return flatten_list(_prg_list)

/datum/modular_computer_app_presets/command/teleporter
	name = "command_teleporter"
	display_name = "Command - Teleporter"
	description = "Contains the most common command programs and has a special teleporter control program loaded."
	available = FALSE

/datum/modular_computer_app_presets/command/teleporter/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		COMPUTER_APP_PRESET_SYSTEM,
		COMPUTER_APP_PRESET_HORIZON_CIVILIAN,
		new /datum/computer_file/program/comm(comp, FALSE),
		new /datum/computer_file/program/records/employment(comp),
		new /datum/computer_file/program/teleporter(comp)
	)
	return flatten_list(_prg_list)

/datum/modular_computer_app_presets/command/account
	name = "command_accounting"
	display_name = "Command - Accounting"
	description = "Contains all the programs you would need to become a god-tier accountant."
	available = FALSE

/datum/modular_computer_app_presets/command/account/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		COMPUTER_APP_PRESET_SYSTEM,
		new /datum/computer_file/program/newsbrowser(comp),
		new /datum/computer_file/program/manifest(comp),
		new /datum/computer_file/program/civilian/cargoorder(comp),
		new /datum/computer_file/program/civilian/cargocontrol(comp),
		new /datum/computer_file/program/records/employment(comp),
		new /datum/computer_file/program/account_db(comp)
	)
	return flatten_list(_prg_list)

/datum/modular_computer_app_presets/command/account/centcomm/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		COMPUTER_APP_PRESET_SYSTEM,
		new /datum/computer_file/program/newsbrowser(comp),
		new /datum/computer_file/program/manifest(comp),
		new /datum/computer_file/program/civilian/cargoorder(comp),
		new /datum/computer_file/program/civilian/cargocontrol(comp),
		new /datum/computer_file/program/records/employment(comp),
		new /datum/computer_file/program/account_db(comp, TRUE)
	)
	return flatten_list(_prg_list)

/datum/modular_computer_app_presets/trashcompactor
	name = "trashcompactor"
	display_name = "Trash Compactor"
	description = "A preset for the Trash Compactor Wall Console."
	available = FALSE

/datum/modular_computer_app_presets/trashcompactor/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		new /datum/computer_file/program/crushercontrol(comp)
	)
	return flatten_list(_prg_list)

/datum/modular_computer_app_presets/cargo_delivery
	name = "cargo_delivery"
	display_name = "Cargo Delivery"
	description = "Contains the Delivery App."
	available = FALSE

/datum/modular_computer_app_presets/cargo_delivery/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		COMPUTER_APP_PRESET_SYSTEM,
		COMPUTER_APP_PRESET_HORIZON_CIVILIAN,
		new /datum/computer_file/program/civilian/cargodelivery(comp)
	)
	return flatten_list(_prg_list)
