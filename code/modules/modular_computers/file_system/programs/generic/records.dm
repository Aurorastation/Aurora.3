/datum/computer_file/program/records
	filename = "record"
	filedesc = "Records"
	extended_desc = "Used to view, edit and maintain records."

	program_icon_state = "generic"
	color = LIGHT_COLOR_BLUE
	available_on_ntnet = FALSE
	size = 6

	requires_ntnet = TRUE
	requires_ntnet_feature = NTNET_SYSTEMCONTROL
	requires_access_to_run = PROGRAM_ACCESS_LIST_ONE

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
		"physical_status" = list("Active", "*Deceased*", "*SSD*", "Physically Unfit", "Disabled"),
		"criminal_status" = list("None", "*Arrest*", "Search", "Incarcerated", "Parolled", "Released"),
		"mental_status" = list("Stable", "*Insane*", "*Unstable*", "*Watch*"),
		"medical" = list(
			"blood_type" = list("A-", "B-", "AB-", "O-", "A+", "B+", "AB+", "O+")
		)
	)

/datum/computer_file/program/records/medical
	filename = "medrec"
	filedesc = "Medical records"
	extended_desc = "Used to view, edit and maintain medical records."
	record_prefix = "Medical "

	required_access_run = list(access_medical_equip, access_forensics_lockers, access_detective, access_hop)
	required_access_download = access_heads
	available_on_ntnet = TRUE

	records_type = RECORD_MEDICAL | RECORD_VIRUS
	edit_type = RECORD_MEDICAL
	default_screen = "medical"
	program_icon_state = "medical_record"
	color = LIGHT_COLOR_CYAN

/datum/computer_file/program/records/security
	filename = "secrec"
	filedesc = "Security records"
	extended_desc = "Used to view, edit and maintain security records"
	record_prefix = "Security "

	required_access_run = list(access_security, access_forensics_lockers, access_lawyer, access_hop)
	required_access_download = access_heads
	available_on_ntnet = TRUE

	records_type = RECORD_SECURITY
	edit_type = RECORD_SECURITY
	default_screen = "security"
	program_icon_state = "security_record"
	color = LIGHT_COLOR_RED

/datum/computer_file/program/records/employment
	filename = "emprec"
	filedesc = "Employment records"
	extended_desc = "Used to view, edit and maintain employment records."
	record_prefix = "Employment "

	required_access_run = list(access_heads, access_lawyer)
	required_access_download = access_heads
	available_on_ntnet = TRUE

	records_type = RECORD_GENERAL | RECORD_SECURITY
	edit_type = RECORD_GENERAL
	program_icon_state = "employment_record"
	color = LIGHT_COLOR_BLUE

/datum/computer_file/program/records/New()
	. = ..()
	listener = new(src)

/datum/computer_file/program/records/ui_interact(mob/user as mob)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new /datum/vueui/modularcomputer(user, src, "records-main", 450, 520, filedesc)
		if(!authenticated)
			ui.activeui = "records-login"
	ui.open()

/datum/computer_file/program/records/vueui_transfer(oldobj)
	var/ui_name = "records-main"
	if(!authenticated)
		ui_name = "records-login"
	SSvueui.transfer_uis(oldobj, src, ui_name, 450, 520, filedesc)
	return TRUE

