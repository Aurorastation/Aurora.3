
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

/datum/modular_computer_app_presets/merchant/nka
	name = "merchant_nka"
	display_name = "Merchant - NKA"
	description = "A preset for the merchant console for the new kingdom of adhomai."

/datum/modular_computer_app_presets/merchant/nka/New()
	. = ..()
	program_list += /datum/computer_file/program/merchant/nka


/datum/modular_computer_app_presets/merchant/guild
	name = "merchant_guild"
	display_name = "Merchant - Guild"
	description = "A preset for the merchant console for the guild."

/datum/modular_computer_app_presets/merchant/guild/New()
	. = ..()
	program_list += /datum/computer_file/program/merchant/guild


/datum/modular_computer_app_presets/merchant/golden_deep
	name = "merchant_golden_deep"
	display_name = "Merchant - Golden Deep"
	description = "A preset for the merchant console for the golden deep."

/datum/modular_computer_app_presets/merchant/golden_deep/New()
	. = ..()
	program_list += /datum/computer_file/program/merchant/golden_deep
