/**
 * Used to create a tgui Extended List Viewer
 *
 * Accepts either an associative list or a flat list
 *
 * If an associative list is passed, the key is a string and the value the datum
 */
/client/proc/view_extended_list(list/L, datum/original_datum)
	if(!check_rights(R_VAREDIT|R_DEV))
		return

	if(istype(L))
		new /datum/tgui_module/list_viewer(L, usr, original_datum = original_datum)

/datum/tgui_module/list_viewer
	var/list/viewed_list
	var/datum/weakref/original_datum_ref

/datum/tgui_module/list_viewer/New(list/L, mob/user, datum/original_datum)
	if(istype(L))
		viewed_list = L
	if(istype(original_datum))
		original_datum_ref = WEAKREF(original_datum)
		if(!original_datum_ref)
			stack_trace("Unable to create a weakref to the original datum, please report this to a developer")

	ui_interact(user)

/datum/tgui_module/list_viewer/ui_interact(mob/user, datum/tgui/ui)
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

	//Let's just compute it once instead of for every element
	var/is_normal_list = IS_NORMAL_LIST(viewed_list)

	for(var/index in 1 to length(viewed_list))
		var/entry = viewed_list[index]

		if(is_normal_list && IS_VALID_ASSOC_KEY(entry))
			if(!isnull(viewed_list[entry]))
				data["listvar"] += list(list("key" = entry, "value" = viewed_list[entry]))
			else
				data["listvar"] += list(list("key" = index, "value" = entry))
		else
			data["listvar"] += list(list("key" = index, "value" = entry))

	return data

/datum/tgui_module/list_viewer/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(!check_rights(R_VAREDIT|R_DEV))
		return

	var/client/user_client = ui.user?.client
	if(!user_client)
		stack_trace("No client found to open entry in, despite having received a request to edit a list, uh oh!")
		return

	switch(action)

		if("open_entry")

			var/datum/entry_to_open = null

			if(isnum(text2num(params["open_entry_key"])))
				entry_to_open = viewed_list[text2num(params["open_entry_key"])]
			else
				entry_to_open = viewed_list[params["open_entry_key"]]

			if(!entry_to_open)
				to_chat(usr, "No entry found to open!")
				return FALSE

			if(!isdatum(entry_to_open))
				to_chat(usr, "The entry is not a datum!")
				return FALSE

			user_client.debug_variables_open(entry_to_open)

			return TRUE

		if("open_whole_list")
			if(tgui_alert(usr, "Opening the whole list in VV might take a long time or cause issues, are you sure?", "Confirm", list("Yes", "No")) != "Yes")
				return FALSE

			var/datum/original_datum = original_datum_ref.resolve()
			if(!original_datum)
				tgui_alert(usr, "Unable to open the list, the original datum has been deleted or has never been set.")
				return FALSE

			user_client.mod_list(viewed_list, original_datum)

			return TRUE
