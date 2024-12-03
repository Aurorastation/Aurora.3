
/*##########################
	ENGINEERING PRESETS
##########################*/
/datum/modular_computer_app_presets/engineering
	name = "engineering"
	display_name = "Engineering"
	description = "Contains the most common engineering programs."
	available = TRUE

/datum/modular_computer_app_presets/engineering/New()
	. = ..()
	program_list += COMPUTER_APP_PRESET_SYSTEM + COMPUTER_APP_PRESET_HORIZON_CIVILIAN + COMPUTER_APP_PRESET_HORIZON_ENGINEERING


/datum/modular_computer_app_presets/engineering/atmos
	name = "atmos"
	display_name = "Engineering - Atmospherics"
	description = "Contains the most common engineering programs and atmospheric monitoring software."

/datum/modular_computer_app_presets/engineering/atmos/New()
	. = ..()
	program_list += /datum/computer_file/program/scanner/gas


/datum/modular_computer_app_presets/engineering/ce
	name = "engineering_head"
	display_name = "Engineering - CE"
	description = "Contains the most common engineering programs and command software."
	available = FALSE

/datum/modular_computer_app_presets/engineering/ce/New()
	. = ..()
	program_list += list(/datum/computer_file/program/comm,	/datum/computer_file/program/records/employment)


/*##########################
	MEDICAL PRESETS
##########################*/
/datum/modular_computer_app_presets/medical
	name = "medical"
	display_name = "Medical"
	description = "Contains the most common medical programs."
	available = TRUE

/datum/modular_computer_app_presets/medical/New()
	. = ..()
	program_list += COMPUTER_APP_PRESET_SYSTEM + COMPUTER_APP_PRESET_HORIZON_CIVILIAN + COMPUTER_APP_PRESET_HORIZON_MEDICAL


/datum/modular_computer_app_presets/medical/cmo
	name = "medical_head"
	display_name = "Medical - CMO"
	description = "Contains the most common medical programs and command software."
	available = FALSE

/datum/modular_computer_app_presets/medical/cmo/New()
	. = ..()
	program_list += list(/datum/computer_file/program/records/employment, /datum/computer_file/program/scanner/science, /datum/computer_file/program/comm)


/*##########################
	RESEARCH PRESETS
##########################*/
/datum/modular_computer_app_presets/research
	name = "research"
	display_name = "Research"
	description = "Contains the most common research programs."
	available = TRUE

/datum/modular_computer_app_presets/research/New()
	. = ..()
	program_list += COMPUTER_APP_PRESET_SYSTEM + COMPUTER_APP_PRESET_HORIZON_CIVILIAN + COMPUTER_APP_PRESET_HORIZON_RESEARCH


/datum/modular_computer_app_presets/research/rd
	name = "research_head"
	display_name = "Research - RD"
	description = "Contains the most common research programs and command software."
	available = FALSE

/datum/modular_computer_app_presets/research/rd/New()
	. = ..()
	program_list += list(/datum/computer_file/program/comm,	/datum/computer_file/program/records/employment)


/*##########################
	BRIDGE CREW PRESETS
##########################*/
/datum/modular_computer_app_presets/bridge
	name = "bridge"
	display_name = "Bridge"
	description = "Contains the most common bridge programs"
	available = TRUE

/datum/modular_computer_app_presets/bridge/New()
	. = ..()
	program_list += COMPUTER_APP_PRESET_SYSTEM + COMPUTER_APP_PRESET_HORIZON_CIVILIAN + /datum/computer_file/program/away_manifest


/*##########################
	COMMAND PRESETS
##########################*/
/datum/modular_computer_app_presets/command
	name = "command"
	display_name = "Command"
	description = "Contains the most common command programs."
	available = TRUE

/datum/modular_computer_app_presets/command/New()
	. = ..()
	program_list += COMPUTER_APP_PRESET_SYSTEM + COMPUTER_APP_PRESET_HORIZON_CIVILIAN
	program_list += list(/datum/computer_file/program/card_mod,
						/datum/computer_file/program/comm/intercept,
						/datum/computer_file/program/docks,
						/datum/computer_file/program/away_manifest,
						/datum/computer_file/program/records/employment,
						)


/datum/modular_computer_app_presets/command/hop
	name = "command_hop"
	display_name = "Command - HoP"
	description = "Contains the most common command programs."
	available = FALSE

/datum/modular_computer_app_presets/command/hop/New()
	. = ..()
	program_list += list(/datum/computer_file/program/civilian/cargocontrol, /datum/computer_file/program/records/security)


/datum/modular_computer_app_presets/command/captain
	name = "captain"
	display_name = "Captain"
	description = "Contains the most important programs for the Captain."
	available = FALSE

/datum/modular_computer_app_presets/command/captain/New()
	. = ..()
	program_list += list(/datum/computer_file/program/camera_monitor,
						/datum/computer_file/program/digitalwarrant,
						/datum/computer_file/program/civilian/cargocontrol,
						/datum/computer_file/program/alarm_monitor/all,
						/datum/computer_file/program/records/medical,
						/datum/computer_file/program/records/security,
						)


