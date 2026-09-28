/datum/computer_file/program/records
	filename = "employee_directory"
	filedesc = "Employee Directory"
	extended_desc = "Browse public employee information and access departmental records with an authorized ID."

	program_icon_state = "employment_record"
	program_key_icon_state = "lightblue_key"
	color = LIGHT_COLOR_BLUE
	available_on_ntnet = TRUE
	size = 6

	requires_ntnet = TRUE
	requires_ntnet_feature = "NTNET_SYSTEMCONTROL"
	requires_access_to_run = FALSE
	requires_access_to_download = FALSE
	usage_flags = PROGRAM_ALL_REGULAR | PROGRAM_STATIONBOUND
	tgui_id = "Records"

	var/records_type = 0
	var/edit_type = 0
	var/datum/record/general/active
	var/listener/record/rconsole/listener
	var/authenticated = FALSE
	var/authenticated_name
	var/default_screen = "Public"
	var/list/medical_access = list(/datum/access/medical_equip::id, /datum/access/forensics_lockers::id, /datum/access/robotics::id, /datum/access/hop::id)
	var/list/security_access = list(/datum/access/security::id, /datum/access/forensics_lockers::id, /datum/access/lawyer::id, /datum/access/hop::id)
	var/list/employment_access = list(/datum/access/heads::id, /datum/access/lawyer::id, /datum/access/consular::id)
	var/typechoices = list(
		"physical_status" = list("Active", "*Deceased*", "*SSD*", "*Missing*", "Physically Unfit", "Disabled"),
		"criminal_status" = list("None", "*Arrest*", "Search", "Incarcerated", "Parolled", "Released"),
		"mental_status" = list("Stable", "*Insane*", "*Unstable*", "*Watch*"),
		"blood_type" = list("A-", "B-", "AB-", "O-", "A+", "B+", "AB+", "O+", "SBS")
	)

/datum/computer_file/program/records/New()
	. = ..()
	listener = new(src)

/datum/computer_file/program/records/Destroy()
	active = null
	QDEL_NULL(listener)
	. = ..()

/datum/computer_file/program/records/pai
	extended_desc = "This program is used to view crew records."
	usage_flags = PROGRAM_SILICON_PAI
	available_on_ntnet = FALSE

/datum/computer_file/program/records/proc/logout()
	authenticated = FALSE
	authenticated_name = null
	records_type = 0
	edit_type = 0

/datum/computer_file/program/records/proc/login(obj/item/card/id/id_card)
	logout()
	if(!istype(id_card) || !id_card.registered_name)
		return FALSE

	authenticated = TRUE
	authenticated_name = "[id_card.registered_name], [id_card.assignment]"
	if(has_access(req_one_access = employment_access, accesses = id_card.access))
		records_type |= RECORD_GENERAL
		edit_type |= RECORD_GENERAL
	if(has_access(req_one_access = medical_access, accesses = id_card.access))
		records_type |= RECORD_MEDICAL
		edit_type |= RECORD_MEDICAL
	if(has_access(req_one_access = security_access, accesses = id_card.access))
		records_type |= RECORD_SECURITY
		edit_type |= RECORD_SECURITY
	return TRUE

