/datum/modular_computer_app_presets
	var/name = "default_preset"
	var/display_name = "default preset"
	var/description = "Description of the preset."
	var/available = FALSE

/datum/modular_computer_app_presets/proc/return_install_programs(var/obj/item/modular_computer/comp)
	return list()

/datum/modular_computer_app_presets/all
	name = "all"
	display_name = "All Programs"
	description = "Contains all programs."
	available = FALSE

/datum/modular_computer_app_presets/all/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list()
	for(var/F in typesof(/datum/computer_file/program))
		var/datum/computer_file/program/prog = new F(comp)
		_prg_list += prog
	return _prg_list

/datum/modular_computer_app_presets/engineering
	name = "engineering"
	display_name = "Engineering"
	description = "Contains the most common engineering programs."
	available = TRUE

/datum/modular_computer_app_presets/engineering/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		new /datum/computer_file/program/ntnetdownload(comp),
		new /datum/computer_file/program/filemanager(comp),
		new /datum/computer_file/program/newsbrowser(comp),
		new /datum/computer_file/program/manifest(comp),
		new /datum/computer_file/program/chat_client(comp),
		new /datum/computer_file/program/civilian/cargoorder(comp),
		new /datum/computer_file/program/power_monitor(comp),
		new /datum/computer_file/program/alarm_monitor(comp),
		new /datum/computer_file/program/atmos_control(comp),
		new /datum/computer_file/program/rcon_console(comp),
		new /datum/computer_file/program/camera_monitor(comp),
		new /datum/computer_file/program/lighting_control(comp)
	)
	return _prg_list

/datum/modular_computer_app_presets/engineering/atmos
	name = "atmos"
	display_name = "Engineering - Atmospherics"
	description = "Contains the most common engineering programs and atmospheric monitoring software."
	available = TRUE

/datum/modular_computer_app_presets/engineering/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		new /datum/computer_file/program/ntnetdownload(comp),
		new /datum/computer_file/program/filemanager(comp),
		new /datum/computer_file/program/newsbrowser(comp),
		new /datum/computer_file/program/manifest(comp),
		new /datum/computer_file/program/chat_client(comp),
		new /datum/computer_file/program/civilian/cargoorder(comp),
		new /datum/computer_file/program/power_monitor(comp),
		new /datum/computer_file/program/alarm_monitor(comp),
		new /datum/computer_file/program/atmos_control(comp),
		new /datum/computer_file/program/rcon_console(comp),
		new /datum/computer_file/program/camera_monitor(comp),
		new /datum/computer_file/program/lighting_control(comp),
		new /datum/computer_file/program/scanner/gas(comp)
	)
	return _prg_list

/datum/modular_computer_app_presets/engineering/ce
	name = "engineering_head"
	display_name = "Engineering - CE"
	description = "Contains the most common engineering programs and command software."
	available = FALSE

/datum/modular_computer_app_presets/engineering/ce/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		new /datum/computer_file/program/ntnetdownload(comp),
		new /datum/computer_file/program/filemanager(comp),
		new /datum/computer_file/program/newsbrowser(comp),
		new /datum/computer_file/program/manifest(comp),
		new /datum/computer_file/program/chat_client(comp),
		new /datum/computer_file/program/civilian/cargoorder(comp),
		new /datum/computer_file/program/comm(comp, FALSE),
		new /datum/computer_file/program/game/sudoku(comp),
		new /datum/computer_file/program/power_monitor(comp),
		new /datum/computer_file/program/alarm_monitor(comp),
		new /datum/computer_file/program/atmos_control(comp),
		new /datum/computer_file/program/rcon_console(comp),
		new /datum/computer_file/program/camera_monitor(comp),
		new /datum/computer_file/program/lighting_control(comp),
		new /datum/computer_file/program/records/employment(comp),
		new /datum/computer_file/program/scanner/gas(comp)
	)
	return _prg_list

/datum/modular_computer_app_presets/medical
	name = "medical"
	display_name = "Medical"
	description = "Contains the most common medical programs."
	available = TRUE

/datum/modular_computer_app_presets/medical/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		new /datum/computer_file/program/ntnetdownload(comp),
		new /datum/computer_file/program/filemanager(comp),
		new /datum/computer_file/program/newsbrowser(comp),
		new /datum/computer_file/program/manifest(comp),
		new /datum/computer_file/program/chat_client(comp),
		new /datum/computer_file/program/civilian/cargoorder(comp),
		new /datum/computer_file/program/suit_sensors(comp),
		new /datum/computer_file/program/records/medical(comp),
		new /datum/computer_file/program/chemistry_codex(comp),
		new /datum/computer_file/program/scanner/medical(comp)
	)
	return _prg_list

