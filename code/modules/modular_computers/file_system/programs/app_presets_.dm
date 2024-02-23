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
	return flatten_list(_prg_list)

#define COMPUTER_APP_PRESET_SYSTEM list(\
	new /datum/computer_file/program/ntnetdownload(comp),\
	new /datum/computer_file/program/filemanager(comp),\
)

#define COMPUTER_APP_PRESET_HORIZON_CIVILIAN list(\
	new /datum/computer_file/program/newsbrowser(comp),\
	new /datum/computer_file/program/manifest(comp),\
	new /datum/computer_file/program/chat_client(comp),\
	new /datum/computer_file/program/civilian/cargoorder(comp),\
	new /datum/computer_file/program/map(comp),\
)

#define COMPUTER_APP_PRESET_HORIZON_ENGINEERING list(\
	new /datum/computer_file/program/power_monitor(comp),\
	new /datum/computer_file/program/alarm_monitor/engineering(comp),\
	new /datum/computer_file/program/atmos_control(comp),\
	new /datum/computer_file/program/rcon_console(comp),\
	new /datum/computer_file/program/camera_monitor(comp),\
	new /datum/computer_file/program/lighting_control(comp)\
)

#define COMPUTER_APP_PRESET_HORIZON_MEDICAL list(\
	new /datum/computer_file/program/suit_sensors(comp),\
	new /datum/computer_file/program/records/medical(comp),\
	new /datum/computer_file/program/chemistry_codex(comp),\
	new /datum/computer_file/program/scanner/medical(comp),\
)

#define COMPUTER_APP_PRESET_HORIZON_RESEARCH list(\
	new /datum/computer_file/program/ntnetmonitor(comp),\
	new /datum/computer_file/program/aidiag(comp),\
	new /datum/computer_file/program/chemistry_codex(comp),\
	new /datum/computer_file/program/scanner/science(comp),\
	new /datum/computer_file/program/scanner/gas(comp),\
	new /datum/computer_file/program/away_manifest(comp),\
)

#define COMPUTER_APP_PRESET_HORIZON_SECURITY list(\
	new /datum/computer_file/program/alarm_monitor/security(comp),\
	new /datum/computer_file/program/camera_monitor(comp),\
	new /datum/computer_file/program/digitalwarrant(comp),\
	new /datum/computer_file/program/records/security(comp),\
	new /datum/computer_file/program/guntracker(comp),\
)
