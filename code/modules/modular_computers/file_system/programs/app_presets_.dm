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
