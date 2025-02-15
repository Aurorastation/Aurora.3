
/datum/modular_computer_app_presets/merchant
	name = "merchant"
	display_name = "Merchant"
	description = "A preset for the merchant console."
	available = FALSE

/datum/modular_computer_app_presets/merchant/New()
	. = ..()
	program_list += list(/datum/computer_file/program/filemanager,
						/datum/computer_file/program/manifest,
						/datum/computer_file/program/newsbrowser,
						/datum/computer_file/program/chat_client,
						/datum/computer_file/program/merchant
						)
