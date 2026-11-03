#define REPORT_EDITOR_FILES 1
#define REPORT_EDITOR_FORMS 2
#define REPORT_EDITOR_DOCUMENT 3
#define REPORT_EDITOR_MAX_FIELD_LENGTH 8000

/datum/computer_file/program/report_editor
	filename = "reporteditor"
	filedesc = "Report Editor"
	extended_desc = "Creates structured reports from SCC database forms while protecting their standard text."
	program_icon_state = "generic"
	program_key_icon_state = "green_key"
	color = LIGHT_COLOR_GREEN
	size = 3
	requires_ntnet = FALSE
	available_on_ntnet = TRUE
	tgui_id = "ReportEditor"
	var/screen = REPORT_EDITOR_FILES
	var/form_filter = ""
	var/datum/computer_file/data/report/loaded_report
	var/selected_field = 0
	var/message = ""

/datum/computer_file/program/report_editor/kill_program(forced)
	..()
	loaded_report = null
	selected_field = 0
	screen = REPORT_EDITOR_FILES
	message = ""

/datum/computer_file/program/report_editor/ui_data(mob/user)
	var/list/data = initial_data()
	data["screen"] = screen
	data["message"] = message
	data["form_filter"] = form_filter
	data["usb_connected"] = !!computer?.portable_drive

	if(screen == REPORT_EDITOR_FORMS)
		data["forms"] = get_database_forms()

	if(screen == REPORT_EDITOR_FILES)
		data["reports"] = get_drive_reports(computer?.hard_drive, FALSE)
		data["usb_reports"] = get_drive_reports(computer?.portable_drive, TRUE)

	if(screen == REPORT_EDITOR_DOCUMENT)
		if(!loaded_report || QDELETED(loaded_report) || !loaded_report.hard_drive)
			close_report("The report is no longer available.")
			data["screen"] = screen
			data["message"] = message
			data["reports"] = get_drive_reports(computer?.hard_drive, FALSE)
			data["usb_reports"] = get_drive_reports(computer?.portable_drive, TRUE)
			return data
		data["report_name"] = loaded_report.filename
		data["form_name"] = loaded_report.form_name
		data["form_id"] = loaded_report.form_id
		data["form_department"] = loaded_report.form_department
		data["created_by"] = loaded_report.created_by
		data["created_at"] = loaded_report.created_at
		data["modified_at"] = loaded_report.modified_at
		data["field_count"] = loaded_report.field_count
		var/filled_fields = 0
		for(var/i = 1 to loaded_report.field_count)
			if(length(loaded_report.field_values[i]) || loaded_report.has_signatures(i))
				filled_fields++
		data["filled_fields"] = filled_fields
		data["read_only"] = loaded_report.hard_drive.read_only
		data["selected_field"] = selected_field
		data["selected_value"] = selected_field ? loaded_report.field_values[selected_field] : ""
		var/list/selected_signatures = list()
		if(selected_field)
			for(var/datum/report_signature/signature in loaded_report.get_signatures(selected_field))
				selected_signatures += list(list(
					"id" = signature.id,
					"name" = signature.signer_name,
					"assignment" = signature.signer_assignment,
					"signature" = signature.signature_text,
					"signed_at" = signature.signed_at,
					"can_remove" = signature.signer_ckey == user.ckey
				))
		data["selected_signatures"] = selected_signatures
		data["preview"] = render_report_preview(loaded_report)
	return data

