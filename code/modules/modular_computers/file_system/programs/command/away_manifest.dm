/datum/computer_file/program/away_manifest
	filename = "awayshuttlemanifest"
	filedesc = "Shuttle Manifest Program"
	extended_desc = "Used to view the manifest of the Horizon's shuttles."
	program_icon_state = "menu"
	program_key_icon_state = "lightblue_key"
	color = LIGHT_COLOR_BLUE
	size = 8
	requires_ntnet = TRUE
	available_on_ntnet = TRUE
	usage_flags = PROGRAM_ALL_REGULAR
	tgui_id = "AwayShuttleManifest"
	var/datum/record/shuttle_manifest/active_record

/datum/computer_file/program/away_manifest/ui_data(mob/user)
	var/list/data = list()
	
	if(active_record)
		data["active_record"] = list(
			"name" = active_record.name,
			"shuttle" = active_record.shuttle,
			"id" = active_record.id
		)
	else
		var/list/allshuttles = list()
		for (var/datum/record/shuttle_manifest/m in SSrecords.shuttle_manifests)
			allshuttles += list(list(
				"name" = m.name,
				"shuttle" = m.shuttle,
				"id" = m.id
			))
		data["shuttle_manifest"] = allshuttles
		data["active_record"] = null
	return data
	
/datum/computer_file/program/away_manifest/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
		
	switch(action)
		if("am_menu")
			active_record = null
			SStgui.update_uis(computer)
		
		if("editentry")
			for(var/datum/record/shuttle_manifest/m in SSrecords.shuttle_manifests)
				if(m.id == text2num(params["editentry"]))
					active_record = m
					break
		
		if("back")
			active_record = null
			SStgui.update_uis(computer)
			
	//Check ID for command/mining/research access to edit
	var/mob/user = usr
	if(!istype(user))
		return
	var/obj/item/card/id/I = user.GetIdCard()
	if(!istype(I) || !I.registered_name || issilicon(user) || (!(access_heads in I.access) && !(access_research in I.access) && !(access_mining in I.access)))
		to_chat(user, SPAN_WARNING("Authentication error: Unable to locate ID with appropriate access to allow this operation."))
		return
			
	switch(action)
		if("addentry")
			. = TRUE
			var/datum/record/shuttle_manifest/m = new()
			if(!computer.use_check_and_message(user))
				m.name = "Unknown"
				m.shuttle = "Unknown"
				active_record = m
			
		if("saveentry")
			SSrecords.update_record(active_record)
			active_record = null
			SStgui.update_uis(computer)
		
		if("deleteentry")
			SSrecords.remove_record(active_record)
			active_record = null
			SStgui.update_uis(computer)
				
		if("editentryname")
			. = TRUE
			var/names = list()
			for(var/datum/record/general/r in SSrecords.records)
				names += r.name
			var/newname = sanitize(input(usr, "Please enter name.") as null|anything in names)
			if(!computer.use_check_and_message(user))
				if(!newname)
					return
				active_record.name = newname
					
		if("editentrynamecustom")
			. = TRUE
			var/newname = sanitize(input("Please enter name.") as null|text)
			if(!computer.use_check_and_message(user))
				if(!newname)
					return
				active_record.name = newname
		if("editentryshuttle")
			. = TRUE
			var/newshuttle = sanitize(input("Please enter shuttle.") as null|anything in list("SCCV Canary", "SCCV Intrepid", "SCCV Spark"))
			if(!computer.use_check_and_message(user))
				if(!newshuttle)
					return
				active_record.shuttle = newshuttle
				