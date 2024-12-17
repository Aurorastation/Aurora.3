ABSTRACT_TYPE(/datum/modular_computer_app_presets)
	var/name = "default_preset"
	var/display_name = "default preset"
	var/description = "Description of the preset."
	var/available = FALSE

	/**
	 * A `/list` of `/datum/computer_file/program` _typepaths_ that constitute this preset
	 *
	 * Is instantiated and returned by `return_install_programs()` on the computers that request it
	 *
	 * **Do not set this directly**, add or remove tye typepaths to it in New() **only**
	 */
	var/list/program_list = list()

/datum/modular_computer_app_presets/proc/return_install_programs(obj/item/modular_computer/comp)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_CALL_PARENT(TRUE)

	. = list()

	for(var/program_typepath in program_list)
		. += new program_typepath(comp)


/datum/modular_computer_app_presets/all
	name = "all"
	display_name = "All Programs"
	description = "Contains all programs."
	available = FALSE

/datum/modular_computer_app_presets/all/return_install_programs(obj/item/modular_computer/comp)
	SHOULD_CALL_PARENT(FALSE) //Special snowflake case

	. = list()
	for(var/F in subtypesof(/datum/computer_file/program))
		var/datum/computer_file/program/prog = new F(comp)
		. += prog

#define COMPUTER_APP_PRESET_SYSTEM list(/datum/computer_file/program/ntnetdownload, /datum/computer_file/program/filemanager)

#define COMPUTER_APP_PRESET_HORIZON_CIVILIAN list(\
	/datum/computer_file/program/newsbrowser,\
	/datum/computer_file/program/manifest,\
	/datum/computer_file/program/chat_client,\
	/datum/computer_file/program/civilian/cargoorder,\
	/datum/computer_file/program/map,\
)

#define COMPUTER_APP_PRESET_HORIZON_ENGINEERING list(\
	/datum/computer_file/program/power_monitor,\
	/datum/computer_file/program/alarm_monitor/engineering,\
	/datum/computer_file/program/atmos_control,\
	/datum/computer_file/program/rcon_console,\
	/datum/computer_file/program/camera_monitor,\
	/datum/computer_file/program/lighting_control,\
)

#define COMPUTER_APP_PRESET_HORIZON_MEDICAL list(\
	/datum/computer_file/program/suit_sensors,\
	/datum/computer_file/program/records/medical,\
	/datum/computer_file/program/chemistry_codex,\
	/datum/computer_file/program/scanner/medical,\
	)

#define COMPUTER_APP_PRESET_HORIZON_RESEARCH list(\
	/datum/computer_file/program/ntnetmonitor,\
	/datum/computer_file/program/aidiag,\
	/datum/computer_file/program/chemistry_codex,\
	/datum/computer_file/program/scanner/science,\
	/datum/computer_file/program/scanner/gas,\
	/datum/computer_file/program/away_manifest,\
)

#define COMPUTER_APP_PRESET_HORIZON_SECURITY list(\
	/datum/computer_file/program/alarm_monitor/security,\
	/datum/computer_file/program/camera_monitor,\
	/datum/computer_file/program/digitalwarrant,\
	/datum/computer_file/program/records/security,\
	/datum/computer_file/program/guntracker,\
)
