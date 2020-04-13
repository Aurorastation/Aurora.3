/datum/computer_file/program/digitalwarrant
	filename = "digitalwarrant"
	filedesc = "Warrant Assistant"
	extended_desc = "Official NTsec program for creation and handling of warrants."
	program_icon_state = "security"
	color = LIGHT_COLOR_ORANGE
	size = 8
	requires_ntnet = TRUE
	available_on_ntnet = TRUE
	required_access_download = access_hos
	required_access_run = access_security
	nanomodule_path = /datum/nano_module/program/digitalwarrant/

/datum/nano_module/program/digitalwarrant/
	name = "Warrant Assistant"
	var/datum/record/warrant/activewarrant

/datum/nano_module/program/digitalwarrant/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/list/data = host.initial_data()

	if(activewarrant)
		data["warrantname"] = activewarrant.name
		data["warrantcharges"] = activewarrant.notes
		data["warrantauth"] = activewarrant.authorization
		data["type"] = activewarrant.wtype
	else
		var/list/allwarrants = list()
		for(var/datum/record/warrant/W in SSrecords.warrants)
			allwarrants.Add(list(list(
			"warrantname" = W.name,
			"charges" = "[copytext(W.notes,1,min(length(W.notes) + 1, 50))]...",
			"auth" = W.authorization,
			"id" = W.id,
			"arrestsearch" = W.wtype
		)))
		data["allwarrants"] = allwarrants

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "digitalwarrant.tmpl", name, 500, 350, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/digitalwarrant/Topic(href, href_list)
	if(..())
		return TRUE

	if(href_list["sw_menu"])
		activewarrant = null

	if(href_list["editwarrant"])
		. = TRUE
		for(var/datum/record/warrant/W in SSrecords.warrants)
			if(W.id == text2num(href_list["editwarrant"]))
				activewarrant = W
				break

	// The following actions will only be possible if the user has an ID with security access equipped. This is in line with modular computer framework's authentication methods,
	// which also use RFID scanning to allow or disallow access to some functions. Anyone can view warrants, editing requires ID.

	var/mob/user = usr
	if(!istype(user))
		return
	var/obj/item/card/id/I = user.GetIdCard()
	if(!istype(I) || !I.registered_name || !(access_armory in I.access) || issilicon(user))
		to_chat(user, "Authentication error: Unable to locate ID with appropriate access to allow this operation.")
		return

	if(href_list["addwarrant"])
		. = TRUE
		var/datum/record/warrant/W = new()
		var/temp = sanitize(input(usr, "Do you want to create a search-, or an arrest warrant?") as null|anything in list("search","arrest"))
		if(CanInteract(user, default_state))
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
			activewarrant = W

	if(href_list["savewarrant"])
		. = TRUE
		SSrecords.update_record(activewarrant)
		activewarrant = null

	if(href_list["deletewarrant"])
		. = TRUE
		SSrecords.remove_record(activewarrant)
		activewarrant = null

	if(href_list["editwarrantname"])
		. = TRUE
		var/namelist = list()
		for(var/datum/record/general/t in SSrecords.records)
			namelist += t.name
		var/new_name = sanitize(input(usr, "Please input name") as null|anything in namelist)
		if(CanInteract(user, default_state))
			if (!new_name)
				return
			activewarrant.name = new_name

	if(href_list["editwarrantnamecustom"])
		. = TRUE
		var/new_name = sanitize(input("Please input name") as null|text)
		if(CanInteract(user, default_state))
			if (!new_name)
				return
			activewarrant.name = new_name

	if(href_list["editwarrantcharges"])
		. = TRUE
		var/new_charges = sanitize(input("Please input charges", "Charges", activewarrant.notes) as null|text)
		if(CanInteract(user, default_state))
			if (!new_charges)
				return
			activewarrant.notes = new_charges

	if(href_list["editwarrantauth"])
		. = TRUE

		activewarrant.authorization = "[I.registered_name] - [I.assignment ? I.assignment : "(Unknown)"]"

	if(href_list["back"])
		. = TRUE
		activewarrant = null
