GLOBAL_VAR_INIT(report_signature_uid, 0)

/// Keeps player-entered pencode from closing tags belonging to a surrounding form.
/// Raw HTML and unsupported tags must be encoded by the caller before this proc is used.
/proc/isolate_report_field_pencode(pencode)
	var/static/list/paired_tags = list("b", "i", "u", "small", "large", "center", "h1", "h2", "h3", "list", "redacted")
	var/static/list/self_closing_tags = list("*", "br", "editorbr", "hr", "date", "time", "tajdate", "tajtime", "station", "cr")
	var/list/open_tags = list()
	var/output = ""
	var/search_from = 1

	while(TRUE)
		var/tag_start = findtext(pencode, "\[", search_from)
		if(!tag_start)
			output += copytext(pencode, search_from)
			break
		var/tag_end = findtext(pencode, "\]", tag_start + 1)
		if(!tag_end)
			output += copytext(pencode, search_from)
			break

		output += copytext(pencode, search_from, tag_start)
		var/original_tag = copytext(pencode, tag_start + 1, tag_end)
		var/tag = lowertext(original_tag)
		var/is_closing = copytext(tag, 1, 2) == "/"
		var/tag_name = is_closing ? copytext(tag, 2) : tag

		if(is_closing)
			if(open_tags.len && open_tags[open_tags.len] == tag_name)
				output += copytext(pencode, tag_start, tag_end + 1)
				open_tags.Cut(open_tags.len, open_tags.len + 1)
			else
				output += "&#91;[original_tag]]"
		else if(tag_name in paired_tags)
			output += copytext(pencode, tag_start, tag_end + 1)
			open_tags += tag_name
		else if(tag_name in self_closing_tags)
			output += copytext(pencode, tag_start, tag_end + 1)
		else
			output += "&#91;[original_tag]]"

		search_from = tag_end + 1

	for(var/i = open_tags.len; i >= 1; i--)
		output += "\[/[open_tags[i]]\]"

	return output

/// Verified identity metadata attached to one editable report field.
/datum/report_signature
	var/id
	var/field_index
	var/signer_name = "Unknown"
	var/signer_assignment = "Unknown"
	var/signer_ckey = ""
	var/signature_text = "Unknown"
	var/signed_at = ""
	var/signed_value = ""

/datum/report_signature/New()
	..()
	id = GLOB.report_signature_uid++

/datum/report_signature/proc/clone()
	var/datum/report_signature/copy = new
	copy.id = id
	copy.field_index = field_index
	copy.signer_name = signer_name
	copy.signer_assignment = signer_assignment
	copy.signer_ckey = signer_ckey
	copy.signature_text = signature_text
	copy.signed_at = signed_at
	copy.signed_value = signed_value
	return copy

/datum/report_signature/proc/flatten()
	return "[signature_text] — [signer_name], [signer_assignment] — [signed_at]"

/// A structured report made from an immutable database form snapshot.
/datum/computer_file/data/report
	filetype = "RPT"
	filedesc = "Structured report"
	do_not_edit = TRUE
	var/form_id
	var/form_name = "Untitled Form"
	var/form_department = ""
	var/form_template = ""
	var/list/field_values = list()
	var/list/signatures = list()
	var/field_count = 0
	var/created_by = "Unknown"
	var/created_at = ""
	var/modified_at = ""

/datum/computer_file/data/report/clone(var/rename = FALSE, var/computer)
	var/datum/computer_file/data/report/temp = ..(rename, computer)
	temp.form_id = form_id
	temp.form_name = form_name
	temp.form_department = form_department
	temp.form_template = form_template
	temp.field_values = field_values.Copy()
	temp.signatures = list()
	for(var/datum/report_signature/signature in signatures)
		temp.signatures += signature.clone()
	temp.field_count = field_count
	temp.created_by = created_by
	temp.created_at = created_at
	temp.modified_at = modified_at
	return temp

/datum/computer_file/data/report/Destroy()
	QDEL_LIST(signatures)
	return ..()

