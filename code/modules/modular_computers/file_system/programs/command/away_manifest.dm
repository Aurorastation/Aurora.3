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
	usage_flags = PROGRAM_ALL_REGULAR | PROGRAM_SILICON
	tgui_id = "AwayShuttleManifest"
	var/datum/record/shuttle_manifest/active_record

/datum/computer_file/program/away_manifest/ui_data(mob/user)
	var/list/data = list()

	if(active_record)
		data["active_record"] = list(
			"name" = active_record.name,
			"id" = active_record.id,
			"shuttle" = active_record.shuttle,
			"pilot" = active_record.pilot,
			"lead" = active_record.lead
		)
	else
		var/list/allshuttles = list()
		var/list/allassignments = list()
		for (var/datum/record/shuttle_manifest/m in SSrecords.shuttle_manifests)
			allshuttles += list(list(
				"name" = m.name,
				"id" = m.id,
				"shuttle" = m.shuttle,
				"pilot" = m.pilot,
				"lead" = m.lead
			))
		for(var/datum/record/shuttle_assignment/a in SSrecords.shuttle_assignments)
			if(!a.departure_time)
				a.departure_time = worldtime2text()
			if(!a.return_time)
				a.return_time = worldtime2text(world.time + 1 HOUR)
			allassignments += list(list(
				"shuttle" = a.shuttle,
				"destination" = a.destination,
				"heading" = a.heading,
				"mission" = a.mission,
				"departure_time" = a.departure_time,
				"return_time" = a.return_time
			))
		data["shuttles"] = SSatlas.current_map.shuttle_manifests
		data["shuttle_manifest"] = allshuttles
		data["shuttle_assignments"] = allassignments
		data["active_record"] = null
	return data

/datum/computer_file/program/away_manifest/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("am_menu")
			. = TRUE
			active_record = null
			SStgui.update_uis(computer)

		if("editentry")
			for(var/datum/record/shuttle_manifest/m in SSrecords.shuttle_manifests)
				if(m.id == text2num(params["editentry"]))
					active_record = m
					break

		if("back")
			. = TRUE
			active_record = null
			SStgui.update_uis(computer)

	//Check ID for command/mining/research access to edit
	if(!istype(usr))
		return
	var/obj/item/card/id/I = usr.GetIdCard()
	if(!istype(I) || !I.registered_name || (!(ACCESS_HEADS in I.access) && !(ACCESS_RESEARCH in I.access) && !(ACCESS_MINING in I.access)))
		to_chat(usr, SPAN_WARNING("Authentication error: Unable to locate ID with appropriate access to allow this operation."))
		return

	switch(action)
		if("addentry")
			. = TRUE
			var/datum/record/shuttle_manifest/m = new()
			m.name = "Unknown"
			m.shuttle = "Unknown"
			active_record = m

		if("saveentry")
			. = TRUE
			SSrecords.update_record(active_record)
			active_record = null
			SStgui.update_uis(computer)

		if("deleteentry")
			. = TRUE
			SSrecords.remove_record(active_record)
			active_record = null
			SStgui.update_uis(computer)

		if("editentryname")
			. = TRUE
			var/names = list()
			for(var/datum/record/general/r in SSrecords.records)
				names += r.name
			var/newname = sanitize(tgui_input_list(usr, "Please select name.", "Name select", names, active_record.name))
			if(!newname)
				return
			active_record.name = newname

		if("editentrynamecustom")
			. = TRUE
			var/newname = sanitize(tgui_input_text(usr, "Please enter name.", "Name entry", active_record.name))
			if(!newname)
				return
			active_record.name = newname

		if("editentryshuttle")
			. = TRUE
			var/newshuttle = tgui_input_list(usr, "Please select shuttle.", "Shuttle select", SSatlas.current_map.shuttle_manifests, active_record.shuttle)
			if(!newshuttle)
				return
			active_record.shuttle = newshuttle

		if("editdestination")
			for(var/datum/record/shuttle_assignment/a in SSrecords.shuttle_assignments)
				if(a.shuttle == params["editdestination"])
					var/new_dest = sanitize(tgui_input_text(usr, "Please enter destination.", "Destination entry", a.destination))
					if(!new_dest)
						return
					a.destination = new_dest

		if("editheading")
			for(var/datum/record/shuttle_assignment/a in SSrecords.shuttle_assignments)
				if(a.shuttle == params["editheading"])
					var/new_head = floor(tgui_input_number(usr, "Please enter heading.", "Heading entry", a.heading, 359, 0))
					if(new_head < 0 || new_head > 359 || !new_head)
						new_head = 0
					a.heading = new_head

		if("editmission")
			for(var/datum/record/shuttle_assignment/a in SSrecords.shuttle_assignments)
				if(a.shuttle == params["editmission"])
					var/new_mis = tgui_input_list(usr, "Please select mission.", "Mission select", SSatlas.current_map.shuttle_missions, a.mission)
					if(!new_mis)
						return
					a.mission = new_mis

		if("editdeparturetime")
			for(var/datum/record/shuttle_assignment/a in SSrecords.shuttle_assignments)
				if(a.shuttle == params["editdeparturetime"])
					var/new_depart = sanitize(tgui_input_text(usr, "Please enter new departure time.", "Departure time entry", a.departure_time))
					if(!new_depart)
						return
					a.departure_time = new_depart

		if("editreturntime")
			for(var/datum/record/shuttle_assignment/a in SSrecords.shuttle_assignments)
				if(a.shuttle == params["editreturntime"])
					var/new_return = sanitize(tgui_input_text(usr, "Please enter new return time.", "Return time entry", a.departure_time))
					if(!new_return)
						return
					a.return_time = new_return

		if("editlead")
			for(var/datum/record/shuttle_manifest/m in SSrecords.shuttle_manifests)
				if(m.id == text2num(params["editlead"]))
					m.lead = !m.lead
					if(m.lead)
						for(var/datum/record/shuttle_manifest/other in SSrecords.shuttle_manifests) // There can be only one
							if(other.shuttle == m.shuttle && other.lead && other != m)
								other.lead = FALSE

		if("editpilot")
			for(var/datum/record/shuttle_manifest/m in SSrecords.shuttle_manifests)
				if(m.id == text2num(params["editpilot"]))
					m.pilot = !m.pilot
					if(m.pilot)
						for(var/datum/record/shuttle_manifest/other in SSrecords.shuttle_manifests)
							if(other.shuttle == m.shuttle && other.pilot && other != m)
								other.pilot = FALSE
