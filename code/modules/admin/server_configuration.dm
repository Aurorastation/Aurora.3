/client/proc/server_configuration()
	set category = "Admin"
	set name = "Server Configuration"
	set desc = "View and edit server configuration"
	if(!check_rights(R_SERVER|R_ADMIN|R_DEV))
		return

	var/static/datum/tgui_module/server_configuration/global_server_configuration = new()
	global_server_configuration.ui_interact(usr)

/datum/tgui_module/server_configuration
	var/datum/space_sector/selected_sector
	var/datum/space_sector/committed_sector

	var/selected_message_of_the_day
	var/committed_message_of_the_day

	var/selected_lore_summary
	var/committed_lore_summary

/datum/tgui_module/server_configuration/ui_close(mob/user)
	reset_state(TRUE)
	. = ..()

/datum/tgui_module/server_configuration/proc/reset_state(hard_reset = FALSE)
	selected_sector = null
	selected_message_of_the_day = null
	selected_lore_summary = null

	if(hard_reset)
		committed_sector = null
		committed_message_of_the_day = null
		committed_lore_summary = null

/datum/tgui_module/server_configuration/ui_interact(mob/user, var/datum/tgui/ui)
	if(!check_rights(R_SERVER|R_ADMIN|R_DEV, user=user))
		return

	committed_sector = SSatlas.possible_sectors[SSregistry.getValue(REGISTRY_CURRENT_SECTOR, GLOB.config.current_space_sector ? GLOB.config.current_space_sector : SSatlas.current_sector?.name)]
	committed_message_of_the_day = SSregistry.getValue(REGISTRY_MESSAGE_OF_THE_DAY)
	committed_lore_summary = SSregistry.getValue(REGISTRY_LORE_SUMMARY)

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ServerConfiguration", "Server configuration", 600, 500)
		ui.open()
	ui.open()

/datum/tgui_module/server_configuration/ui_data(mob/user)
	var/list/data = list()

	data["sector_name"] = selected_sector?.name || committed_sector?.name || "Unknown"
	data["sector_description"] = selected_sector?.description || committed_sector?.description || "No description available."
	data["sector_changed"] = selected_sector != null

	data["message_of_the_day"] = selected_message_of_the_day != null ? selected_message_of_the_day : committed_message_of_the_day || ""
	data["message_of_the_day_changed"] = selected_message_of_the_day != null

	data["lore_summary"] = selected_lore_summary != null ? selected_lore_summary : committed_lore_summary || ""
	data["lore_summary_changed"] = selected_lore_summary != null

	data["read_only"] = !check_rights(R_SERVER|R_ADMIN, user=user) // Developers only get view-access, no edit permissions
	data["unsaved_changes"] = check_for_unsaved_changes()
	return data

/datum/tgui_module/server_configuration/proc/check_for_unsaved_changes()
	return \
		selected_sector != null || \
		selected_message_of_the_day != null || \
		selected_lore_summary != null

/datum/tgui_module/server_configuration/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(!check_rights(R_SERVER|R_ADMIN, user=ui.user)) // Developers only get view-access, no edit permissions
		return

	switch(action)
		if("set_selected_sector")
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
		if("reset_selected_sector")
			selected_sector = null
			return TRUE

		if("set_message_of_the_day")
			selected_message_of_the_day = params["value"]
			return TRUE
		if("reset_message_of_the_day")
			selected_message_of_the_day = null
			return TRUE

		if("set_lore_summary")
			selected_lore_summary = params["value"]
			return TRUE
		if("reset_lore_summary")
			selected_lore_summary = null
			return TRUE

		if("commit_changes")
			if(selected_sector)
				if(SSregistry.setValue(REGISTRY_CURRENT_SECTOR, selected_sector.name))
					log_change("Sector changed to [selected_sector.name]")
					committed_sector = selected_sector
				else
					to_chat(ui.user, SPAN_WARNING("Failed to set the current sector."))
			if(selected_message_of_the_day != null)
				if(SSregistry.setValue(REGISTRY_MESSAGE_OF_THE_DAY, selected_message_of_the_day))
					log_change("Message of the day changed")
					committed_message_of_the_day = selected_message_of_the_day
				else
					to_chat(ui.user, SPAN_WARNING("Failed to set the message of the day."))
			if(selected_lore_summary != null)
				if(SSregistry.setValue(REGISTRY_LORE_SUMMARY, selected_lore_summary))
					log_change("Lore summary changed")
					committed_lore_summary = selected_lore_summary
				else
					to_chat(ui.user, SPAN_WARNING("Failed to set the lore summary."))
			reset_state()
			return TRUE

/datum/tgui_module/server_configuration/proc/log_change(text)
	log_and_message_admins("Server configuration: [text]", usr)
