/datum/tgui_module/flavor_text
	var/mob_name = ""
	var/flavor_text = ""

/datum/tgui_module/flavor_text/New(mob/user, var/set_mob_name, var/set_flavor_text)
	..()
	mob_name = set_mob_name
	flavor_text = set_flavor_text

/datum/tgui_module/flavor_text/ui_interact(var/mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "FlavorText", mob_name, 500, 400)
		ui.autoupdate = FALSE
		ui.open()

/datum/tgui_module/flavor_text/ui_data(mob/user)
	var/list/data = list()
	data["flavor_text"] = flavor_text
	return data
