/datum/tgui_module/armor_values
	var/armor_name = ""
	var/list/armor_values = list()
	var/cold_protection
	var/cold_protection_percentage

/datum/tgui_module/armor_values/New(mob/user, var/set_armor_name, var/list/set_armor_values, var/set_cold_protection, var/set_cold_protection_percentage)
	..()
	armor_name = set_armor_name
	armor_values = set_armor_values
	cold_protection = set_cold_protection
	cold_protection_percentage = set_cold_protection_percentage

/datum/tgui_module/armor_values/ui_interact(var/mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ArmorValues", armor_name, 500, 400)
		ui.autoupdate = FALSE
		ui.open()

/datum/tgui_module/armor_values/ui_data(mob/user)
	var/list/data = list()
	data["armor_values"] = armor_values
	data["cold_protection"] = cold_protection
	data["cold_protection_percentage"] = cold_protection_percentage
	return data