/datum/computer_file/program/records/ui_data(mob/user)
	var/list/data = list(
		"activeview" = "list",
		"defaultview" = default_screen,
		"editingvalue" = ""
	)

	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata

	data["authenticated"] = authenticated
	data["authenticated_name"] = authenticated_name
	if(!authenticated)
		return data

	data["canprint"] = !!(computer?.nano_printer)

	data["available_types"] = records_type
	data["editable"] = edit_type
	data["physical_status_options"] = typechoices["physical_status"]
	data["criminal_status_options"] = typechoices["criminal_status"]
	data["mental_status_options"] = typechoices["mental_status"]
	data["blood_type_options"] = typechoices["blood_type"]
	data["medical_options"] = typechoices["medical"]
	data["allrecords"] = list()
	data["allrecords_locked"] = list()
	for(var/tR in sortRecord(SSrecords.records))
		var/datum/record/general/R = tR
		data["allrecords"] += list(list(
			"id" = R.id,
			"name" = R.name,
			"rank" = R.rank,
			"has_notes" = (records_type & RECORD_GENERAL) ? html_decode(R.notes) : "",
			"fingerprint" = (records_type & RECORD_SECURITY) ? R.fingerprint : "",
			"dna" = (records_type & RECORD_MEDICAL) && R.medical ? R.medical.blood_dna : ""
		))

	if(active)
		data["front"] = icon2base64(active.photo_front)
		data["side"] = icon2base64(active.photo_side)
		data["active"] = list(
			"id" = active.id,
			"name" = active.name,
			"rank" = active.rank,
			"age" = active.age,
			"sex" = active.sex,
			"species" = active.species,
			"physical_status" = active.physical_status
		)
		if(records_type & RECORD_GENERAL)
			data["active"] += list(
				"citizenship" = active.citizenship,
				"religion" = active.religion,
				"employer" = active.employer,
				"notes" = html_decode(active.notes),
				"notes_html" = active.notes_as_paper_html(),
				"ccia_notes" = active.ccia_record,
				"ccia_actions" = active.ccia_actions,
				"comments" = list()
			)
			for(var/datum/record/record_comment/record_comment in active.comments)
				data["active"]["comments"] += list(record_comment.Listify(decode_html = TRUE))
		if(records_type & RECORD_SECURITY)
			data["active"]["fingerprint"] = active.fingerprint
			data["active"]["security"] = active.security?.Listify(decode_html = TRUE)
		if(records_type & RECORD_MEDICAL)
			data["active"]["mental_status"] = active.mental_status
			data["active"]["medical"] = active.medical?.Listify(decode_html = TRUE)
	else
		data["active"] = null
	return data

/datum/computer_file/program/records/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(action == "login")
		var/obj/item/card/id/id_card = usr.GetIdCard()
		if(!login(id_card))
			to_chat(usr, SPAN_WARNING("Login failed: unable to scan a registered ID."))
		. = TRUE

	if(action == "logout")
		logout()
		active = null
		. = TRUE

	if(!authenticated)
		return

	switch(action)
		if("setactive")
			active = SSrecords.find_record("id", params["setactive"])
			. = TRUE

		//Key is the variable we want to edit. Value is what we set it to.
		if("editrecord")
			if(!active)
				return
			var/datum/record/record_to_edit = active
			var/key = params["key"]
			var/value = sanitize(params["value"], encode = 0, extra = 0)
			var/record_type = params["record_type"]
			if(record_type)
				if(!(record_type in list("security", "medical")))
					return
				record_to_edit = active.vars[record_type]
			if(record_to_edit && canEdit(key, record_type))
				if(isnum(record_to_edit.vars[key]))
					value = text2num(value)
				record_to_edit.vars[key] = value
				SSrecords.onModify(active)
				. = TRUE

		if("deleterecord")
			if(active && canEdit("name"))
				var/confirm = alert("Are you sure you want to delete this record?", "Confirm Deletion", "No", "Yes")
				if(confirm == "Yes")
					SSrecords.remove_record(active)
					active = null
				. = TRUE

		if("newrecord")
			if(edit_type & RECORD_GENERAL)
				active = new /datum/record/general()
				SSrecords.add_record(active)
				. = TRUE

		if("addcomment")
			var/record_type = params["record_type"]
			if(!active || !can_manage_comments(record_type))
				return
			var/datum/record/general/selected_record = active
			var/comment_text = tgui_input_text(usr, "Enter the new comment.", "[capitalize(record_type)] Record Comment", multiline = TRUE, encode = FALSE)
			comment_text = sanitize(comment_text, MAX_MESSAGE_LEN, encode = 0, extra = 0)
			if(!comment_text || active != selected_record || !can_manage_comments(record_type))
				return
			var/datum/record/record_comment/record_comment = selected_record.add_comment(record_type, comment_text, authenticated_name, usr.ckey)
			if(selected_record.character_id && record_comment && !record_comment.db_id)
				to_chat(usr, SPAN_WARNING("The comment was added for this round, but could not be saved to the persistent database."))
			SSrecords.onModify(selected_record)
			. = TRUE

		if("editcomment")
			var/record_type = params["record_type"]
			if(!active || !can_manage_comments(record_type))
				return
			var/datum/record/general/selected_record = active
			var/datum/record/record_comment/record_comment = find_comment(record_type, params["comment_id"])
			if(!record_comment)
				return
			var/comment_text = tgui_input_text(usr, "Edit this comment.", "[capitalize(record_type)] Record Comment", default = html_decode(record_comment.comment), multiline = TRUE, encode = FALSE)
			comment_text = sanitize(comment_text, MAX_MESSAGE_LEN, encode = 0, extra = 0)
			if(!comment_text || active != selected_record || !can_manage_comments(record_type) || record_comment != find_comment(record_type, params["comment_id"]))
				return
			var/old_comment = record_comment.comment
			var/old_updated_by = record_comment.updated_by
			var/old_updated_at = record_comment.updated_at
			record_comment.comment = comment_text
			record_comment.updated_by = usr.ckey
			record_comment.updated_at = "[time2text(world.realtime, "DDD MMM DD hh:mm:ss")], [GLOB.game_year]"
			if(record_comment.db_id && !record_comment.save_to_db())
				record_comment.comment = old_comment
				record_comment.updated_by = old_updated_by
				record_comment.updated_at = old_updated_at
				to_chat(usr, SPAN_WARNING("The comment could not be saved to the persistent database."))
				return
			SSrecords.onModify(selected_record)
			. = TRUE

		if("deletecomment")
			var/record_type = params["record_type"]
			if(!active || !can_manage_comments(record_type))
				return
			var/datum/record/record_comment/record_comment = find_comment(record_type, params["comment_id"])
			if(!record_comment || tgui_alert(usr, "Delete this record comment?", "Delete Comment", list("Cancel", "Delete")) != "Delete")
				return
			if(!active || !can_manage_comments(record_type) || record_comment != find_comment(record_type, params["comment_id"]))
				return
			var/list/comment_list = active.get_comments(record_type)
			if(record_comment.db_id && !record_comment.delete_from_db(usr.ckey))
				to_chat(usr, SPAN_WARNING("The comment could not be deleted from the persistent database."))
				return
			comment_list -= record_comment
			qdel(record_comment)
			SSrecords.onModify(active)
			. = TRUE

		if("print")
			var/list/excluded = list()
			if(computer?.nano_printer && active)
				if(!(records_type & RECORD_GENERAL))
					excluded += active.advanced_fields
					excluded += "notes"
					excluded += "comments"
				if(!(records_type & RECORD_SECURITY))
					excluded += "security"
					excluded += "fingerprint"
				if(!(records_type & RECORD_MEDICAL))
					excluded += "medical"
					excluded += "mental_status"
				var/out = active.Printify(excluded)
				computer.nano_printer.print_text(out, "Employee Record ([active.name])")
				. = TRUE