/datum/modular_computer_app_presets/medical/cmo
	name = "medical_head"
	display_name = "Medical - CMO"
	description = "Contains the most common medical programs and command software."
	available = FALSE

/datum/modular_computer_app_presets/medical/cmo/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		new /datum/computer_file/program/ntnetdownload(comp),
		new /datum/computer_file/program/filemanager(comp),
		new /datum/computer_file/program/newsbrowser(comp),
		new /datum/computer_file/program/manifest(comp),
		new /datum/computer_file/program/chat_client(comp),
		new /datum/computer_file/program/civilian/cargoorder(comp),
		new /datum/computer_file/program/comm(comp, FALSE),
		new /datum/computer_file/program/suit_sensors(comp),
		new /datum/computer_file/program/records/employment(comp),
		new /datum/computer_file/program/records/medical(comp),
		new /datum/computer_file/program/chemistry_codex(comp),
		new /datum/computer_file/program/scanner/medical(comp),
		new /datum/computer_file/program/scanner/science(comp)
	)
	return _prg_list

/datum/modular_computer_app_presets/research
	name = "research"
	display_name = "Research"
	description = "Contains the most common research programs."
	available = TRUE

/datum/modular_computer_app_presets/research/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		new /datum/computer_file/program/ntnetdownload(comp),
		new /datum/computer_file/program/newsbrowser(comp),
		new /datum/computer_file/program/manifest(comp),
		new /datum/computer_file/program/filemanager(comp),
		new /datum/computer_file/program/chat_client(comp),
		new /datum/computer_file/program/civilian/cargoorder(comp),
		new /datum/computer_file/program/ntnetmonitor(comp),
		new /datum/computer_file/program/aidiag(comp),
		new /datum/computer_file/program/chemistry_codex(comp),
		new /datum/computer_file/program/scanner/science(comp),
		new /datum/computer_file/program/scanner/gas(comp)
	)
	return _prg_list

/datum/modular_computer_app_presets/research/rd
	name = "research_head"
	display_name = "Research - RD"
	description = "Contains the most common research programs and command software."
	available = FALSE

/datum/modular_computer_app_presets/research/rd/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		new /datum/computer_file/program/ntnetdownload(comp),
		new /datum/computer_file/program/filemanager(comp),
		new /datum/computer_file/program/newsbrowser(comp),
		new /datum/computer_file/program/manifest(comp),
		new /datum/computer_file/program/chat_client(comp),
		new /datum/computer_file/program/civilian/cargoorder(comp),
		new /datum/computer_file/program/comm(comp, FALSE),
		new /datum/computer_file/program/ntnetmonitor(comp),
		new /datum/computer_file/program/records/employment(comp),
		new /datum/computer_file/program/chemistry_codex(comp),
		new /datum/computer_file/program/scanner/science(comp),
		new /datum/computer_file/program/scanner/gas(comp)
	)
	return _prg_list

/datum/modular_computer_app_presets/command
	name = "command"
	display_name = "Command"
	description = "Contains the most common command programs."
	available = TRUE

/datum/modular_computer_app_presets/command/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		new /datum/computer_file/program/ntnetdownload(comp),
		new /datum/computer_file/program/filemanager(comp),
		new /datum/computer_file/program/newsbrowser(comp),
		new /datum/computer_file/program/manifest(comp),
		new /datum/computer_file/program/chat_client(comp),
		new /datum/computer_file/program/civilian/cargoorder(comp),
		new /datum/computer_file/program/card_mod(comp),
		new /datum/computer_file/program/comm(comp, TRUE),
		new /datum/computer_file/program/records/employment(comp)
	)
	return _prg_list

/datum/modular_computer_app_presets/command/teleporter
	name = "command_teleporter"
	display_name = "Command - Teleporter"
	description = "Contains the most common command programs and has a special teleporter control program loaded."
	available = FALSE

/datum/modular_computer_app_presets/command/teleporter/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		new /datum/computer_file/program/ntnetdownload(comp),
		new /datum/computer_file/program/filemanager(comp),
		new /datum/computer_file/program/newsbrowser(comp),
		new /datum/computer_file/program/manifest(comp),
		new /datum/computer_file/program/chat_client(comp),
		new /datum/computer_file/program/civilian/cargoorder(comp),
		new /datum/computer_file/program/comm(comp, FALSE),
		new /datum/computer_file/program/records/employment(comp),
		new /datum/computer_file/program/teleporter(comp)
	)
	return _prg_list