/*##########################
	SECURITY PRESETS
##########################*/
/datum/modular_computer_app_presets/security
	name = "security"
	display_name = "Security"
	description = "Contains the most common security programs."
	available = TRUE

/datum/modular_computer_app_presets/security/New()
	. = ..()
	program_list += COMPUTER_APP_PRESET_SYSTEM + COMPUTER_APP_PRESET_HORIZON_CIVILIAN + COMPUTER_APP_PRESET_HORIZON_SECURITY


/datum/modular_computer_app_presets/security/armory
	name = "security_arm"
	display_name = "Security - Armory"
	description = "Contains the most common security and armory programs."
	available = FALSE

/datum/modular_computer_app_presets/security/armory/New()
	. = ..()
	program_list += list(/datum/computer_file/program/implant_tracker, /datum/computer_file/program/comm)


/datum/modular_computer_app_presets/security/investigations
	name = "security_inv"
	display_name = "Security - Investigations"
	description = "Contains the most common security and forensics programs."

/datum/modular_computer_app_presets/security/investigations/New()
	. = ..()
	program_list += /datum/computer_file/program/records/medical
	program_list -= /datum/computer_file/program/guntracker //Remove the guntracker, investigators don't have access to it


/datum/modular_computer_app_presets/security/hos
	name = "security_head"
	display_name = "Security - HoS"
	description = "Contains the most common security programs and command software."
	available = FALSE

/datum/modular_computer_app_presets/security/hos/New()
	. = ..()
	program_list += list(/datum/computer_file/program/comm,	/datum/computer_file/program/records/employment)


/*##########################
	CIVILIAN PRESETS
##########################*/
/datum/modular_computer_app_presets/civilian
	name = "service"
	display_name = "Service"
	description = "Contains the most common service programs."
	available = TRUE

/datum/modular_computer_app_presets/civilian/New()
	. = ..()
	program_list += COMPUTER_APP_PRESET_SYSTEM + COMPUTER_APP_PRESET_HORIZON_CIVILIAN
	program_list += list(/datum/computer_file/program/game/arcade, /datum/computer_file/program/cooking_codex)


/datum/modular_computer_app_presets/civilian/janitor
	name = "janitor"
	display_name = "Janitor"
	description = "Contains programs for janitorial service."

/datum/modular_computer_app_presets/civilian/janitor/New()
	. = ..()
	program_list += /datum/computer_file/program/civilian/janitor

/datum/modular_computer_app_presets/civilian/miner
	name = "miner"
	display_name = "Miner"
	description = "Contains programs for miners."

/datum/modular_computer_app_presets/civilian/miner/New()
	. = ..()
	program_list += /datum/computer_file/program/away_manifest


/*##########################
	SUPPLY PRESETS
##########################*/
/datum/modular_computer_app_presets/supply
	name = "supply"
	display_name = "Supply"
	description = "Contains the most common cargo programs."
	available = TRUE

/datum/modular_computer_app_presets/supply/New()
	. = ..()
	program_list += COMPUTER_APP_PRESET_SYSTEM + COMPUTER_APP_PRESET_HORIZON_CIVILIAN
	program_list += list(/datum/computer_file/program/civilian/cargocontrol,
						/datum/computer_file/program/civilian/cargodelivery,
						/datum/computer_file/program/away_manifest,
						)


/datum/modular_computer_app_presets/supply/om
	name = "operations manager"
	display_name = "Operations Manager"
	description = "Contains the most common cargo programs as well as the OM's ones."
	available = FALSE

/datum/modular_computer_app_presets/supply/om/New()
	. = ..()
	program_list += list(/datum/computer_file/program/comm, /datum/computer_file/program/docks)


/datum/modular_computer_app_presets/supply/mining
	name = "operations_mining"
	display_name = "Mining"
	description = "Contains the most common EVA programs."

/datum/modular_computer_app_presets/supply/mining/New()
	. = ..()
	program_list -= list(/datum/computer_file/program/civilian/cargocontrol, /datum/computer_file/program/civilian/cargodelivery) //Snowflake


/datum/modular_computer_app_presets/supply/machinist
	name = "operations_machinist"
	display_name = "Operations - Machinist"
	description = "Contains the most common supply programs and medical record software."

/datum/modular_computer_app_presets/supply/machinist/New()
	. = ..()
	program_list += list(/datum/computer_file/program/records/medical, /datum/computer_file/program/scanner/science)
	//Machinist is the bastard child of supply/operation, it doesn't have access to shit essentially
	program_list -= list(/datum/computer_file/program/civilian/cargocontrol, /datum/computer_file/program/civilian/cargodelivery, /datum/computer_file/program/away_manifest)


/*#############################
	REPRESENTATIVE PRESETS
#############################*/
/datum/modular_computer_app_presets/representative
	name = "representative"
	display_name = "Representative"
	description = "Contains software intended for representatives."
	available = FALSE

/datum/modular_computer_app_presets/representative/New()
	. = ..()
	program_list += COMPUTER_APP_PRESET_SYSTEM + COMPUTER_APP_PRESET_HORIZON_CIVILIAN + /datum/computer_file/program/records/employment