/datum/computer_file/program/records/vueui_data_change(list/data, mob/user, datum/vueui/ui)
	if(!data)
		. = data = list(
			"activeview" = "list",
			"defaultview" = default_screen,
			"editingvalue" = "",
			"choices" = typechoices
			)

	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata
		. = data

	if(!authenticated)
		VUEUI_SET_CHECK(ui.activeui, "records-login", ., data)
	else
		VUEUI_SET_CHECK(ui.activeui, "records-main", ., data)

	VUEUI_SET_CHECK(data["canprint"], !!(computer?.nano_printer), ., data)

	VUEUI_SET_CHECK(data["avaivabletypes"], records_type, ., data)
	VUEUI_SET_CHECK(data["editable"], edit_type, ., data)
	LAZYINITLIST(data["allrecords"])
	LAZYINITLIST(data["allrecords_locked"])
	LAZYINITLIST(data["record_viruses"])
	if(authenticated)
		if(LAZYLEN(data["allrecords"]) != SSrecords.records.len)
			data["allrecords"] = list()
		for(var/tR in sortRecord(SSrecords.records))
			var/datum/record/general/R = tR
			LAZYINITLIST(data["allrecords"][R.id])
			VUEUI_SET_CHECK(data["allrecords"][R.id]["id"], R.id, ., data)
			VUEUI_SET_CHECK(data["allrecords"][R.id]["name"], R.name, ., data)
			VUEUI_SET_CHECK(data["allrecords"][R.id]["rank"], R.rank, ., data)
			VUEUI_SET_CHECK(data["allrecords"][R.id]["sex"], R.sex, ., data)
			VUEUI_SET_CHECK(data["allrecords"][R.id]["age"], R.age, ., data)
			VUEUI_SET_CHECK(data["allrecords"][R.id]["fingerprint"], R.fingerprint, ., data)
			if(R.medical)
				VUEUI_SET_CHECK(data["allrecords"][R.id]["blood"], R.medical.blood_type, ., data)
				VUEUI_SET_CHECK(data["allrecords"][R.id]["dna"], R.medical.blood_dna, ., data)


		if(records_type & RECORD_LOCKED)
			if(LAZYLEN(data["allrecords_locked"]) != SSrecords.records_locked.len)
				data["allrecords_locked"] = list()
			for(var/tR in sortRecord(SSrecords.records_locked))
				var/datum/record/general/R = tR
				LAZYINITLIST(data["allrecords_locked"][R.id])
				VUEUI_SET_CHECK(data["allrecords_locked"][R.id]["id"], R.id, ., data)
				VUEUI_SET_CHECK(data["allrecords_locked"][R.id]["name"], R.name, ., data)
				VUEUI_SET_CHECK(data["allrecords_locked"][R.id]["rank"], R.rank, ., data)

		if(records_type & RECORD_VIRUS)
			if(LAZYLEN(data["record_viruses"]) != SSrecords.viruses.len)
				data["record_viruses"] = list()
			for(var/tR in sortRecord(SSrecords.viruses))
				var/datum/record/virus/R = tR
				LAZYINITLIST(data["record_viruses"]["[R.id]"])
				VUEUI_SET_CHECK(data["record_viruses"]["[R.id]"]["id"], R.id, ., data)
				VUEUI_SET_CHECK(data["record_viruses"]["[R.id]"]["name"], R.name, ., data)
		if(active_virus)
			var/returned = active_virus.Listify(1, list(), data["active_virus"])
			if(returned)
				data["active_virus"] = returned
				. = data
		else
			if(data["activeview"] == "virus")
				VUEUI_SET_CHECK(data["activeview"], "list", ., data)
			VUEUI_SET_CHECK(data["active_virus"], 0, ., data)

		if(active)
			if(!ui.assets["front"] || !ui.assets["side"])
				ui.add_asset("front", active.photo_front)
				ui.add_asset("side", active.photo_side)
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
				. = data
		else
			if(data["activeview"] in list("general", "medical", "security"))
				VUEUI_SET_CHECK(data["activeview"], "list", ., data)
			VUEUI_SET_CHECK(data["active"], 0, ., data)
	else
		VUEUI_SET_CHECK(data["active_virus"], 0, ., data)
		VUEUI_SET_CHECK(data["active"], 0, ., data)