/// Initializes this report from a database row and takes a permanent template snapshot.
/datum/computer_file/data/report/proc/load_form(id, name, department, template, author)
	form_id = id
	form_name = name
	form_department = department
	form_template = template
	created_by = author || "Unknown"
	created_at = worldtime2text()
	modified_at = created_at
	field_count = count_fields()
	field_values = list()
	signatures = list()
	for(var/i = 1 to field_count)
		field_values += ""
	refresh_stored_data()

/// Counts [field] markers case-insensitively without changing the original form text.
/datum/computer_file/data/report/proc/count_fields()
	var/count = 0
	var/search_from = 1
	var/lower_template = lowertext(form_template)
	var/position
	while((position = findtext(lower_template, "\[field\]", search_from)))
		count++
		search_from = position + 7
	return count

/// Produces ordinary pencode with values inserted immediately before the retained markers.
/datum/computer_file/data/report/proc/filled_pencode(remove_markers = FALSE)
	var/output = ""
	var/search_from = 1
	var/field_index = 1
	var/lower_template = lowertext(form_template)
	var/position
	while((position = findtext(lower_template, "\[field\]", search_from)))
		output += copytext(form_template, search_from, position)
		output += flattened_field(field_index)
		if(!remove_markers)
			output += copytext(form_template, position, position + 7)
		field_index++
		search_from = position + 7
	output += copytext(form_template, search_from)
	return output

/datum/computer_file/data/report/proc/get_signatures(index)
	var/list/matches = list()
	for(var/datum/report_signature/signature in signatures)
		if(signature.field_index == index)
			matches += signature
	return matches

/datum/computer_file/data/report/proc/has_signatures(index)
	for(var/datum/report_signature/signature in signatures)
		if(signature.field_index == index)
			return TRUE
	return FALSE

/datum/computer_file/data/report/proc/flattened_field(index)
	var/output = isolate_report_field_pencode(html_encode(field_values[index] || ""))
	for(var/datum/report_signature/signature in signatures)
		if(signature.field_index != index)
			continue
		if(length(output))
			output += "\n"
		output += signature.flatten()
	return output

/datum/computer_file/data/report/proc/add_signature(index, mob/user, obj/item/card/id/id_card)
	if(index < 1 || index > field_count || !user || !id_card)
		return
	for(var/datum/report_signature/existing in signatures)
		if(existing.field_index == index && existing.signer_ckey == user.ckey)
			return
	var/datum/report_signature/signature = new
	signature.field_index = index
	signature.signer_name = id_card.registered_name
	signature.signer_assignment = id_card.assignment || "Unassigned"
	signature.signer_ckey = user.ckey
	signature.signature_text = user.mind?.signature || id_card.registered_name
	signature.signed_at = "[worlddate2text()] [worldtime2text()]"
	signature.signed_value = field_values[index] || ""
	signatures += signature
	modified_at = worldtime2text()
	refresh_stored_data()
	return signature

/// Detaches signatures without deleting them so a failed drive update can restore them.
/datum/computer_file/data/report/proc/detach_signatures(index)
	var/list/detached = get_signatures(index)
	signatures -= detached
	return detached

/datum/computer_file/data/report/proc/remove_signature(signature_id, signer_ckey)
	for(var/datum/report_signature/signature in signatures)
		if(signature.id != signature_id || signature.signer_ckey != signer_ckey)
			continue
		signatures -= signature
		qdel(signature)
		modified_at = worldtime2text()
		refresh_stored_data()
		return TRUE
	return FALSE

/datum/computer_file/data/report/proc/set_field(index, value)
	if(index < 1 || index > field_count)
		return FALSE
	field_values[index] = value
	modified_at = worldtime2text()
	refresh_stored_data()
	return TRUE

/// Keeps File Manager, printing, and generic file transfers useful without making TXT authoritative.
/datum/computer_file/data/report/proc/refresh_stored_data()
	stored_data = filled_pencode()
	calculate_size()
	if(hard_drive)
		hard_drive.recalculate_size()
