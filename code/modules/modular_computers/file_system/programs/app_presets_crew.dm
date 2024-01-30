
/datum/modular_computer_app_presets/engineering
	name = "engineering"
	display_name = "Engineering"
	description = "Contains the most common engineering programs."
	available = TRUE

/datum/modular_computer_app_presets/engineering/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		COMPUTER_APP_PRESET_SYSTEM,
		COMPUTER_APP_PRESET_HORIZON_CIVILIAN,
		COMPUTER_APP_PRESET_HORIZON_ENGINEERING,
	)
	return flatten_list(_prg_list)

/datum/modular_computer_app_presets/engineering/atmos
	name = "atmos"
	display_name = "Engineering - Atmospherics"
	description = "Contains the most common engineering programs and atmospheric monitoring software."
	available = TRUE

/datum/modular_computer_app_presets/engineering/atmos/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		COMPUTER_APP_PRESET_SYSTEM,
		COMPUTER_APP_PRESET_HORIZON_CIVILIAN,
		COMPUTER_APP_PRESET_HORIZON_ENGINEERING,
		new /datum/computer_file/program/scanner/gas(comp)
	)
	return flatten_list(_prg_list)

/datum/modular_computer_app_presets/engineering/ce
	name = "engineering_head"
	display_name = "Engineering - CE"
	description = "Contains the most common engineering programs and command software."
	available = FALSE

/datum/modular_computer_app_presets/engineering/ce/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		COMPUTER_APP_PRESET_SYSTEM,
		COMPUTER_APP_PRESET_HORIZON_CIVILIAN,
		COMPUTER_APP_PRESET_HORIZON_ENGINEERING,
		new /datum/computer_file/program/scanner/gas(comp),
		new /datum/computer_file/program/comm(comp, FALSE),
		new /datum/computer_file/program/records/employment(comp),
	)
	return flatten_list(_prg_list)

/datum/modular_computer_app_presets/medical
	name = "medical"
	display_name = "Medical"
	description = "Contains the most common medical programs."
	available = TRUE

/datum/modular_computer_app_presets/medical/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		COMPUTER_APP_PRESET_SYSTEM,
		COMPUTER_APP_PRESET_HORIZON_CIVILIAN,
		COMPUTER_APP_PRESET_HORIZON_MEDICAL,
	)
	return flatten_list(_prg_list)

/datum/modular_computer_app_presets/medical/cmo
	name = "medical_head"
	display_name = "Medical - CMO"
	description = "Contains the most common medical programs and command software."
	available = FALSE

/datum/modular_computer_app_presets/medical/cmo/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		COMPUTER_APP_PRESET_SYSTEM,
		COMPUTER_APP_PRESET_HORIZON_CIVILIAN,
		COMPUTER_APP_PRESET_HORIZON_MEDICAL,
		new /datum/computer_file/program/comm(comp, FALSE),
		new /datum/computer_file/program/records/employment(comp),
		new /datum/computer_file/program/scanner/science(comp),
	)
	return flatten_list(_prg_list)

/datum/modular_computer_app_presets/research
	name = "research"
	display_name = "Research"
	description = "Contains the most common research programs."
	available = TRUE

/datum/modular_computer_app_presets/research/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		COMPUTER_APP_PRESET_SYSTEM,
		COMPUTER_APP_PRESET_HORIZON_CIVILIAN,
		COMPUTER_APP_PRESET_HORIZON_RESEARCH,
	)
	return flatten_list(_prg_list)

/datum/modular_computer_app_presets/research/rd
	name = "research_head"
	display_name = "Research - RD"
	description = "Contains the most common research programs and command software."
	available = FALSE

/datum/modular_computer_app_presets/research/rd/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		COMPUTER_APP_PRESET_SYSTEM,
		COMPUTER_APP_PRESET_HORIZON_CIVILIAN,
		COMPUTER_APP_PRESET_HORIZON_RESEARCH,
		new /datum/computer_file/program/comm(comp, FALSE),
		new /datum/computer_file/program/records/employment(comp),
	)
	return flatten_list(_prg_list)

/datum/modular_computer_app_presets/command
	name = "command"
	display_name = "Command"
	description = "Contains the most common command programs."
	available = TRUE

