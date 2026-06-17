#define STATUS_OPEN "Open"
#define STATUS_SUBMITTED "Submitted"
#define STATUS_ARCHIVED "Archived"
/datum/computer_file/program/case_dossier
	filename = "case_dossier"
	filedesc = "Case Dossier"
	extended_desc = "Official NTsec program for the handling of investigation cases."
	program_icon_state = "security_record"
	program_key_icon_state = "yellow_key"
	color = LIGHT_COLOR_RED
	size = 6
	requires_ntnet = TRUE
	available_on_ntnet = TRUE
	// Security officers and wardens are allowed to download the program, but not edit it
	required_access_download = ACCESS_SECURITY
	required_access_run = ACCESS_SECURITY
	usage_flags = PROGRAM_ALL_REGULAR | PROGRAM_STATIONBOUND
	tgui_id = "Casedossier"

	var/list/stored_cases
	var/datum/investigation_case/open_case

/datum/computer_file/program/case_dossier/New(obj/item/modular_computer/comp)
	. = ..()
	stored_cases = GLOB.case_dossier_cases

/// Who is permitted to edit the investigation files. Defaults to forensic staff
/datum/computer_file/program/case_dossier/proc/can_edit(mob/user)
	if(!user)
		return FALSE

	var/obj/item/card/id/I = user.GetIdCard()
	if(!I)
		return FALSE

	return (ACCESS_FORENSICS_LOCKERS in I.access)

/datum/computer_file/program/case_dossier/ui_data(mob/user)
	var/list/data = list()

	data["available_statuses"] = list(STATUS_OPEN, STATUS_SUBMITTED, STATUS_ARCHIVED)
	data["can_edit"] = can_edit(user)
	data["open_case"] = null
	data["cases"] = list()

	if(open_case)
		open_case.send_photo_resources(user)
		data["open_case"] = open_case.tgui_data()

	if(stored_cases)
		for(var/datum/investigation_case/C in stored_cases)
			data["cases"] += list(C.tgui_data(TRUE))

	return data

/datum/investigation_case/proc/tgui_data(var/include_contents = TRUE)
	var/list/data = list()

	data["id"] = "[case_id]"
	data["title"] = title
	data["status"] = status
	data["investigator"] = investigator
	data["created_at"] = created_at
	data["updated_at"] = updated_at
	data["tags"] = tags

	data["victim_count"] = length(victims)
	data["suspect_count"] = length(suspects)
	data["witness_count"] = length(witnesses)
	data["evidence_count"] = length(evidence_refs)
	data["photo_count"] = length(photo_refs)
	data["report_count"] = length(report_refs)

	if(include_contents)
		data["summary"] = summary
		data["timeline"] = timeline
		data["findings"] = findings

		data["victims"] = person_list_tgui_data(victims)
		data["suspects"] = person_list_tgui_data(suspects)
		data["witnesses"] = person_list_tgui_data(witnesses)

		data["evidence"] = evidence_list_tgui_data(evidence_refs)
		data["photos"] = evidence_list_tgui_data(photo_refs)
		data["reports"] = report_list_tgui_data(report_refs)

	return data