/datum/modular_computer_app_presets/command/teleporter/ninja
	name = "ninja_teleporter"
	display_name = "Offsite - Teleporter"
	description = "Contains the most common command programs and has a special teleporter control program loaded."
	available = FALSE

/datum/modular_computer_app_presets/command/teleporter/ninja/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		new /datum/computer_file/program/ntnetdownload(comp),
		new /datum/computer_file/program/filemanager(comp),
		new /datum/computer_file/program/newsbrowser(comp),
		new /datum/computer_file/program/manifest(comp),
		new /datum/computer_file/program/chat_client(comp),
		new /datum/computer_file/program/civilian/cargoorder(comp),
		new /datum/computer_file/program/comm(comp, FALSE),
		new /datum/computer_file/program/records/employment(comp),
		new /datum/computer_file/program/teleporter/ninja(comp)
	)
	return _prg_list

/datum/modular_computer_app_presets/command/hop
	name = "command_hop"
	display_name = "Command - HoP"
	description = "Contains the most common command programs."
	available = FALSE

/datum/modular_computer_app_presets/command/hop/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		new /datum/computer_file/program/ntnetdownload(comp),
		new /datum/computer_file/program/filemanager(comp),
		new /datum/computer_file/program/newsbrowser(comp),
		new /datum/computer_file/program/manifest(comp),
		new /datum/computer_file/program/chat_client(comp),
		new /datum/computer_file/program/civilian/cargoorder(comp),
		new /datum/computer_file/program/civilian/cargocontrol(comp),
		new /datum/computer_file/program/card_mod(comp),
		new /datum/computer_file/program/comm(comp, FALSE),
		new /datum/computer_file/program/records/employment(comp),
		new /datum/computer_file/program/records/security(comp)
	)
	return _prg_list

/datum/modular_computer_app_presets/command/captain
	name = "captain"
	display_name = "Captain"
	description = "Contains the most important programs for the Captain."
	available = FALSE

/datum/modular_computer_app_presets/command/captain/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		new /datum/computer_file/program/ntnetdownload(comp),
		new /datum/computer_file/program/filemanager(comp),
		new /datum/computer_file/program/newsbrowser(comp),
		new /datum/computer_file/program/manifest(comp),
		new /datum/computer_file/program/chat_client(comp),
		new /datum/computer_file/program/card_mod(comp),
		new /datum/computer_file/program/comm(comp, TRUE),
		new /datum/computer_file/program/camera_monitor(comp),
		new /datum/computer_file/program/digitalwarrant(comp),
		new /datum/computer_file/program/penal_mechs(comp),
		new /datum/computer_file/program/civilian/cargocontrol(comp),
		new /datum/computer_file/program/civilian/cargoorder(comp),
		new /datum/computer_file/program/alarm_monitor(comp),
		new /datum/computer_file/program/records/employment(comp),
		new /datum/computer_file/program/records/medical(comp),
		new /datum/computer_file/program/records/security(comp)
	)
	return _prg_list

/datum/modular_computer_app_presets/command/account
	name = "command_accounting"
	display_name = "Command - Accounting"
	description = "Contains all the programs you would need to become a god-tier accountant."
	available = FALSE

/datum/modular_computer_app_presets/command/account/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		new /datum/computer_file/program/ntnetdownload(comp),
		new /datum/computer_file/program/filemanager(comp),
		new /datum/computer_file/program/newsbrowser(comp),
		new /datum/computer_file/program/manifest(comp),
		new /datum/computer_file/program/civilian/cargoorder(comp),
		new /datum/computer_file/program/civilian/cargocontrol(comp),
		new /datum/computer_file/program/records/employment(comp),
		new /datum/computer_file/program/account_db(comp)
	)
	return _prg_list

/datum/modular_computer_app_presets/command/account/centcomm/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		new /datum/computer_file/program/ntnetdownload(comp),
		new /datum/computer_file/program/filemanager(comp),
		new /datum/computer_file/program/newsbrowser(comp),
		new /datum/computer_file/program/manifest(comp),
		new /datum/computer_file/program/civilian/cargoorder(comp),
		new /datum/computer_file/program/civilian/cargocontrol(comp),
		new /datum/computer_file/program/records/employment(comp),
		new /datum/computer_file/program/account_db(comp, TRUE)
	)
	return _prg_list

