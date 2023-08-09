/datum/computer_file/program/away_manifest
	filename = "awayshuttlemanifest"
	filedesc = "Shuttle Manifest Program"
	extended_desc = "Used to view the manifest of the Horizon's shuttles."
	program_icon_state = "away"
	program_key_icon_state = "lightblue_key"
	color = LIGHT_COLOR_BLUE
	size = 8
	requires_ntnet = TRUE
	available_on_ntnet = TRUE
	required_access_run = access_heads
	required_access_download = access_heads //change to || others?
	usage_flags = PROGRAM_ALL_REGULAR
	tgui_id = "AwayShuttleManifest"
	var/datum/record/shuttle_manifest/active_record //do I need this? Or should I do like, a custom type with the vars from the tgui file

/datum/computer_file/program/away_manifest/ui_data(mob/user)
	var/list/data = list()
	
	if(active_record)
		data["active_record"] = list(
			"name" = active_record.name,
			"shuttle" = active_record.shuttle
		)
	else
		var/list/allshuttles = list()
		for (var/datum/record/shuttle_manifest/m in SSrecords.shuttle_manifests)
			allshuttles += list(list(
				"name" = m.name,
				"shuttle" = m.shuttle
			))
		data["allshuttles"] = allshuttles
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
			
	//Check ID for command/ops/research
	var/mob/user = usr
	if(!istype(user))
		return
	var/obj/item/card/id/I = user.GetIdCard()
	if(!istype(I) || !I.registered_name || !(access_heads in I.access) || issilicon(user) || !(access_research in I.access) || !(access_cargo in I.access))
		to_chat(user, SPAN_WARNING("Authentication error: Unable to locate ID with appropriate access to allow this operation."))
		return
			
	switch(action)
		if("addentry")
			. = TRUE
			//do I need to make a new record type for this?
			//probably add a 'shuttle manifest' or whatever record to the datums
			var/datum/record/shuttle_manifest/m = new()
			var/temp = sanitize(input(usr, "Which shuttle is this for?") as null|anything in list("Canary", "Intrepid", "Spark"))
			if(!computer.use_check_and_message(user))
				if(temp == "Canary")
					m.name = "Unknown"
					m.shuttle = "Canary"
				if(temp == "Intrepid")
					m.name = "Unknown"
					m.shuttle = "Intrepid"
				if(temp == "Spark")
					m.name = "Unknown"
					m.shuttle = "Spark"
				if(isnull(temp))
					return
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