/datum/computer_file/program/records/Topic(href, href_list)
	if(..())
		return TRUE
	var/datum/vueui/ui = href_list["vueui"]
	if(!istype(ui))
		return
	if(href_list["login"])
		if(can_run(usr, TRUE))
			authenticated = TRUE
		else
			to_chat(usr, "[src] beeps: Access Denied")
		SSvueui.check_uis_for_change(src)
	if(href_list["logout"])
		authenticated = FALSE
		active = null
		active_virus = null
		ui.remove_asset("front")
		ui.remove_asset("side")
		ui.data = null
		SSvueui.check_uis_for_change(src)
	if(!authenticated)
		return
	if(href_list["setactive"])
		active = SSrecords.find_record("id", href_list["setactive"])
		if(active)
			ui.add_asset("front", active.photo_front)
			ui.add_asset("side", active.photo_side)
			ui.send_asset("front")
			ui.send_asset("side")
		else
			ui.remove_asset("front")
			ui.remove_asset("side")
		SSvueui.check_uis_for_change(src)
	if(href_list["setactive_locked"] && (records_type & RECORD_LOCKED))
		active = SSrecords.find_record("id", href_list["setactive_locked"], RECORD_GENERAL | RECORD_LOCKED)
		SSvueui.check_uis_for_change(src)
	if(href_list["setactive_virus"] && (records_type & RECORD_VIRUS))
		active_virus = SSrecords.find_record("id", text2num(href_list["setactive_virus"]), RECORD_VIRUS)
		SSvueui.check_uis_for_change(src)
	if(href_list["editrecord"])
		var/list/key = href_list["editrecord"]["key"]
		var/value = sanitize(href_list["editrecord"]["value"], encode = 0, extra = 0)
		if(key.len >= 2 && canEdit(key))
			if(isnum(obj_query_get(null, src, null, key)))
				value = text2num(value)
			isEditing = TRUE
			obj_query_set(null, src, value, null, key)
			obj_query_set(null, ui.data, value, null, key)
			SSrecords.onModify(vars[key[1]])
			isEditing = FALSE
			. = TRUE
	if(href_list["deleterecord"])
		if(canEdit(list("active", "name")))
			var/confirm = alert("Are you sure you want to delete this record?", "Confirm Deletion", "No", "Yes")
			if(confirm == "Yes")
				isEditing = TRUE
				SSrecords.remove_record(active)
				ui.data["allrecords"] -= active.id
				active = null
				ui.data["activeview"] = default_screen
				isEditing = FALSE
			SSvueui.check_uis_for_change(src)
	if(href_list["newrecord"])
		if(edit_type & RECORD_GENERAL)
			active = new /datum/record/general()
			SSrecords.add_record(active)
			ui.add_asset("front", active.photo_front)
			ui.add_asset("side", active.photo_side)
			ui.send_asset("front")
			ui.send_asset("side")
			SSvueui.check_uis_for_change(src)
	if(href_list["addtorecord"])
		var/list/key = href_list["addtorecord"]["key"]
		var/value = sanitize(href_list["addtorecord"]["value"], encode = 0, extra = 0)
		if(key.len >= 2 && canEdit(key))
			isEditing = TRUE
			obj_query_set(null, src, obj_query_get(null, src, null, key) + value, null, key)
			obj_query_set(null, ui.data, obj_query_get(null, ui.data, null, key) + value, null, key)
			SSrecords.onModify(vars[key[1]])
			isEditing = FALSE
			. = TRUE
	if(href_list["removefromrecord"])
		var/list/key = href_list["removefromrecord"]["key"]
		var/value = sanitize(href_list["removefromrecord"]["value"], encode = 0, extra = 0)
		if(key.len >= 2 && canEdit(key))
			isEditing = TRUE
			obj_query_set(null, src, obj_query_get(null, src, null, key) - value, null, key)
			obj_query_set(null, ui.data, obj_query_get(null, ui.data, null, key) - value, null, key)
			SSrecords.onModify(vars[key[1]])
			isEditing = FALSE
			. = TRUE
	if(href_list["print"])
		if(!(href_list["print"] in list("active", "active_virus")))
			return
		var/datum/record/R = vars[href_list["print"]]
		if(computer?.nano_printer && R)
			var/excluded = list()
			if(href_list["print"] == "active")
				if(!(records_type & RECORD_GENERAL))
					excluded += active.advanced_fields
				if(!(records_type & RECORD_SECURITY))
					excluded += "security"
				if(!(records_type & RECORD_MEDICAL))
					excluded += "medical"
			var/out = R.Printify(excluded)
			computer.nano_printer.print_text(out, "[record_prefix]Record ([R.name])")


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
			SSvueui.check_uis_for_change(t)

/listener/record/rconsole/on_modify(var/datum/record/r)
	var/datum/computer_file/program/records/t = target
	if(istype(t) && !t.isEditing)
		if(t.active == r || t.active_virus == r)
			SSvueui.check_uis_for_change(t)