/datum/computer_file/program/report_editor/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return

	switch(action)
		if("show_files")
			close_report()
			return TRUE

		if("show_forms")
			screen = REPORT_EDITOR_FORMS
			message = ""
			return TRUE

		if("set_filter")
			form_filter = sanitize(params["filter"])
			return TRUE

		if("clear_filter")
			form_filter = ""
			return TRUE

		if("create_report")
			create_report_from_form(text2num(params["id"]), usr)
			return TRUE

		if("open_report")
			open_report(text2num(params["uid"]), !!params["usb"], usr)
			return TRUE

		if("select_field")
			if(!loaded_report)
				return TRUE
			var/index = text2num(params["index"])
			if(index >= 1 && index <= loaded_report.field_count)
				selected_field = index
			return TRUE

		if("set_field")
			if(!loaded_report || selected_field < 1)
				return TRUE
			if(loaded_report.hard_drive.read_only)
				message = "That drive is read-only."
				return TRUE
			var/value = params["value"] || ""
			if(length(value) > REPORT_EDITOR_MAX_FIELD_LENGTH)
				message = "That field is too long. The maximum is [REPORT_EDITOR_MAX_FIELD_LENGTH] characters."
				return TRUE
			var/old_value = loaded_report.field_values[selected_field]
			var/old_modified_at = loaded_report.modified_at
			var/list/invalidated_signatures = list()
			if(value != old_value && loaded_report.has_signatures(selected_field))
				if(tgui_alert(usr, "Changing this field will invalidate every signature attached to it. Continue?", "Invalidate Signatures", list("Cancel", "Continue")) != "Continue")
					return TRUE
				invalidated_signatures = loaded_report.detach_signatures(selected_field)
			loaded_report.set_field(selected_field, value)
			if(loaded_report.hard_drive.used_capacity > loaded_report.hard_drive.max_capacity)
				loaded_report.field_values[selected_field] = old_value
				loaded_report.signatures += invalidated_signatures
				loaded_report.modified_at = old_modified_at
				loaded_report.refresh_stored_data()
				message = "There is not enough free space to save that field."
			else
				QDEL_LIST(invalidated_signatures)
				message = ""
			return TRUE

		if("sign_field")
			if(!loaded_report || selected_field < 1)
				return TRUE
			if(loaded_report.hard_drive.read_only)
				message = "That drive is read-only."
				return TRUE
			var/obj/item/card/id/id_card = usr.GetIdCard()
			// ID_CARD_UNSET is local to cards_ids.dm and is undefined at the end of that file.
			if(!id_card || !id_card.registered_name || id_card.registered_name == "\[UNSET\]")
				message = "A valid ID card is required to sign a report."
				return TRUE
			var/datum/report_signature/signature = loaded_report.add_signature(selected_field, usr, id_card)
			if(!signature)
				message = "You have already signed this field."
				return TRUE
			if(loaded_report.hard_drive.used_capacity > loaded_report.hard_drive.max_capacity)
				loaded_report.remove_signature(signature.id, usr.ckey)
				message = "There is not enough free space to add that signature."
				return TRUE
			var/signer_assignment = id_card.assignment || "Unassigned"
			message = "Field signed as [id_card.registered_name], [signer_assignment]."
			return TRUE

		if("remove_signature")
			if(!loaded_report || loaded_report.hard_drive.read_only)
				return TRUE
			if(loaded_report.remove_signature(text2num(params["id"]), usr.ckey))
				message = "Signature removed."
			else
				message = "You may only remove your own signature."
			return TRUE

		if("rename_report")
			if(!loaded_report)
				return TRUE
			if(loaded_report.hard_drive.read_only)
				message = "That drive is read-only."
				return TRUE
			var/new_name = sanitize_filename(params["name"])
			if(new_name)
				loaded_report.filename = new_name
				loaded_report.modified_at = worldtime2text()
				message = ""
			return TRUE

		if("print_report")
			print_report()
			return TRUE

		if("export_text")
			export_text()
			return TRUE

/datum/computer_file/program/report_editor/proc/get_database_forms()
	var/list/forms = list()
	if(!SSdbcore.Connect())
		message = "Unable to connect to the forms database."
		return forms
	var/datum/db_query/query
	if(form_filter)
		query = SSdbcore.NewQuery(
			"SELECT id, name, department FROM ss13_forms WHERE department LIKE :filter OR name LIKE :filter ORDER BY id",
			list("filter" = "%[form_filter]%"))
	else
		query = SSdbcore.NewQuery("SELECT id, name, department FROM ss13_forms ORDER BY id")
	if(!query.Execute())
		message = "Unable to retrieve forms from the database."
		qdel(query)
		return forms
	while(query.NextRow())
		forms += list(list("id" = query.item[1], "name" = query.item[2], "department" = query.item[3]))
	qdel(query)
	message = ""
	return forms

