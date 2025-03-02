
/datum/modular_computer_app_presets/command/teleporter/ninja
	name = "ninja_teleporter"
	display_name = "Offsite - Teleporter"
	description = "Contains the most common command programs and has a special teleporter control program loaded."
	available = FALSE

/datum/modular_computer_app_presets/command/teleporter/ninja/New()
	. = ..()
	program_list -= /datum/computer_file/program/teleporter //Remove the default one since ninjas have a special one
	program_list += /datum/computer_file/program/teleporter/ninja


/datum/modular_computer_app_presets/merc
	name = "merc"
	display_name = "Mercenary"
	description = "Preset for the Merc Console."
	available = FALSE

/datum/modular_computer_app_presets/merc/New()
	. = ..()
	program_list += COMPUTER_APP_PRESET_SYSTEM
	program_list += list(/datum/computer_file/program/newsbrowser,
						/datum/computer_file/program/manifest,
						/datum/computer_file/program/camera_monitor/hacked
						)



/datum/modular_computer_app_presets/ert
	name = "ert"
	display_name = "EmergencyResposeTeam"
	description = "Preset for the ERT Console."
	available = FALSE

/datum/modular_computer_app_presets/ert/New()
	. = ..()
	program_list += COMPUTER_APP_PRESET_SYSTEM
	program_list += list(/datum/computer_file/program/camera_monitor/hacked,
						/datum/computer_file/program/comm,
						/datum/computer_file/program/suit_sensors,
						/datum/computer_file/program/alarm_monitor/all,
						/datum/computer_file/program/lighting_control,
						/datum/computer_file/program/aidiag,
						/datum/computer_file/program/records
						)
