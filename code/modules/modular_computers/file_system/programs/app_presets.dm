/datum/modular_computer_app_presets
	var/name = "default_preset"
	var/display_name = "default preset"
	var/description = "Description of the preset."
	var/available = FALSE

/datum/modular_computer_app_presets/proc/return_install_programs()
	return list()

/datum/modular_computer_app_presets/all
	name = "all"
	display_name = "All Programs"
	description = "Contains all programs."
	available = FALSE

/datum/modular_computer_app_presets/all/return_install_programs()
	var/list/_prg_list = list()
	for(var/F in typesof(/datum/computer_file/program))
		var/datum/computer_file/program/prog = new F
		_prg_list += prog
	return _prg_list

/datum/modular_computer_app_presets/engineering
	name = "engineering"
	display_name = "Engineering"
	description = "Contains the most common engineering programs."
	available = TRUE

/datum/modular_computer_app_presets/engineering/return_install_programs()
	var/list/_prg_list = list(
		new /datum/computer_file/program/filemanager(),
		new /datum/computer_file/program/chatclient(),
		new /datum/computer_file/program/civilian/cargoorder(),
		new /datum/computer_file/program/power_monitor(),
		new /datum/computer_file/program/alarm_monitor(),
		new /datum/computer_file/program/atmos_control(),
		new /datum/computer_file/program/rcon_console(),
		new /datum/computer_file/program/camera_monitor(),
		new /datum/computer_file/program/lighting_control()
	)
	return _prg_list

/datum/modular_computer_app_presets/engineering/ce
	name = "engineering_head"
	display_name = "Engineering - CE"
	description = "Contains the most common engineering programs and command software."
	available = FALSE

/datum/modular_computer_app_presets/engineering/ce/return_install_programs()
	var/list/_prg_list = list(
		new /datum/computer_file/program/filemanager(),
		new /datum/computer_file/program/chatclient(),
		new /datum/computer_file/program/civilian/cargoorder(),
		new /datum/computer_file/program/comm(FALSE),
		new /datum/computer_file/program/game/sudoku(),
		new /datum/computer_file/program/power_monitor(),
		new /datum/computer_file/program/alarm_monitor(),
		new /datum/computer_file/program/atmos_control(),
		new /datum/computer_file/program/rcon_console(),
		new /datum/computer_file/program/camera_monitor(),
		new /datum/computer_file/program/lighting_control(),
		new /datum/computer_file/program/records/employment()
	)
	return _prg_list

/datum/modular_computer_app_presets/medical
	name = "medical"
	display_name = "Medical"
	description = "Contains the most common medical programs."
	available = TRUE

/datum/modular_computer_app_presets/medical/return_install_programs()
	var/list/_prg_list = list(
		new /datum/computer_file/program/filemanager(),
		new /datum/computer_file/program/chatclient(),
		new /datum/computer_file/program/civilian/cargoorder(),
		new /datum/computer_file/program/suit_sensors(),
		new /datum/computer_file/program/records/medical()
	)
	return _prg_list

/datum/modular_computer_app_presets/medical/cmo
	name = "medical_head"
	display_name = "Medical - CMO"
	description = "Contains the most common medical programs and command software."
	available = FALSE

/datum/modular_computer_app_presets/medical/cmo/return_install_programs()
	var/list/_prg_list = list(
		new /datum/computer_file/program/filemanager(),
		new /datum/computer_file/program/chatclient(),
		new /datum/computer_file/program/civilian/cargoorder(),
		new /datum/computer_file/program/comm(FALSE),
		new /datum/computer_file/program/suit_sensors(),
		new /datum/computer_file/program/records/employment(),
		new /datum/computer_file/program/records/medical()
	)
	return _prg_list

/datum/modular_computer_app_presets/research
	name = "research"
	display_name = "Research"
	description = "Contains the most common research programs."
	available = TRUE

/datum/modular_computer_app_presets/research/return_install_programs()
	var/list/_prg_list = list(
		new /datum/computer_file/program/filemanager(),
		new /datum/computer_file/program/chatclient(),
		new /datum/computer_file/program/civilian/cargoorder(),
		new /datum/computer_file/program/ntnetmonitor(),
		new /datum/computer_file/program/aidiag()
	)
	return _prg_list

/datum/modular_computer_app_presets/research/rd
	name = "research_head"
	display_name = "Research - RD"
	description = "Contains the most common research programs and command software."
	available = FALSE

/datum/modular_computer_app_presets/research/return_install_programs()
	var/list/_prg_list = list(
		new /datum/computer_file/program/filemanager(),
		new /datum/computer_file/program/chatclient(),
		new /datum/computer_file/program/civilian/cargoorder(),
		new /datum/computer_file/program/comm(FALSE),
		new /datum/computer_file/program/ntnetmonitor(),
		new /datum/computer_file/program/aidiag(),
		new /datum/computer_file/program/records/employment()
	)
	return _prg_list