/datum/modular_computer_app_presets/security
	name = "security"
	display_name = "Security"
	description = "Contains the most common security programs."
	available = TRUE

/datum/modular_computer_app_presets/security/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		new /datum/computer_file/program/ntnetdownload(comp),
		new /datum/computer_file/program/nttransfer(comp),
		new /datum/computer_file/program/newsbrowser(comp),
		new /datum/computer_file/program/manifest(comp),
		new /datum/computer_file/program/filemanager(comp),
		new /datum/computer_file/program/chat_client(comp),
		new /datum/computer_file/program/civilian/cargoorder(comp),
		new /datum/computer_file/program/camera_monitor(comp),
		new /datum/computer_file/program/digitalwarrant(comp),
		new /datum/computer_file/program/penal_mechs(comp),
		new /datum/computer_file/program/records/security(comp),
		new /datum/computer_file/program/guntracker(comp)
	)
	return _prg_list

/datum/modular_computer_app_presets/security/armory
	name = "security_arm"
	display_name = "Security - Armory"
	description = "Contains the most common security and armory programs."
	available = FALSE

/datum/modular_computer_app_presets/security/armory/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		new /datum/computer_file/program/nttransfer(comp),
		new /datum/computer_file/program/newsbrowser(comp),
		new /datum/computer_file/program/manifest(comp),
		new /datum/computer_file/program/filemanager(comp),
		new /datum/computer_file/program/chat_client(comp),
		new /datum/computer_file/program/civilian/cargoorder(comp),
		new /datum/computer_file/program/camera_monitor(comp),
		new /datum/computer_file/program/comm(comp),
		new /datum/computer_file/program/digitalwarrant(comp),
		new /datum/computer_file/program/penal_mechs(comp),
		new /datum/computer_file/program/records/security(comp),
		new /datum/computer_file/program/guntracker(comp),
		new /datum/computer_file/program/implant_tracker(comp)
	)
	return _prg_list

/datum/modular_computer_app_presets/security/investigations
	name = "security_inv"
	display_name = "Security - Investigations"
	description = "Contains the most common security and forensics programs."
	available = TRUE

/datum/modular_computer_app_presets/security/investigations/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		new /datum/computer_file/program/ntnetdownload(comp),
		new /datum/computer_file/program/nttransfer(comp),
		new /datum/computer_file/program/newsbrowser(comp),
		new /datum/computer_file/program/manifest(comp),
		new /datum/computer_file/program/filemanager(comp),
		new /datum/computer_file/program/chat_client(comp),
		new /datum/computer_file/program/camera_monitor(comp),
		new /datum/computer_file/program/digitalwarrant(comp),
		new /datum/computer_file/program/records/security(comp),
		new /datum/computer_file/program/records/medical(comp)
	)
	return _prg_list

/datum/modular_computer_app_presets/security/hos
	name = "security_head"
	display_name = "Security - HoS"
	description = "Contains the most common security programs and command software."
	available = FALSE

/datum/modular_computer_app_presets/security/hos/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		new /datum/computer_file/program/ntnetdownload(comp),
		new /datum/computer_file/program/nttransfer(comp),
		new /datum/computer_file/program/newsbrowser(comp),
		new /datum/computer_file/program/manifest(comp),
		new /datum/computer_file/program/filemanager(comp),
		new /datum/computer_file/program/chat_client(comp),
		new /datum/computer_file/program/civilian/cargoorder(comp),
		new /datum/computer_file/program/comm(comp, FALSE),
		new /datum/computer_file/program/camera_monitor(comp),
		new /datum/computer_file/program/digitalwarrant(comp),
		new /datum/computer_file/program/penal_mechs(comp),
		new /datum/computer_file/program/records/security(comp),
		new /datum/computer_file/program/records/employment(comp)
	)
	return _prg_list

/datum/modular_computer_app_presets/civilian
	name = "service"
	display_name = "Service"
	description = "Contains the most common service programs."
	available = TRUE

/datum/modular_computer_app_presets/civilian/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		new /datum/computer_file/program/ntnetdownload(comp),
		new /datum/computer_file/program/filemanager(comp),
		new /datum/computer_file/program/newsbrowser(comp),
		new /datum/computer_file/program/manifest(comp),
		new /datum/computer_file/program/chat_client(comp),
		new /datum/computer_file/program/civilian/cargoorder(comp),
		new /datum/computer_file/program/game/arcade(comp),
		new /datum/computer_file/program/game/sudoku(comp)
	)
	return _prg_list

