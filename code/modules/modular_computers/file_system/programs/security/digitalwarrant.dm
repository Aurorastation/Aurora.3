/datum/computer_file/program/digitalwarrant
	filename = "digitalwarrant"
	filedesc = "Warrant Assistant"
	extended_desc = "Official NTsec program for creation and handling of warrants."
	program_icon_state = "warrant"
	program_key_icon_state = "red_key"
	color = LIGHT_COLOR_RED
	size = 8
	requires_ntnet = TRUE
	available_on_ntnet = TRUE
	required_access_download = ACCESS_HOS
	required_access_run = ACCESS_SECURITY
	usage_flags = PROGRAM_ALL_REGULAR | PROGRAM_STATIONBOUND
	tgui_id = "DigitalWarrant"
	var/datum/record/warrant/active_warrant

/datum/computer_file/program/digitalwarrant/ui_data(mob/user)
	var/list/data = initial_data()

	if(active_warrant)
		data["active_warrant"] = list(
			"name" = active_warrant.name,
			"charges" = active_warrant.notes,
			"authorisation" = active_warrant.authorization,
			"id" = active_warrant.id,
			"type" = active_warrant.wtype
		)
	else
		var/list/allwarrants = list()
		for(var/datum/record/warrant/W in SSrecords.warrants)
			allwarrants += list(list(
			"name" = W.name,
			"charges" = "[copytext(W.notes,1,min(length(W.notes) + 1, 50))]...",
			"authorisation" = W.authorization,
			"id" = W.id,
			"wtype" = W.wtype
		))
		data["allwarrants"] = allwarrants
		data["active_warrant"] = null
	return data

/datum/computer_file/program/digitalwarrant/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("sw_menu")
			active_warrant = null
			SStgui.update_uis(computer)

		if("editwarrant")
			for(var/datum/record/warrant/W in SSrecords.warrants)
				if(W.id == text2num(params["editwarrant"]))
					active_warrant = W
					break
			. = TRUE

		if("back")
			active_warrant = null
			SStgui.update_uis(computer)

	// The following actions will only be possible if the user has an ID with security access equipped. This is in line with modular computer framework's authentication methods,
	// which also use RFID scanning to allow or disallow access to some functions. Anyone can view warrants, editing requires ID.

	var/mob/user = usr
	if(!istype(user))
		return
	var/obj/item/card/id/I = user.GetIdCard()
	if(!istype(I) || !I.registered_name || !(ACCESS_SECURITY in I.access) || issilicon(user))
		to_chat(user, SPAN_WARNING("Authentication error: Unable to locate ID with appropriate access to allow this operation."))
		return

	// Require higher access to edit warrants that have already been authorized
	if(active_warrant && active_warrant.authorization != "Unauthorized" && !(ACCESS_ARMORY in I.access))
		to_chat(user, SPAN_WARNING("Authentication error: Unable to locate ID with appropriate access to adjust an authorized warrant."))
		return

	switch(action)
		if("addwarrant")
			. = TRUE
			var/datum/record/warrant/W = new()
			var/temp = sanitize(input(usr, "Do you want to create a search-, or an arrest warrant?") as null|anything in list("search", "arrest"))
			if(!computer.use_check_and_message(user))
				if(temp == "arrest")
					W.name = "Unknown"
					W.notes = "No charges present"
					W.authorization = "Unauthorized"
					W.wtype = "arrest"
				if(temp == "search")
					W.name = "No location given"
					W.notes = "No reason given"
					W.authorization = "Unauthorized"
					W.wtype = "search"
				if(isnull(temp))
					return
				active_warrant = W

		if("savewarrant")
			if(!(active_warrant in SSrecords.warrants))
				SSrecords.add_record(active_warrant)
			else
				SSrecords.update_record(active_warrant)
			active_warrant = null
			SStgui.update_uis(computer)

		if("deletewarrant")
			SSrecords.remove_record(active_warrant)
			active_warrant = null
			SStgui.update_uis(computer)

		if("editwarrantname")
			. = TRUE
			var/namelist = list()
			for(var/datum/record/general/t in SSrecords.records)
				namelist += t.name
			var/new_name = sanitize(input(usr, "Please input name") as null|anything in namelist)
			if(!computer.use_check_and_message(user))
				if (!new_name)
					return
				active_warrant.name = new_name

		if("editwarrantnamecustom")
			. = TRUE
			var/new_name = sanitize(input("Please input name") as null|text)
			if(!computer.use_check_and_message(user))
				if (!new_name)
					return
				active_warrant.name = new_name

		if("editwarrantcharges")
			. = TRUE
			var/new_charges = sanitize(input("Please input charges", "Charges", active_warrant.notes) as null|text)
			if(!computer.use_check_and_message(user))
				if (!new_charges)
					return
				active_warrant.notes = new_charges

		if("editwarrantauth")
			if(!(ACCESS_ARMORY in I.access))
				to_chat(user, SPAN_WARNING("Authentication error: Unable to locate ID with appropriate access to allow this operation."))
				return
			. = TRUE

			active_warrant.authorization = "[I.registered_name] - [I.assignment ? I.assignment : "(Unknown)"]"