/datum/modular_computer_app_presets/command/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		COMPUTER_APP_PRESET_SYSTEM,
		COMPUTER_APP_PRESET_HORIZON_CIVILIAN,
		new /datum/computer_file/program/card_mod(comp),
		new /datum/computer_file/program/comm(comp, TRUE),
		new /datum/computer_file/program/docks(comp),
		new /datum/computer_file/program/away_manifest(comp),
		new /datum/computer_file/program/records/employment(comp),
	)
	return flatten_list(_prg_list)

/datum/modular_computer_app_presets/command/hop
	name = "command_hop"
	display_name = "Command - HoP"
	description = "Contains the most common command programs."
	available = FALSE

/datum/modular_computer_app_presets/command/hop/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		COMPUTER_APP_PRESET_SYSTEM,
		COMPUTER_APP_PRESET_HORIZON_CIVILIAN,
		new /datum/computer_file/program/civilian/cargocontrol(comp),
		new /datum/computer_file/program/card_mod(comp),
		new /datum/computer_file/program/comm(comp, FALSE),
		new /datum/computer_file/program/docks(comp),
		new /datum/computer_file/program/away_manifest(comp),
		new /datum/computer_file/program/records/employment(comp),
		new /datum/computer_file/program/records/security(comp),
	)
	return flatten_list(_prg_list)

/datum/modular_computer_app_presets/command/captain
	name = "captain"
	display_name = "Captain"
	description = "Contains the most important programs for the Captain."
	available = FALSE

/datum/modular_computer_app_presets/command/captain/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		COMPUTER_APP_PRESET_SYSTEM,
		COMPUTER_APP_PRESET_HORIZON_CIVILIAN,
		new /datum/computer_file/program/card_mod(comp),
		new /datum/computer_file/program/comm(comp, TRUE),
		new /datum/computer_file/program/docks(comp),
		new /datum/computer_file/program/away_manifest(comp),
		new /datum/computer_file/program/camera_monitor(comp),
		new /datum/computer_file/program/digitalwarrant(comp),
		new /datum/computer_file/program/civilian/cargocontrol(comp),
		new /datum/computer_file/program/alarm_monitor/all(comp),
		new /datum/computer_file/program/records/employment(comp),
		new /datum/computer_file/program/records/medical(comp),
		new /datum/computer_file/program/records/security(comp),
	)
	return flatten_list(_prg_list)

/datum/modular_computer_app_presets/security
	name = "security"
	display_name = "Security"
	description = "Contains the most common security programs."
	available = TRUE

/datum/modular_computer_app_presets/security/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		COMPUTER_APP_PRESET_SYSTEM,
		COMPUTER_APP_PRESET_HORIZON_CIVILIAN,
		COMPUTER_APP_PRESET_HORIZON_SECURITY,
	)
	return flatten_list(_prg_list)

/datum/modular_computer_app_presets/security/armory
	name = "security_arm"
	display_name = "Security - Armory"
	description = "Contains the most common security and armory programs."
	available = FALSE

/datum/modular_computer_app_presets/security/armory/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		COMPUTER_APP_PRESET_SYSTEM,
		COMPUTER_APP_PRESET_HORIZON_CIVILIAN,
		COMPUTER_APP_PRESET_HORIZON_SECURITY,
		new /datum/computer_file/program/implant_tracker(comp),
		new /datum/computer_file/program/comm(comp),
	)
	return flatten_list(_prg_list)

/datum/modular_computer_app_presets/security/investigations
	name = "security_inv"
	display_name = "Security - Investigations"
	description = "Contains the most common security and forensics programs."
	available = TRUE

/datum/modular_computer_app_presets/security/investigations/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		COMPUTER_APP_PRESET_SYSTEM,
		COMPUTER_APP_PRESET_HORIZON_CIVILIAN,
		new /datum/computer_file/program/alarm_monitor/security(comp),
		new /datum/computer_file/program/camera_monitor(comp),
		new /datum/computer_file/program/digitalwarrant(comp),
		new /datum/computer_file/program/records/security(comp),
		new /datum/computer_file/program/records/medical(comp),
	)
	return flatten_list(_prg_list)