/datum/modular_computer_app_presets/command
	name = "command"
	display_name = "Command"
	description = "Contains the most common command programs."
	available = TRUE

/datum/modular_computer_app_presets/command/return_install_programs()
	var/list/_prg_list = list(
		new /datum/computer_file/program/filemanager(),
		new /datum/computer_file/program/chatclient(),
		new /datum/computer_file/program/civilian/cargoorder(),
		new /datum/computer_file/program/card_mod(),
		new /datum/computer_file/program/comm(FALSE),
		new /datum/computer_file/program/records/employment()
	)
	return _prg_list

/datum/modular_computer_app_presets/command/hop
	name = "command_hop"
	display_name = "Command - HoP"
	description = "Contains the most common command programs."
	available = FALSE

/datum/modular_computer_app_presets/command/hop/return_install_programs()
	var/list/_prg_list = list(
		new /datum/computer_file/program/filemanager(),
		new /datum/computer_file/program/chatclient(),
		new /datum/computer_file/program/civilian/cargoorder(),
		new /datum/computer_file/program/civilian/cargocontrol(),
		new /datum/computer_file/program/card_mod(),
		new /datum/computer_file/program/comm(FALSE),
		new /datum/computer_file/program/records/employment(),
		new /datum/computer_file/program/records/security()
	)
	return _prg_list

/datum/modular_computer_app_presets/captain
	name = "captain"
	display_name = "Captain"
	description = "Contains the most important programs for the Captain."
	available = FALSE

/datum/modular_computer_app_presets/captain/return_install_programs()
	var/list/_prg_list = list(
		new /datum/computer_file/program/filemanager(),
		new /datum/computer_file/program/chatclient(),
		new /datum/computer_file/program/card_mod(),
		new /datum/computer_file/program/comm(FALSE),
		new /datum/computer_file/program/camera_monitor(),
		new /datum/computer_file/program/digitalwarrant(),
		new /datum/computer_file/program/penal_mechs(),
		new /datum/computer_file/program/civilian/cargocontrol(),
		new /datum/computer_file/program/civilian/cargoorder(),
		new /datum/computer_file/program/alarm_monitor(),
		new /datum/computer_file/program/records/employment(),
		new /datum/computer_file/program/records/medical(),
		new /datum/computer_file/program/records/security()
	)
	return _prg_list

/datum/modular_computer_app_presets/security
	name = "security"
	display_name = "Security"
	description = "Contains the most common security programs."
	available = TRUE

/datum/modular_computer_app_presets/security/return_install_programs()
	var/list/_prg_list = list(
		new /datum/computer_file/program/filemanager(),
		new /datum/computer_file/program/chatclient(),
		new /datum/computer_file/program/civilian/cargoorder(),
		new /datum/computer_file/program/camera_monitor(),
		new /datum/computer_file/program/comm(),
		new /datum/computer_file/program/digitalwarrant(),
		new /datum/computer_file/program/penal_mechs(),
		new /datum/computer_file/program/records/security()
	)
	return _prg_list

/datum/modular_computer_app_presets/security/investigations
	name = "security_inv"
	display_name = "Security - Investigations"
	description = "Contains the most common security and forensics programs."
	available = FALSE

/datum/modular_computer_app_presets/security/return_install_programs()
	var/list/_prg_list = list(
		new /datum/computer_file/program/filemanager(),
		new /datum/computer_file/program/chatclient(),
		new /datum/computer_file/program/camera_monitor(),
		new /datum/computer_file/program/digitalwarrant(),
		new /datum/computer_file/program/penal_mechs(),
		new /datum/computer_file/program/records/security(),
		new /datum/computer_file/program/records/employment(),
		new /datum/computer_file/program/records/medical()
	)
	return _prg_list

/datum/modular_computer_app_presets/security/hos
	name = "security_head"
	display_name = "Security - HoS"
	description = "Contains the most common security programs and command software."
	available = FALSE

/datum/modular_computer_app_presets/security/hos/return_install_programs()
	var/list/_prg_list = list(
		new /datum/computer_file/program/filemanager(),
		new /datum/computer_file/program/chatclient(),
		new /datum/computer_file/program/civilian/cargoorder(),
		new /datum/computer_file/program/comm(FALSE),
		new /datum/computer_file/program/camera_monitor(),
		new /datum/computer_file/program/digitalwarrant(),
		new /datum/computer_file/program/penal_mechs(),
		new /datum/computer_file/program/records/security(),
		new /datum/computer_file/program/records/employment()
	)
	return _prg_list

/datum/modular_computer_app_presets/civilian
	name = "civilian"
	display_name = "Civilian"
	description = "Contains the most common civilian programs."
	available = TRUE