/datum/computer_file/program/records/proc/canEdit(key, record_type)
	if(record_type == "security")
		return (key in list("criminal", "crimes", "notes")) && !!(edit_type & RECORD_SECURITY)
	if(record_type == "medical")
		return (key in list("blood_type", "blood_dna", "notes")) && !!(edit_type & RECORD_MEDICAL)

	switch(key)
		if("fingerprint")
			return !!(edit_type & RECORD_SECURITY)
		if("physical_status")
			return !!((edit_type & RECORD_MEDICAL) || (edit_type & RECORD_GENERAL))
		if("mental_status")
			return !!(edit_type & RECORD_MEDICAL)
		if("species")
			return !!((edit_type & RECORD_MEDICAL) || (edit_type & RECORD_GENERAL))
		if("name", "age", "sex", "rank", "citizenship", "religion", "employer", "notes")
			return !!(edit_type & RECORD_GENERAL)
	return FALSE

/datum/computer_file/program/records/proc/can_manage_comments(var/record_type)
	switch(record_type)
		if("employment")
			return !!(edit_type & RECORD_GENERAL)
		if("medical")
			return !!(edit_type & RECORD_MEDICAL)
		if("security")
			return !!(edit_type & RECORD_SECURITY)
	return FALSE

/datum/computer_file/program/records/proc/find_comment(var/record_type, var/comment_id)
	var/list/comment_list = active?.get_comments(record_type)
	for(var/datum/record/record_comment/record_comment in comment_list)
		if(record_comment.id == comment_id)
			return record_comment

/*
 * Listener for record changes
 */

/listener/record/rconsole/on_delete(var/datum/record/r)
	. = FALSE
	var/datum/computer_file/program/records/t = target
	if(istype(t))
		if(t.active == r)
			t.active = null
			. = TRUE
		if(.)
			SStgui.update_uis(t)

/listener/record/rconsole/on_modify(var/datum/record/r)
	var/datum/computer_file/program/records/t = target
	if(istype(t))
		if(t.active == r)
			SStgui.update_uis(t)
