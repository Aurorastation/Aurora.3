/client/proc/server_configuration()
	set category = "Admin"
	set name = "Server configuration"
	set desc = "View and edit server configuration"
	if(!check_rights(R_ADMIN|R_DEV))
		return

	var/static/datum/tgui_module/server_configuration/global_server_configuration = new()
	global_server_configuration.ui_interact(usr)

/datum/tgui_module/server_configuration
	// Selected data
	var/datum/space_sector/selected_sector
	// Committed data
	var/datum/space_sector/committed_sector

/datum/tgui_module/server_configuration/ui_close(mob/user)
	. = ..()
	selected_sector = null
	committed_sector = null

/datum/tgui_module/server_configuration/ui_interact(mob/user, var/datum/tgui/ui)
	if(!check_rights(R_ADMIN|R_DEV, user=user))
		return

	committed_sector = SSatlas.possible_sectors[SSregistry.getValue(REGISTRY_CURRENT_SECTOR, SSatlas.current_sector)]

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ServerConfiguration", "Server configuration", 600, 500)
		ui.open()
	ui.open()

/datum/tgui_module/server_configuration/ui_data(mob/user)
	var/list/data = list()

	data["sector_name"] = selected_sector?.name || committed_sector?.name || "Unknown"
	data["sector_description"] = selected_sector?.description || committed_sector?.description || "No description available."

	data["read_only"] = !check_rights(R_ADMIN, user=user) // Developers only get view-access, no edit permissions
	data["unsaved_changes"] = \
		selected_sector != null

	return data

/datum/tgui_module/server_configuration/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(!check_rights(R_ADMIN, user=ui.user)) // Developers only get view-access, no edit permissions
		return

	switch(action)
		if("select_sector")
			var/list/sector_names = list()
			for(var/sector_name in SSatlas.possible_sectors)
				sector_names += sector_name
			if(!length(sector_names))
				return TRUE
			sortTim(sector_names, GLOBAL_PROC_REF(cmp_text_asc))

			var/selected_sector_name = tgui_input_list(ui.user, "Select a space sector.", "Server configuration", sector_names, default = (selected_sector?.name || committed_sector?.name))
			if(!selected_sector_name || !(selected_sector_name in SSatlas.possible_sectors) || !state.can_use_topic(src, ui.user))
				return TRUE

			var/datum/space_sector/picked_sector = SSatlas.possible_sectors[selected_sector_name]
			if(picked_sector != committed_sector)
				selected_sector = picked_sector
			else
				selected_sector = null
			return TRUE
		if("reset_sector_selection")
			selected_sector = null
			return TRUE

		if("commit_changes")
			if(selected_sector)
				SSregistry.setValue(REGISTRY_CURRENT_SECTOR, selected_sector.name)
				log_and_message_admins("Server configuration", "Sector changed to [src]", usr)
				committed_sector = selected_sector
				selected_sector = null
			return TRUE