/datum/computer_file/program/report_editor/proc/get_drive_reports(obj/item/computer_hardware/hard_drive/drive, on_usb)
	var/list/reports = list()
	if(!drive)
		return reports
	for(var/datum/computer_file/data/report/report in drive.stored_files)
		reports += list(list(
			"uid" = report.uid,
			"name" = report.filename,
			"form" = report.form_name,
			"department" = report.form_department,
			"size" = report.size,
			"usb" = on_usb
		))
	return reports

/datum/computer_file/program/report_editor/proc/create_report_from_form(form_id, mob/user)
	if(!form_id || !computer?.hard_drive)
		return
	if(!SSdbcore.Connect())
		message = "Unable to connect to the forms database."
		return
	var/datum/db_query/query = SSdbcore.NewQuery(
		"SELECT id, name, department, data FROM ss13_forms WHERE id = :id",
		list("id" = form_id))
	if(!query.Execute() || !query.NextRow())
		message = "Unable to load that form from the database."
		qdel(query)
		return
	var/datum/computer_file/data/report/report = new
	report.filename = sanitize_filename("SCCF-[query.item[1]]-[query.item[2]]")
	report.load_form(query.item[1], query.item[2], query.item[3], query.item[4], user?.real_name)
	qdel(query)
	if(!computer.hard_drive.store_file(report))
		qdel(report)
		message = "Unable to create the report. The hard drive may be full or read-only."
		return
	loaded_report = report
	selected_field = report.field_count ? 1 : 0
	screen = REPORT_EDITOR_DOCUMENT
	message = report.field_count ? "" : "This form contains no \[field\] markers."

/datum/computer_file/program/report_editor/proc/open_report(uid, from_usb, mob/user)
	var/obj/item/computer_hardware/hard_drive/drive = from_usb ? computer?.portable_drive : computer?.hard_drive
	if(!drive)
		return
	for(var/datum/computer_file/data/report/report in drive.stored_files)
		if(report.uid == uid && load_report(report, user))
			return TRUE
	message = "Unable to open that report."
	return FALSE

/// Loads a specific report, including reports handed off by File Manager.
/datum/computer_file/program/report_editor/proc/load_report(datum/computer_file/data/report/report, mob/user)
	if(!report || QDELETED(report) || !report.hard_drive)
		return FALSE
	if(report.hard_drive != computer?.hard_drive && report.hard_drive != computer?.portable_drive)
		return FALSE
	if(!report.can_access_file(user))
		return FALSE
	loaded_report = report
	selected_field = report.field_count ? 1 : 0
	screen = REPORT_EDITOR_DOCUMENT
	message = ""
	return TRUE

/datum/computer_file/program/report_editor/proc/close_report(new_message = "")
	loaded_report = null
	selected_field = 0
	screen = REPORT_EDITOR_FILES
	message = new_message

/// Converts the whole form at once, using inert tokens so table and formatting tags remain balanced.
/datum/computer_file/program/report_editor/proc/render_report_preview(datum/computer_file/data/report/report)
	var/tokenized = ""
	var/search_from = 1
	var/field_index = 1
	var/lower_template = lowertext(report.form_template)
	var/position
	while((position = findtext(lower_template, "\[field\]", search_from)))
		tokenized += copytext(report.form_template, search_from, position)
		tokenized += "REPORTEDITORTOKEN[field_index]END"
		field_index++
		search_from = position + 7
	tokenized += copytext(report.form_template, search_from)
	tokenized = normalize_report_lists(tokenized)
	var/rendered = pencode2html(tokenized)
	for(var/i = 1 to report.field_count)
		var/value = report.field_values[i]
		var/list/field_signatures = report.get_signatures(i)
		var/display_value = value ? render_report_fragment(value) : ""
		for(var/datum/report_signature/signature in field_signatures)
			if(length(display_value))
				display_value += "<br>"
			// Character signatures are already sanitized HTML produced by the preferences system.
			display_value += "<span data-report-signature='true'><b>✓ [signature.signature_text]</b><br><small>[html_encode(signature.signer_name)] · [html_encode(signature.signer_assignment)] · [html_encode(signature.signed_at)]</small></span>"
		if(!length(display_value))
			display_value = "Click to edit"
		var/field_state = (value || field_signatures.len) ? "data-report-filled='true'" : "data-report-filled='false'"
		if(i == selected_field)
			field_state += " data-report-selected='true'"
		var/replacement = "<span data-report-field='[i]' [field_state]>[display_value]</span>"
		rendered = replacetext(rendered, "REPORTEDITORTOKEN[i]END", replacement)
	return rendered