/datum/modular_computer_app_presets/civilian/janitor
	name = "janitor"
	display_name = "Janitor"
	description = "Contains programs for janitorial service."
	available = TRUE

/datum/modular_computer_app_presets/civilian/janitor/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		new /datum/computer_file/program/ntnetdownload(comp),
		new /datum/computer_file/program/filemanager(comp),
		new /datum/computer_file/program/newsbrowser(comp),
		new /datum/computer_file/program/manifest(comp),
		new /datum/computer_file/program/chat_client(comp),
		new /datum/computer_file/program/civilian/cargoorder(comp),
		new /datum/computer_file/program/civilian/janitor(comp),
		new /datum/computer_file/program/game/arcade(comp),
		new /datum/computer_file/program/game/sudoku(comp)
	)
	return _prg_list

/datum/modular_computer_app_presets/supply
	name = "supply"
	display_name = "Supply"
	description = "Contains the most common cargo programs."
	available = TRUE

/datum/modular_computer_app_presets/supply/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		new /datum/computer_file/program/ntnetdownload(comp),
		new /datum/computer_file/program/filemanager(comp),
		new /datum/computer_file/program/newsbrowser(comp),
		new /datum/computer_file/program/manifest(comp),
		new /datum/computer_file/program/chat_client(comp),
		new /datum/computer_file/program/civilian/cargocontrol(comp),
		new /datum/computer_file/program/civilian/cargoorder(comp),
		new /datum/computer_file/program/civilian/cargodelivery(comp)
	)
	return _prg_list

/datum/modular_computer_app_presets/supply/om
	name = "operations manager"
	display_name = "Operations Manager"
	description = "Contains the most common cargo programs as well as the OM's ones."
	available = FALSE

/datum/modular_computer_app_presets/supply/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		new /datum/computer_file/program/ntnetdownload(comp),
		new /datum/computer_file/program/filemanager(comp),
		new /datum/computer_file/program/newsbrowser(comp),
		new /datum/computer_file/program/manifest(comp),
		new /datum/computer_file/program/chat_client(comp),
		new /datum/computer_file/program/civilian/cargocontrol(comp),
		new /datum/computer_file/program/civilian/cargoorder(comp),
		new /datum/computer_file/program/civilian/cargodelivery(comp),
		new /datum/computer_file/program/comm(comp, FALSE)
	)
	return _prg_list

/datum/modular_computer_app_presets/cargo_delivery
	name = "cargo_delivery"
	display_name = "Cargo Delivery"
	description = "Contains the Delivery App."
	available = FALSE

/datum/modular_computer_app_presets/cargo_delivery/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		new /datum/computer_file/program/ntnetdownload(comp),
		new /datum/computer_file/program/filemanager(comp),
		new /datum/computer_file/program/newsbrowser(comp),
		new /datum/computer_file/program/manifest(comp),
		new /datum/computer_file/program/chat_client(comp),
		new /datum/computer_file/program/civilian/cargodelivery(comp)
	)
	return _prg_list

/datum/modular_computer_app_presets/supply/machinist
	name = "operations_machinist"
	display_name = "Operations - Machinist"
	description = "Contains the most common supply programs and medical record software."
	available = TRUE

/datum/modular_computer_app_presets/supply/machinist/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		new /datum/computer_file/program/ntnetdownload(comp),
		new /datum/computer_file/program/newsbrowser(comp),
		new /datum/computer_file/program/manifest(comp),
		new /datum/computer_file/program/filemanager(comp),
		new /datum/computer_file/program/chat_client(comp),
		new /datum/computer_file/program/civilian/cargoorder(comp),
		new /datum/computer_file/program/aidiag(comp),
		new /datum/computer_file/program/records/medical(comp),
		new /datum/computer_file/program/scanner/science(comp),
		new /datum/computer_file/program/scanner/gas(comp)
	)
	return _prg_list

/datum/modular_computer_app_presets/representative
	name = "representative"
	display_name = "Representative"
	description = "Contains software intended for representatives."
	available = FALSE

