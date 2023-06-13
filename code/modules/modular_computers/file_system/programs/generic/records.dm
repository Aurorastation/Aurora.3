/datum/computer_file/program/records
	filename = "record"
	filedesc = "Records"
	extended_desc = "Used to view, edit and maintain records."

	program_icon_state = "generic"
	program_key_icon_state = "green_key"
	color = LIGHT_COLOR_BLUE
	available_on_ntnet = FALSE
	size = 6

	requires_ntnet = TRUE
	requires_ntnet_feature = "NTNET_SYSTEMCONTROL"
	requires_access_to_run = PROGRAM_ACCESS_LIST_ONE
	requires_access_to_download = PROGRAM_ACCESS_LIST_ONE
	usage_flags = PROGRAM_ALL_REGULAR | PROGRAM_STATIONBOUND
	tgui_id = "Records"

	var/records_type = RECORD_GENERAL | RECORD_MEDICAL | RECORD_SECURITY | RECORD_VIRUS | RECORD_WARRANT | RECORD_LOCKED
	var/edit_type = RECORD_GENERAL | RECORD_MEDICAL | RECORD_SECURITY | RECORD_VIRUS | RECORD_WARRANT | RECORD_LOCKED
	var/datum/record/general/active
	var/datum/record/virus/active_virus
	var/listener/record/rconsole/listener
	var/isEditing = FALSE
	var/authenticated = FALSE
	var/default_screen = "general"
	var/record_prefix = ""
	var/typechoices = list(
		"physical_status" = list("Active", "*Deceased*", "*SSD*", "*Missing*", "Physically Unfit", "Disabled"),
		"criminal_status" = list("None", "*Arrest*", "Search", "Incarcerated", "Parolled", "Released"),
		"mental_status" = list("Stable", "*Insane*", "*Unstable*", "*Watch*"),
		"medical" = list(
			"blood_type" = list("A-", "B-", "AB-", "O-", "A+", "B+", "AB+", "O+")
		)
	)

/datum/computer_file/program/records/medical
	filename = "medrec"
	filedesc = "Medical Records"
	extended_desc = "Used to view, edit and maintain medical records."
	record_prefix = "Medical "

	required_access_run = list(access_medical_equip, access_forensics_lockers, access_robotics, access_hop)
	required_access_download = list(access_heads, access_medical_equip, access_forensics_lockers, access_robotics)
	available_on_ntnet = TRUE

	records_type = RECORD_MEDICAL | RECORD_VIRUS
	edit_type = RECORD_MEDICAL
	default_screen = "medical"
	program_icon_state = "medical_record"
	program_key_icon_state = "teal_key"
	color = LIGHT_COLOR_CYAN

/datum/computer_file/program/records/security
	filename = "secrec"
	filedesc = "Security Records"
	extended_desc = "Used to view, edit and maintain security records"
	record_prefix = "Security "

	required_access_run = list(access_security, access_forensics_lockers, access_lawyer, access_hop)
	required_access_download = list(access_heads, access_security)
	available_on_ntnet = TRUE

	records_type = RECORD_SECURITY
	edit_type = RECORD_SECURITY
	default_screen = "security"
	program_icon_state = "security_record"
	program_key_icon_state = "yellow_key"
	color = LIGHT_COLOR_YELLOW

/datum/computer_file/program/records/employment
	filename = "emprec"
	filedesc = "Employment Records"
	extended_desc = "Used to view, edit and maintain employment records."
	record_prefix = "Employment "

	required_access_run = list(access_heads, access_lawyer, access_consular)
	requires_access_to_download = PROGRAM_ACCESS_ONE
	required_access_download = access_heads
	available_on_ntnet = TRUE

	records_type = RECORD_GENERAL | RECORD_SECURITY
	edit_type = RECORD_GENERAL
	program_icon_state = "employment_record"
	program_key_icon_state = "lightblue_key"
	color = LIGHT_COLOR_BLUE

/datum/computer_file/program/records/pai
	available_on_ntnet = 1
	extended_desc = "This program is used to view crew records."
	usage_flags = PROGRAM_SILICON_PAI
	edit_type = 0

/datum/computer_file/program/records/New()
	. = ..()
	listener = new(src)

/datum/computer_file/program/records/ui_data(mob/user)
	var/list/data = list(
		"activeview" = "list",
		"defaultview" = default_screen,
		"editingvalue" = "",
		"choices" = typechoices
	)

	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata

	data["authenticated"] = authenticated

	data["canprint"] = !!(computer?.nano_printer)

	data["available_types"] = records_type
	data["editable"] = edit_type
	data["allrecords"] = list()
	data["allrecords_locked"] = list()
	data["record_viruses"] = list()
	if(authenticated)
		data["allrecords"] = list()
		for(var/tR in sortRecord(SSrecords.records))
			var/datum/record/general/R = tR
			data["allrecords"] += list(list(
				"id" = R.id,
				"name" = R.name,
				"rank" = R.rank,
				"sex" = R.sex,
				"age" = R.age,
				"fingerprint" = R.fingerprint,
				"has_notes" = R.notes,
				"physical_status" = R.physical_status,
				"mental_status" = R.mental_status,
				"species" = R.species,
				"citizenship" = R.citizenship,
				"religion" = R.religion,
				"employer" = R.employer,
				"blood" = R.medical ? R.medical.blood_type : null,
				"dna" = R.medical ? R.medical.blood_dna : null
			))

		if(records_type & RECORD_LOCKED)
			data["allrecords_locked"] = list()
			for(var/tR in sortRecord(SSrecords.records_locked))
				var/datum/record/general/R = tR
				data["allrecords_locked"] += list(list(
					"id" = R.id,
					"name" = R.name,
					"rank" = R.rank
				))

		if(active)
			data["front"] = icon2base64(active.photo_front)
			data["side"] = icon2base64(active.photo_side)
			var/excluded = list()
			if(!(records_type & RECORD_GENERAL))
				excluded += active.advanced_fields
			if(!(records_type & RECORD_SECURITY))
				excluded += "security"
			if(!(records_type & RECORD_MEDICAL))
				excluded += "medical"
			var/returned = active.Listify(1, excluded, data["active"])
			if(returned)
				data["active"] = returned
		else
			if(data["activeview"] in list("general", "medical", "security"))
				data["activeview"] = "list"
			data["active"] = null
	else
		data["active"] = null
	return data