/datum/modular_computer_app_presets/security/hos
	name = "security_head"
	display_name = "Security - HoS"
	description = "Contains the most common security programs and command software."
	available = FALSE

/datum/modular_computer_app_presets/security/hos/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		COMPUTER_APP_PRESET_SYSTEM,
		COMPUTER_APP_PRESET_HORIZON_CIVILIAN,
		COMPUTER_APP_PRESET_HORIZON_SECURITY,
		new /datum/computer_file/program/comm(comp, FALSE),
		new /datum/computer_file/program/records/employment(comp),
	)
	return flatten_list(_prg_list)

/datum/modular_computer_app_presets/civilian
	name = "service"
	display_name = "Service"
	description = "Contains the most common service programs."
	available = TRUE

/datum/modular_computer_app_presets/civilian/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		COMPUTER_APP_PRESET_SYSTEM,
		COMPUTER_APP_PRESET_HORIZON_CIVILIAN,
		new /datum/computer_file/program/game/arcade(comp),
		new /datum/computer_file/program/cooking_codex(comp),
	)
	return flatten_list(_prg_list)

/datum/modular_computer_app_presets/civilian/janitor
	name = "janitor"
	display_name = "Janitor"
	description = "Contains programs for janitorial service."
	available = TRUE

/datum/modular_computer_app_presets/civilian/janitor/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		COMPUTER_APP_PRESET_SYSTEM,
		COMPUTER_APP_PRESET_HORIZON_CIVILIAN,
		new /datum/computer_file/program/civilian/janitor(comp),
		new /datum/computer_file/program/game/arcade(comp),
	)
	return flatten_list(_prg_list)

/datum/modular_computer_app_presets/supply
	name = "supply"
	display_name = "Supply"
	description = "Contains the most common cargo programs."
	available = TRUE

/datum/modular_computer_app_presets/supply/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		COMPUTER_APP_PRESET_SYSTEM,
		COMPUTER_APP_PRESET_HORIZON_CIVILIAN,
		new /datum/computer_file/program/civilian/cargocontrol(comp),
		new /datum/computer_file/program/civilian/cargodelivery(comp),
		new /datum/computer_file/program/away_manifest(comp),
	)
	return flatten_list(_prg_list)

/datum/modular_computer_app_presets/supply/om
	name = "operations manager"
	display_name = "Operations Manager"
	description = "Contains the most common cargo programs as well as the OM's ones."
	available = FALSE

/datum/modular_computer_app_presets/supply/om/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		COMPUTER_APP_PRESET_SYSTEM,
		COMPUTER_APP_PRESET_HORIZON_CIVILIAN,
		new /datum/computer_file/program/civilian/cargocontrol(comp),
		new /datum/computer_file/program/civilian/cargodelivery(comp),
		new /datum/computer_file/program/away_manifest(comp),
		new /datum/computer_file/program/comm(comp, FALSE),
		new /datum/computer_file/program/docks(comp),
	)
	return flatten_list(_prg_list)

/datum/modular_computer_app_presets/supply/machinist
	name = "operations_machinist"
	display_name = "Operations - Machinist"
	description = "Contains the most common supply programs and medical record software."
	available = TRUE

/datum/modular_computer_app_presets/supply/machinist/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		COMPUTER_APP_PRESET_SYSTEM,
		COMPUTER_APP_PRESET_HORIZON_CIVILIAN,
		new /datum/computer_file/program/aidiag(comp),
		new /datum/computer_file/program/records/medical(comp),
		new /datum/computer_file/program/scanner/science(comp),
		new /datum/computer_file/program/scanner/gas(comp),
	)
	return flatten_list(_prg_list)

/datum/modular_computer_app_presets/representative
	name = "representative"
	display_name = "Representative"
	description = "Contains software intended for representatives."
	available = FALSE

/datum/modular_computer_app_presets/representative/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		COMPUTER_APP_PRESET_SYSTEM,
		COMPUTER_APP_PRESET_HORIZON_CIVILIAN,
		new /datum/computer_file/program/records/employment(comp),
	)
	return flatten_list(_prg_list)