/datum/modular_computer_app_presets/representative/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		new /datum/computer_file/program/ntnetdownload(comp),
		new /datum/computer_file/program/filemanager(comp),
		new /datum/computer_file/program/newsbrowser(comp),
		new /datum/computer_file/program/manifest(comp),
		new /datum/computer_file/program/chat_client(comp),
		new /datum/computer_file/program/game/sudoku(comp),
		new /datum/computer_file/program/civilian/cargoorder(comp),
		new /datum/computer_file/program/records/employment(comp)
	)
	return _prg_list

/datum/modular_computer_app_presets/wall_generic
	name = "wallgeneric"
	display_name = "Wall - Generic"
	description = "A generic preset for the wall console."
	available = FALSE

/datum/modular_computer_app_presets/wall_generic/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		new /datum/computer_file/program/filemanager(comp),
		new /datum/computer_file/program/newsbrowser(comp),
		new /datum/computer_file/program/manifest(comp),
		new /datum/computer_file/program/chat_client(comp),
		new /datum/computer_file/program/civilian/cargoorder(comp),
		new /datum/computer_file/program/camera_monitor(comp),
		new /datum/computer_file/program/alarm_monitor(comp)
	)
	return _prg_list

/datum/modular_computer_app_presets/merc
	name = "merc"
	display_name = "Mercenary"
	description = "Preset for the Merc Console."
	available = FALSE

/datum/modular_computer_app_presets/merc/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		new /datum/computer_file/program/ntnetdownload(comp),
		new /datum/computer_file/program/filemanager(comp),
		new /datum/computer_file/program/newsbrowser(comp),
		new /datum/computer_file/program/manifest(comp),
		new /datum/computer_file/program/nttransfer(comp),
		new /datum/computer_file/program/camera_monitor/hacked(comp),
		new /datum/computer_file/program/signaler(comp)
	)
	return _prg_list

/datum/modular_computer_app_presets/ert
	name = "ert"
	display_name = "EmergencyResposeTeam"
	description = "Preset for the ERT Console."
	available = FALSE

/datum/modular_computer_app_presets/ert/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		new /datum/computer_file/program/filemanager(comp),
		new /datum/computer_file/program/ntnetdownload(comp),
		new /datum/computer_file/program/camera_monitor/hacked(comp),
		new /datum/computer_file/program/comm(comp, FALSE),
		new /datum/computer_file/program/suit_sensors(comp),
		new /datum/computer_file/program/alarm_monitor(comp),
		new /datum/computer_file/program/lighting_control(comp),
		new /datum/computer_file/program/aidiag(comp),
		new /datum/computer_file/program/records(comp)
	)
	return _prg_list

/datum/modular_computer_app_presets/trashcompactor
	name = "trashcompactor"
	display_name = "Trash Compactor"
	description = "A preset for the Trash Compactor Wall Console."
	available = FALSE

/datum/modular_computer_app_presets/trashcompactor/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		new /datum/computer_file/program/crushercontrol(comp)
	)
	return _prg_list

/datum/modular_computer_app_presets/merchant
	name = "merchant"
	display_name = "Merchant"
	description = "A preset for the merchant console."
	available = FALSE

/datum/modular_computer_app_presets/merchant/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		new /datum/computer_file/program/filemanager(comp),
		new /datum/computer_file/program/manifest(comp),
		new /datum/computer_file/program/newsbrowser(comp),
		new /datum/computer_file/program/chat_client(comp),
		new /datum/computer_file/program/merchant(comp)
	)
	return _prg_list

/datum/modular_computer_app_presets/merchant/nka/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		new /datum/computer_file/program/filemanager(comp),
		new /datum/computer_file/program/manifest(comp),
		new /datum/computer_file/program/newsbrowser(comp),
		new /datum/computer_file/program/chat_client(comp),
		new /datum/computer_file/program/merchant/nka(comp)
	)
	return _prg_list

/datum/modular_computer_app_presets/merchant/guild/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		new /datum/computer_file/program/filemanager(comp),
		new /datum/computer_file/program/manifest(comp),
		new /datum/computer_file/program/newsbrowser(comp),
		new /datum/computer_file/program/chat_client(comp),
		new /datum/computer_file/program/merchant/guild(comp)
	)
	return _prg_list

/datum/modular_computer_app_presets/ai
	name = "ai"
	display_name = "AI"
	description = "A preset for the AI consoles."
	available = FALSE

/datum/modular_computer_app_presets/ai/return_install_programs(obj/item/modular_computer/comp)
	return list(
		new /datum/computer_file/program/filemanager(comp),
		new /datum/computer_file/program/ntnetdownload(comp)
	)
