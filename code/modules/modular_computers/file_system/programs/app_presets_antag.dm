
/datum/modular_computer_app_presets/command/teleporter/ninja
	name = "ninja_teleporter"
	display_name = "Offsite - Teleporter"
	description = "Contains the most common command programs and has a special teleporter control program loaded."
	available = FALSE

/datum/modular_computer_app_presets/command/teleporter/ninja/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		COMPUTER_APP_PRESET_SYSTEM,
		COMPUTER_APP_PRESET_HORIZON_CIVILIAN,
		new /datum/computer_file/program/comm(comp, FALSE),
		new /datum/computer_file/program/records/employment(comp),
		new /datum/computer_file/program/teleporter/ninja(comp)
	)
	return flatten_list(_prg_list)

/datum/modular_computer_app_presets/merc
	name = "merc"
	display_name = "Mercenary"
	description = "Preset for the Merc Console."
	available = FALSE

/datum/modular_computer_app_presets/merc/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		COMPUTER_APP_PRESET_SYSTEM,
		new /datum/computer_file/program/newsbrowser(comp),
		new /datum/computer_file/program/manifest(comp),
		new /datum/computer_file/program/camera_monitor/hacked(comp)
	)
	return flatten_list(_prg_list)

/datum/modular_computer_app_presets/ert
	name = "ert"
	display_name = "EmergencyResposeTeam"
	description = "Preset for the ERT Console."
	available = FALSE

/datum/modular_computer_app_presets/ert/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		COMPUTER_APP_PRESET_SYSTEM,
		new /datum/computer_file/program/camera_monitor/hacked(comp),
		new /datum/computer_file/program/comm(comp, FALSE),
		new /datum/computer_file/program/suit_sensors(comp),
		new /datum/computer_file/program/alarm_monitor/all(comp),
		new /datum/computer_file/program/lighting_control(comp),
		new /datum/computer_file/program/aidiag(comp),
		new /datum/computer_file/program/records(comp)
	)
	return flatten_list(_prg_list)
