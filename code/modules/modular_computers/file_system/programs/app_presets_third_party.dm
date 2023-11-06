
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


/datum/modular_computer_app_presets/merchant/golden_deep/return_install_programs(obj/item/modular_computer/comp)
	var/list/_prg_list = list(
		new /datum/computer_file/program/filemanager(comp),
		new /datum/computer_file/program/manifest(comp),
		new /datum/computer_file/program/newsbrowser(comp),
		new /datum/computer_file/program/chat_client(comp),
		new /datum/computer_file/program/merchant/golden_deep(comp)
	)
	return _prg_list
