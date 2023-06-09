/client/proc/view_extended_list(var/list/L)
	if(!check_rights(R_VAREDIT|R_DEV))	return

	if(istype(L))
		new /datum/tgui_module/list_viewer(L, usr)

/datum/tgui_module/list_viewer
	var/list/viewed_list

/datum/tgui_module/list_viewer/New(var/list/L, mob/user)
	if(istype(L))
		viewed_list = L
	ui_interact(user)

/datum/tgui_module/list_viewer/ui_interact(mob/user, var/datum/tgui/ui)
	if(!check_rights(R_VAREDIT|R_DEV|R_MOD))
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ListViewer", "Extended List Viewer", 800, 600)
		ui.open()

/datum/tgui_module/list_viewer/ui_data(mob/user)
	var/list/data = list()

	if(!user.client.holder)
		return

	if(!check_rights(R_VAREDIT|R_DEV, FALSE, user))
		return

	data["listvar"] = list()

	var/index = 1
	for(var/k in viewed_list)
		if(!isnull(viewed_list[k]))
			data["listvar"] += list(list("key" = k, "value" = viewed_list[k]))
		else
			data["listvar"] += list(list("key" = index, "value" = k))
			index++

	return data