/datum/computer_file/program/records/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(action == "login")
		if(can_run(usr, TRUE))
			authenticated = TRUE
		else
			to_chat(usr, SPAN_WARNING("Access denied."))
		. = TRUE

	if(action == "logout")
		authenticated = FALSE
		active = null
		active_virus = null
		. = TRUE

	if(!authenticated)
		return

	switch(action)
		if("setactive")
			active = SSrecords.find_record("id", params["setactive"])
			. = TRUE

		if("setactive_locked")
			if(records_type & RECORD_LOCKED)
				active = SSrecords.find_record("id", params["setactive_locked"], RECORD_GENERAL | RECORD_LOCKED)
				. = TRUE

		if("editrecord")
			var/list/key = params["editrecord"]["key"]
			var/value = sanitize(params["editrecord"]["value"], encode = 0, extra = 0)
			if(key.len >= 2 && canEdit(key))
				if(isnum(obj_query_get(null, src, null, key)))
					value = text2num(value)
				isEditing = TRUE
				obj_query_set(null, src, value, null, key)
				SSrecords.onModify(vars[key[1]])
				isEditing = FALSE
				. = TRUE

		if("deleterecord")
			if(canEdit(list("active", "name")))
				var/confirm = alert("Are you sure you want to delete this record?", "Confirm Deletion", "No", "Yes")
				if(confirm == "Yes")
					isEditing = TRUE
					SSrecords.remove_record(active)
					active = null
					isEditing = FALSE
				. = TRUE

		if("newrecord")
			if(edit_type & RECORD_GENERAL)
				active = new /datum/record/general()
				SSrecords.add_record(active)
				. = TRUE

		if("addtorecord")
			var/list/key = params["addtorecord"]["key"]
			var/value = sanitize(params["addtorecord"]["value"], encode = 0, extra = 0)
			if(key.len >= 2 && canEdit(key))
				isEditing = TRUE
				obj_query_set(null, src, obj_query_get(null, src, null, key) + value, null, key)
				SSrecords.onModify(vars[key[1]])
				isEditing = FALSE
				. = TRUE

		if("removefromrecord")
			var/list/key = params["removefromrecord"]["key"]
			var/value = sanitize(params["removefromrecord"]["value"], encode = 0, extra = 0)
			if(key.len >= 2 && canEdit(key))
				isEditing = TRUE
				obj_query_set(null, src, obj_query_get(null, src, null, key) - value, null, key)
				SSrecords.onModify(vars[key[1]])
				isEditing = FALSE
				. = TRUE

		if("print")
			if(!(params["print"] in list("active", "active_virus")))
				return
			var/datum/record/R = vars[params["print"]]
			if(computer?.nano_printer && R)
				var/excluded = list()
				if(params["print"] == "active")
					if(!(records_type & RECORD_GENERAL))
						excluded += active.advanced_fields
					if(!(records_type & RECORD_SECURITY))
						excluded += "security"
					if(!(records_type & RECORD_MEDICAL))
						excluded += "medical"
				var/out = R.Printify(excluded)
				computer.nano_printer.print_text(out, "[record_prefix]Record ([R.name])")
				. = TRUE

/datum/computer_file/program/records/proc/canEdit(list/key)
	if(!(key[1] in list("active", "active_virus")))
		return FALSE
	if(vars[key[1]] == null)
		return FALSE
	if(key[1] == "active_virus" && !(edit_type & RECORD_VIRUS))
		return FALSE
	if(key[1] == "active")
		switch(key[2])
			if("security")
				if(!(edit_type & RECORD_SECURITY))
					return FALSE
			if("physical_status")
				if(!((edit_type & RECORD_MEDICAL) || (edit_type & RECORD_GENERAL)))
					return FALSE
			if("mental_status")
				if(!((edit_type & RECORD_MEDICAL) || (edit_type & RECORD_GENERAL)))
					return FALSE
			if("medical")
				if(!(edit_type & RECORD_MEDICAL))
					return FALSE
			else
				if(key.len == 2 && !(edit_type & RECORD_GENERAL))
					return FALSE
	return TRUE

/*
 * Listener for record changes
 */

/listener/record/rconsole/on_delete(var/datum/record/r)
	. = FALSE
	var/datum/computer_file/program/records/t = target
	if(istype(t) && !t.isEditing)
		if(t.active == r)
			t.active = null
			. = TRUE
		if(t.active_virus == r)
			t.active_virus = null
			. = TRUE
		if(.)
			SStgui.update_uis(t)

/listener/record/rconsole/on_modify(var/datum/record/r)
	var/datum/computer_file/program/records/t = target
	if(istype(t) && !t.isEditing)
		if(t.active == r || t.active_virus == r)
			SStgui.update_uis(t)