/datum/computer_file/program/case_dossier/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("new_case")
			create_new_case(usr)
			return TRUE

		if("open_case")
			open_case_by_id(params["id"])
			return TRUE

		if("save_case")
			save_open_case(usr)
			return TRUE

		if("edit_case_field")
			if(open_case)
				open_case.set_field(params["field"], params["value"])
			else
				to_chat(usr, SPAN_NOTICE("No open case selected."))
			return TRUE

		if("edit_case_tags")
			if(open_case)
				open_case.set_tags_from_text(params["value"])
			else
				to_chat(usr, SPAN_NOTICE("No open case selected."))
			return TRUE

		if("add_person")
			if(open_case)
				open_case.add_person(params["list"])
			else
				to_chat(usr, SPAN_NOTICE("No open case selected."))
			return TRUE

		if("edit_person")
			if(open_case)
				open_case.edit_person(params["list"], params["id"], params["field"], params["value"])
			else
				to_chat(usr, SPAN_NOTICE("No open case selected."))
			return TRUE

		if("remove_person")
			if(open_case)
				open_case.remove_person(params["list"], params["id"])
			else
				to_chat(usr, SPAN_NOTICE("No open case selected."))
			return TRUE

		if("scan_evidence")
			if(open_case)
				open_case.scan_held_evidence(usr, usr.get_type_in_hands(/obj/item))
			else
				to_chat(usr, SPAN_NOTICE("No open case selected."))
			return TRUE

		if("scan_photo")
			if(open_case)
				open_case.scan_held_photo(usr, usr.get_type_in_hands(/obj/item))
			else
				to_chat(usr, SPAN_NOTICE("No open case selected."))
			return TRUE

		if("scan_report")
			if(open_case)
				open_case.scan_held_report(usr, usr.get_type_in_hands(/obj/item))
			else
				to_chat(usr, SPAN_NOTICE("No open case selected."))
			return TRUE

		if("print_summary")
			if(open_case)
				open_case.print_summary(usr)
			else
				to_chat(usr, SPAN_NOTICE("No open case selected."))
			return TRUE

		if("print_evidence_log")
			if(open_case)
				open_case.print_evidence_log(usr)
			else
				to_chat(usr, SPAN_NOTICE("No open case selected."))
			return TRUE

		if("set_case_status")
			var/datum/investigation_case/C = find_case_by_id(params["id"])
			if(C)
				C.set_field("status", params["status"])
			return TRUE

		if("duplicate_case")
			duplicate_case_by_id(params["id"], usr)
			return TRUE

		if("delete_case")
			delete_case_by_id(params["id"])
			return TRUE

		if("add_manual_evidence")
			if(open_case)
				open_case.add_manual_evidence(usr)
			return TRUE

		if("edit_evidence")
			if(open_case)
				open_case.edit_evidence(params["id"], params["field"], params["value"])
			return TRUE

		if("remove_evidence")
			if(open_case)
				open_case.remove_evidence(params["id"])
			return TRUE

		if("edit_photo")
			if(open_case)
				open_case.edit_photo(params["id"], params["field"], params["value"])
			return TRUE

		if("remove_photo")
			if(open_case)
				open_case.remove_photo(params["id"])
			return TRUE

		if("remove_report")
			if(open_case)
				open_case.remove_report(params["id"])
			return TRUE

/datum/computer_file/program/case_dossier/proc/create_new_case(var/mob/user)
	var/datum/investigation_case/C = new /datum/investigation_case()

	C.created_by = user?.real_name
	C.investigator = user?.real_name
	C.created_at = worldtime2text()
	C.updated_at = C.created_at

	stored_cases += C
	open_case = C

/datum/computer_file/program/case_dossier/proc/find_case_by_id(var/id)
	if(!id)
		return null

	for(var/datum/investigation_case/C in stored_cases)
		if("[C.case_id]" == "[id]")
			return C

	return null

/datum/computer_file/program/case_dossier/proc/open_case_by_id(var/id)
	var/datum/investigation_case/C = find_case_by_id(id)
	if(!C)
		return FALSE

	open_case = C
	return TRUE

/datum/computer_file/program/case_dossier/proc/save_open_case(var/mob/user)
	if(!open_case)
		return FALSE

	open_case.touch()

	if(user)
		to_chat(user, SPAN_NOTICE("You save [open_case.title]."))

	return TRUE

/datum/computer_file/program/case_dossier/proc/delete_case_by_id(var/id)
	var/datum/investigation_case/C = find_case_by_id(id)
	if(!C)
		return FALSE

	stored_cases -= C

	if(open_case == C)
		open_case = null

	qdel(C)
	return TRUE

/datum/computer_file/program/case_dossier/proc/duplicate_case_by_id(var/id, var/mob/user)
	var/datum/investigation_case/C = find_case_by_id(id)
	if(!C)
		return FALSE

	var/datum/investigation_case/N = C.copy_case()

	N.title = "Copy of [C.title]"
	N.created_by = user?.real_name
	N.created_at = worldtime2text()
	N.updated_at = N.created_at

	stored_cases += N
	open_case = N

	return TRUE

#undef STATUS_OPEN
#undef STATUS_SUBMITTED
#undef STATUS_ARCHIVED