/datum/modular_computer_app_presets/civilian/return_install_programs()
	var/list/_prg_list = list(
		new /datum/computer_file/program/filemanager(),
		new /datum/computer_file/program/chatclient(),
		new /datum/computer_file/program/civilian/cargoorder(),
		new /datum/computer_file/program/game/arcade(),
		new /datum/computer_file/program/game/sudoku()
	)
	return _prg_list

/datum/modular_computer_app_presets/supply
	name = "supply"
	display_name = "Supply"
	description = "Contains the most common cargo programs."
	available = TRUE

/datum/modular_computer_app_presets/supply/return_install_programs()
	var/list/_prg_list = list(
		new /datum/computer_file/program/filemanager(),
		new /datum/computer_file/program/chatclient(),
		new /datum/computer_file/program/civilian/cargocontrol(),
		new /datum/computer_file/program/civilian/cargoorder(),
		new /datum/computer_file/program/civilian/cargodelivery()
	)
	return _prg_list

/datum/modular_computer_app_presets/cargo_delivery
	name = "cargo_delivery"
	display_name = "Cargo Delivery"
	description = "Contains the Delivery App."
	available = FALSE

/datum/modular_computer_app_presets/cargo_delivery/return_install_programs()
	var/list/_prg_list = list(
		new /datum/computer_file/program/filemanager(),
		new /datum/computer_file/program/chatclient(),
		new /datum/computer_file/program/civilian/cargodelivery()
	)
	return _prg_list

/datum/modular_computer_app_presets/representative
	name = "representative"
	display_name = "Representative"
	description = "Contains software intended for representatives."
	available = FALSE

/datum/modular_computer_app_presets/representative/return_install_programs()
	var/list/_prg_list = list(
		new /datum/computer_file/program/filemanager(),
		new /datum/computer_file/program/chatclient(),
		new /datum/computer_file/program/game/sudoku(),
		new /datum/computer_file/program/civilian/cargoorder(),
		new /datum/computer_file/program/records/employment()
	)
	return _prg_list

/datum/modular_computer_app_presets/wall_generic
	name = "wallgeneric"
	display_name = "Wall - Generic"
	description = "A generic preset for the wall console."
	available = FALSE

/datum/modular_computer_app_presets/wall_generic/return_install_programs()
	var/list/_prg_list = list(
		new /datum/computer_file/program/filemanager(),
		new /datum/computer_file/program/chatclient(),
		new /datum/computer_file/program/civilian/cargoorder(),
		new /datum/computer_file/program/camera_monitor(),
		new /datum/computer_file/program/alarm_monitor()
	)
	return _prg_list

/datum/modular_computer_app_presets/merc
	name = "merc"
	display_name = "Mercenary"
	description = "Preset for the Merc Console."
	available = FALSE

/datum/modular_computer_app_presets/merc/return_install_programs()
	var/list/_prg_list = list(
		new /datum/computer_file/program/filemanager(),
		new /datum/computer_file/program/ntnetdownload(),
		new /datum/computer_file/program/camera_monitor/hacked()
	)
	return _prg_list

/datum/modular_computer_app_presets/ert
	name = "ert"
	display_name = "EmergencyResposeTeam"
	description = "Preset for the ERT Console."
	available = FALSE

/datum/modular_computer_app_presets/ert/return_install_programs()
	var/list/_prg_list = list(
		new /datum/computer_file/program/filemanager(),
		new /datum/computer_file/program/ntnetdownload(),
		new /datum/computer_file/program/camera_monitor/hacked(),
		new /datum/computer_file/program/comm(FALSE),
		new /datum/computer_file/program/suit_sensors(),
		new /datum/computer_file/program/alarm_monitor(),
		new /datum/computer_file/program/lighting_control(),
		new /datum/computer_file/program/aidiag(),
		new /datum/computer_file/program/records()
	)
	return _prg_list

/datum/modular_computer_app_presets/trashcompactor
	name = "trashcompactor"
	display_name = "Trash Compactor"
	description = "A preset for the Trash Compactor Wall Console."
	available = FALSE

/datum/modular_computer_app_presets/trashcompactor/return_install_programs()
	var/list/_prg_list = list(
		new /datum/computer_file/program/crushercontrol()
	)
	return _prg_list

/datum/modular_computer_app_presets/merchant
	name = "merchant"
	display_name = "Merchant"
	description = "A preset for the merchant console."
	available = FALSE

/datum/modular_computer_app_presets/merchant/return_install_programs()
	var/list/_prg_list = list(
		new /datum/computer_file/program/filemanager(),
		new /datum/computer_file/program/chatclient(),
		new /datum/computer_file/program/merchant()
	)
	return _prg_list

/datum/modular_computer_app_presets/ai
	name = "ai"
	display_name = "AI"
	description = "A preset for the AI consoles."
	available = FALSE

/datum/modular_computer_app_presets/ai/return_install_programs()
	return list(
		new /datum/computer_file/program/filemanager,
		new /datum/computer_file/program/ntnetdownload
	)