/// Renders player-entered pencode consistently with paper while encoding any raw HTML.
/datum/computer_file/program/report_editor/proc/render_report_fragment(value)
	var/encoded_value = html_encode(value)
	encoded_value = isolate_report_field_pencode(encoded_value)
	encoded_value = normalize_report_lists(encoded_value)
	return pencode2html(encoded_value)

/// Replaces Aurora's open-ended list pencode with valid nested HTML for the TGUI preview.
/// The source template is never modified, so printing retains the established paper behavior.
/datum/computer_file/program/report_editor/proc/normalize_report_lists(pencode)
	var/output = ""
	var/lower_pencode = lowertext(pencode)
	var/search_from = 1
	var/depth = 0
	var/list/open_items = list()

	while(TRUE)
		var/list_start = findtext(lower_pencode, "\[list\]", search_from)
		var/list_end = findtext(lower_pencode, "\[/list\]", search_from)
		var/list_item = findtext(lower_pencode, "\[*\]", search_from)
		var/next_token = 0

		for(var/token_position in list(list_start, list_end, list_item))
			if(token_position && (!next_token || token_position < next_token))
				next_token = token_position

		if(!next_token)
			output += copytext(pencode, search_from)
			break

		output += copytext(pencode, search_from, next_token)
		if(next_token == list_start)
			output += "<ul>"
			depth++
			open_items.len = depth
			open_items[depth] = FALSE
			search_from = next_token + 6
		else if(next_token == list_item)
			if(!depth)
				// Gracefully handle a stray list item instead of displaying raw pencode.
				output += "<ul>"
				depth = 1
				open_items.len = 1
				open_items[1] = FALSE
			if(open_items[depth])
				output += "</li>"
			output += "<li>"
			open_items[depth] = TRUE
			search_from = next_token + 3
		else
			if(depth)
				if(open_items[depth])
					output += "</li>"
				output += "</ul>"
				open_items.Cut(depth, depth + 1)
				depth--
			search_from = next_token + 7

	while(depth)
		if(open_items[depth])
			output += "</li>"
		output += "</ul>"
		open_items.Cut(depth, depth + 1)
		depth--

	return output

/datum/computer_file/program/report_editor/proc/print_report()
	if(!loaded_report)
		return
	if(!computer?.nano_printer)
		message = "Missing hardware: this computer has no printer."
		return
	if(!computer.nano_printer.print_text(loaded_report.filled_pencode(), loaded_report.filename))
		message = "The printer could not print the report. It may be out of paper."
		return
	message = "Report printed with its field markers retained."

/datum/computer_file/program/report_editor/proc/export_text()
	if(!loaded_report || !computer?.hard_drive)
		return
	var/datum/computer_file/data/exported = new
	exported.filename = "[loaded_report.filename]-export"
	exported.filetype = "TXT"
	exported.filedesc = "Flattened report export"
	exported.stored_data = loaded_report.filled_pencode(TRUE)
	exported.calculate_size()
	if(!computer.hard_drive.store_file(exported))
		qdel(exported)
		message = "Unable to export the report. The hard drive may be full or read-only."
		return
	message = "Exported [exported.filename].TXT to the internal drive."

#undef REPORT_EDITOR_FILES
#undef REPORT_EDITOR_FORMS
#undef REPORT_EDITOR_DOCUMENT
#undef REPORT_EDITOR_MAX_FIELD_LENGTH
